//+------------------------------------------------------------------+
//|                                                  priceAction.mqh |
//|                              Copyright 2023, Linx Trading Co LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co LLC"
#property link      "https://www.linxtradingco.com"

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//CHECK PRICE FUNCTION/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void checkPriceAction(datetime currentBarTime)
{
   if(currentBarTime != prevBarTime)
   {
      if(patternsToUse == 1 && identifyNewHammer())
      {
         deletePendingOrders();
         newHamAlert();
      }
      else if(patternsToUse == 2 && identifyNewDoji())
      {
         deletePendingOrders();
         newDojiAlert();
      }
      else if (patternsToUse == 3 && (identifyNewHammer() || identifyNewDoji()))
      {
         deletePendingOrders();
         newHammerDojiAlert();
      }
      else if(patternsToUse == 4 && identifyNewFVG())
      {
         deletePendingOrders();
         newFvgAlert();
      }
   }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//FVG LOGIC////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct FVG
{
    bool isNew;    //Is New Gap
    datetime time; // Time of the FVG
    double high;   // High price of the FVG
    double low;    // Low price of the FVG
    double size;   // Size of the FVG (difference between high and low)
    bool bullish;  // Flag indicating if the FVG is bullish (true) or bearish (false)
};

FVG newFVG;

void resetFVG()
{
    newFVG.isNew  = false;
    newFVG.time = 0;
    newFVG.high = 0;
    newFVG.low = 0;
    newFVG.size = 0;
}

bool identifyNewFVG()
{
      resetFVG();
      double high1 = iHigh(_Symbol, PERIOD_CURRENT, 3);
      double low1 = iLow(_Symbol, PERIOD_CURRENT, 3);
      double high2 = iHigh(_Symbol, PERIOD_CURRENT, 2);
      double low2 = iLow(_Symbol, PERIOD_CURRENT, 2);
      double high3 = iHigh(_Symbol, PERIOD_CURRENT, 1);
      double low3 = iLow(_Symbol, PERIOD_CURRENT, 1);

      bool bullishFVG = high1 < low3;
      bool bearishFVG = low1 > high3;

      if (bullishFVG || bearishFVG)
      {
         double fvgSize;

         if (bullishFVG)
         {
             fvgSize = low3 - high1;

             newFVG.isNew  = true;
             newFVG.time = iTime(_Symbol, PERIOD_CURRENT, 2);
             newFVG.low = high1;
             newFVG.high = low3;
             newFVG.size = fvgSize;
             newFVG.bullish = true;
         }
         else
         {
             fvgSize = high3 - low1;

             newFVG.isNew = true;
             newFVG.time = iTime(_Symbol, PERIOD_CURRENT, 2);
             newFVG.low = high3;
             newFVG.high = low1;
             newFVG.size = fvgSize;
             newFVG.bullish = false;
         }
      }
   return newFVG.isNew;
}

void newFvgAlert()
{
   if(newFVG.bullish && entryS.entryIsBull)
   { 
      executeLimitOrder(1, newFVG.high);
   }
   if(!newFVG.bullish && !entryS.entryIsBull)
   {
      executeLimitOrder(2, newFVG.low);
   }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//HAMMER LOGIC/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct hammer
{
    bool       isNew;   // Is New 
    datetime   time;    // Time
    double     high;    // High price 
    double     low;     // Low price
    double     open;    // Open Price
    double     close;   // Close price
    bool       bullish; // Flag indicating if the FVG is bullish (true) or bearish (false)
};

hammer newHam;

void resetHam()
{
    newHam.isNew  = false;
    newHam.time = 0;
    newHam.high = 0;
    newHam.low = 0;
    newHam.open = 0;
    newHam.close = 0;
}

bool identifyNewHammer()
{
      resetHam();
      double high1   = iHigh(_Symbol, PERIOD_CURRENT, 1);
      double low1    = iLow(_Symbol, PERIOD_CURRENT, 1);
      double open1   = iOpen(_Symbol, PERIOD_CURRENT, 1);
      double close1  = iClose(_Symbol, PERIOD_CURRENT, 1);

      bool bullishHam = hammerDetector(open1, high1, low1, close1) == 1;
      bool bearishHam = hammerDetector(open1, high1, low1, close1) == 2;

      if (bullishHam || bearishHam)
      {
         if (bullishHam)
         {
             newHam.isNew     = true;
             newHam.time      = iTime(_Symbol, PERIOD_CURRENT, 1);
             newHam.low       = low1;
             newHam.high      = high1;
             newHam.close     = close1;
             newHam.bullish   = true;
         }
         else
         {
             newHam.isNew     = true;
             newHam.time      = iTime(_Symbol, PERIOD_CURRENT, 1);
             newHam.low       = low1;
             newHam.high      = high1;
             newHam.open      = open1;
             newHam.close     = close1;
             newHam.bullish   = false;
         }
      }
   return newHam.isNew;
}

int hammerDetector(double open, double high, double low, double close)
{
   double size = high - low;
   double bearHamLevel = (size * 0.382) + low;
   double bullHamLevel = high - (size * 0.382);
   
   if(open > bullHamLevel && close > bullHamLevel)
   {
      return 1;
   }
   if(open < bearHamLevel && close < bearHamLevel)
   {
      return 2;
   }
   else return 0;
}

void newHamAlert()
{
   if(newHam.bullish && entryS.entryIsBull)
   { 
      executeMarketOrder(1);
   }
   if(!newHam.bullish && !entryS.entryIsBull)
   {
      executeMarketOrder(2);
   }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//DOJI LOGIC///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct doji
{
    bool       isNew;   // Is New 
    datetime   time;    // Time
    double     high;    // High price 
    double     low;     // Low price
    double     open;    // Open Price
    double     close;   // Close price
    bool       bullish; // Flag indicating if the FVG is bullish (true) or bearish (false)
};

doji newDoji;

void resetDoji()
{
    newDoji.isNew  = false;
    newDoji.time = 0;
    newDoji.high = 0;
    newDoji.low = 0;
    newDoji.open = 0;
    newDoji.close = 0;
}

bool identifyNewDoji()
{
      resetDoji();
      double high1   = iHigh(_Symbol, PERIOD_CURRENT, 1);
      double low1    = iLow(_Symbol, PERIOD_CURRENT, 1);
      double open1   = iOpen(_Symbol, PERIOD_CURRENT, 1);
      double close1  = iClose(_Symbol, PERIOD_CURRENT, 1);

      bool bullishDoji = dojiDetector(open1, high1, low1, close1) == 1;
      bool bearishDoji = dojiDetector(open1, high1, low1, close1) == 2;

      if (bullishDoji || bearishDoji)
      {
         if (bullishDoji)
         {
             newDoji.isNew     = true;
             newDoji.time      = iTime(_Symbol, PERIOD_CURRENT, 1);
             newDoji.low       = low1;
             newDoji.high      = high1;
             newDoji.close     = close1;
             newDoji.bullish   = true;
         }
         else
         {
             newDoji.isNew     = true;
             newDoji.time      = iTime(_Symbol, PERIOD_CURRENT, 1);
             newDoji.low       = low1;
             newDoji.high      = high1;
             newDoji.open      = open1;
             newDoji.close     = close1;
             newDoji.bullish   = false;
         }
      }
   return newDoji.isNew;
}

int dojiDetector(double open, double high, double low, double close)
{
   double size = high - low;
   double bottomDojiLevel = (size * 0.25) + low;
   double topDojiLevel = high - (size * 0.25);
   double reqDojiSize = size * 0.2;
   double dojiSize = MathAbs(close - open);
   
   if((open > bottomDojiLevel && close > bottomDojiLevel) && (open < topDojiLevel && close < topDojiLevel) && (dojiSize <= reqDojiSize))
   {
      if(entryS.entryIsBull)
      {
         return 1;
      }
      if(!entryS.entryIsBull)
      {
         return 2;
      }
      return 0;
   }
   else return 0;
}

void newDojiAlert()
{
   if(newDoji.bullish && entryS.entryIsBull)
   { 
      executeMarketOrder(1);
   }
   if(!newDoji.bullish && !entryS.entryIsBull)
   {
      executeMarketOrder(2);
   }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//HAMMER AND DOJI//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void newHammerDojiAlert()
{
   if((newHam.bullish || newDoji.bullish) && entryS.entryIsBull)
   {
      executeMarketOrder(1);
   }
   if((!newDoji.bullish || !newHam.bullish) && !entryS.entryIsBull)
   {
      executeMarketOrder(2);
   }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//CHECK PSAR///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void identifySarCross(datetime currentBarTime)
{

   if(currentBarTime != prevBarTime)
   {
      double close1  = iClose(_Symbol, PERIOD_CURRENT, 1);
      double close2  = iClose(_Symbol, PERIOD_CURRENT, 2);
      
      bool bullishSarCross = close2 < sar.valueLast && close1 > sar.valueCurrent;
      bool bearishSarCross = close2 > sar.valueLast && close1 < sar.valueCurrent;
      
      if(bullishSarCross || bearishSarCross)
      {
         if(bullishSarCross && entryS.entryIsBull)
         {
            executeMarketOrder(1);
         }
         else if(bearishSarCross && !entryS.entryIsBull)
         {
            executeMarketOrder(2);
         }
      }
   }
}