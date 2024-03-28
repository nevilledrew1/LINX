//+------------------------------------------------------------------+
//|                                                      DailyPL.mqh |
//|                                             Linx Trading Co. LLC |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Linx Trading Co. LLC"
#property link      "https://www.mql5.com"
#property strict

   bool isDailySlHit = false;
   bool isDailyTpHit = false;

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Check Daily P&L <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void checkForDailyPL()
{
   isDailySlHit = false;
   isDailyTpHit = false;
   
   if (useDailyStopLoss)
   {
      dailyStopLoss();
   }
   if (useDailyTakeProfit)
   {
      dailyTakeProfit();
   }
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Today Close PL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

double todayClosePL()
{
   datetime    BOD      = Time[0] - Time[0] % 86400;
   double      closedPL = 0;
   int         count    = 0;
   
   for  (int pos=OrdersHistoryTotal()-1; pos >= 0; pos--)
      if
      (
         OrderSelect(pos, SELECT_BY_POS, MODE_HISTORY)   // Only orders w/
      &&   OrderMagicNumber()  == magicNumber             // my magic number
      &&   OrderSymbol()       == Symbol()                 // and my pair,
      &&   OrderCloseTime()    > BOD)                       // closed today.
      {
         closedPL = OrderProfit() + closedPL;
         count++;
      }
      
      return closedPL;

}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Today Open PL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

double todayOpenPL()
{
   datetime    BOD      = Time[0] - Time[0] % 86400;
   double      openPL = 0;
   int         count    = 0;
   
   for  (int pos=OrdersTotal()-1; pos >= 0; pos--)
      if
      (
         OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)   // Only orders w/
      &&   OrderMagicNumber()  == magicNumber             // my magic number
      &&   OrderSymbol()       == Symbol()                 // and my pair,
      &&   OrderOpenTime()     > BOD)                       // closed today.
      {
         openPL = OrderProfit() + openPL;
         count++;
      }
      
      return openPL;

}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Use Daily Stop <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void dailyStopLoss()
{
   
   if(todayOpenPL() + todayClosePL() <= - accountStartingBalance * (dailyStopLoss / 100))
   {
      Alert("Daily Stop-Loss % has been reached, attempting to close trades..");
      isDailySlHit = true;
      for  (int pos=OrdersTotal()-1; pos >= 0; pos--)
      if
      (
         OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)   // Only orders w/
      &&   OrderMagicNumber()  == magicNumber             // my magic number
      &&   OrderSymbol()       == Symbol())                
      {
         OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), 10);
         Alert("Removing expert from chart ", Symbol()," due to daily stop loss limit!"); 
         ExpertRemove();      
      }
   }


}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Use Daily TP <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void dailyTakeProfit()
{
   
   if(todayOpenPL() + todayClosePL() >= accountStartingBalance * (dailyTakeProfit / 100))
   {
      Alert("Daily Take-Profit % has been reached, attempting to close trades..");
      isDailyTpHit = true;
      for  (int pos=OrdersTotal()-1; pos >= 0; pos--)
      if
      (
           OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)   // Only orders w/
      &&   OrderMagicNumber()  == magicNumber             // my magic number
      &&   OrderSymbol()       == Symbol()  )              
      {
         OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), 10);
         Alert("Removing expert from chart ", Symbol()," due to daily take profit limit!");
         ExpertRemove();
      }
   }
}
