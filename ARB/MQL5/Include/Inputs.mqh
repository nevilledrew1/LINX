//+------------------------------------------------------------------+
//|                                               LRB-UserInputs.mqh |
//|                             Copyright 2023, Linx Trading Co. LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co. LLC"
#property link      "https://www.linxtradingco.com"

enum lotType
{
   p = 0, //% Risk Lot
   f = 1 //Fixed Lot
};

enum ordSidesAllowed
{
   b = 0, //Long & Short
   l = 1, //Only Long
   s = 2  //Only Short
};

enum tradeTime
{
   are = 0, //After Range Ends
   ct  = 1  //Custom Start Time
};

enum stopType
{
   fi = 0, //Fixed Stop Size
   r = 1  //Range Stop Loss
};

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INPUT PARAMETERS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

input string  MMSTRING          = "======= MONEY MANAGEMENT =====";     //==================

input lotType lotTypeInp        = 0;           //Lot-Size Type
input double  percentLot        = 2.50;        //Risk % Per-Trade
input double  fixedLotSize      = 1.00;        //Fixed Lot Size
input double  maxLotSize        = 500;         //Maximum Lot Size

input string  ICSTRING          = "====== IF TRADING AN INDEX ====";     //==================
input bool    isIndex           = false;       //Is Symbol An Index?

input string  OCSTRING          = "====== ORDER CUSTOMIZATION ====";     //==================

input int     magicNumber       = 12121;       //Magic Number
input string  tradeComment      = "LinxARB EA - MT4"; //Trade Comment

input string  TSESTRING          = "====== TRADE SETTINGS ====";     //==================

input ordSidesAllowed ordSideInp = 0;          //Order Sides Allowed
input int     maxDailyOrders    = 4;           //Max Daily Orders
input bool    allowMultipleSame = true;        //Allow Multiple Same Orders?
input bool    useReverseTrades  = false;       //Use Reverse Trades?
input bool    waitForClose      = false;        //Wait For Close To Enter?

input string  RTSTRING          = "======== RANGE TIME =======";     //==================

input int     rangeStartHour    = 16;          //Range Start Hour
input int     rangeStartMinute  = 00;          //Range Start Minute
input int     rangeStopHour     = 16;          //Range Stop Hour
input int     rangeStopMinute   = 30;          //Range Stop Minute

input string  TTSTRING          = "======== TRADE TIME =======";     //==================

input tradeTime tradeStartToUse   = 0;           //When To Start Trading?
input int     tradeStartHour    = 16;          //Trade Start Hour
input int     tradeStartMinute  = 30;          //Trade Start Minute
input int     tradeStopHour     = 17;          //Trade Stop Hour
input int     tradeStopMinute   = 0;           //Trade Stop Minute

input string  RCSTRING          = "====== RANGE CUSTOMIZATION ====";     //==================

input bool    useRangeSize      = false;        //Use Range Size?
input int     minRangeSize      = 0;          //Min Range Size
input int     maxRangeSize      = 1000;          //Max Range Size
input int     rangeBuffer       = 0;           //Range Buffer

input string  SLSTRING          = "======= STOP-LOSS SETTINGS =====";     //==================

input stopType    stopTypeInp   = 0;       //Stop-Loss Type
input int     fixedStopLoss     = 500;         //Fixed Stop Distance
input double  rangeStopMult     = 1;            //Range Stop Multiplier
input bool    useDailyStopLoss  = false;       //Use Daily Stop-Loss?
input double  dailyStopLoss     = 10;          //Daily Stop-Loss %

input string  TPSTRING          = "====== TAKE-PROFIT SETTINGS =====";     //==================

input int     fixedTakeProfit   = 500;         //Fixed Take-Profit
input bool    useDailyTakeProfit= true;        //Use Daily Take Profit?
input double  dailyTakeProfit   = 10;          //Daily Take Profit %

input string  BESTRING          = "====== BREAK-EVEN SETTINGS =====";     //==================

input bool    useBreakeven      = true;        //Use Breakeven?
input int     breakevenStart    = 50;          //Breakeven Start
input int     breakevenStop     = 50;          //Breakeven Stop Size

input string  TSSTRING          = "====== TRAIL-STOP SETTINGS ======";     //==================

input bool    useTrailingStop   = true;        //Use Trailing Stop?
input int     trailingStart     = 100;         //Trailing-Start Size
input int     trailingStop      = 100;         //Trailing-Stop Size
input int     trailingStep      = 50;          //Trailing-Step Size 