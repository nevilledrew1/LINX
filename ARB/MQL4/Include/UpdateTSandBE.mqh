//+------------------------------------------------------------------+
//|                                                UpdateTSandBE.mqh |
//|                                             Linx Trading Co. LLC |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Linx Trading Co. LLC"
#property link      "https://www.mql5.com"
#property strict


// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> UPDATE STOP LOSSES <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void updateTSandBE()
{
   checkForBreakeven();
   checkForTrailing();
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CHECK FOR BREAKEVEN <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void checkForBreakeven()
{
   if(useBreakeven)
   {
      updateBreakEven();
   }
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CHECK FOR TRAILING STOP <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void checkForTrailing()
{
   if(useTrailingStop)
   {
      updateTrailingStop();
   }
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> UPDATE BREAKEVEN <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void updateBreakEven()
{
   int adjustedBeStart =  breakevenStart;

   for (int b = OrdersTotal()-1; b>=0; b--)
   {
      if (OrderSelect(b, SELECT_BY_POS, MODE_TRADES))
      {
         if(adjustForSlippage && orderIsSlipped(OrderTicket()))
         {
            double slippage = calculateOrderSlippage(determineAttemptedOrderPrice(OrderType()), OrderOpenPrice(), OrderType());

            if(adjustedBeStart > slippage)
            {
               adjustedBeStart = adjustedBeStart - slippage;
            }
            if(slippage > adjustedBeStart && closeIfTooMuchSlippage)
            {
               Print("Too much slippage to set breakeven start! Closing order ticket: ", OrderTicket());
               OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), 0);
            }

            if (OrderSymbol() == Symbol() && OrderType() == OP_BUY && Bid >= OrderOpenPrice() + (adjustedBeStart*Point)  && OrderStopLoss() < OrderOpenPrice() + (breakevenStop*Point))
            {
               OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() + (breakevenStop*Point), Digits), OrderTakeProfit(), 0);
            }
            if (OrderSymbol() == Symbol() && OrderType() == OP_SELL && Ask <= OrderOpenPrice() - (adjustedBeStart*Point)  && OrderStopLoss() > OrderOpenPrice() - (breakevenStop*Point))
            {
               OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() - (breakevenStop*Point), Digits), OrderTakeProfit(), 0);
            }
         }
         if(!adjustForSlippage)
         {
            if (OrderSymbol() == Symbol() && OrderType() == OP_BUY && Bid >= OrderOpenPrice() + (breakevenStart*Point)  && OrderStopLoss() < OrderOpenPrice() + (breakevenStop*Point))
            {
               OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() + (breakevenStop*Point), Digits), OrderTakeProfit(), 0);
            }
            if (OrderSymbol() == Symbol() && OrderType() == OP_SELL && Ask <= OrderOpenPrice() - (breakevenStart*Point)  && OrderStopLoss() > OrderOpenPrice() - (breakevenStop*Point))
            {
               OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() - (breakevenStop*Point), Digits), OrderTakeProfit(), 0);
            }
         }
      }
   }
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> UPDATE TRAILING STOP <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

struct OrderInfo
{
    bool slippageAdjusted; // Flag to track whether slippage has been adjusted for this order
};

void updateTrailingStop()
{
    static map<long, OrderInfo> ordersInfo;

    for (int b = OrdersTotal() - 1; b >= 0; b--)
    {
        if (OrderSelect(b, SELECT_BY_POS, MODE_TRADES))
        {
            long ticket = OrderTicket();

            if (!ordersInfo.Contains(ticket))
            {
                OrderInfo newOrderInfo;
                newOrderInfo.slippageAdjusted = false;
                ordersInfo[ticket] = newOrderInfo;
            }

            if (!ordersInfo[ticket].slippageAdjusted)
            {
                if (adjustForSlippage && orderIsSlipped(ticket))
                {
                    double slippage = calculateOrderSlippage(determineAttemptedOrderPrice(OrderType()), OrderOpenPrice(), OrderType());

                    trailingStart -= slippage;
                    ordersInfo[ticket].slippageAdjusted = true;
                }
            }

            if (OrderSymbol() == Symbol() && OrderType() == OP_BUY && Bid >= OrderOpenPrice() + (trailingStart * Point) && OrderStopLoss() < (Bid - (trailingStop * Point) - (trailingStep * Point)))
            {
                OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Bid - (trailingStop * Point), Digits), OrderTakeProfit(), 0);
            }
            if (OrderSymbol() == Symbol() && OrderType() == OP_SELL && Ask <= OrderOpenPrice() - (trailingStart * Point) && OrderStopLoss() > (Ask + (trailingStop * Point) + (trailingStep * Point)))
            {
                OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Ask + (trailingStop * Point), Digits), OrderTakeProfit(), 0);
            }
        }
    }
}

void deleteOrderInfoStructs()
{
    for (int i = 0; i < OrdersHistoryTotal(); i++)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
        {
            long ticket = OrderTicket(); // Get the order ticket

            // Remove the order from the map if it exists
            if (ordersInfo.Contains(ticket))
            {
                ordersInfo.Delete(ticket);
            }
        }
    }
}