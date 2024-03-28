//+------------------------------------------------------------------+
//|                                             LinxARB4-March24.mq4 |
//|                                             Linx Trading Co. LLC |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Linx Trading Co. LLC"
#property link      "https://www.mql5.com"
#property version   "1.04"
#property description "The LinxARB expert advisor is a trading bot that features a ranging breakout automated trading strategy. The LinxARB utilizes a user-defined time range and features trailing stop, breakeven, and several other trade and risk management features!"
#property description "\n Please reach out to linxtradingcollc@gmail.com with any questions or issues! Happy trading."
#property strict

#include <LINX\ARB4\Files.mqh>

MqlTick prevTick, lastTick;

string   initSymbol              = "";
double   accountStartingBalance  = AccountBalance();
int      screenDPI               = TerminalInfoInteger(TERMINAL_SCREEN_DPI);
datetime prevBarTime             = iTime(_Symbol, _Period, 0);
datetime expiration              = D'2024.04.01 00:00:00';

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> EXPERT ON INIT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
int OnInit()
{
   runInitializationChecks();           
   setChartColors();
   decideAndCreateLabelText(screenDPI);
   updateLabelText(screenDPI);
   initSymbol = _Symbol;

   return(INIT_SUCCEEDED);
}
// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> EXPERT ON DE INIT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
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
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> EXPERT ON TICK <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
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
   if(OrdersTotal() > 0)
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



