//+------------------------------------------------------------------+
//|                                           LRB-CanOpenAnother.mqh |
//|                             Copyright 2023, Linx Trading Co. LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co. LLC"
#property link      "https://www.linxtradingco.com"

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CanOpenAnotherSell <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
 
bool canOpenAnotherSell()
{
   int todaysSellCount = todayShortDeals();
   return allowMultipleSame || todaysSellCount == 0;
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CanOpenAnotherBuy <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

bool canOpenAnotherBuy()
{
   int todaysBuyCount = todayLongDeals();
   return allowMultipleSame || todaysBuyCount == 0;
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> TodayShortDeals <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

int todayShortDeals()
{
   datetime BOD=TimeCurrent();
   BOD=(BOD/86400)*86400;
   
   uint     totalNumberOfDeals   = HistoryDealsTotal();
   ulong    ticketNumber         = 0;
   long     orderSide, dealEntry;
   string   symbol               = "";
   long     magic                = 0;
   int      count                = 0;
   
   HistorySelect(BOD, TimeCurrent());
   for(uint i = 0; i<totalNumberOfDeals; ++i)
   {
      if((ticketNumber = HistoryDealGetTicket(i)) > 0)
      { 
         orderSide = HistoryDealGetInteger(ticketNumber, DEAL_TYPE);
         magic     = HistoryDealGetInteger(ticketNumber, DEAL_MAGIC);
         symbol    = HistoryDealGetString(ticketNumber, DEAL_SYMBOL);
         dealEntry = HistoryDealGetInteger(ticketNumber, DEAL_ENTRY);
         
         if(orderSide == ORDER_TYPE_SELL && dealEntry == 0 && orderIsMine(symbol, magic))
         {
            ++count;
         }
      }
   }
   return count;
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> TodayLongDeals <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

int todayLongDeals()
{
   datetime BOD=TimeCurrent();
   BOD=(BOD/86400)*86400;
   
   uint     totalNumberOfDeals   = HistoryDealsTotal();
   ulong    ticketNumber         = 0;
   long     orderSide, dealEntry;
   string   symbol               = "";
   long     magic                = 0;
   int      count                = 0;
   
   HistorySelect(BOD, TimeCurrent());
   for(uint i = 0; i<totalNumberOfDeals; ++i)
   {
      if((ticketNumber = HistoryDealGetTicket(i)) > 0)
      { 
         orderSide = HistoryDealGetInteger(ticketNumber, DEAL_TYPE);
         magic     = HistoryDealGetInteger(ticketNumber, DEAL_MAGIC);
         symbol    = HistoryDealGetString(ticketNumber, DEAL_SYMBOL);
         dealEntry = HistoryDealGetInteger(ticketNumber, DEAL_ENTRY);
         
         if(orderSide == ORDER_TYPE_BUY && dealEntry == 0 && orderIsMine(symbol, magic))
         {
            ++count;
         }
      }
   }
   return count;
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> OPENSellPosCount <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

int openSellPosCount()
{
   datetime BOD=TimeCurrent();
   BOD=(BOD/86400)*86400;
   
   int      count                = 0;
   long     openTime             = 0;
   uint     totalPos             = myPositionsTotal();
   ulong    ticketNumber         = 0;
   long     posSide              = 0;
   string   symbol               = "";
   long     magic                = 0;
   
   for(uint i = 0; i<totalPos; ++i)
   {
      if((ticketNumber = PositionGetTicket(i)) > 0)
      {
         posSide        = PositionGetInteger(POSITION_TYPE); 
         symbol         = PositionGetString(POSITION_SYMBOL);
         magic          = PositionGetInteger(POSITION_MAGIC);
         openTime       = PositionGetInteger(POSITION_TIME);
         
         if(orderOpenedToday(BOD, openTime) && posSide == 1)
         {
            ++count;
         }
      }
   }
   return count;
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> OPEN BuyPosCount <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

int openBuyPosCount()
{
   datetime BOD=TimeCurrent();
   BOD=(BOD/86400)*86400;
   
   int      count                = 0;
   long     openTime             = 0;
   uint     totalPos             = myPositionsTotal();
   ulong    ticketNumber         = 0;
   long     posSide              = 0;
   string   symbol               = "";
   long     magic                = 0;
   
   for(uint i = 0; i<totalPos; ++i)
   {
      if((ticketNumber = PositionGetTicket(i)) > 0)
      {
         posSide        = PositionGetInteger(POSITION_TYPE); 
         symbol         = PositionGetString(POSITION_SYMBOL);
         magic          = PositionGetInteger(POSITION_MAGIC);
         openTime       = PositionGetInteger(POSITION_TIME);
         
         if(orderOpenedToday(BOD, openTime) && posSide == 0)
         {
            ++count;
         }
      }
   }
   return count;
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> WAS ORDER OPENED TODAY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
bool orderOpenedToday(datetime BOD, long time)
{
   return (time > (datetime(BOD)));
}