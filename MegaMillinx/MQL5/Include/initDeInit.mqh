//+------------------------------------------------------------------+
//|                                                   initDeInit.mqh |
//|                              Copyright 2023, Linx Trading Co LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co LLC"
#property link      "https://www.linxtradingco.com"

#include "executionLogic.mqh"
#include "generalUtility.mqh"
#include "inputs.mqh"
#include "indicatorLogic.mqh"
#include "martLogic.mqh"
#include "entryConditions.mqh"
#include "tradeLogic.mqh"

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//INITIALIZE EXPERT////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void initializeExpert()
{
   addChartIndicators();
   runInitializationChecks();
   resetBollingerStructs();
   resetEntryStruct();
   resetRsiStructs();
   resetFVG();
   resetTradeInfo();
   setChartColors();
   trade.SetExpertMagicNumber(magicNumber);
   accountStartingBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   initSymbol = _Symbol;
   checkUserInputs();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//RUN INITIALIZATION CHECKS////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void runInitializationChecks()
{
   if(TimeCurrent() >= expirationDate)
   {
      Alert("Your copy of the Mega Millinx expert-advisor has expired! \nPlease contact Linx Trading Co LLC at linxtradingcollc@gmail.com");
      ExpertRemove();
   }

   if(takeProfitInp == 4 && stopType == 3)
   {
      Alert("Cannot use RR based SL and TP simultaneously! Removing expert.");
      ExpertRemove();
   }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//CHECK INPUT PARAMETERS///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//SET CHART COLORS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void setChartColors()
{
   ChartSetInteger(NULL, CHART_SHOW_GRID, false);
   ChartSetInteger(NULL, CHART_SHOW_ASK_LINE, true);
   ChartSetInteger(NULL, CHART_COLOR_BACKGROUND, C'242,242,242');
   ChartSetInteger(NULL, CHART_COLOR_CANDLE_BEAR, clrBlack);
   ChartSetInteger(NULL, CHART_COLOR_CANDLE_BULL, clrBlack);
   ChartSetInteger(NULL, CHART_COLOR_FOREGROUND, clrBlack);
   ChartSetInteger(NULL, CHART_COLOR_BID, clrBlack);
   ChartSetInteger(NULL, CHART_COLOR_ASK, C'76,76,76');
   ChartSetInteger(NULL, CHART_COLOR_CHART_DOWN, clrBlack);
   ChartSetInteger(NULL, CHART_COLOR_CHART_UP, clrBlack);
   ChartSetInteger(NULL, CHART_COLOR_CHART_LINE, clrBlack);
   ChartSetInteger(NULL, CHART_SHOW_VOLUMES, false);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//ADD INDICATORS///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void addChartIndicators()
{
   ChartIndicatorAdd(_Symbol, 0, iBands(_Symbol, PERIOD_CURRENT, bbLength, 0, bbStdDev, PRICE_CLOSE));
   ChartIndicatorAdd(_Symbol, 0, iRSI(_Symbol, PERIOD_CURRENT, rsiPeriod, PRICE_CLOSE));
   if(tradeWithTrend)
   {
      ChartIndicatorAdd(_Symbol, 0, iMA(_Symbol, trendTf, trendLength, 0, MODE_EMA, PRICE_CLOSE));
      if(useSecondTrend)
      {
         ChartIndicatorAdd(_Symbol, 0, iMA(_Symbol, secMaTimeFrame, secMaLength, 0, MODE_EMA, PRICE_CLOSE));
      }
   }
   if(useSar)
   {
      ChartIndicatorAdd(_Symbol, 0, iSAR(_Symbol, PERIOD_CURRENT, sarIncrement, sarMaxVal));
   }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//DE INITIALIZE EXPERT/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void deInitializeExpert()
{
   resetChartColors();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//RESET CHART COLORS///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void resetChartColors()
{
   ChartSetInteger(NULL, CHART_SHOW_GRID, true);
   ChartSetInteger(NULL, CHART_SHOW_ASK_LINE, false);
   ChartSetInteger(NULL, CHART_COLOR_BACKGROUND, clrBlack);
   ChartSetInteger(NULL, CHART_COLOR_CANDLE_BEAR, clrBlack);
   ChartSetInteger(NULL, CHART_COLOR_CANDLE_BULL, clrWhite);
   ChartSetInteger(NULL, CHART_COLOR_FOREGROUND, clrWhite);
   ChartSetInteger(NULL, CHART_COLOR_BID, clrBlack);
   ChartSetInteger(NULL, CHART_COLOR_CHART_DOWN, clrGreen);
   ChartSetInteger(NULL, CHART_COLOR_CHART_UP, clrGreen);
   ChartSetInteger(NULL, CHART_COLOR_CHART_LINE, clrGreen);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//CHECK USER INPUTS////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void checkUserInputs()
{
   if(fixedLotSize <= 0)
   {
      Alert("Input 'Fixed Lot Size' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(maxLotSize <= 0)
   {
      Alert("Input 'Maximum Lot Size' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(maxLotSize < fixedLotSize)
   {
      Alert("Fixed lot size cannot be more than maximum lot size. Removing Expert!");
      ExpertRemove();
   }
   if(maxSpread <= 0)
   {
      Alert("Input 'Maximum Spread' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(maxDailyOrders <= 0)
   {
      Alert("Input 'Max Daily Positions' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(bbLength <= 0)
   {
      Alert("Input 'BB Length' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(bbStdDev <= 0)
   {
      Alert("Input 'BB Std Dev' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(useRsi && (
      rsiPeriod <= 0
      || rsiHigh <= 0
      || rsiLow <= 0))
   {
      Alert("Rsi Inputs must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(useRsi && (rsiHigh < 1 || rsiHigh > 100))
   {
      Alert("Input 'RSI High' must be an integer between 1 and 100. Removing Expert!");
      ExpertRemove();
   }
   if(useRsi && (rsiLow < 1 || rsiLow > 100))
   {
      Alert("Input 'RSI Low' must be an integer between 1 and 100. Removing Expert!");
      ExpertRemove();
   }
   if(tradeWithTrend && trendLength <= 0)
   {
      Alert("Input 'MA Length' must be greater than 0. Removig Expert!");
      ExpertRemove();
   }
   if(useSecondTrend && secMaLength <= 0)
   {
      Alert("Input 'Sec MA Length' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(useThirdTrend && thirdMaLength <= 0)
   {
      Alert("Input 'Third MA Length' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(allowGrid && maxOpenOrders <= 0)
   {
      Alert("Input 'Max Open Positions' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(allowGrid && gridDistance <= 0)
   {
      Alert("Input 'Grid Distance' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(allowGrid && gridMultiplier <= 0)
   {
      Alert("Input 'Grid Distance Multiplier' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(allowGrid && changeTpAfterTrades <= 0)
   {
      Alert("Input 'Change To Fixed TP After Trade Amount' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(allowGrid && lotMultiplier <= 0)
   {
      Alert("Input 'Lot Multiplier' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(sarIncrement <= 0)
   {
      Alert("Input 'PSAR Increment' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(sarMaxVal <= 0)
   {
      Alert("Input 'PSAR Max Value' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(stopType == 2 && psarSlMultiplier <= 0)
   {
      Alert("Input 'PSAR SL Multiplier' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(stopType == 3 && rrSlMultiplier <= 0)
   {
      Alert("Input 'Risk/Reward Ratio SL' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(useFloatingStop && floatingStop <= 0)
   {
      Alert("Input 'Floating Stop-Loss $' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(useDailyStop && dailyStopValue <= 0)
   {
      Alert("Input 'Daily Stop $' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(takeProfitInp == 3 && psarTpMultiplier <= 0)
   {
      Alert("Input 'PSAR TP Multiplier' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(takeProfitInp == 4 && rrTpMultiplier <= 0)
   {
      Alert("Input 'Risk/Reward Ratio TP' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(useFloatingTakeProfit && floatingTakeProfit <= 0)
   {
      Alert("Input 'Floating Take-Profit $' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(useDailyTakeProfit && dailyTakeProfitValue <= 0)
   {
      Alert("Input 'Daily Take-Profit $' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(usePartialClose && partialsSpacing <= 0)
   {
      Alert("Input 'Take Partials Every 'X' %' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(usePartialClose && (partialsSpacing < 1 || partialsSpacing > 100))
   {
      Alert("Input 'Take Partials Every 'X' %' must be an integer between 1 and 100. Removing Expert!");
      ExpertRemove();
   }
   if(usePartialClose && percentPosToClose <= 0)
   {
      Alert("Input '% Of Pos To Close At Partials' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(usePartialClose && (percentPosToClose < 1 || percentPosToClose > 100))
   {
      Alert("Input '% Of Pos To Close At Partials' must be an integer between 1 and 100. Removing Expert!");
      ExpertRemove();
   }
   if(useTrailingStop && trailingType == 1 && trailingStop <= 0)
   {
      Alert("Input 'Trail Stop' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(tradeStartToUse == 1 && !tradeAsia && !tradeLondon && !tradeNewYork)
   {
      Alert("All trading sessions toggled to false while using custom session trading time. You must select at least one session to trade. Removing Expert!");
      ExpertRemove();
   }
   if(closeMinsBeforeNews <= 0)
   {
      Alert("Input 'Close Pos 'X' Minutes Before News' must be greater than 0. Removing Expert!");
      ExpertRemove();
   }
   if(usePartialClose && takeProfitInp == 0 && fixedTakeProfit == 0)
   {
      Alert("Input 'Fixed Take-Profit' must be greater than 0 if using partial closing. Removing Expert!");
      ExpertRemove();
   }
   if(takeProfitInp == 0 && fixedTakeProfit == 0 && stopType == 3)
   {
      Alert("Input 'Fixed Take-Profit' must be greater than 0 if using RR Based SL. Removing Expert!");
      ExpertRemove();
   }
   if(stopType == 0 && fixedStopLoss == 0 && takeProfitInp == 4)
   {
      Alert("Input 'Fixed Stop Distance' must be greater than 0 if using RR Based TP. Removing Expert!");
      ExpertRemove();
   }
   
}