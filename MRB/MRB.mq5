//+------------------------------------------------------------------+
//|                                             LinxRB-MT5-V1.00.mq5 |
//|                             Copyright 2023, Linx Trading Co. LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co. LLC"
#property link      "https://www.linxtradingco.com"
#property version   "1.00"
#property description "The LinxARB expert advisor is a trading bot that features a ranging breakout automated trading strategy. The LinxARB utilizes a user-defined time range and features trailing stop, breakeven, and several other trade and risk management features!"
#property description "\n Please reach out to linxtradingcollc@gmail.com with any questions or issues! Happy trading."

#include <WebLicense\LicenseChecker.mqh>
#include <Trade\Trade.mqh>
#include <LINXinclude\LinxMRB\LRB-Files.mqh>

CTrade trade;

int   screenDPI = TerminalInfoInteger(TERMINAL_SCREEN_DPI);
long  accNum = AccountInfoInteger(ACCOUNT_LOGIN);

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ONINIT FUNCTION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
int OnInit()
{
   if (MQLInfoInteger(MQL_TESTER)) 
   {
      printf("STRATEGY TESTING - WEBREQUEST VOIDED");
      return (INIT_SUCCEEDED);
   }
   else if(!linx::LicenseChecker::verifyUser(userID, 11111, accNum))
   {
      Alert("Unable to verify license");
      ExpertRemove();
   } 
   
   setChartColors();
   decideAndCreateBoxLabel(screenDPI);
   updateChartLabels(screenDPI);
   trade.SetExpertMagicNumber(magicNumber);
  
   if(UninitializeReason() == REASON_PARAMETERS)
   {
      Print("Input parameters changed, re-initializing expert.");
   }
  
   if(checkUserInputs() == 32767)
   {
      Alert("Fatal input parameters, removing expert from ", _Symbol, ".\nPlease re-initialize expert after addressing the printed error.");
      ExpertRemove();
   }
   
return(INIT_SUCCEEDED);
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ON DEINIT FUNCTION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void OnDeinit(const int reason)
{
   Comment("");
   deleteAllDrawings();
   //resetChartColors();
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ON TICK FUNCTION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void OnTick()
{
   prevTick = lastTick;
   SymbolInfoTick(_Symbol, lastTick);

   checkAndInitializeRangePriceLevels();
   if(allowedToTrade())
   {
      checkBreakoutTriggers();
   }
   if(myPositionsTotal() > 0)
   {
      updateTSandBE();
      checkForDailyPL();
      updateChartLabels(screenDPI);
   }           
}
   //Initialize range prices and trade time flag
   //If allowed to trade check breakout triggers
   //Update SLBE
   
   /*
   
   AllowedToTrade()
   {
   return !shouldReInitRange()
            !dailySL
            !dailyTP
            range.WithinTradeTime
   }
   
   shouldReInitRange()
   {
      if(pastStopTime or stopAfter 1 trade, 2 trade, etc.)
      {
         remove range lines
         return false
      }
   return true
   }
   
   
   
   */
   


