//+------------------------------------------------------------------+
//|                                               executionLogic.mqh |
//|                              Copyright 2023, Linx Trading Co LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co LLC"
#property link      "https://www.linxtradingco.com"

#include <Trade\Trade.mqh>

CTrade trade;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//ORDER EXECUTION ALGORITHM////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void orderExecution(datetime currentBar)
{
   if(patternsToUse != 0 && patternsToUse != 5)
   {
      checkPriceAction(currentBar);
   }
   if(patternsToUse == 5)
   {
      identifySarCross(currentBar);
   }
   if(patternsToUse == 0)
   {
      if(entryS.entryIsBull)
      {
         executeMarketOrder(1);
      }
      else{executeMarketOrder(2);}
   }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//EXECUTE MARKET POSITIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void executeMarketOrder(int signalSide)
{
   //SIGNAL SIDE 1 = LONG
   //SIGNAL SIDE 2 = SHORT
   resetTradeInfo();
   
   if(signalSide == 1)
   {
      if(!useReverseTrades)
      {
         executeMarketBuy();
      }
      else executeMarketSell();
   }
   if(signalSide == 2)
   {
      if(!useReverseTrades)
      {
         executeMarketSell();
      }
      else executeMarketBuy();
   }
}

void executeMarketBuy()
{
   double ask  = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double bid  = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double tp   = NormalizeDouble(gatherTakeProfit(1), _Digits);
   double sl   = NormalizeDouble(gatherStopLoss(1), _Digits);
   double lot  = MathRound(fixedLotSize / SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP))* SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
   double spread  = ask - bid;
   
   if(tp <= ask && takeProfitInp != 0)
   {
      Print("TakeProfit not usable due to being lower than current ask price, using fixed take-profit of ", fixedTakeProfit, " to execute buy position.");
      if(fixedTakeProfit != 0)
      {
         tp = ask + fixedTakeProfit * _Point;
      }
      else tp = 0;
   }
   if(sl >= bid && stopType != 0)
   {
      Print("StopLoss not usable due to being higher than current bid price, using fixed stop-loss of ", fixedStopLoss, " to execute buy position.");
      if(fixedStopLoss != 0)
      {
         sl = bid - fixedStopLoss * _Point;
      }
      else sl = 0;
   }
   if(fixedStopLoss == 0 && stopType == 0)
   {
      sl = 0;
   }
   
   initialTrade.entryPrice = ask;
   initialTrade.lot        = fixedLotSize;
   initialTrade.tp         = tp;
   initialTrade.sl         = sl;
   initialTrade.tpDistance = (tp - bid) / _Point;
   initialTrade.posSide    = 1;
   
   if(spread / _Point > maxSpread)
   {
      Print("Unable to set sell limit due to spread size. Returning and trying again..");
      return;
   }
   
   trade.Buy(lot, _Symbol, ask, sl, tp, tradeComment);
   Alert("Market buy executed at ask price: ", ask, " for symbol ", _Symbol, "\nTake-Profit: ", tp, " Stop-Loss: ", sl);
}

void executeMarketSell()
{
   double bid  = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double ask  = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double tp   = NormalizeDouble(gatherTakeProfit(2), _Digits);
   double sl   = NormalizeDouble(gatherStopLoss(2), _Digits);
   double lot  = MathRound(fixedLotSize / SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP))* SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
   double spread  = ask - bid;

   if(tp >= bid && takeProfitInp != 0)
   {
      Print("TakeProfit not usable due to being higher than current bid price, using fixed take-profit of ", fixedTakeProfit, " to execute sell position.");
      if(fixedTakeProfit != 0)
      {
         tp = bid - fixedTakeProfit * _Point;
      }
      else tp = 0;
   }
   if(sl <= ask && stopType != 0)
   {
      Print("StopLoss not usable due to being lower than current ask price, using fixed stop-loss of ", fixedStopLoss, "to execute sell position.");
      if(fixedStopLoss !=0)
      {
         sl = ask + fixedStopLoss * _Point;
      }
      else sl = 0;
   }
   if(fixedStopLoss == 0 && stopType == 0)
   {
      sl = 0;
   }
   
   initialTrade.entryPrice = bid;
   initialTrade.lot        = lot;
   initialTrade.tp         = tp;
   initialTrade.sl         = sl;
   initialTrade.tpDistance = (bid - tp) / _Point;
   initialTrade.posSide    = 2;

   if(spread / _Point > maxSpread)
   {
      Print("Unable to set sell limit due to spread size. Returning and trying again..");
      return;
   }

   trade.Sell(lot, _Symbol, bid, sl, tp, tradeComment);
   Alert("Market sell executed at bid price: ", bid, " for symbol ", _Symbol, "\nTake-Profit: ", tp, " Stop-Loss: ", sl);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//EXECUTE LIMIT ORDERS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void executeLimitOrder(int signalSide, double limitPrice)
{
   //SIGNAL SIDE 1 = LONG
   //SIGNAL SIDE 2 = SHORT
   resetTradeInfo();
   
   if(signalSide == 1)
   {
      if(!useReverseTrades)
      {
         executeLimitBuy(limitPrice);
      }
      else executeLimitSell(limitPrice);
   }
   if(signalSide == 2)
   {
      if(!useReverseTrades)
      {
         executeLimitSell(limitPrice);
      }
      else executeLimitBuy(limitPrice);
   }
}

void executeLimitBuy(double limitPrice)
{
   double bid     = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double ask     = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double spread  = ask - bid;
   double tp      = NormalizeDouble(gatherTakeProfit(1), _Digits);
   double sl      = NormalizeDouble(gatherStopLoss(1), _Digits);
   double lot  = MathRound(fixedLotSize / SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP))* SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);

   if(tp <= limitPrice && takeProfitInp != 0)
   {
      Print("TakeProfit not usable due to being lower than limit price, using fixed take-profit of ", fixedTakeProfit, " to place buy limit.");
      if(fixedTakeProfit != 0)
      {
         tp = ask + fixedTakeProfit * _Point;
      }
      else tp = 0;
   }
   if(sl >= limitPrice + spread && stopType != 0)
   {
      Print("StopLoss not usable due to being higher than limit price, using fixed stop-loss of ", fixedStopLoss, " to place buy limit.");
      if(fixedStopLoss != 0)
      {
         sl = limitPrice - fixedStopLoss * _Point;
      }
      else sl = 0;
   }
   if(fixedStopLoss == 0 && stopType == 0)
   {
      sl = 0;
   }
   
   initialTrade.entryPrice = limitPrice;
   initialTrade.lot        = lot;
   initialTrade.tp         = tp;
   initialTrade.sl         = sl;
   initialTrade.tpDistance = (tp - limitPrice) / _Point;
   initialTrade.posSide    = 1;
   
   if(spread / _Point > maxSpread)
   {
      Print("Unable to set sell limit due to spread size. Returning and trying again..");
      return;
   }
   
   trade.BuyLimit(lot, limitPrice, _Symbol, sl, tp, ORDER_TIME_GTC, 0, tradeComment);
   Alert("Buy limit set at price: ", limitPrice, " for symbol ", _Symbol, "\nTake-Profit: ", tp, " Stop-Loss: ", sl);
}

void executeLimitSell(double limitPrice)
{
   double bid     = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double ask     = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double spread  = ask - bid;
   double tp      = NormalizeDouble(gatherTakeProfit(2), _Digits);
   double sl      = NormalizeDouble(gatherStopLoss(2), _Digits);
   double lot  = MathRound(fixedLotSize / SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP))* SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
   
   if(tp >= limitPrice && takeProfitInp != 0)
   {
      Print("TakeProfit not usable due to being higher than limit price, using fixed take-profit of ", fixedTakeProfit, " to place sell limit.");
      if(fixedTakeProfit != 0)
      {
         tp = limitPrice - fixedTakeProfit * _Point;
      }
      else tp = 0;
   }
   if(sl <= limitPrice - spread && stopType != 0)
   {
      Print("StopLoss not usable due to being lower than limit price, using fixed stop-loss of ", fixedStopLoss, "to place sell limit.");
      if(fixedStopLoss != 0)
      {
         sl = limitPrice + fixedStopLoss * _Point;
      }
      else sl = 0;
   }
   if(fixedStopLoss == 0 && stopType == 0)
   {
      sl = 0;
   }
   
   initialTrade.entryPrice = limitPrice;
   initialTrade.lot        = lot;
   initialTrade.tp         = tp;
   initialTrade.sl         = sl;
   initialTrade.tpDistance = (limitPrice - tp) / _Point;
   initialTrade.posSide    = 2;
   
   if(spread / _Point > maxSpread)
   {
      Print("Unable to set sell limit due to spread size. Returning and trying again..");
      return;
   }
   
   trade.SellLimit(lot, limitPrice, _Symbol, sl, tp, ORDER_TIME_GTC, 0, tradeComment);
   Alert("Sell limit set at price: ", limitPrice, " for symbol ", _Symbol, "\nTake-Profit: ", tp, " Stop-Loss: ", sl);
   
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//GATHER TP/SL/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
double gatherTakeProfit(int posSide)
{
   double ask  = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double bid  = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   
   if(posSide == 1)
   {
      if(takeProfitInp == 0)
      {
         return ask + fixedTakeProfit * _Point;
      }
      if(takeProfitInp == 1)
      {
         if(bbTpTime == 0)
         {
            return bollingerb.upperBandCurrent;
         }
         else return bollingerbSec.upperBandCurrent;
      }
      if(takeProfitInp == 2)
      {
         return bollingerb.middleBandValue;
      }
      if(takeProfitInp == 3)
      {
         return ask + psarTpMultiplier * (ask - sar.valueCurrent);
      }
      if(takeProfitInp == 4)
      {
         return ask + ((rrTpMultiplier * ((ask - gatherStopLoss(1)) / _Point)) * _Point) ;
      }
   }
   if(takeProfitInp == 0)
   {
      return bid - fixedTakeProfit * _Point;
   }
   if(takeProfitInp == 1)
   {
      if(bbTpTime == 0)
      {
         return bollingerb.lowerBandCurrent;
      }
      else return bollingerbSec.lowerBandCurrent;
   }
   if(takeProfitInp == 2)
   {
      return bollingerb.middleBandValue;
   }
   if(takeProfitInp == 3)
   {
      return bid - psarTpMultiplier * (MathAbs(sar.valueCurrent-bid));
   }
   if(takeProfitInp == 4)
   {
      return bid - ((rrTpMultiplier * ((gatherStopLoss(2) - bid) / _Point)) * _Point);
   }
   Print("No usable TP found. Setting tp to 0.");
   return 0;
}

double gatherStopLoss(int posSide)
{
   double bid  = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double ask  = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   
   if(posSide == 1)
   {
      if(stopType == 0)
      {
         return bid - fixedStopLoss * _Point;
      }
      if(stopType == 1)
      {
         if(BbStopTf == 0)
         {
            return bollingerb.lowerBandCurrent;
         }
         else return bollingerbSec.lowerBandCurrent;
      }
      if(stopType == 2)
      {
         return ask - psarSlMultiplier * (MathAbs(ask - sar.valueCurrent));
      }
      if(stopType == 3)
      {
         return ask - ((((gatherTakeProfit(1) - ask) / _Point) / rrSlMultiplier) * _Point);
      }
   }
   if(stopType == 0)
   {
      return ask + fixedStopLoss * _Point;
   }
   if(stopType == 1)
   {
      if(BbStopTf == 0)
      {
         return bollingerb.upperBandCurrent;
      }
      else return bollingerbSec.upperBandCurrent;
   }
   if(stopType == 2)
   {
      return bid + psarSlMultiplier * (MathAbs(sar.valueCurrent - bid));
   }
   if(stopType == 3)
   {
      return bid + ((((bid - gatherTakeProfit(2)) / _Point) / rrSlMultiplier) * _Point);
   }
return 0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//DELETE PENDING ORDERS////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void deletePendingOrders()
{
   int         posTotal    = OrdersTotal();
   ulong       ticket      = 0;
   string      symbol      = "";
   long        magic       = 0;
   
   for (int i = OrdersTotal()-1; i>=0; i--)
   {
      ticket   = OrderGetTicket(i);
      symbol   = OrderGetString(ORDER_SYMBOL);
      magic    = OrderGetInteger(ORDER_MAGIC);
      
      if(orderIsMine(symbol, magic))
      {
         trade.OrderDelete(ticket);
      }          
   }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//CLOSE OPEN TRADES////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void closeAllOpenTrades()
{
   int         posTotal    = PositionsTotal();
   ulong       ticket      = 0;
   string      symbol      = "";
   long        magic       = 0;
   int         count       = 0;
   
   Print("Closing all open trades, total trades open: ", posTotal);
   
   for (int i = PositionsTotal()-1; i>=0; i--)
   {
      ticket   = PositionGetTicket(i);
      symbol   = PositionGetString(POSITION_SYMBOL);
      magic    = PositionGetInteger(POSITION_MAGIC);
      
      if(orderIsMine(symbol, magic))
      {
         ++count;
         Print(count);
         Print(trade.PositionClose(ticket, NULL));
      }          
   }
}

