//+------------------------------------------------------------------+
//|                                                  LRB-DailyPL.mqh |
//|                             Copyright 2023, Linx Trading Co. LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co. LLC"
#property link      "https://www.linxtradingco.com"

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Check Daily P&L <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void checkForDailyPL()
{
   
   if (useDailyStopLoss)
   {
      if(checkDailyStopLoss())
      {
         dailyStopExecute();
      }
   }
   if (useDailyTakeProfit)
   {
      if(checkDailyTakeProfit())
      {
         dailyTakeProfitExecute();
      }
   }
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Today Close PL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

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

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Today Open PL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

double todayOpenPL()
{
   datetime BOD=TimeCurrent();
   BOD=(BOD/86400)*86400;
   
   long     openTime             = 0;
   double   openPL               = 0;
   uint     totalPos             = myPositionsTotal();
   ulong    ticketNumber         = 0;
   double   posProfit            = 0;
   string   symbol               = "";
   long     magic                = 0;
   
   for(uint i = 0; i<totalPos; ++i)
   {
      if((ticketNumber = PositionGetTicket(i)) > 0)
      {
         posProfit      = PositionGetDouble(POSITION_PROFIT); 
         symbol         = PositionGetString(POSITION_SYMBOL);
         magic          = PositionGetInteger(POSITION_MAGIC);
         openTime       = PositionGetInteger(POSITION_TIME);
         
         if(orderOpenedToday(BOD, openTime))
         {
            openPL += posProfit;
         }
         
      }
   }
   
   return openPL;

}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Check Daily Stop <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

bool checkDailyStopLoss()
{
   return todayOpenPL() + todayClosePL() <= - accountStartingBalance * (dailyStopLoss / 100);
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Check Daily TP <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

bool checkDailyTakeProfit()
{
   return todayOpenPL() + todayClosePL() >= accountStartingBalance * (dailyTakeProfit / 100);
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Daily SL Execute <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void dailyStopExecute()
{
   Alert("Daily Stop-Loss % has been reached, attempting to close trades..");
      
   int         posTotal    = myPositionsTotal();
   ulong       ticket      = 0;
   string      symbol      = "";
   long        magic       = 0;
   
   for (int i = 0; i < posTotal; ++i)
   {
      if((ticket = PositionGetTicket(i)) >0)
      {
         symbol               = PositionGetString(POSITION_SYMBOL);
         magic                = PositionGetInteger(POSITION_MAGIC);
         trade.PositionClose(ticket, NULL);          
      }
   }
   Alert("Removing expert from chart: ", _Symbol, " due to daily stop-loss limit!");
   ExpertRemove();
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Daily TP Execute <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void dailyTakeProfitExecute()
{
   Alert("Daily Take-Profit % has been reached, attempting to close trades..");
        
   int         posTotal    = myPositionsTotal();
   ulong       ticket      = 0;
   string      symbol      = "";
   long        magic       = 0;
   
   for (int i = 0; i < posTotal; ++i)
   {
      if((ticket = PositionGetTicket(i)) >0)
      {
         symbol               = PositionGetString(POSITION_SYMBOL);
         magic                = PositionGetInteger(POSITION_MAGIC);
         trade.PositionClose(ticket, NULL);          
      }
   }
   Alert("Removing expert from chart: ", _Symbol, " due to daily take-profit limit!");
   ExpertRemove();
}