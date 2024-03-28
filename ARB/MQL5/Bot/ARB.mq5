//+------------------------------------------------------------------+
//|                                             LinxRB-MT5-V1.00.mq5 |
//|                             Copyright 2023, Linx Trading Co. LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co. LLC"
#property link      "https://www.linxtradingco.com"
#property version   "1.04"
#property description "The LinxARB expert advisor is a trading bot that features a ranging breakout automated trading strategy. The LinxARB utilizes a user-defined time range and features trailing stop, breakeven, and several other trade and risk management features!"
#property description "\n Please reach out to linxtradingcollc@gmail.com with any questions or issues! Happy trading."

#include <Trade\Trade.mqh>
#include <LINX\ARB\Files.mqh>

CTrade trade;

MqlTick prevTick, lastTick;

string      initSymbol              = "";
int         screenDPI               = TerminalInfoInteger(TERMINAL_SCREEN_DPI);
datetime    prevBarTime             = iTime(_Symbol, _Period, 0);
double      accountStartingBalance  = 0;
datetime    expirationDate          = D'2024.04.01 00:00:00';

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ONINIT FUNCTION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
int OnInit()
{
   runInitializationChecks();
   setChartColors();
   decideAndCreateLabelText(screenDPI);
   updateLabelText(screenDPI);
   trade.SetExpertMagicNumber(magicNumber);
   accountStartingBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   initSymbol = _Symbol;

   return(INIT_SUCCEEDED);
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ON DEINIT FUNCTION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void OnDeinit(const int reason)
{
   Comment("");
   deleteRangeDrawings();
   deleteAllDrawings();
   deleteLabelText();
   resetChartColors();
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ON TICK FUNCTION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void OnTick()
{
   prevTick = lastTick;
   SymbolInfoTick(_Symbol, lastTick);

   datetime currentBarTime = iTime(_Symbol, _Period, 0);      
   
   if(allowedToTrade())
   {
      checkBreakoutTriggers();
      if(waitForClose)
      {
         if(range.f_awaiting_high_close && currentBarTime != prevBarTime)
         {
            checkIfClosedAbove();
         }
         if(range.f_awaiting_low_close && currentBarTime != prevBarTime)
         {
            checkIfClosedBelow();
         }
         if(range.f_awaiting_rev_close_under_high && currentBarTime != prevBarTime)
         {
            checkIfClosedUnderHigh();
         }
         if(range.f_awaiting_rev_close_above_low && currentBarTime != prevBarTime)
         {
            checkIfClosedAboveLow();
         }
      }
   }
   if(myPositionsTotal() > 0)
   {
      updateTSandBE();
      checkForDailyPL();
      updateLabelText(screenDPI);
   }           
   if(range.withinRangeTime(lastTick.time))
   {
      calculateRangeHighsAndLows();
   }
   if(shouldCalculateNewRange())     
   {
      calculateNewRange();
   }
   prevBarTime = currentBarTime;  
}
   


