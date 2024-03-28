//+------------------------------------------------------------------+
//|                                             LRB-TradeAllowed.mqh |
//|                             Copyright 2023, Linx Trading Co. LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co. LLC"
#property link      "https://www.linxtradingco.com"

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ALLOWED TO TRADE? <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

bool allowedToTrade()
{  
   return   (!shouldReInitRange())
            && (range.withinTradeTime(lastTick.time))
            && (!checkDailyStopLoss())
            && (!checkDailyTakeProfit());
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> TODAY DEALS TOTAL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

int todayDealsOpenedTotal()
{
   datetime BOD=TimeCurrent();
   BOD=(BOD/86400)*86400;
   
   uint     totalNumberOfDeals   = HistoryDealsTotal();
   ulong    ticketNumber         = 0;
   long     dealEntry;
   string   symbol               = "";
   long     magic                = 0;
   int      count                = 0;
   
   HistorySelect(BOD, TimeCurrent());
   for(uint i = 0; i<totalNumberOfDeals; ++i)
   {
      if((ticketNumber = HistoryDealGetTicket(i)) > 0)
      { 
         magic     = HistoryDealGetInteger(ticketNumber, DEAL_MAGIC);
         symbol    = HistoryDealGetString(ticketNumber, DEAL_SYMBOL);
         dealEntry = HistoryDealGetInteger(ticketNumber, DEAL_ENTRY);
         
         if(dealEntry == 0 && orderIsMine(symbol, magic))
         {
            ++count;
         }
      }
   }
   return count;
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CHECK IF AT MAX DAY CLOSED ORDERS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

bool isMaxDayOrders()
{
   return todayDealsOpenedTotal() < maxDailyOrders;
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CHECK SIZE OF RANGE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

bool isRangeSizeAllowed()
{
   double sizeOfRange = ((range.highOfRange - range.lowOfRange) / _Point);
   if (!useRangeSize)
      return true;
   else
      return (sizeOfRange >= minRangeSize) && (sizeOfRange <= maxRangeSize);
}


