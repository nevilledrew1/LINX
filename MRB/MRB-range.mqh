//+------------------------------------------------------------------+
//|                                        LRB-RangeCalculations.mqh |
//|                             Copyright 2023, Linx Trading Co. LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co. LLC"
#property link      "https://www.linxtradingco.com"

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RANGE STRUCT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
struct RANGE
{

   datetime init_time         //Init time of range
   datetime trade_stop;       //end trading time
   
   double   highOfRange;      //high of the range
   double   lowOfRange;       //low of the range
   double   rangeSize;        //Size of the range
   
   bool     f_onChart;        //Are range lines on chart?
   bool     f_entry;          //flag if we are inside the range
   bool     f_high_breakout;  //price breaking above high of range
   bool     f_low_breakout;   //price breaking below low of range

   RANGE() : init_time(0), trade_stop(0), highOfRange(0), lowOfRange(9999), f_onChart(false), f_entry(false), f_high_breakout(false), f_low_breakout(false){};
   
   bool withinTradeTime(datetime t)
   {
      return t >= init_time && t < trade_stop;
   }
};

RANGE range;

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CALCULATE A RANGE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void calculateNewRange()
{
   deleteRangeDrawings();
   deleteRangePriceLines();

   range.init_time = 0;
   range.trade_stop = 0;
   range.highOfRange = 0;
   range.lowOfRange = 9999999;
   range.f_onChart = false;
   range.f_entry = false;
   range.f_high_breakout = false;
   range.f_low_breakout = false;
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CALCULATE TRADE STOP <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void calculateTradeStopTime()
{ 
   int timeCycle = 86400;
   range.trade_stop = (range.init_time - (range.init_time % timeCycle)) + findTradeStopTime() * 60;
   
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
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> SHOULD RE INIT RANGE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void shouldReInitRange()
{
   if((sASresult == 1 && findTradeStopTime()>=0 && lastTick.time>=range.trade_stop)
   || ((sASresult == 2) && (tradesOpenedSinceInit() >=0) && (tradesOpenedSinceInit()>= stopAfterTradeNumber))
   || (sASresult == 3 && (range.f_high_breakout || range.f_low_breakout)));

   {
      calculateNewRange();
      removeRangeLines();
      return true;
   }
return false;
}

int tradesOpenedSinceInit()
{
   if(range.init_time == 0)
   {
      return -1;
   }
   else
   uint     totalNumberOfDeals   = HistoryDealsTotal();
   ulong    ticketNumber         = 0;
   long     dealEntry;
   string   symbol               = "";
   long     magic                = 0;
   int      count                = 0;
   
   HistorySelect(range.init_time, TimeCurrent());
   for(uint i = 0; i<totalNumberOfDeals; ++i)
   {
      if((ticketNumber = HistoryDealGetTicket(i)) > 0)
      { 
         magic     = HistoryDealGetInteger(ticketNumber, DEAL_MAGIC);
         symbol    = HistoryDealGetString(ticketNumber, DEAL_SYMBOL);
         dealEntry = HistoryDealGetInteger(ticketNumber, DEAL_ENTRY);
         
         if(dealEntry == 0 && orderIsMine(symbol, magic))
         {
            ++count;
         }
      }
   }
   return count;
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ETC RANGE FUNCTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
int findTradeStopTime()
{
return ((tradeStopHour*60)+tradeStopMinute);
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> DRAW RANGE THINGS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void drawRangeBox()
{
   ObjectDelete(NULL, "Range Box");
   //Create range box fill
   ObjectCreate(NULL,"Range Box",OBJ_RECTANGLE,0, range.init_time,range.highOfRange,range.trade_stop,range.lowOfRange);

   ObjectSetInteger(NULL,"Range Box",OBJPROP_COLOR,clrMediumSlateBlue);
   ObjectSetInteger(NULL,"Range Box",OBJPROP_STYLE,STYLE_DOT);
   ObjectSetInteger(NULL,"Range Box",OBJPROP_WIDTH,0);
   ObjectSetInteger(NULL,"Range Box",OBJPROP_FILL,true);
   ObjectSetInteger(NULL,"Range Box",OBJPROP_BACK, true);
   ObjectSetInteger(NULL,"Range Box",OBJPROP_SELECTABLE,false);
   
   ObjectDelete(NULL, "Range Box Outline");
   //Create range box outline
   ObjectCreate(NULL,"Range Box Outline",OBJ_RECTANGLE,0,range.range.init_time,range.highOfRange,range.trade_stop,range.lowOfRange);
   
   ObjectSetInteger(NULL,"Range Box Outline",OBJPROP_COLOR,clrBlack);
   ObjectSetInteger(NULL,"Range Box Outline",OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(NULL,"Range Box Outline",OBJPROP_WIDTH,3);
   ObjectSetInteger(NULL,"Range Box Outline",OBJPROP_FILL,false);
   ObjectSetInteger(NULL,"Range Box Outline",OBJPROP_BACK,true);
   ObjectSetInteger(NULL,"Range Box Outline",OBJPROP_SELECTABLE,false);

}

void createRangePriceLines()
{
   range.init_time            = TimeCurrent();
   double ask                 = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double bid                 = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits); 
   double normalDefaultOffset = NormalizeDouble((bid+defaultOffset) * _Point, _Digits);

   ObjectDelete(NULL, "Range High Price Line");
   ObjectCreate(NULL, "Range High Price Line", OBJ_HLINE, 0, range.init_time, (bid + normalDefaultOffset));

   ObjectSetInteger(NULL, "Range High Price Line", OBJPROP_COLOR, clrGreen);
   ObjectSetInteger(NULL, "Range High Price Line", OBJPROP_WIDTH, 3);
   ObjectSetInteger(NULL, "Range High Price Line", OBJPROP_BACK, true);
   ObjectSetInteger(NULL, "Range High Price Line", OBJPROP_STYLE, STYLE_SOLID);
   ObjectSetInteger(NULL, "Range High Price Line", OBJPROP_SELECTABLE, true);

   ObjectDelete(NULL, "Range Low Price Line");
   ObjectCreate(NULL, "Range Low Price Line", OBJ_HLINE, 0, range.init_time, (bid + normalDefaultOffset));

   ObjectSetInteger(NULL, "Range Low Price Line", OBJPROP_COLOR, clrRed);
   ObjectSetInteger(NULL, "Range Low Price Line", OBJPROP_WIDTH, 3);
   ObjectSetInteger(NULL, "Range Low Price Line", OBJPROP_BACK, true);
   ObjectSetInteger(NULL, "Range Low Price Line", OBJPROP_STYLE, STYLE_SOLID);
   ObjectSetInteger(NULL, "Range Low Price Line", OBJPROP_SELECTABLE, true);

   range.f_onChart = true;
}

void deleteRangePriceLines()
{
   ObjectDelete(NULL, "Range High Price Line");
   ObjectDelete(NULL, "Range Low Price Line");
}
// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INITIALIZE RANGE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void checkAndInitializeRangePriceLevels()
{
   double rangeHighPrice   = ObjectGetDouble(NULL, "Range High Price Line", OBJPROP_PRICE, 0);
   double rangeLowPrice    = ObjectGetDouble(NULL, "Range Low Price Line", OBJPROP_PRICE, 0);

   if(   ((rangeHighPrice == 0) && (rangeLowPrice > 0))
   ||    ((rangeLowPrice == 0) && (rangeHighPrice > 0))
   ||    (range.f_onChart && (rangeHighPrice == 0 && rangeLowPrice == 0)))
   {
      Print("Range initialization failed. Calculating new range.");
      calculateNewRange();
   }

   if(range.f_onChart && range.highOfRange > 0 && range.highOfRange > range.lowOfRange && range.lowOfRange > 0)
   {
      range.highOfRange = ObjectGetDouble(NULL, "Range High Price Line", OBJPROP_PRICE, 0);
      range.lowOfRange  = ObjectGetDouble(NULL, "Range Low Price Line", OBJPROP_PRICE, 0);
   }
}

