//+------------------------------------------------------------------+
//|                                         LRB-BreakoutTriggers.mqh |
//|                             Copyright 2023, Linx Trading Co. LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co. LLC"
#property link      "https://www.linxtradingco.com"

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CHECK BREAKOUT TRIGGERS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void checkBreakoutTriggers()
{
   resetBreakoutTriggers();
   
   if (!range.f_high_breakout && lastTick.ask > range.highOfRange)
   {
      range.f_high_breakout = true;
      HighBreakoutTrigger();
   }
      
   if(!range.f_low_breakout && lastTick.bid < range.lowOfRange)
   {
      range.f_low_breakout = true;
      LowBreakoutTrigger();
   }
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> HIGH BREAKOUT TRIGGER <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void HighBreakoutTrigger()
{
   if (!useReverseTrades)
   {
      if(canOpenAnotherBuy() && openBuyPosCount() == 0)
      {
         openBuyPos();
      }
   }
   else
   {
         if(canOpenAnotherSell() && openSellPosCount() == 0)
         {
            openSellPos();
         }
   }
   
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> LOW BREAKOUT TRIGGER <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void LowBreakoutTrigger()
{
   if (!useReverseTrades)
   {
      if(canOpenAnotherSell() && openSellPosCount() == 0)
      {
         openSellPos();
      }
   }
   else
   {  
         if(canOpenAnotherBuy() && openBuyPosCount() == 0)
         {
            openBuyPos();
         }   
   }
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RESET BREAKOUT TRIGGERS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void resetBreakoutTriggers()
{

   if (lastTick.bid < range.highOfRange)
   {
      range.f_high_breakout = false;
   }
   if (lastTick.bid > range.lowOfRange)
   {
      range.f_low_breakout = false;
   }
}