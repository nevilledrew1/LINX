//+------------------------------------------------------------------+
//|                                              CanIOpenAnother.mqh |
//|                                             Linx Trading Co. LLC |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Linx Trading Co. LLC"
#property link      "https://www.mql5.com"
#property strict

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CanOpenAnotherSell <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

bool canOpenAnotherSell()
{
   //return (useMultipleSame || (todaysSellPosCount() == 0));
   if(allowMultipleSame || (closedSellPosCount() == 0))
   {
      return true;
   }

   return false;
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CanOpenAnotherBuy <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

bool canOpenAnotherBuy()
{
   if(allowMultipleSame || (closedBuyPosCount() == 0))
   {
      return true;
   }
   return false;
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ClosedSellPosCount <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

int closedSellPosCount()
{
   datetime    BOD     = Time[0] - Time[0] % 86400;    // Beginning of today
                // Use  = TimeCurrent() - 86400 for last 24 hours
   int         count   = 0;
   for  (int pos=OrdersHistoryTotal()-1; pos >= 0; pos--)
      if
      (
         OrderSelect(pos, SELECT_BY_POS, MODE_HISTORY)   // Only orders w/
      &&   OrderMagicNumber()  == magicNumber             // my magic number
      &&   OrderSymbol()       == Symbol()                 // and my pair,
      &&   OrderOpenTime()    > BOD                       // closed today.
      &&   OrderType()         == OP_SELL)
   {
      count++;
   }
   
   return (count);
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ClosedBuyPosCount <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

int closedBuyPosCount()
{
   datetime    BOD     = Time[0] - Time[0] % 86400;    // Beginning of today
                // Use  = TimeCurrent() - 86400 for last 24 hours
   int         count   = 0;
   for  (int pos=OrdersHistoryTotal()-1; pos >= 0; pos--)
      if
      (
         OrderSelect(pos, SELECT_BY_POS, MODE_HISTORY)   // Only orders w/
      &&   OrderMagicNumber()  == magicNumber             // my magic number
      &&   OrderSymbol()       == Symbol()                 // and my pair,
      &&   OrderOpenTime()    > BOD                       // closed today.
      &&   OrderType()         == OP_BUY)
   {
      count++;
   }
   
   return (count);
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> OPENSellPosCount <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

int openSellPosCount()
{
   datetime    BOD     = Time[0] - Time[0] % 86400;    // Beginning of today
                // Use  = TimeCurrent() - 86400 for last 24 hours
   int         count   = 0;
   for  (int pos=OrdersTotal()-1; pos >= 0; pos--)
      if
      (
         OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)   // Only orders w/
      &&   OrderMagicNumber()  == magicNumber             // my magic number
      &&   OrderSymbol()       == Symbol()                 // and my pair,
      &&   OrderOpenTime()     > BOD                       // closed today.
      &&   OrderType()         == OP_SELL)
   {
      count++;
   }
   
   return (count);
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> OPEN BuyPosCount <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

int openBuyPosCount()
{
   datetime    BOD     = Time[0] - Time[0] % 86400;    // Beginning of today
                // Use  = TimeCurrent() - 86400 for last 24 hours
   int         count   = 0;
   for  (int pos=OrdersTotal()-1; pos >= 0; pos--)
      if
      (
         OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)   // Only orders w/
      &&   OrderMagicNumber()  == magicNumber             // my magic number
      &&   OrderSymbol()       == Symbol()                 // and my pair,
      &&   OrderOpenTime()     > BOD                       // closed today.
      &&   OrderType()         == OP_BUY)
   {
      count++;
   }
   
   return (count);
}