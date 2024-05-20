//+------------------------------------------------------------------+
//|                                                  MegaMillinx.mq5 |
//|                              Copyright 2023, Linx Trading Co LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co LLC"
#property link      "https://www.linxtradingco.com"
#property version   "1.17"
#property description "The MEGA MILLINX expert advisor utilizes several indicator-based trading strategies along with price-action analysis in order to provide you with the smartest-executing EA on the market.\nFeaturing multi-time frame indicator analysis, price action identification, trend-following and much more!\n\nPlease reach out to Linx Trading Co LLC at linxtradingcollc@gmail.com with any questions, inquiries on purchase, or to renew your license. Happy trading!"

#include <LINX\Millinx\initDeInit.mqh>

MqlTick prevTick, lastTick;

string      initSymbol              = "";
datetime    prevBarTime             = iTime(_Symbol, _Period, 0);
double      accountStartingBalance  = 0;
datetime    expirationDate          = D'2024.05.18 00:00:00';

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//EXPERT ON-INIT FUNCTION//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int OnInit()
  {
   initializeExpert();
   return(INIT_SUCCEEDED);
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//EXPERT ON DE-INIT FUNCTION///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void OnDeinit(const int reason)
  {
   deInitializeExpert();
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//EXPERT ON-TICK FUNCTION//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void OnTick()
{
   updateIndicatorData();
   datetime currentBarTime = iTime(_Symbol, _Period, 0);

   if(myPositionsTotal() > 0)
   {
      checkOppSignal();
      checkEquityStopLoss();
      checkEquityTakeProfit();
      resetEntryStruct();
      checkCloseOutOfSession();
      checkNewsClose();
      if(allowGrid)
      {
         gridTradingLogic();
      }
      else 
      {
         if(useTrailingStop)
         {
            updateTrailingStop();
         }
         if(usePartialClose)
         {
            checkPartialClose();
         }
      }
   }
   else {searchForEntry();}
   if(initialPosAllowed())
   {
      if(trendEntryAllowed(entryS.entryIsBull))
      {
         orderExecution(currentBarTime);
      }
   }
   else {deletePendingOrders(); resetEntryStruct();}
   prevBarTime = currentBarTime;
}