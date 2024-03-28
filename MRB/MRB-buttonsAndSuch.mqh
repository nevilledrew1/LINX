//+------------------------------------------------------------------+
//|                                           MRB-buttonsAndSuch.mqh |
//|                             Copyright 2023, Linx Trading Co. LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co. LLC"
#property link      "https://www.linxtradingco.com"

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CHART BUTTONS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void drawChartButtons()
{
   //Create Range Button
   ObjectDelete(NULL, "Create Button");
   ObjectCreate(NULL, "Create Button", OBJ_BUTTON, 0, 0, 0);

   ObjectSetInteger(NULL, "Create Button", OBJPROP_XDISTANCE, 8);
   ObjectSetInteger(NULL, "Create Button", OBJPROP_YDISTANCE, 125);
   ObjectSetInteger(NULL, "Create Button", OBJPROP_XSIZE, 150);
   ObjectSetInteger(NULL, "Create Button", OBJPROP_YSIZE, 30);
   ObjectSetInteger(NULL, "Create Button", OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetString(NULL, "Create Button", OBJPROP_TEXT, "CREATE RANGE");
   ObjectSetString(NULL, "Create Button", OBJPROP_FONT, "Courier New Bold");
   ObjectSetInteger(NULL, "Create Button", OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(NULL, "Create Button", OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(NULL,"Create Button",OBJPROP_BGCOLOR,clrMediumSlateBlue);
   ObjectSetInteger(NULL,"Create Button",OBJPROP_BORDER_COLOR,clrBlack);

   //Remove Range Button
   ObjectDelete(NULL, "Remove Button");
   ObjectCreate(NULL, "Remove Button", OBJ_BUTTON, 0, 0, 0);

   ObjectSetInteger(NULL, "Remove Button", OBJPROP_XDISTANCE, 160);
   ObjectSetInteger(NULL, "Remove Button", OBJPROP_YDISTANCE, 125);
   ObjectSetInteger(NULL, "Remove Button", OBJPROP_XSIZE, 150);
   ObjectSetInteger(NULL, "Remove Button", OBJPROP_YSIZE, 30);
   ObjectSetInteger(NULL, "Remove Button", OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetString(NULL, "Remove Button", OBJPROP_TEXT, "REMOVE RANGE");
   ObjectSetString(NULL, "Remove Button", OBJPROP_FONT, "Courier New Bold");
   ObjectSetInteger(NULL, "Remove Button", OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(NULL, "Remove Button", OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(NULL, "Remove Button",OBJPROP_BGCOLOR,clrMediumSlateBlue);
   ObjectSetInteger(NULL, "Remove Button",OBJPROP_BORDER_COLOR,clrBlack);
}

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      if(sparam == "Create Button")
      {
         if(!range.f_onChart)
         {
            calculateNewRange();
            createRangeLines();
            initializeRangePriceLevels();
         }
         else
         deleteRangePriceLines();
         calculateNewRange();
         createRangePriceLines();
         initializeRangePriceLevels();
      }
      if(sparam == "Remove Button")
      {
         if(!range.f_onChart)
         {
            Alert("No range on current chart symbol ", _Symbol, "!");
         }
         else
         deleteRangePriceLines();
         calculateNewRange();
      }
   }
}