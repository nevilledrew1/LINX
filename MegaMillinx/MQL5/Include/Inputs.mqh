//+------------------------------------------------------------------+
//|                                                       Inputs.mqh |
//|                             Copyright 2023, Linx Trading Co. LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co. LLC"
#property link      "https://www.linxtradingco.com"

enum ordSidesAllowed
{
   b = 0, //Long & Short
   l = 1, //Only Long
   s = 2  //Only Short
};

enum tradeTime
{
   all = 0, //All Day
   ct  = 1  //Custom Trading Time
};

fixedTp, fixedBB, trailingBb

doji, hammer, doji or hammer, none

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INPUT PARAMETERS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
input string  MMSTRING          = "======= MONEY MANAGEMENT =====";     //==================
input double  fixedLotSize      = 1.00;        //Fixed Lot Size
input double  maxLotSize        = 500;         //Maximum Lot Size
input double  lotMultiplier     = 1.00;        //Lot Multiplier
input double  maxMarginUse      = 100;         //Max Margin Use %

input string  OCSTRING          = "====== ORDER CUSTOMIZATION ====";     //==================
input int     magicNumber       = 12121;              //Magic Number  
input string  tradeComment      = "MegaMillinx";      //Trade Comment

input string  TSESTRING          = "=== GENERAL TRADE SETTINGS ===";     //==================
input ordSidesAllowed ordSideInp = 0;           //Trade Sides Allowed
input int     maxDailyOrders     = 20;          //Max Open Positions
input bool    allowHedge         = true;        //Allow Hedging?
input bool    useReverseTrades   = false;       //Use Reverse Trades?
input bool    closeOnOppositeSig = true;        //Close On Opposite Signal?

input string  ECSTRING          = "======= ENTRY CONDITIONS ====="      //==================
input bool    requireBbClose    = true;        //Require Close After BB Touch?
input bool    useDoji           = 0;           //Only Enter On Pattern Close?
input bool    useMaForEntry     = true;        //Use BB MA For Signals?
input bool    waitForStructureShift = false;   //Wait For Structure Shift to Enter?

input string  DOJISTRING        = "==== CANDLE PATTERN SETTINGS ==="      //==================
input double  dojiBodyPercent   = 5;            //% Body Size Required For Doji
input double  hammerMidline     = 50;           //% Close Position for Hammner
input double  hammerBodyPercent = 38.2;         //% Body Size Required For Hammer
input int     minFvgSize        = 1000;         //Minimum FVG Size

input string  BBSTRING          = "==== BOLLINGER BAND SETTINGS ===="      //==================
input int     bbLength          = 20;           //BB Length
input int     bbTimeFrame       = 0;            //BB TimeFrame
input int     bbStdDev          = 2;            //BB Std Dev

input string  RSISTRING          = "======= RSI SETTINGS ====="      //==================
input int     rsiPeriod         = 7;           //RSI Period
input int     rsiHigh           = 70;          //RSI OverBought Value
input int     rsiLow            = 30;          //RSI OverSold Value
input rsiInitEnum rsiInitInp            = 0;   //RSI Timeframe
input rsiSecondaryEnum rsiSecondaryInp  = 0;   //Secondary RSI Timeframe

input string  GSSTRING          = "======= GRID SETTINGS =====";     //==================
input int     gridDistance      = 10;          //Grid Distance
input double  gridMultiplier    = 1.00;        //Grid Multiplier

input string  SLSTRING          = "======= STOP-LOSS SETTINGS =====";     //==================
input int     fixedStopLoss     = 0;           //Fixed Stop Distance
input bool    useFloatingStop   = false;       //Use Equity Stop-Loss?
input double  floatingStop      = 10;          //Equity Stop-Loss %

input string  TPSTRING          = "====== TAKE-PROFIT SETTINGS =====";     //==================
input takeProfit takeProfitInp  = 0;           //Take Profit Type
input int     fixedTakeProfit   = 500;         //Fixed Take-Profit
input bool    changeToFixedTp   = true;        //Change To Fixed TP After 'X' Trades?
input int     changeTpAfterTrades = 3;         //Change After Trade Amount
input bool    useFloatingTakeProfit= true;     //Use Floating Take Profit?
input double  floatingTakeProfit   = 10;       //Floating Take Profit %

input string  TSSTRING          = "====== TRAIL-STOP SETTINGS ======";     //==================
input bool    useTrailingStop   = true;        //Use Trailing Stop?
input int     trailingStart     = 100;         //Trailing-Start Size
input int     trailingStop      = 100;         //Trailing-Stop Size
input int     trailingStep      = 50;          //Trailing-Step Size

input string  SDSTRING          = "==== SIGNAL DELETE SETTINGS ====";     //==================
input sDeleteEnum signalDeleteInp 0;           //When to Delete Signal?

input string  TTSTRING          = "======== TRADE SCHEDULE =======";     //==================
input tradeTime tradeStartToUse = 0;           //When To Trade?
input int     tradeStartHour    = 16;          //Custom Start Hour
input int     tradeStartMinute  = 30;          //Custom Start Minute
input int     tradeStopHour     = 17;          //Custom Stop Hour
input int     tradeStopMinute   = 0;           //Custom Stop Minute
input bool    mondayAllowed     = true;        //Trade Monday?
input bool    tuesdayAllowed    = true;        //Trade Tuesday?
input bool    wednesdayAllowed  = true;        //Trade Wednesday?
input bool    thursdayAllowed   = true;        //Trade Thursday?
input bool    fridayAllowed     = true;        //Trade Friday?