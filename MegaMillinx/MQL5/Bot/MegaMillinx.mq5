//+------------------------------------------------------------------+
//|                                                  MegaMillinx.mq5 |
//|                              Copyright 2023, Linx Trading Co LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co LLC"
#property link      "https://www.linxtradingco.com"
#property version   "1.00"

datetime prevBarTime    = iTime(_Symbol, _Period, 0);

int OnInit()
  {

   

   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {

   
  }

void OnTick()
{
   prevTick = lastTick;
   SymbolInfoTick(_Symbol, lastTick);
   datetime currentBarTime = iTime(_Symbol, _Period, 0);
   
   if(currentBarTime != prevBarTime && allowedToTrade())
   {
      resetFVG();
      
      if(identifyNewFVG())
      {
         newFvgAlert();
      }
   }
   
   if(myOpenPositions() > 0)
   {
      checkIfNeedToMart(initialTrade.posSide);
   }
   prevBarTime = currentBarTime;
}
