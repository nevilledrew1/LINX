//+------------------------------------------------------------------+
//|                                               LRB-UserInputs.mqh |
//|                             Copyright 2023, Linx Trading Co. LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co. LLC"
#property link      "https://www.linxtradingco.com"

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INPUT ENUMS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
enum stopAfterSelection 
  {
   wR = 0,  //When Range Is Removed
   sT = 1,  //At Specified Time
   aT = 2,  //After 'X' Trades
   bO = 3,  //After Price Breakout
  };

enum orderType 
  {
   p = 0,  //Pending Orders
   m = 1,  //Market Orders
  };

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INPUT PARAMETERS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

input string   LICSTRING            = "========== LICENSING  ========";     //==================
input string   userID               = "profitmaker123";                     //Web UserID

input string   ISSTRING             = "======= INDEX SPECIFICATION =====";  //==================
input bool     isIndex              = false;       //Is Index?
input int      indexContSize        = 1;           //Index Contract Size

input string   MMSTRING             = "======= MONEY MANAGEMENT =====";     //==================

input double   fixedLotSize         = 1.00;        //Fixed Lot Size
input bool     usePercentLot        = false;       //Use % Risk Lot?
input double   percentLot           = 2.50;        //Risk % Per-Trade
input double   maxLotSize           = 500.00;      //Max Lot-Size     

input string   OCSTRING             = "====== ORDER CUSTOMIZATION ====";     //==================
input orderTypeEnum orderTypeInp    = 0;           //Order Type
input int      magicNumber          = 12121;       //Magic Number
input string   tradeComment         = "LINX-MRB";  //Trade Comment

input string   TCSTRING             = "====== TRADE CUSTOMIZATION ====";     //==================

input bool     allowMultipleSame    = true;        //Allow Multiple Same Orders?
input bool     useReverseTrades     = false;       //Use Reverse Trades?

input string   RSSTRING             = "======== RANGE SETTINGS =======";     //==================

input stopAfterSelection sASresult  = 0;           //When To Stop Trading?
input int      tradeStopHour        = 0;           //Trade Stop Hour
input int      tradeStopMinute      = 0;           //Trade Stop Minute
input int      stopAfterTradeNumber = 1;           //Stop After 'X' Trades

input string   RCSTRING             = "====== RANGE CUSTOMIZATION =====";     //==================

input int      defaultOffset        = 1000;        //Default Range Offset

input string   SLSTRING             = "======= STOP-LOSS SETTINGS =====";     //==================

input bool     useRangeStopLoss     = false;       //Use Range Stop-Loss?
input int      fixedStopLoss        = 500;         //Fixed Stop-Loss
input bool     useDailyStopLoss     = false;       //Use Daily Stop-Loss?
input double   dailyStopLoss        = 10;          //Daily Stop-Loss %

input string   TPSTRING             = "====== TAKE-PROFIT SETTINGS =====";     //==================

input int      fixedTakeProfit      = 500;         //Fixed Take-Profit
input bool     useDailyTakeProfit   = true;        //Use Daily Take Profit?
input double   dailyTakeProfit      = 10;          //Daily Take Profit %

input string   BESTRING             = "====== BREAK-EVEN SETTINGS =====";     //==================

input bool     useBreakeven         = true;        //Use Breakeven?
input int      breakevenStart       = 50;          //Breakeven Start
input int      breakevenStop        = 50;          //Breakeven Stop Size

input string   TSSTRING             = "====== TRAIL-STOP SETTINGS ======";     //==================

input bool     useTrailingStop      = true;        //Use Trailing Stop?
input int      trailingStart        = 100;         //Trailing-Start Size
input int      trailingStop         = 100;         //Trailing-Stop Size
input int      trailingStep         = 50;          //Trailing-Step Size 