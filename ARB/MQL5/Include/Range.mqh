//+------------------------------------------------------------------+
//|                                        LRB-RangeCalculations.mqh |
//|                             Copyright 2023, Linx Trading Co. LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co. LLC"
#property link      "https://www.linxtradingco.com"

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RANGE STRUCT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
struct RANGE
{
   datetime start_time;          //start of the range
   datetime end_time;            //end of the range
   datetime trade_start;         //trading start time
   datetime trade_stop;          //end trading time
   
   double   highOfRange;         //high of the range
   double   lowOfRange;          //low of the range
   double   rangeSize;           //Size of the range
   
   bool     f_inside_range_time; //flag if we are inside the range
   bool     f_inside_trade_time; //flag if we are inside trade time
   bool     f_high_breakout;     //price breaking above high of range
   bool     f_low_breakout;      //price breaking below low of range
   bool     f_awaiting_high_close; //flag if we're waiting for close above range to enter trade
   bool     f_awaiting_low_close; //flag if we're waiting for close below range to enter trade
   bool     f_awaiting_rev_close_under_high; //Flag if using reverse trades and high breakout
   bool     f_awaiting_rev_close_above_low; //Flag if using reverse trades and low breakout

   RANGE() : start_time(0), end_time(0), trade_start(0), trade_stop(0), highOfRange(0), lowOfRange(9999),
             f_inside_range_time(false), f_inside_trade_time(false), f_high_breakout(false), f_low_breakout(false),
             f_awaiting_high_close(false), f_awaiting_low_close(false), f_awaiting_rev_close_above_low(false), f_awaiting_rev_close_under_high(false){};
   
   bool withinRangeTime(datetime t)
   {
      return t <= end_time && t >= start_time;
   }
   bool withinTradeTime(datetime t)
   {
      return t >= trade_start && t < trade_stop;
   }
};

RANGE range;

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CALCULATE NEW RANGE VALUES <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void calculateNewRange()
{
   deleteRangeDrawings();

   range.start_time = 0;
   range.end_time = 0;
   range.trade_start = 0;
   range.trade_stop = 0;

   range.highOfRange = 0;
   range.lowOfRange = 9999999;

   range.f_inside_range_time = false;
   range.f_inside_trade_time = false;
   range.f_high_breakout = false;
   range.f_low_breakout = false;
   range.f_awaiting_high_close = false;
   range.f_awaiting_low_close = false;
   range.f_awaiting_rev_close_above_low = false;
   range.f_awaiting_rev_close_under_high = false;

   calculateRangeStartTime();
   calculateRangeEndTime();
   calculateTradeStartTime();
   calculateTradeStopTime();
   
   if(range.trade_start > range.end_time)
   {
      range.f_high_breakout = true;
      range.f_low_breakout = true;
   }
}

int findRangeStartTimeInMinutes()
{
   return ((rangeStartHour*60)+rangeStartMinute);
}

int findRangeEndTimeInMinutes()
{
   return (((rangeStopHour*60)+rangeStopMinute)- findRangeStartTimeInMinutes());
}

int findTradeStartTimeInMinutes()
{
   return ((tradeStartHour*60)+tradeStartMinute);
}

int findTradeStopTimeInMinutes()
{
   return ((tradeStopHour*60)+tradeStopMinute);
}


// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CALCULATE RANGE START <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void calculateRangeStartTime()
{
   int timeCycle = 86400;
   range.start_time = (lastTick.time - (lastTick.time % timeCycle)) + findRangeStartTimeInMinutes() * 60;
   for(int i=0; i<8; i++)
   {
      MqlDateTime tmp;
      TimeToStruct (range.start_time,tmp);
      int dayOfWeek = tmp.day_of_week;
      if (lastTick.time >= range.start_time)
      {
         range.start_time += timeCycle;     
      }
      if ( dayOfWeek == 6 || dayOfWeek == 0)
      {
         range.start_time += timeCycle;
      }
   }
}


// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CALCULATE RANGE END <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void calculateRangeEndTime()
{ 
   range.end_time = range.start_time + (findRangeEndTimeInMinutes() * 60);
   int timeCycle = 86400;
   for(int i=0; i<2; i++)
   {
      MqlDateTime tmp;
      TimeToStruct (range.end_time,tmp);
      int dayOfWeek = tmp.day_of_week;
      if(dayOfWeek == 6 || dayOfWeek == 0)
      {
         range.end_time += timeCycle;       
      }
   }
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CALCULATE TRADE START <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void calculateTradeStartTime()
{
   if(tradeStartToUse == 1)
   {
      int timeCycle = 86400;
      range.trade_start = (range.end_time - (range.end_time % timeCycle)) + findTradeStartTimeInMinutes() * 60;
      for(int i=0; i<3; i++)
      {
         MqlDateTime tmp;
         TimeToStruct (range.trade_start,tmp);
         int dayOfWeek = tmp.day_of_week;
         if (dayOfWeek == 6 || dayOfWeek == 0)
         {
            range.trade_start += timeCycle;
         }
      }
   }
   else
   range.trade_start = range.end_time;
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CALCULATE TRADE STOP <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void calculateTradeStopTime()
{ 
   int timeCycle = 86400;
   range.trade_stop = (range.trade_start - (range.trade_start % timeCycle)) + findTradeStopTimeInMinutes() * 60;
   for(int i=0; i<3; i++)
   {
      MqlDateTime tmp;
      TimeToStruct (range.trade_stop,tmp);
      int dayOfWeek = tmp.day_of_week;
      if (dayOfWeek == 6 || dayOfWeek == 0)
      {
         range.trade_stop += timeCycle;
      }
   }
}


// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CALCULATE HIGHS/LOWS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void calculateRangeHighsAndLows()
{
   range.f_inside_range_time = true;
   
   //NEW HIGH
   if(lastTick.bid + (rangeBuffer*_Point) > range.highOfRange)
   {
      range.highOfRange = lastTick.bid + (rangeBuffer*_Point);
      drawRangeBox();
   }
   //NEW LOW
   if(lastTick.bid - (rangeBuffer*_Point) < range.lowOfRange)
   {
      range.lowOfRange = lastTick.bid - (rangeBuffer*_Point);
      drawRangeBox();
   }
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CALCULATE A NEW RANGE IF <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
bool shouldCalculateNewRange()
{    
   return(range.trade_stop != 0 && lastTick.time>=range.trade_stop)
         ||(range.end_time == 0)
         ||(range.end_time != 0 && lastTick.time > range.end_time && !range.f_inside_range_time && lastTick.time >= range.trade_start);
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> DRAW A RANGE BOX <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void drawRangeBox()
{
   ObjectDelete(NULL, "Range Box");
   //Create range box fill
   ObjectCreate(NULL,"Range Box",OBJ_RECTANGLE,0,range.start_time,range.highOfRange,range.end_time,range.lowOfRange);

   ObjectSetInteger(NULL,"Range Box",OBJPROP_COLOR,clrLavender);
   ObjectSetInteger(NULL,"Range Box",OBJPROP_STYLE,STYLE_DOT);
   ObjectSetInteger(NULL,"Range Box",OBJPROP_WIDTH,0);
   ObjectSetInteger(NULL,"Range Box",OBJPROP_FILL,true);
   ObjectSetInteger(NULL,"Range Box",OBJPROP_BACK, true);
   ObjectSetInteger(NULL,"Range Box",OBJPROP_SELECTABLE,false);
   
   ObjectDelete(NULL, "Range Box Outline");
   //Create range box outline
   ObjectCreate(NULL,"Range Box Outline",OBJ_RECTANGLE,0,range.start_time,range.highOfRange,range.end_time,range.lowOfRange);
   
   ObjectSetInteger(NULL,"Range Box Outline",OBJPROP_COLOR,clrBlack);
   ObjectSetInteger(NULL,"Range Box Outline",OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(NULL,"Range Box Outline",OBJPROP_WIDTH,3);
   ObjectSetInteger(NULL,"Range Box Outline",OBJPROP_FILL,false);
   ObjectSetInteger(NULL,"Range Box Outline",OBJPROP_BACK,true);
   ObjectSetInteger(NULL,"Range Box Outline",OBJPROP_SELECTABLE,false);

}
