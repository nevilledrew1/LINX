//+------------------------------------------------------------------+
//|                                               indicatorLogic.mqh |
//|                              Copyright 2023, Linx Trading Co LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co LLC"
#property link      "https://www.linxtradingco.com"

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//INDICATOR STRUCTS////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//BOLLINGER BANDS//////////////////////////
struct bollingerStruct
{
   double upperBand2;
   double upperBand1;
   double upperBandCurrent;
   
   double lowerBand2;
   double lowerBand1;
   double lowerBandCurrent;
   
   double middleBandValue;
};

bollingerStruct bollingerb;

struct secBollingerStruct
{
   double upperBandCurrent;
   double lowerBandCurrent;
};

secBollingerStruct bollingerbSec;

void resetBollingerStructs()
{
   bollingerb.lowerBand1 = 0;
   bollingerb.lowerBand2 = 0;
   bollingerb.lowerBandCurrent = 0;
   bollingerb.upperBand1 = 0;
   bollingerb.upperBand2 = 0;
   bollingerb.upperBandCurrent = 0;
   bollingerb.middleBandValue = 0;
   
   bollingerbSec.upperBandCurrent = 0;
   bollingerbSec.lowerBandCurrent = 0;
}

//RSI'S/////////////////////////////////////
struct RSIstruct
{
   double value2;
   double value1;
   double valueCurrent;
};

RSIstruct rsi;

struct RSIsecondaryStruct
{
   double value;
};

RSIsecondaryStruct rsiSecondary;

void resetRsiStructs()
{
   rsi.value2        = 0;
   rsi.value1        = 0;
   rsi.valueCurrent  = 0;
   rsiSecondary.value = 0;
}

//MOVING AVERAGES///////////////////////////
struct maStruct
{
   double value;
};
maStruct ma;

struct maStructSec
{
   double value;
};
maStructSec secMa;

struct maStructThird
{
   double value;
};
maStructThird thirdMa;

void resetMaStructs()
{
   ma.value    = 0;
   secMa.value = 0;
   thirdMa.value = 0;
}

//PSAR///////////////////////////////////////
struct sarStruct
{
   double valueCurrent;
   double valueLast;
};

sarStruct sar;

void resetSarStruct()
{
   sar.valueCurrent = 0;
   sar.valueLast = 0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//UPDATE INDICATOR STRUCTS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void updateIndicatorData()
{
   resetBollingerStructs();
   resetRsiStructs();
   resetMaStructs();
   resetSarStruct();
  
   //BOLLINGER INITIAL///////////////////////////////////////////////////////////////
   int bollingerBands = iBands(_Symbol, _Period, bbLength, 0, bbStdDev, PRICE_CLOSE);  
   double upperBand[];
   double lowerBand[];
   
   ArraySetAsSeries(upperBand, true);
   ArraySetAsSeries(lowerBand, true);
   CopyBuffer(bollingerBands, 1, 0, 3, upperBand);
   CopyBuffer(bollingerBands, 2, 0, 3, lowerBand);
   
   bollingerb.upperBand2         = upperBand[2];
   bollingerb.lowerBand2         = lowerBand[2];
   bollingerb.upperBand1         = upperBand[1];
   bollingerb.lowerBand1         = lowerBand[1];
   bollingerb.upperBandCurrent   = upperBand[0];
   bollingerb.lowerBandCurrent   = lowerBand[0];
   
   int middleBb                  = iMA(_Symbol, _Period, bbLength, 0, MODE_SMA, PRICE_CLOSE);
   double middleBand[];
   
   ArraySetAsSeries(middleBand, true);
   CopyBuffer(middleBb, 0, 0, 1, middleBand);
   
   bollingerb.middleBandValue    = NormalizeDouble(middleBand[0], _Digits);
   
   //BOLLINGER SECONDARY///////////////////////////////////////////////////////////////////////
   int secBollingerBands = iBands(_Symbol, secBbTimeFrame, bbLength, 0, bbStdDev, PRICE_CLOSE);  
   double upperBandSec[];
   double lowerBandSec[];
   
   ArraySetAsSeries(upperBandSec, true);
   ArraySetAsSeries(lowerBandSec, true);
   CopyBuffer(secBollingerBands, 1, 0, 3, upperBandSec);
   CopyBuffer(secBollingerBands, 2, 0, 3, lowerBandSec);
   
   bollingerbSec.upperBandCurrent = upperBandSec[0];
   bollingerbSec.lowerBandCurrent = lowerBandSec[0];
   
   //RSI INITIAL//////////////////////////////////////////////////////////////////
   int RSIdefinition                = iRSI(_Symbol, _Period, rsiPeriod, PRICE_CLOSE);
   double RSIarray[];
   
   ArraySetAsSeries(RSIarray, true);
   CopyBuffer(RSIdefinition, 0, 0, 3, RSIarray);
   
   rsi.value2                    = NormalizeDouble(RSIarray[2], 2);
   rsi.value1                    = NormalizeDouble(RSIarray[1], 2);
   rsi.valueCurrent              = NormalizeDouble(RSIarray[0], 2);

   //RSI SECONDARY///////////////////////////////////////////////////////////////////////
   int RSISecondaryDef           = iRSI(_Symbol, secRsiTimeframe, rsiPeriod, PRICE_CLOSE);
   double secRsiArray[];
   
   ArraySetAsSeries(secRsiArray, true);
   CopyBuffer(RSISecondaryDef, 0, 0, 1, secRsiArray);
   
   rsiSecondary.value            = NormalizeDouble(RSIarray[0], 2);
   
   //MA INITIAL/////////////////////////////////////////////////////////////////////////////////
   int maDefinition              = iMA(_Symbol, trendTf, trendLength, 0, MODE_EMA, PRICE_CLOSE);
   double emaArray[];
   
   ArraySetAsSeries(emaArray, true);
   CopyBuffer(maDefinition, 0, 0, 1, emaArray);
   
   ma.value                      = NormalizeDouble(emaArray[0], _Digits);
   
   //MA SECONDARY/////////////////////////////////////////////////////////////////////////////////////
   int maDefinitionSec           = iMA(_Symbol, secMaTimeFrame, secMaLength, 0, MODE_EMA, PRICE_CLOSE);
   double emaArraySec[];
   
   ArraySetAsSeries(emaArraySec, true);
   CopyBuffer(maDefinitionSec, 0, 0, 1, emaArraySec);
   
   secMa.value                   = NormalizeDouble(emaArraySec[0], _Digits);

   //MA THIRD/////////////////////////////////////////////////////////////////////////////////////
   int maDefinitionThird         = iMA(_Symbol, thirdMaTimeFrame, thirdMaLength, 0, MODE_EMA, PRICE_CLOSE);
   double emaArrayThird[];
   
   ArraySetAsSeries(emaArrayThird, true);
   CopyBuffer(maDefinitionThird, 0, 0, 1, emaArrayThird);
   
   thirdMa.value                  = NormalizeDouble(emaArrayThird[0], _Digits);
   
   //PSAR INITIAL/////////////////////////////////////////
   int      sarInd   = iSAR(_Symbol, PERIOD_CURRENT, sarIncrement, sarMaxVal);
   double   sarVal[];
   ArraySetAsSeries(sarVal, true);
   CopyBuffer(sarInd, 0, 0, 3, sarVal);
   
   sar.valueCurrent         = sarVal[1];
   sar.valueLast            = sarVal[2];
}
