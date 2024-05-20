//+------------------------------------------------------------------+
//|                                                       Inputs.mqh |
//|                             Copyright 2023, Linx Trading Co. LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co. LLC"
#property link      "https://www.linxtradingco.com"

enum patternEnum
{
   non = 0, //NULL
   ham = 1, //Hammer
   doj = 2, //Doji
   hamDoj = 3, //Hammer & Doji
   fvgP = 4, //FVG
   psar = 5 //SAR Crossover
};

enum takeProfit
{
   fix = 0,  //Fixed TP
   BbTp = 1, //BB TP
   mbTp = 2,  //Middle Band BB TP
   pstp = 3,   //PSAR TP
   rrtp = 4    //RR TP Based On SL
};

enum stopEnum
{
   fs = 0, //Fixed SL
   bbs = 1, //BB Stop
   pssl = 2, //PSAR SL
   rrsl = 3 //RR SL Based On TP
};

enum bbSlTimeFrame
{
   curr = 0, //Current TF
   secc = 1 //Secondary BB TF
};

enum bbTpTimeFrame
{
   cur = 0, //Current TF
   sec = 1 //Secondary BB TF
};

enum tradeTime
{
   all = 0,  //All Day
   ct  = 1,  //Custom Sessions
   ase = 2   //All sessions
};

enum tsEnum
{
   sts = 0, //PSAR Trailing
   ft = 1   //Fixed Trailing
};

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INPUT PARAMETERS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
input string  MMSTRING          = "======= MONEY MANAGEMENT =====";     //========================================================================
input double  fixedLotSize      = 1.00;        //Fixed Lot Size
input double  maxLotSize        = 500;         //Maximum Lot Size
input int     maxSpread         = 50;          //Maximum Spread

input string  OCSTRING          = "====== ORDER CUSTOMIZATION ====";     //========================================================================
input int     magicNumber       = 12121;              //Magic Number  
input string  tradeComment      = "MegaMillinx";      //Trade Comment

input string  TSESTRING         = "=== GENERAL TRADE SETTINGS ===";     //========================================================================
input int     maxDailyOrders    = 100;          //Max Daily Positions
input bool    useReverseTrades  = false;        //Use Reverse Trades?
input bool    closeOnOppositeSig = true;        //Close On Opposite Signal?
input bool    closeOppOnlyProfit = true;        //Only Close Opp If In Profit?

input string  ECSTRING          = "======= ENTRY CONDITIONS =====";      //========================================================================
input patternEnum patternsToUse = 0;            //Enter On " " After BB Signal

input string  BBSTRING          = "==== BOLLINGER BAND SETTINGS ====";      //========================================================================
input int     bbLength          = 20;           //BB Length
input int     bbStdDev          = 2;            //BB Std Dev
input bool    useSecBB          = true;         //Use Secondary BB?
input ENUM_TIMEFRAMES secBbTimeFrame = 1;       //Secondary BB Timeframe

input string  RSISTRING         = "======= RSI SETTINGS =====";      //========================================================================
input bool    useRsi            = true;        //Use RSI?
input int     rsiPeriod         = 14;          //RSI Period
input int     rsiHigh           = 70;          //RSI OverBought Value
input int     rsiLow            = 30;          //RSI OverSold Value
input bool    useSecRsi         = true;        //Use Secondary RSI?
input ENUM_TIMEFRAMES secRsiTimeframe = 1;     //Secondary RSI Timeframe

input string  TRSISTRING        = "======= TREND SETTINGS =====";      //========================================================================
input bool    tradeWithTrend    = true;        //Trade With Trend?
input bool    reverseTrend      = false;       //Reverse Trend Trades?
input int     trendLength       = 50;          //MA Length
input ENUM_TIMEFRAMES trendTf   = 0;           //MA TimeFrame
input bool    useSecondTrend    = false;       //Use Second MA?
input int     secMaLength       = 100;         //Sec MA Length
input ENUM_TIMEFRAMES secMaTimeFrame    = 0;   //Sec MA TimeFrame
input bool    useThirdTrend     = false;       //Use Third MA?
input int     thirdMaLength      = 200;        //Third MA Length
input ENUM_TIMEFRAMES thirdMaTimeFrame = 0;    //Third MA TimeFrame

input string  GSSTRING          = "======= GRID SETTINGS =====";     //========================================================================
input bool    allowGrid         = false;       //Allow Grid Trading?
input int     maxOpenOrders     = 5;           //Max Open Positions
input int     gridDistance      = 100;         //Grid Distance
input double  gridMultiplier    = 1.00;        //Grid Distance Multiplier
input int     changeTpAfterTrades= 3;          //Change To Fixed TP After Trade Amount
input double  lotMultiplier     = 1.00;        //Lot Multiplier

input string PSSTRING           = "======= PSAR SETTINGS =====";     //========================================================================
input bool   useSar             = true;        //Use PSAR?
input double sarIncrement       = 0.02;        //PSAR Increment
input double sarMaxVal          = 0.2;         //PSAR Max Value

input string  SLSTRING          = "======= STOP-LOSS SETTINGS =====";     //========================================================================
input stopEnum stopType         = 0;           //Stop-Loss Type
input bbSlTimeFrame BbStopTf    = 1;           //BB SL TimeFrame
input int     fixedStopLoss     = 0;           //Fixed Stop Distance
input double  psarSlMultiplier  = 1.00;        //PSAR SL Multiplier
input double  rrSlMultiplier    = 1.00;        //Risk/Reward Ratio SL
input bool    useFloatingStop   = false;       //Use Floating Stop-Loss?
input double  floatingStop      = 1000;        //Floating Stop-Loss $
input bool    useDailyStop      = true;        //Use Daily Stop-Loss?
input double  dailyStopValue    = 10000;       //Daily Stop $

input string  TPSTRING          = "====== TAKE-PROFIT SETTINGS =====";     //========================================================================
input takeProfit takeProfitInp  = 0;           //Take Profit Type
input bbTpTimeFrame bbTpTime    = 0;           //BB TP TimeFrame
input int     fixedTakeProfit   = 500;         //Fixed Take-Profit
input double  psarTpMultiplier  = 1.00;        //PSAR TP Multiplier
input double  rrTpMultiplier    = 1.00;        //Risk/Reward Ratio TP
input bool    useFloatingTakeProfit= true;     //Use Floating Take-Profit?
input double  floatingTakeProfit= 1000;        //Floating Take-Profit $
input bool    useDailyTakeProfit= true;        //Use Daily Take-Profit?
input double dailyTakeProfitValue= 10000;      //Daily Take-Profit $

input string  PCSTRING          = "====== PARTIAL CLOSE SETTINGS =====";     //========================================================================
input bool    usePartialClose   = false;       //Use Partial Close?
input int     partialsSpacing   = 25;          //Take Partials Every 'X' %
input int     percentPosToClose = 50;          //% Of Pos To Close At Partials

input string  TSSTRING          = "====== TRAIL-STOP SETTINGS ======";     //========================================================================
input bool     useTrailingStop = true;   //Use Trailling Stop?
input tsEnum   trailingType   = 0;       //Trailing Stop Type
input bool     trailOnlyProf  = false;    //Trail Only In Profit?
input int      trailingStart     = 0;    //Trailing Start
input int      trailingStop      = 25;   //Trail Stop
input int      trailingStep      = 0;    //Trail Step


input string  TTSTRING          = "======== TRADE SCHEDULE =======";     //========================================================================
input tradeTime tradeStartToUse = 0;           //When To Trade?
input bool    tradeAsia         = 16;          //Trade Asia Session?
input bool    tradeLondon       = 30;          //Trade London Session?
input bool    tradeNewYork      = 17;          //Trade NY Session?
input bool    closeOutOfSession = false;       //Close Trades When Out oF Session?
input bool    tradeDuringSwapRollover = false; //Trade During Swap Rollover?

input string  NFSTRING          = "========= NEWS FILTER ========";     //========================================================================
input bool    highImpactTrade   = true;       //Trade During High Impact News?
input bool    medImpactNews    = true;        //Trade During Medium Impact News?
input int     minutesBeforeNews = 10;         //Stop Trading "X" Minutes Before News
input int     minutesAfterNews  = 10;         //Continue Trading "X" Minutes After News
input bool    closeBeforeHighImp= false;      //Close Open Pos Before HI News?
input bool    closeBeforeMedImp = false;      //Close Open pos Before MI News?
input int     closeMinsBeforeNews = 10;       //Close Pos "X" Minutes Before News