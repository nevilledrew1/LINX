//+------------------------------------------------------------------+
//|                                             BreakoutTriggers.mqh |
//|                                             Linx Trading Co. LLC |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Linx Trading Co. LLC"
#property link      "https://www.mql5.com"
#property strict

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CHECK BREAKOUT TRIGGERS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void checkBreakoutTriggers()
{
   resetBreakoutTriggers();
   
   if (!range.f_high_breakout && lastTick.ask > range.highOfRange)
   {
      range.f_high_breakout = true;
      highBreakoutAlert();
   }
      
   if(!range.f_low_breakout && lastTick.bid < range.lowOfRange)
   {
      range.f_low_breakout = true;
      lowBreakoutAlert();
   }
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> HIGH BREAKOUT TRIGGER <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void highBreakoutAlert()
{
   if(waitForClose)
   {
      if(!useReverseTrades)
      {
         range.f_awaiting_high_close = true;
      }
      else range.f_awaiting_rev_close_under_high = true;
   }
   
   else{normalHighBreakoutTrigger();}
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> LOW BREAKOUT TRIGGER <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void lowBreakoutAlert()
{
   if(waitForClose)
   {
      if(!useReverseTrades)
      {
         range.f_awaiting_low_close = true;
      }
      else range.f_awaiting_rev_close_above_low = true;
   }
   else{normalLowBreakoutTrigger();}
}

void normalHighBreakoutTrigger()
{
   if (!useReverseTrades)
   {
      if(canOpenAnotherBuy() && openBuyPosCount() == 0 && (ordSideInp == 0 || ordSideInp == 1))
      {
         openBuyPos();
      }
   }

   else
   {
         if(canOpenAnotherSell() && openSellPosCount() == 0 && (ordSideInp == 0 || ordSideInp == 2))
         {
            openSellPos();
         }
   }
}

void normalLowBreakoutTrigger()
{
   if (!useReverseTrades)
   {
      if(canOpenAnotherSell() && openSellPosCount() == 0 && (ordSideInp == 0 || ordSideInp == 2))
      {
         openSellPos();
      }
   }
   
   else
   {  
         if(canOpenAnotherBuy() && openBuyPosCount() == 0 && (ordSideInp == 0 || ordSideInp == 1))
         {
            openBuyPos();
         }   
   }
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RESET BREAKOUT ALERTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void resetBreakoutTriggers()
{
   if (lastTick.ask < range.highOfRange)
   {
      range.f_high_breakout = false;
   }
   if (lastTick.bid > range.lowOfRange)
   {
      range.f_low_breakout = false;
   }
}

void checkIfClosedAbove()
{
   double prevCandleClosePrice = iClose(_Symbol, _Period, 1);
   if(prevCandleClosePrice > range.highOfRange && canOpenAnotherBuy() && openBuyPosCount() == 0 && (ordSideInp == 0 || ordSideInp == 1))
   {
      openBuyPos();
   }
   range.f_awaiting_high_close = false;
}

void checkIfClosedBelow()
{
   double prevCandleClosePrice = iClose(_Symbol, _Period, 1);
   if(prevCandleClosePrice < range.lowOfRange && canOpenAnotherSell() && openSellPosCount() == 0 && (ordSideInp == 0 || ordSideInp == 2))
   {
      openSellPos();
   }
   range.f_awaiting_low_close = false;
}

void checkIfClosedUnderHigh()
{
   double prevCandleClosePrice = iClose(_Symbol, _Period, 1);
   if(prevCandleClosePrice < range.highOfRange && canOpenAnotherSell() && openSellPosCount() == 0 && (ordSideInp == 0 || ordSideInp == 2))
   {
      openSellPos();
   }
   range.f_awaiting_rev_close_under_high = false;
}
void checkIfClosedAboveLow()
{
   double prevCandleClosePrice = iClose(_Symbol, _Period, 1);
   if(prevCandleClosePrice > range.lowOfRange && canOpenAnotherBuy() && openBuyPosCount() == 0 && (ordSideInp == 0 || ordSideInp == 1))
   {
      openBuyPos();
   }
   range.f_awaiting_rev_close_above_low = false;
}