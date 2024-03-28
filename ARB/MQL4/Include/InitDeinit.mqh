//+------------------------------------------------------------------+
//|                                                   InitDeinit.mqh |
//|                                             Linx Trading Co. LLC |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Linx Trading Co. LLC"
#property link      "https://www.mql5.com"
#property strict

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ININTIALIZATION CHECKS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void runInitializationChecks()
{
   if(TimeCurrent() >= expiration)
   {
      Alert("Your copy of the LinxARB4 expert-advisor has expired! \nPlease contact Linx Trading Co LLC at linxtradingcollc@gmail.com");
      ExpertRemove();
   }
   if(UninitializeReason() == 5)
   {
      Alert("Input parameters changed, re-initializing expert.");
      calculateNewRange();
   }

   if(UninitializeReason() == 3 && initSymbol != _Symbol)
   {
      Alert("Chart symbol changed, calculating new range...");
      calculateNewRange();
   }

   if(checkInputParameters() == 32767)
   {
      Alert("Fatal input parameters selected, removing expert from ", Symbol(), ".\nPlease re-initialize expert and refer to printed error to fix input error..");
      ExpertRemove();
   }
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CHECK INPUT PARAMETERS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
int checkInputParameters()
{
   if(lotTypeInp == 0){
      if(percentLot <= 0){
         Print("Input 'Risk % Per Trade' must be greater than 0!");
         return INIT_PARAMETERS_INCORRECT;
      }
   }

   if(lotTypeInp == 1){
      if(fixedLotSize <= 0){
         Print("Input 'Lot Size' must be greater than 0!");
         return INIT_PARAMETERS_INCORRECT;
      }
   }
   if(magicNumber <= 0){
      Print("Input 'magicNumber' must be greater than 0!");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(maxDailyOrders <= 0){
      Print("Input 'Max Daily Orders' must be greater than 0!");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(rangeStartHour < 0 || rangeStartHour > 23){
      Print("Input 'Range Start Hour' must be an integer between 0 and 23!");
      return INIT_PARAMETERS_INCORRECT;
   }
    if(rangeStartMinute < 0 || rangeStartMinute > 59){
      Print("Input 'Range Start Minute' must be an integer between 0 and 59!");
      return INIT_PARAMETERS_INCORRECT;
   } 
   if(rangeStopHour < 0 || rangeStopHour > 23){
      Print("Input 'Range Stop Hour' must be an integer between 0 and 23!");
      return INIT_PARAMETERS_INCORRECT;
   } 
   if(rangeStopMinute < 0 || rangeStopMinute > 60){
      Print("Input 'Range Stop Minute' must be an integer between 0 and 59!");
      return INIT_PARAMETERS_INCORRECT;
   } 
   if(tradeStopHour < 0 || tradeStopHour > 23){
      Print("Input 'Trade Stop Hour' must be an integer between 0 and 23!");
      return INIT_PARAMETERS_INCORRECT;
   } 
   if(tradeStopMinute < 0 || tradeStopMinute > 60){
      Print("Input 'Trade Stop Minute' must be an integer between 0 and 59!");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(useRangeSize == true){
      if(minRangeSize < 0){
         Print("Input 'Min Range Size' must be greater than 0!");
         return INIT_PARAMETERS_INCORRECT;
      }
   }
   if(useRangeSize == true){
      if(maxRangeSize <= 0){
         Print("Input 'Max Range Size' must be greater than 0!");
         return INIT_PARAMETERS_INCORRECT;
      }
   }
   if(useDailyStopLoss == true){
      if(dailyStopLoss <= 0){
         Print("Input 'Daily Stop-Loss %' must be greater than 0!");
         return INIT_PARAMETERS_INCORRECT;
      }
   }
   if(useDailyTakeProfit == true){
      if(dailyTakeProfit <= 0){
         Print("Input 'Daily Take-Profit %' must be greater than 0!");
         return INIT_PARAMETERS_INCORRECT;
      }
   } 
   if(useTrailingStop == true){
      if(trailingStop <= 0){
         Print("Input 'Trailing-Stop Size' must be greater than 0!");
         return INIT_PARAMETERS_INCORRECT;
      }
   }
   if((rangeStartHour * 60) + rangeStartMinute == (rangeStopHour*60) + rangeStopMinute)
   {
      Print("Range start time cannot be equal to range end time!");
      return INIT_PARAMETERS_INCORRECT;
   }
   if((rangeStopHour * 60) + rangeStopMinute == (tradeStopHour*60) + tradeStopMinute)
   {
      Print("Range end time cannot equal trade stop time!");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(((rangeStopHour*60)+rangeStopMinute)-((rangeStartHour*60)+rangeStartMinute) < PERIOD_CURRENT)
      {
         Print("Range duration cannot be less than the current period of your chart!");
         return INIT_PARAMETERS_INCORRECT;
      }
   if(allowMultipleSame == false && maxDailyOrders > 2)
   {
      Print("WARNING: When multiple same orders are not allowed, the maximum positions that can be opened are limited to 2!");
   }
   return INIT_SUCCEEDED;
   }

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> SET CHART COLORS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void setChartColors()
{
   ChartSetInteger(NULL, CHART_SHOW_GRID, false);
   ChartSetInteger(NULL, CHART_SHOW_ASK_LINE, true);
   ChartSetInteger(NULL, CHART_COLOR_BACKGROUND, C'246,246,255');
   ChartSetInteger(NULL, CHART_COLOR_CANDLE_BEAR, clrBlack);
   ChartSetInteger(NULL, CHART_COLOR_CANDLE_BULL, clrWhite);
   ChartSetInteger(NULL, CHART_COLOR_FOREGROUND, clrBlack);
   ChartSetInteger(NULL, CHART_COLOR_BID, clrBlack);
   ChartSetInteger(NULL, CHART_COLOR_ASK, clrSlateBlue);
   ChartSetInteger(NULL, CHART_COLOR_CHART_DOWN, clrBlack);
   ChartSetInteger(NULL, CHART_COLOR_CHART_UP, clrBlack);
   ChartSetInteger(NULL, CHART_COLOR_CHART_LINE, clrBlack);
   ChartSetInteger(NULL, CHART_SHOW_VOLUMES, false);
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RESET CHART COLORS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
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
// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> DELETE DRAWINGS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void deleteRangeDrawings()
{
   ObjectDelete(NULL, "Range Start");
   ObjectDelete(NULL, "Range End");
   ObjectDelete(NULL, "Range Close");
   ObjectDelete(NULL, "Range High");
   ObjectDelete(NULL, "Range Low");
}

void deleteAllDrawings()
{
   ObjectDelete(NULL, "Range Box");
   ObjectDelete(NULL, "Range Box Outline");
   ObjectDelete(NULL, "Box Label");
   ObjectDelete(NULL, "Close Button");
   ObjectDelete(NULL, "Remove Button");
   ObjectDelete(NULL, "Text");
   ObjectDelete(NULL, "Text1");
   ObjectDelete(NULL, "Text2");
   ObjectDelete(NULL, "Text3");
   ObjectDelete(NULL, "Text4");
   ObjectDelete(NULL, "Text5");
}

