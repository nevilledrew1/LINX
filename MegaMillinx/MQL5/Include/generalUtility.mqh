//+------------------------------------------------------------------+
//|                                               generalUtility.mqh |
//|                              Copyright 2023, Linx Trading Co LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co LLC"
#property link      "https://www.linxtradingco.com"

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//ORDER IS MINE////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool orderIsMine(string symbol, long magic)
{
   return (MQLInfoInteger(MQL_TESTER) || (symbol == _Symbol && magic == magicNumber));
}

int myPositionsTotal()
{
   int      count                = 0;
   uint     totalPos             = PositionsTotal();
   ulong    ticketNumber         = 0;
   string   symbol               = "";
   long     magic                = 0;
   
   for(int i = PositionsTotal()-1; i>=0; i--)
   {
      if((ticketNumber = PositionGetTicket(i)) > 0)
      {
         symbol         = PositionGetString(POSITION_SYMBOL);
         magic          = PositionGetInteger(POSITION_MAGIC);
         
         if(orderIsMine(symbol, magic))
         {
            ++count;
         }
      }
   }
   return count;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//COUNT OPEN POSITIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int openBuyPosCount()
{
   int      count                = 0;
   uint     totalPos             = PositionsTotal();
   ulong    ticketNumber         = 0;
   long     posSide              = 0;
   string   symbol               = "";
   long     magic                = 0;   
   
   for(int i = PositionsTotal()-1; i>=0; i--)
   {
      if((ticketNumber = PositionGetTicket(i)) > 0)
      {
         posSide        = PositionGetInteger(POSITION_TYPE); 
         symbol         = PositionGetString(POSITION_SYMBOL);
         magic          = PositionGetInteger(POSITION_MAGIC);
         
         if(posSide == 0 && orderIsMine(symbol, magic))
         {
            ++count;
         }
      }
   }
   return count;
}

int openSellPosCount()
{
   int      count                = 0;
   uint     totalPos             = PositionsTotal();
   ulong    ticketNumber         = 0;
   long     posSide              = 0;
   string   symbol               = "";
   long     magic                = 0;
   
   for(int i = PositionsTotal()-1; i>=0; i--)
   {
      if((ticketNumber = PositionGetTicket(i)) > 0)
      {
         posSide        = PositionGetInteger(POSITION_TYPE); 
         symbol         = PositionGetString(POSITION_SYMBOL);
         magic          = PositionGetInteger(POSITION_MAGIC);
         
         if(posSide == 1 && orderIsMine(symbol, magic))
         {
            ++count;
         }
      }
   }
   return count;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//CHECK EQUITY STOP / TP///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void checkEquityStopLoss()
{
   if(useFloatingStop && (openPl() <= -floatingStop))
   {
      Print("Floating stop-loss of $", floatingStop, " has Been Reached!\nClosing all trades...");
      closeAllOpenTrades();
   }
}

void checkEquityTakeProfit()
{
   if(useFloatingTakeProfit && (openPl() >= floatingTakeProfit))
   {
      Print("Floating take-profit of $", floatingTakeProfit, " has been reached!\nClosing all trades...");
      closeAllOpenTrades();
   }
}

double openPl()
{
   double   openPL               = 0;
   uint     totalPos             = PositionsTotal();
   ulong    ticketNumber         = 0;
   double   posProfit            = 0;
   string   symbol               = "";
   long     magic                = 0;
   
   for(int i = PositionsTotal()-1; i>=0; i--)
   {
      if((ticketNumber = PositionGetTicket(i)) > 0)
      {
         posProfit      = PositionGetDouble(POSITION_PROFIT); 
         symbol         = PositionGetString(POSITION_SYMBOL);
         magic          = PositionGetInteger(POSITION_MAGIC);
         
         if(orderIsMine(symbol, magic))
         {
            openPL += posProfit;
         }
      }
   }
   return openPL;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//CHECK DAILY STOP / TP////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool isDailyStopHit()
{
   if(useDailyStop)
   {
      if(todayOpenPL() + todayClosePL() <= -dailyStopValue)
      {
         dailyStopExecute();
         return true;
      }
   }
   return false;
}

bool isDailyTpHit()
{
   if(useDailyTakeProfit)
   {
      if(todayOpenPL() + todayClosePL() >= dailyTakeProfitValue)
      {
         dailyTpExecute();
         return true;
      }
   }
   return false;
}

void dailyStopExecute()
{
   //Alert("Daily stop-loss of $", dailyStopValue, " has been reached!\n Closing all positions and resuming trading tomorrow..");
   closeAllOpenTrades();
}

void dailyTpExecute()
{
   //Alert("Daily take-profit of $", dailyTakeProfitValue, " has been reached!\n Closing all positions and resuming trading tomorrow..");
   closeAllOpenTrades();
}

double todayOpenPL()
{
   datetime BOD=TimeCurrent();
   BOD=(BOD/86400)*86400;
   
   long     openTime             = 0;
   double   openPL               = 0;
   uint     totalPos             = PositionsTotal();
   ulong    ticketNumber         = 0;
   double   posProfit            = 0;
   string   symbol               = "";
   long     magic                = 0;
   
   for(int i = PositionsTotal()-1; i>=0; i--)
   {
      if((ticketNumber = PositionGetTicket(i)) > 0)
      {
         posProfit      = PositionGetDouble(POSITION_PROFIT); 
         symbol         = PositionGetString(POSITION_SYMBOL);
         magic          = PositionGetInteger(POSITION_MAGIC);
         openTime       = PositionGetInteger(POSITION_TIME);
         
         if(orderOpenedToday(BOD, openTime) && orderIsMine(symbol, magic))
         {
            openPL += posProfit;
         }
      }
   }
   return openPL;
}

double todayClosePL()
{
   datetime BOD=TimeCurrent();
   BOD=(BOD/86400)*86400;
   
   double   closePL              = 0;
   uint     totalNumberOfDeals   = HistoryDealsTotal();
   ulong    ticketNumber         = 0;
   long     dealEntry               ;
   double   orderProfit          = 0;
   string   symbol               = "";
   long     magic                = 0;
   long     dealTime             = 0;
   
   HistorySelect(BOD, TimeCurrent());
   for(uint i = 0; i<totalNumberOfDeals; i++)
   {
      if((ticketNumber = HistoryDealGetTicket(i)) > 0)
      {
         orderProfit    = HistoryDealGetDouble(ticketNumber, DEAL_PROFIT); 
         symbol         = HistoryDealGetString(ticketNumber, DEAL_SYMBOL);
         dealEntry      = HistoryDealGetInteger(ticketNumber, DEAL_ENTRY);
         magic          = HistoryDealGetInteger(ticketNumber, DEAL_MAGIC);
         dealTime       = HistoryDealGetInteger(ticketNumber, DEAL_TIME);
         
         if(dealEntry == 1 && orderIsMine(symbol, magic) && orderOpenedToday(BOD, dealTime))
         {
            closePL += orderProfit;
         }
      }
   }
   return closePL;
}

bool orderOpenedToday(datetime BOD, long time)
{
   return (time > (datetime(BOD)));
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//ARE MY TRADES IN PROFIT//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool tradesInProfit()
{
   double   openPL               = 0;
   uint     totalPos             = PositionsTotal();
   ulong    ticketNumber         = 0;
   double   posProfit            = 0;
   string   symbol               = "";
   long     magic                = 0;
   
   for(int i = PositionsTotal()-1; i>=0; i--)
   {
      if((ticketNumber = PositionGetTicket(i)) > 0)
      {
         posProfit      = PositionGetDouble(POSITION_PROFIT); 
         symbol         = PositionGetString(POSITION_SYMBOL);
         magic          = PositionGetInteger(POSITION_MAGIC);
         
         if(orderIsMine(symbol, magic))
         {
            openPL += posProfit;
         }
      }
   }
   return openPL > 0;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//CHECK MAX DAY ORDERS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool isMaxDayOrdersGood()
{
   return todayDealsOpenedTotal() < maxDailyOrders;
}

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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//WITHIN SESSION TIME//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool withinSessionTime()
{
   return (tradeStartToUse == 0) || withinAsia() || withinLondon() || withinNewYork();
}

bool withinAsia()
{
   datetime BOD=TimeCurrent();
   BOD=(BOD/86400)*86400;
   datetime asiaOpen = BOD + 7200;
   datetime asiaClose = BOD + 21600;

   return tradeAsia && TimeCurrent() >= asiaOpen && TimeCurrent() < asiaClose;
}

bool withinLondon()
{
   datetime BOD=TimeCurrent();
   BOD=(BOD/86400)*86400;
   datetime londonOpen = BOD + 32400;
   datetime londonClose = BOD + 46800;

   return tradeLondon && TimeCurrent() >= londonOpen && TimeCurrent() < londonClose;
}

bool withinNewYork()
{
   datetime BOD=TimeCurrent();
   BOD=(BOD/86400)*86400;
   datetime nyOpen = BOD + 54000;
   datetime nyClose = BOD + 86340;

   return tradeNewYork && TimeCurrent() >= nyOpen && TimeCurrent() < nyClose;
}

void checkCloseOutOfSession()
{
   if(closeOutOfSession && !withinSessionTime())
   {
      closeAllOpenTrades();
   }
}

bool outsideSwapRollover()
{
   datetime BOD=TimeCurrent();
   BOD=(BOD/86400)*86400;
   
   return tradeDuringSwapRollover || TimeCurrent() > BOD + 3600;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//NEWS FILTER//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool newsIncoming()
{
   if(highImpactTrade && medImpactNews)
   {
      return false;
   }
   else if(!highImpactTrade && medImpactNews)
   {
      return highImpactIncoming(minutesBeforeNews, minutesAfterNews);
   }
   else if(highImpactTrade && !medImpactNews)
   {
      return medImpactIncoming(minutesBeforeNews, minutesAfterNews);
   }
        
   else return highImpactIncoming(minutesBeforeNews, minutesAfterNews) && medImpactIncoming(minutesBeforeNews, minutesAfterNews); Print("true news incoming");
}

bool highImpactIncoming(int minutesAllowedBefore, int minutesAllowedAfter)
{
   MqlCalendarValue calendar[];
   datetime calStart = iTime(_Symbol, PERIOD_D1, 0);
   datetime calEnd   = calStart + PeriodSeconds(PERIOD_D1);
   CalendarValueHistory(calendar, calStart, calEnd, NULL, NULL);
   
   for(int i = 0; i < ArraySize(calendar); ++i)
   {
      MqlCalendarEvent event;
      CalendarEventById(calendar[i].event_id, event);
      MqlCalendarCountry country;
      CalendarCountryById(event.country_id, country);
      
      if(StringFind(_Symbol, country.currency) < 0) continue;
      if(event.importance == CALENDAR_IMPORTANCE_NONE || event.importance == CALENDAR_IMPORTANCE_LOW || event.importance == CALENDAR_IMPORTANCE_MODERATE) continue;
      
      if(((TimeCurrent() >= calendar[i].time - minutesAllowedBefore * 60) && (TimeCurrent() < calendar[i].time)) || (minutesAllowedAfter > 0 && ((TimeCurrent() > calendar[i].time) &&  TimeCurrent() <= calendar[i].time + minutesAllowedAfter * 60)))
      {
         return true;
      }
   }
   return false;
}

bool medImpactIncoming(int minutesAllowedBefore, int minutesAllowedAfter)
{
   MqlCalendarValue calendar[];
   datetime calStart = iTime(_Symbol, PERIOD_D1, 0);
   datetime calEnd   = calStart + PeriodSeconds(PERIOD_D1);
   CalendarValueHistory(calendar, calStart, calEnd, NULL, NULL);
   
   for(int i = 0; i < ArraySize(calendar); ++i)
   {
      MqlCalendarEvent event;
      CalendarEventById(calendar[i].event_id, event);
      MqlCalendarCountry country;
      CalendarCountryById(event.country_id, country);
      
      if(StringFind(_Symbol, country.currency) < 0) continue;
      if(event.importance == CALENDAR_IMPORTANCE_NONE || event.importance == CALENDAR_IMPORTANCE_LOW || event.importance == CALENDAR_IMPORTANCE_HIGH) continue;
      
      if(((TimeCurrent() >= calendar[i].time - minutesAllowedBefore * 60) && (TimeCurrent() < calendar[i].time)) || (minutesAllowedAfter > 0 && ((TimeCurrent() > calendar[i].time) &&  TimeCurrent() <= calendar[i].time + minutesAllowedAfter * 60)))
      {
         return true;
      }
   }
   return false;
}

void checkNewsClose()
{
   if(!closeBeforeHighImp && !closeBeforeMedImp)
   {
      return;
   }
   else if(!closeBeforeHighImp && closeBeforeMedImp)
   {
      if(medImpactIncoming(closeMinsBeforeNews, 0))
      {
         closeAllOpenTrades();
      }
   }
   else if(closeBeforeHighImp && !closeBeforeMedImp)
   {
      if(medImpactIncoming(closeMinsBeforeNews, 0))
      {
         closeAllOpenTrades();
      }
   }
   else if(highImpactIncoming(closeMinsBeforeNews, 0) && medImpactIncoming(closeMinsBeforeNews, 0))
   {
      closeAllOpenTrades();
   }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//TRAILING STOP////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void updateTrailingStop()
{
   if(trailingType == 1)
   {
      double   ask               = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
      double   bid               = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
      double   trailStopNormal   = NormalizeDouble(trailingStop*_Point, _Digits);
      double   trailStartNormal  = NormalizeDouble(trailingStart*_Point, _Digits);
      double   trailStepNormal   = NormalizeDouble(trailingStep*_Point, _Digits);
      double   currentStop       = 0;
      double   entryPrice        = 0;
      double   currentPrice      = 0;
      int      posTot            = PositionsTotal();
      long     orderSide         = 0;
      long     magic             = 0;
      ulong    ticket            = 0;
      string   symbol            = "";
      
      for(int i = PositionsTotal()-1; i>=0; i--)
      {
         symbol         = PositionGetSymbol(i);
         magic          = PositionGetInteger(POSITION_MAGIC);
         ticket         = PositionGetInteger(POSITION_TICKET);
         currentStop    = PositionGetDouble(POSITION_SL);
         entryPrice     = PositionGetDouble(POSITION_PRICE_OPEN);
         currentPrice   = PositionGetDouble(POSITION_PRICE_CURRENT);
         orderSide      = PositionGetInteger(POSITION_TYPE);

         if(!trailOnlyProf)
         {
            if(orderIsMine(symbol, magic) && orderSide == 0 && currentPrice >= entryPrice + trailStartNormal && (currentStop <= bid - trailStopNormal - trailStepNormal || currentStop == 0))
            {
               trade.PositionModify(ticket, bid-trailStopNormal, NULL);
            }
            if(orderIsMine(symbol, magic) && orderSide == 1 && currentPrice <= entryPrice - trailStartNormal && (currentStop >= ask + trailStopNormal + trailStepNormal || currentStop == 0))
            {
               trade.PositionModify(ticket, ask+trailStopNormal, NULL);
            }
         }
         else
         {
            if(orderIsMine(symbol, magic) && orderSide == 0 && currentPrice >= entryPrice + trailStartNormal && (currentStop <= bid - trailStopNormal - trailStepNormal || currentStop == 0) && bid-trailStopNormal > findAverageEntry())
            {
               trade.PositionModify(ticket, bid-trailStopNormal, NULL);
            }
            if(orderIsMine(symbol, magic) && orderSide == 1 && currentPrice <= entryPrice - trailStartNormal && (currentStop >= ask + trailStopNormal + trailStepNormal || currentStop == 0) && ask+trailStopNormal < findAverageEntry())
            {
               trade.PositionModify(ticket, ask+trailStopNormal, NULL);
            }
         }
      }
   }
   else
   {
      double   ask               = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
      double   bid               = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
      double   trailStopNormal   = NormalizeDouble(trailingStop*_Point, _Digits);
      double   trailStartNormal  = NormalizeDouble(trailingStart*_Point, _Digits);
      double   trailStepNormal   = NormalizeDouble(trailingStep*_Point, _Digits);
      double   currentStop       = 0;
      double   entryPrice        = 0;
      double   currentPrice      = 0;
      int      posTot            = PositionsTotal();
      long     orderSide         = 0;
      long     magic             = 0;
      ulong    ticket            = 0;
      string   symbol            = "";
      
      for(int i = PositionsTotal()-1; i>=0; i--)
      {
         symbol         = PositionGetSymbol(i);
         magic          = PositionGetInteger(POSITION_MAGIC);
         ticket         = PositionGetInteger(POSITION_TICKET);
         currentStop    = PositionGetDouble(POSITION_SL);
         entryPrice     = PositionGetDouble(POSITION_PRICE_OPEN);
         currentPrice   = PositionGetDouble(POSITION_PRICE_CURRENT);
         orderSide      = PositionGetInteger(POSITION_TYPE);

         if(!trailOnlyProf)
         {
            if(orderIsMine(symbol, magic) && orderSide == 0 && currentPrice > sar.valueCurrent && currentStop != sar.valueCurrent && (currentStop < sar.valueCurrent || currentStop == 0))
            {
               trade.PositionModify(ticket, sar.valueCurrent, NULL);
            }
            if(orderIsMine(symbol, magic) && orderSide == 1 && currentPrice <sar.valueCurrent && currentStop != sar.valueCurrent && (currentStop > sar.valueCurrent || currentStop == 0))
            {
               trade.PositionModify(ticket, sar.valueCurrent, NULL);
            }
         }
         else
         {
            if(orderIsMine(symbol, magic) && orderSide == 0 && currentPrice > sar.valueCurrent && currentStop != sar.valueCurrent && (currentStop < sar.valueCurrent || currentStop == 0) && sar.valueCurrent >= findAverageEntry())
            {
               trade.PositionModify(ticket, sar.valueCurrent, NULL);
            }
            if(orderIsMine(symbol, magic) && orderSide == 1 && currentPrice <sar.valueCurrent && currentStop != sar.valueCurrent && (currentStop > sar.valueCurrent || currentStop == 0) && sar.valueCurrent <= findAverageEntry())
            {
               trade.PositionModify(ticket, sar.valueCurrent, NULL);
            }
         }
      }
   }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//PARTIALS CLOSE///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void checkPartialClose()
{
   double   ask               = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double   bid               = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double   priceToClosePart  = 0;
   int      partialsClosedTot = initialTrade.partialsClosed + 1;
   double   lotToClose        = MathRound(initialTrade.lot * initialTrade.partialsLotPercent / SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP))* SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
   
   if(initialTrade.posSide == 1)
   {
      priceToClosePart = ((((initialTrade.tpDistance * initialTrade.partialsPercent) * partialsClosedTot) * _Point) + initialTrade.entryPrice);
      if(bid >= priceToClosePart && bid != initialTrade.tp)
      {
         int      posTot            = PositionsTotal();
         long     orderSide         = 0;
         long     magic             = 0;
         ulong    ticket            = 0;
         string   symbol            = "";
         
         for(int i = PositionsTotal()-1; i>=0; i--)
         {
            symbol         = PositionGetSymbol(i);
            magic          = PositionGetInteger(POSITION_MAGIC);
            ticket         = PositionGetInteger(POSITION_TICKET);
            
            if(orderIsMine(symbol, magic))
            {
               if(trade.PositionClosePartial(ticket, lotToClose, NULL))
               {
                  initialTrade.lot -= lotToClose;
                  initialTrade.partialsClosed += 1;
               }
            }
         }
      }
   }
   else if(initialTrade.posSide == 2)
   {
      priceToClosePart = (initialTrade.entryPrice - (_Point * ((initialTrade.tpDistance * initialTrade.partialsPercent) * partialsClosedTot)));
      if(ask <= priceToClosePart && ask != initialTrade.tp)
      {
         int      posTot            = PositionsTotal();
         long     orderSide         = 0;
         long     magic             = 0;
         ulong    ticket            = 0;
         string   symbol            = "";
         
         for(int i = PositionsTotal()-1; i>=0; i--)
         {
            symbol         = PositionGetSymbol(i);
            magic          = PositionGetInteger(POSITION_MAGIC);
            ticket         = PositionGetInteger(POSITION_TICKET);
            
            if(orderIsMine(symbol, magic))
            {
               if(trade.PositionClosePartial(ticket, lotToClose, NULL))
               {
                  initialTrade.lot -= lotToClose;
                  initialTrade.partialsClosed += 1;
               }
            }
         }
      }
   } 
}