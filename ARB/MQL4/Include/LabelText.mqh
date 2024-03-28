//+------------------------------------------------------------------+
//|                                                          etc.mqh |
//|                             Copyright 2023, Linx Trading Co. LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co. LLC"
#property link      "https://www.linxtradingco.com"
#property strict

// ===============================================================================================
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> DECIDE AND CREATE LABEL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void decideAndCreateLabelText(int terminalDPI)
{  
   if(terminalDPI >= 192)
   {
      createLabelTextOne();
   }
   if(terminalDPI < 192)
   {
      createLabelTextTwo();
   }
}

// ===============================================================================================
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CREATE LABEL TEXT ONE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void createLabelTextOne()
{
   ObjectDelete(NULL, "Text");
   ObjectCreate(NULL, "Text", OBJ_LABEL, 0, 0, 0);
   
   ObjectSetInteger(NULL, "Text", OBJPROP_XDISTANCE, 10);
   ObjectSetInteger(NULL, "Text", OBJPROP_YDISTANCE, 50);
   ObjectSetString(NULL, "Text", OBJPROP_TEXT, "LINX RB EXPERT ADVISOR - VERSION 1.01");
   ObjectSetString(NULL, "Text", OBJPROP_FONT, "Courier New Bold");
   ObjectSetInteger(NULL, "Text", OBJPROP_FONTSIZE, 12);
   ObjectSetInteger(NULL, "Text", OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(NULL,"Text",OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetDouble(NULL,"Text",OBJPROP_ANGLE,0);
   ObjectSetInteger(NULL,"Text",OBJPROP_BACK,false);
   
   ObjectDelete(NULL, "Text1");
   ObjectCreate(NULL, "Text1", OBJ_LABEL, 0, 0, 0);
   
   ObjectSetInteger(NULL, "Text1", OBJPROP_XDISTANCE, 10);
   ObjectSetInteger(NULL, "Text1", OBJPROP_YDISTANCE, 80);
   ObjectSetString(NULL, "Text1", OBJPROP_TEXT, "=====================================");
   ObjectSetString(NULL, "Text1", OBJPROP_FONT, "Courier New Bold");
   ObjectSetInteger(NULL, "Text1", OBJPROP_FONTSIZE, 12);
   ObjectSetInteger(NULL, "Text1", OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(NULL,"Text1",OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetDouble(NULL,"Text1",OBJPROP_ANGLE,0);
   ObjectSetInteger(NULL,"Text1",OBJPROP_BACK,false);
   
   ObjectDelete(NULL, "Text2");
   ObjectCreate(NULL, "Text2", OBJ_LABEL, 0, 0, 0);
   
   ObjectSetInteger(NULL, "Text2", OBJPROP_XDISTANCE, 40);
   ObjectSetInteger(NULL, "Text2", OBJPROP_YDISTANCE, 110);
   ObjectSetString(NULL, "Text2", OBJPROP_TEXT,"Account Starting Balance: " + string(accountStartingBalance));
   ObjectSetString(NULL, "Text2", OBJPROP_FONT, "Courier New");
   ObjectSetInteger(NULL, "Text2", OBJPROP_FONTSIZE, 12);
   ObjectSetInteger(NULL, "Text2", OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(NULL,"Text2",OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetDouble(NULL,"Text2",OBJPROP_ANGLE,0);
   ObjectSetInteger(NULL,"Text2",OBJPROP_BACK,false);
   
   ObjectDelete(NULL, "Text3");
   ObjectCreate(NULL, "Text3", OBJ_LABEL, 0, 0, 0);
   
   ObjectSetInteger(NULL, "Text3", OBJPROP_XDISTANCE, 40);
   ObjectSetInteger(NULL, "Text3", OBJPROP_YDISTANCE, 140);
   ObjectSetString(NULL, "Text3", OBJPROP_TEXT, "Today's Orders Placed: "  + string(todayClosedOrdersTotal() + todayOpenOrdersTotal()) + "/" + string(maxDailyOrders));
   ObjectSetString(NULL, "Text3", OBJPROP_FONT, "Courier New");
   ObjectSetInteger(NULL, "Text3", OBJPROP_FONTSIZE, 12);
   ObjectSetInteger(NULL, "Text3", OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(NULL,"Text3",OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetDouble(NULL,"Text3",OBJPROP_ANGLE,0);
   ObjectSetInteger(NULL,"Text3",OBJPROP_BACK,false);
   
   ObjectDelete(NULL, "Text4");
   ObjectCreate(NULL, "Text4", OBJ_LABEL, 0, 0, 0);
   
   ObjectSetInteger(NULL, "Text4", OBJPROP_XDISTANCE, 40);
   ObjectSetInteger(NULL, "Text4", OBJPROP_YDISTANCE, 170);
   ObjectSetString(NULL, "Text4", OBJPROP_TEXT, "Today's Total Profit: "+ string((todayOpenPL()+todayClosePL())));
   ObjectSetString(NULL, "Text4", OBJPROP_FONT, "Courier New");
   ObjectSetInteger(NULL, "Text4", OBJPROP_FONTSIZE, 12);
   ObjectSetInteger(NULL, "Text4", OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(NULL,"Text4",OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetDouble(NULL,"Text4",OBJPROP_ANGLE,0);
   ObjectSetInteger(NULL,"Text4",OBJPROP_BACK,false);
   
   ObjectDelete(NULL, "Text5");
   ObjectCreate(NULL, "Text5", OBJ_LABEL, 0, 0, 0);
   
   ObjectSetInteger(NULL, "Text5", OBJPROP_XDISTANCE, 40);
   ObjectSetInteger(NULL, "Text5", OBJPROP_YDISTANCE, 200);
   ObjectSetString(NULL, "Text5", OBJPROP_TEXT, "Expert Magic #: "+ string(magicNumber));
   ObjectSetString(NULL, "Text5", OBJPROP_FONT, "Courier New");
   ObjectSetInteger(NULL, "Text5", OBJPROP_FONTSIZE, 12);
   ObjectSetInteger(NULL, "Text5", OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(NULL,"Text5",OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetDouble(NULL,"Text5",OBJPROP_ANGLE,0);
   ObjectSetInteger(NULL,"Text5",OBJPROP_BACK,false);
   
}

// ===============================================================================================
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CREATE LABEL TEXT TWO <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void createLabelTextTwo()
{
   ObjectDelete(NULL, "Text");
   ObjectCreate(NULL, "Text", OBJ_LABEL, 0, 0, 0);

   ObjectSetInteger(NULL, "Text", OBJPROP_XDISTANCE, 10);
   ObjectSetInteger(NULL, "Text", OBJPROP_YDISTANCE, 30);
   ObjectSetString(NULL, "Text", OBJPROP_TEXT, "LINX RB EXPERT ADVISOR - VERSION 1.01");
   ObjectSetString(NULL, "Text", OBJPROP_FONT, "Courier New Bold");
   ObjectSetInteger(NULL, "Text", OBJPROP_FONTSIZE, 10);
   ObjectSetInteger(NULL, "Text", OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(NULL,"Text",OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetDouble(NULL,"Text",OBJPROP_ANGLE,0);
   ObjectSetInteger(NULL,"Text",OBJPROP_BACK,false);

   ObjectDelete(NULL, "Text1");
   ObjectCreate(NULL, "Text1", OBJ_LABEL, 0, 0, 0);

   ObjectSetInteger(NULL, "Text1", OBJPROP_XDISTANCE, 10);
   ObjectSetInteger(NULL, "Text1", OBJPROP_YDISTANCE, 45);
   ObjectSetString(NULL, "Text1", OBJPROP_TEXT, "=====================================");
   ObjectSetString(NULL, "Text1", OBJPROP_FONT, "Courier New Bold");
   ObjectSetInteger(NULL, "Text1", OBJPROP_FONTSIZE, 10);
   ObjectSetInteger(NULL, "Text1", OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(NULL,"Text1",OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetDouble(NULL,"Text1",OBJPROP_ANGLE,0);
   ObjectSetInteger(NULL,"Text1",OBJPROP_BACK,false);

   ObjectDelete(NULL, "Text2");
   ObjectCreate(NULL, "Text2", OBJ_LABEL, 0, 0, 0);

   ObjectSetInteger(NULL, "Text2", OBJPROP_XDISTANCE, 20);
   ObjectSetInteger(NULL, "Text2", OBJPROP_YDISTANCE, 60);
   ObjectSetString(NULL, "Text2", OBJPROP_TEXT,"Account Starting Balance: " + string(accountStartingBalance));
   ObjectSetString(NULL, "Text2", OBJPROP_FONT, "Courier New");
   ObjectSetInteger(NULL, "Text2", OBJPROP_FONTSIZE, 10);
   ObjectSetInteger(NULL, "Text2", OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(NULL,"Text2",OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetDouble(NULL,"Text2",OBJPROP_ANGLE,0);
   ObjectSetInteger(NULL,"Text2",OBJPROP_BACK,false);

   ObjectDelete(NULL, "Text3");
   ObjectCreate(NULL, "Text3", OBJ_LABEL, 0, 0, 0);

   ObjectSetInteger(NULL, "Text3", OBJPROP_XDISTANCE, 20);
   ObjectSetInteger(NULL, "Text3", OBJPROP_YDISTANCE, 75);
   ObjectSetString(NULL, "Text3", OBJPROP_TEXT, "Today's Orders Placed: " + string(todayClosedOrdersTotal() + todayOpenOrdersTotal()) + "/" + string(maxDailyOrders));
   ObjectSetString(NULL, "Text3", OBJPROP_FONT, "Courier New");
   ObjectSetInteger(NULL, "Text3", OBJPROP_FONTSIZE, 10);
   ObjectSetInteger(NULL, "Text3", OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(NULL,"Text3",OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetDouble(NULL,"Text3",OBJPROP_ANGLE,0);
   ObjectSetInteger(NULL,"Text3",OBJPROP_BACK,false);

   ObjectDelete(NULL, "Text4");
   ObjectCreate(NULL, "Text4", OBJ_LABEL, 0, 0, 0);

   ObjectSetInteger(NULL, "Text4", OBJPROP_XDISTANCE, 20);
   ObjectSetInteger(NULL, "Text4", OBJPROP_YDISTANCE, 90);
   ObjectSetString(NULL, "Text4", OBJPROP_TEXT, "Today's Total Profit: "+ string((todayOpenPL()+todayClosePL())));
   ObjectSetString(NULL, "Text4", OBJPROP_FONT, "Courier New");
   ObjectSetInteger(NULL, "Text4", OBJPROP_FONTSIZE, 10);
   ObjectSetInteger(NULL, "Text4", OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(NULL,"Text4",OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetDouble(NULL,"Text4",OBJPROP_ANGLE,0);
   ObjectSetInteger(NULL,"Text4",OBJPROP_BACK,false);

   ObjectDelete(NULL, "Text5");
   ObjectCreate(NULL, "Text5", OBJ_LABEL, 0, 0, 0);

   ObjectSetInteger(NULL, "Text5", OBJPROP_XDISTANCE, 20);
   ObjectSetInteger(NULL, "Text5", OBJPROP_YDISTANCE, 105);
   ObjectSetString(NULL, "Text5", OBJPROP_TEXT, "Expert Magic #: " + string(magicNumber));
   ObjectSetString(NULL, "Text5", OBJPROP_FONT, "Courier New");
   ObjectSetInteger(NULL, "Text5", OBJPROP_FONTSIZE, 10);
   ObjectSetInteger(NULL, "Text5", OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(NULL,"Text5",OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetDouble(NULL,"Text5",OBJPROP_ANGLE,0);
   ObjectSetInteger(NULL,"Text5",OBJPROP_BACK,false);

}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> UPDATE CHART LABELS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void updateLabelText(int terminalDPI)
{ 
   if (terminalDPI < 192)
   {
      //1080p monitor
      ObjectDelete(NULL, "Text3");
      ObjectCreate(NULL, "Text3", OBJ_LABEL, 0, 0, 0);
      
      ObjectSetInteger(NULL, "Text3", OBJPROP_XDISTANCE, 20);
      ObjectSetInteger(NULL, "Text3", OBJPROP_YDISTANCE, 75);
      ObjectSetString(NULL, "Text3", OBJPROP_TEXT, "Today's Orders Placed: " + string(todayClosedOrdersTotal() + todayOpenOrdersTotal()) + "/" + string(maxDailyOrders));
      ObjectSetString(NULL, "Text3", OBJPROP_FONT, "Courier New");
      ObjectSetInteger(NULL, "Text3", OBJPROP_FONTSIZE, 10);
      ObjectSetInteger(NULL, "Text3", OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(NULL,"Text3",OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetDouble(NULL,"Text3",OBJPROP_ANGLE,0);
      ObjectSetInteger(NULL,"Text3",OBJPROP_BACK,false);
      
      ObjectDelete(NULL, "Text4");
      ObjectCreate(NULL, "Text4", OBJ_LABEL, 0, 0, 0);
      
      ObjectSetInteger(NULL, "Text4", OBJPROP_XDISTANCE, 20);
      ObjectSetInteger(NULL, "Text4", OBJPROP_YDISTANCE, 90);
      ObjectSetString(NULL, "Text4", OBJPROP_TEXT, "Today's Total Profit: "+ string((todayOpenPL()+todayClosePL())));
      ObjectSetString(NULL, "Text4", OBJPROP_FONT, "Courier New");
      ObjectSetInteger(NULL, "Text4", OBJPROP_FONTSIZE, 10);
      ObjectSetInteger(NULL, "Text4", OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(NULL,"Text4",OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetDouble(NULL,"Text4",OBJPROP_ANGLE,0);
      ObjectSetInteger(NULL,"Text4",OBJPROP_BACK,false);
   }
   
   if(terminalDPI >= 192)
   {
      //1440p monitor (Macbook)
      ObjectDelete(NULL, "Text3");
      ObjectCreate(NULL, "Text3", OBJ_LABEL, 0, 0, 0);
      
      ObjectSetInteger(NULL, "Text3", OBJPROP_XDISTANCE, 40);
      ObjectSetInteger(NULL, "Text3", OBJPROP_YDISTANCE, 14);
      ObjectSetString(NULL, "Text3", OBJPROP_TEXT, "Today's Orders Placed: " + string(todayClosedOrdersTotal() + todayOpenOrdersTotal()) + "/" + string(maxDailyOrders));
      ObjectSetString(NULL, "Text3", OBJPROP_FONT, "Courier New");
      ObjectSetInteger(NULL, "Text3", OBJPROP_FONTSIZE, 12);
      ObjectSetInteger(NULL, "Text3", OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(NULL,"Text3",OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetDouble(NULL,"Text3",OBJPROP_ANGLE,0);
      ObjectSetInteger(NULL,"Text3",OBJPROP_BACK,false);
      
      ObjectDelete(NULL, "Text4");
      ObjectCreate(NULL, "Text4", OBJ_LABEL, 0, 0, 0);
      
      ObjectSetInteger(NULL, "Text4", OBJPROP_XDISTANCE, 40);
      ObjectSetInteger(NULL, "Text4", OBJPROP_YDISTANCE, 170);
      ObjectSetString(NULL, "Text4", OBJPROP_TEXT, "Today's Total Profit: "+ string((todayOpenPL()+todayClosePL())));
      ObjectSetString(NULL, "Text4", OBJPROP_FONT, "Courier New");
      ObjectSetInteger(NULL, "Text4", OBJPROP_FONTSIZE, 12);
      ObjectSetInteger(NULL, "Text4", OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(NULL,"Text4",OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetDouble(NULL,"Text4",OBJPROP_ANGLE,0);
      ObjectSetInteger(NULL,"Text4",OBJPROP_BACK,false);
   }
}

void deleteLabelText()
{
   ObjectDelete(NULL, "Text");
   ObjectDelete(NULL, "Text1");
   ObjectDelete(NULL, "Text2");
   ObjectDelete(NULL, "Text3");
   ObjectDelete(NULL, "Text4");
}