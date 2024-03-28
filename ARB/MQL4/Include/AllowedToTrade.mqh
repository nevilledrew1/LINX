//+------------------------------------------------------------------+
//|                                               AllowedToTrade.mqh |
//|                                             Linx Trading Co. LLC |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Linx Trading Co. LLC"
#property link      "https://www.mql5.com"
#property strict

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ALLOWED TO TRADE? <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
bool allowedToTrade()
{         
   return   (isMaxDayOrders())
            && (range.withinTradeTime(lastTick.time))
            && (isRangeSizeAllowed())
            && (!isDailySlHit)
            && (!isDailyTpHit);
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> TODAY ORDERS TOTAL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
int todayClosedOrdersTotal()
{
   datetime    BOD     = Time[0] - Time[0] % 86400;    // Beginning of today
                // Use  = TimeCurrent() - 86400 for last 24 hours
   int         count   = 0;
   for  (int pos=OrdersHistoryTotal()-1; pos >= 0; pos--)
      if
      (
         OrderSelect(pos, SELECT_BY_POS, MODE_HISTORY)   // Only orders w/
      &&   OrderMagicNumber()  == magicNumber             // my magic number
      &&   OrderSymbol()       == Symbol()                 // and my pair,
      &&   OrderOpenTime()    > BOD)                       // closed today.
   {
      count++;
   }
   
   return (count);
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> TODAY ORDERS TOTAL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
int todayOpenOrdersTotal()
{
   datetime    BOD     = Time[0] - Time[0] % 86400;    // Beginning of today
                // Use  = TimeCurrent() - 86400 for last 24 hours
   int         count   = 0;
   for (int b = OrdersTotal()-1; b>=0; b--)
   
      if
      (
         OrderSelect(b, SELECT_BY_POS, MODE_TRADES)   // Only orders w/
      &&   OrderMagicNumber()  == magicNumber             // my magic number
      &&   OrderSymbol()       == Symbol()                 // and my pair,
      &&   OrderOpenTime()    > BOD)                      // closed today.
   {
      count++;
   }
   
   return (count);
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CHECK IF AT MAX DAY CLOSED ORDERS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
bool isMaxDayOrders()
{
   return todayClosedOrdersTotal() + todayOpenOrdersTotal() < maxDailyOrders;
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CHECK SIZE OF RANGE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
bool isRangeSizeAllowed()
{
   double sizeOfRange = ((range.highOfRange - range.lowOfRange) / Point);
   if (!useRangeSize)
      return true;
   else
      return (sizeOfRange >= minRangeSize) && (sizeOfRange <= maxRangeSize);
}


