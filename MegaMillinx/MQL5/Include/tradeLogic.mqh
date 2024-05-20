//+------------------------------------------------------------------+
//|                                                   tradeLogic.mqh |
//|                              Copyright 2023, Linx Trading Co LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co LLC"
#property link      "https://www.linxtradingco.com"

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//TRADE STRUCTS////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct EntryStruct
{
   bool awaitingEntry;
   bool entryIsBull;
};

EntryStruct entryS;

void resetEntryStruct()
{
   entryS.awaitingEntry = false;
   entryS.entryIsBull   = false;
}

struct TradeInfo
{
    double  entryPrice;
    double  drawdown;
    double  lot;
    double  tp;
    double  sl;
    double  tpDistance;
    int     posSide;
    double  gridDistance;
    int     dollarDrawdownDist;
    int     partialsClosed;
    double  partialsPercent;
    double  partialsLotPercent;
};

TradeInfo initialTrade;

void resetTradeInfo()
{
   initialTrade.entryPrice = 0;
   initialTrade.drawdown   = 0;
   initialTrade.lot        = 0;
   initialTrade.tp         = 0;
   initialTrade.sl         = 0;
   initialTrade.tpDistance = 0;
   initialTrade.posSide    = 0;
   initialTrade.gridDistance = gridDistance * _Point;
   initialTrade.partialsClosed = 0;
   initialTrade.partialsPercent = partialsSpacing / 100.0;
   initialTrade.partialsLotPercent = percentPosToClose / 100.0;
}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//INITIAL POSITION ALLOWED?////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool initialPosAllowed()
{
   return allowedToTrade() && entryS.awaitingEntry && entryStillValid();
}

bool allowedToTrade()
{
   return   tradingDayIsGood()
         && tradingTimeIsGood()
         && !isDailyStopHit()
         && !isDailyTpHit()
         && isMaxDayOrdersGood()
         && !newsIncoming();
}

bool tradingDayIsGood()
{
   return true;
}

bool tradingTimeIsGood()
{
   return withinSessionTime() && outsideSwapRollover();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//SEARCH FOR ENTRY SIGNAL//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void searchForEntry()
{   
   MqlRates PriceInfo[];
   ArraySetAsSeries(PriceInfo, true);
   int priceData = CopyRates(_Symbol, _Period, 0, 3, PriceInfo);
   
   MqlRates secPriceInfo[];
   ArraySetAsSeries(secPriceInfo, true);
   int secPriceData = CopyRates(_Symbol, secBbTimeFrame, 0, 3, secPriceInfo);  
   
   if(isBullBbEntry(PriceInfo, secPriceInfo) && isBullRsiEntry() && trendAllowed(PriceInfo, 1) && secTrendAllowed(PriceInfo, 1) ); //&& thirdTrendAllowed(PriceInfo, 1))
   {
      entryS.awaitingEntry = true;
      entryS.entryIsBull = true;
   }
   
   if(isBearBbEntry(PriceInfo, secPriceInfo) && isBearRsiEntry() && trendAllowed(PriceInfo, 2) && secTrendAllowed(PriceInfo,2) );// && thirdTrendAllowed(PriceInfo, 2))
   {
      entryS.awaitingEntry = true;
      entryS.entryIsBull = false;
   }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//BB ENTRY CHECK///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool isBullBbEntry(const MqlRates &prices[], const MqlRates &secPrices[])
{  
   return (prices[1].close > bollingerb.lowerBand1 && prices[2].close < bollingerb.lowerBand2) && isBullSecBbEntry(secPrices);
}

bool isBearBbEntry(const MqlRates &prices[], const MqlRates &secPrices[])
{  
   return (prices[1].close < bollingerb.upperBand1 && prices[2].close > bollingerb.upperBand2) && isBearSecBbEntry(secPrices);
}

bool isBullSecBbEntry(const MqlRates &prices[])
{  
   return (!useSecBB || prices[0].close < bollingerbSec.upperBandCurrent);
}

bool isBearSecBbEntry(const MqlRates &prices[])
{  
   return (!useSecBB || prices[0].close > bollingerbSec.lowerBandCurrent);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//RSI ENTRY CHECK//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool isBullRsiEntry()
{  
   return !useRsi || ((rsi.valueCurrent < rsiLow) && (!useSecRsi || rsiSecondary.value < rsiHigh));
}

bool isBearRsiEntry()
{  
   return !useRsi || (( rsi.valueCurrent > rsiHigh) && (!useSecRsi || rsiSecondary.value > rsiLow));
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//TREND ALLOWED////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool trendAllowed(const MqlRates &prices[], int posSide)
{
   if(tradeWithTrend)
   {
      if(posSide == 1)
      {
         if(prices[0].close > ma.value && !reverseTrend)
         {
            return true;
         }
         if(prices[0].close < ma.value && reverseTrend)
         {
            return true;
         }
         return false;
      }
      if(prices[0].close < ma.value && !reverseTrend)
      {
         return true;
      }
      if(prices[0].close > ma.value && reverseTrend)
      {
         return true;
      }
      return false;
   }
   return true;
}

bool trendEntryAllowed(bool isBull)
{
   MqlRates PriceInfo[];
   ArraySetAsSeries(PriceInfo, true);
   int priceData = CopyRates(_Symbol, _Period, 0, 3, PriceInfo);
   if(!tradeWithTrend)
   {
      return true;
   }
   if(isBull)
   {
      return PriceInfo[0].close > ma.value && secMaEntryAllowed(isBull);
   }
   else return PriceInfo[0].close < ma.value && secMaEntryAllowed(isBull);
}

bool secTrendAllowed(const MqlRates &prices[], int posSide)
{
   if(tradeWithTrend && useSecondTrend)
   {
      if(posSide == 1)
      {
         if(prices[0].close > secMa.value)
         {
               return true;
         }
         else return false;
      }
      else if(prices[0].close < secMa.value)
      {
         return true;
      }
      else return false;
   }
   return true;
}

bool thirdTrendAllowed(const MqlRates &prices[], int posSide)
{
   if(tradeWithTrend && useThirdTrend)
   {
      if(posSide == 1)
      {
         if(prices[0].close > thirdMa.value)
         {
               return true;
         }
         else return false;
      }
      else if(prices[0].close < thirdMa.value)
      {
         return true;
      }
      else return false;
   }
   return true;
}

bool secMaEntryAllowed(bool isBull)
{
   MqlRates PriceInfo[];
   ArraySetAsSeries(PriceInfo, true);
   int priceData = CopyRates(_Symbol, _Period, 0, 3, PriceInfo);
   if(!useSecondTrend)
   {
      return true;
   }
   if(isBull)
   {
      return PriceInfo[0].close > secMa.value;
   }
   else return PriceInfo[0].close < secMa.value;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//IS ENTRY STILL VALID/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool entryStillValid()
{
   MqlRates PriceInfo[];
   ArraySetAsSeries(PriceInfo, true);
   int priceData = CopyRates(_Symbol, _Period, 0, 3, PriceInfo);
   
   if(entryS.entryIsBull)
   {
      return (PriceInfo[0].close < bollingerb.upperBandCurrent) && (PriceInfo[1].close > bollingerb.lowerBand1);
   }
   
   if(!entryS.entryIsBull)
   {
      return (PriceInfo[0].close > bollingerb.lowerBandCurrent) && (PriceInfo[1].close < bollingerb.upperBand1);
   }
   
   return false;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//CHECK FOR OPP SIGNAL/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void checkOppSignal()
{
   if(!closeOnOppositeSig)
   {
      return;
   }
   else if(openBuyPosCount() > 0)
   {
      checkOppLong();
   }
   else checkOppShort();
}

void checkOppLong()
{
   MqlRates PriceInfo[];
   ArraySetAsSeries(PriceInfo, true);
   int priceData = CopyRates(_Symbol, _Period, 0, 3, PriceInfo);
   
   MqlRates secPriceInfo[];
   ArraySetAsSeries(secPriceInfo, true);
   int secPriceData = CopyRates(_Symbol, secBbTimeFrame, 0, 3, secPriceInfo);  
   
   if(isBearBbEntry(PriceInfo, secPriceInfo) && isBearRsiEntry() && trendAllowed(PriceInfo, 2) && secTrendAllowed(PriceInfo,1))
   {
      if(!closeOppOnlyProfit || tradesInProfit())
      {
         Print("Short signal detected, closing open trades.");
         closeAllOpenTrades();
      }
   }
}

void checkOppShort()
{
   MqlRates PriceInfo[];
   ArraySetAsSeries(PriceInfo, true);
   int priceData = CopyRates(_Symbol, _Period, 0, 3, PriceInfo);
   
   MqlRates secPriceInfo[];
   ArraySetAsSeries(secPriceInfo, true);
   int secPriceData = CopyRates(_Symbol, secBbTimeFrame, 0, 3, secPriceInfo);  
   
   if(isBullBbEntry(PriceInfo, secPriceInfo) && isBullRsiEntry() && trendAllowed(PriceInfo, 1) && secTrendAllowed(PriceInfo, 1))
   {
      if(!closeOppOnlyProfit || tradesInProfit())
      {
         Print("Long signal detected, closing open trades.");
         closeAllOpenTrades();
      }
   }
}