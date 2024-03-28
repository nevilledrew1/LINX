//+------------------------------------------------------------------+
//|                                       CheckAndAdjustSlippage.mqh |
//|                                             Linx Trading Co. LLC |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Linx Trading Co. LLC"
#property link      "https://www.mql5.com"
#property strict

bool isOrderSlipped(long ticket)
{
   double slippage = 0;

   for(int i = 0; i < ordTot; ++i)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderTicket == ticket && orderIsMine(OrderSymbol(), OrderMagicNumber()))
      {
         double   stopLoss    = OrderStopLoss();
         double   takeProfit  = OrderTakeProfit();
         double   openPrice   = OrderOpenPrice();
         int      orderSide   = OrderType();

         determineAttemptedOrderPrice(orderSide);
         return calculateOrderSlippage(determineAttemptedOrderPrice(orderSide), openPrice) > 0;
      }
   }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// OBTAIN ORDER PARAMETERS ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void obtainOrderParameters(long ticket)
{
   for(int i = 0; i < ordTot; ++i)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderTicket == ticket && orderIsMine(OrderSymbol(), OrderMagicNumber()))
      {
         double   stopLoss    = OrderStopLoss();
         double   takeProfit  = OrderTakeProfit();
         double   openPrice   = OrderOpenPrice();
         int      orderSide   = OrderType();

         checkAndAdjustSlippage(orderSide, ticket, openPrice, stopLoss, takeProfit);
      }
   }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CHECK AND ADJUST SLIPPAGE //////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void checkAndAdjustSlippage(int ordSide, long ticket, double openPrice, double stopLoss, double takeProfit)
{
   double attemptedOpenPrice  = determineAttemptedOrderPrice(ordSide);
   double orderSlippage       = calculateOrderSlippage(attemptedOpenPrice, openPrice);

   unslipStopLossTakeProfit(orderSlippage, stopLoss, takeProfit, ticket);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// DETERMINE ATTEMPTED ORDER PRICE ////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
double determineAttemptedOrderPrice(int ordSide)
{
   if(ordSide == 0)
   (
      if(!useReverseTrades)
      {
         return range.highOfRange;
      }
      return range.lowOfRange;
   )
   if(!useReverseTrades)
   {
      return range.lowOfRange;
   }
   return range.highOfRange;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CALCULATE ORDER SLIPPAGE ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
double calculateOrderSlippage(double attemptedOpenPrice, double openPrice, int orderSide)
{
   double slippage = 0;

   if(orderSide == 0)
   {
      slippage = (openPrice - attemptedOpenPrice) / _Point;
   }
   if(orderSide == 1)
   {
      slippage = (attemptedOpenPrice - openPrice) / _Point;
   }

   return slippage;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// UNSLIP STOP LOSS TAKE PROFIT ///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void unslipStopLossTakeProfit(double orderSlippage, double stopLoss, double takeProfit, int orderSide, int ticket)
{
   if(orderSide == 0)
   {
      OrderModify(ticket, NULL, stopLoss - (slippage * _Point), takeProfit + (slippage * _Point));
   }
}

