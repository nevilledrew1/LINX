//+------------------------------------------------------------------+
//|                                                    martLogic.mqh |
//|                              Copyright 2023, Linx Trading Co LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co LLC"
#property link      "https://www.linxtradingco.com"

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//GRID LOGIC FUNCTION//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void gridTradingLogic()
{
   bool haveOpenBuys = openBuyPosCount() > 0;
   bool haveOpenSells = openSellPosCount() > 0;
   if(haveOpenBuys)
   {
      if(openBuyPosCount() < maxOpenOrders)
      {
         initialTrade.drawdown = initialTrade.entryPrice - SymbolInfoDouble(_Symbol, SYMBOL_ASK);
         while (initialTrade.drawdown >= initialTrade.gridDistance * gridMultiplier)
         {
            double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
            initialTrade.entryPrice =  Ask;
            initialTrade.lot = NormalizeDouble((initialTrade.lot * lotMultiplier), 2);
            double averageEntry = findAverageEntry();
            initialTrade.tp = NormalizeDouble(calculateNewTp(1, averageEntry), _Digits);
            initialTrade.gridDistance = initialTrade.gridDistance * gridMultiplier;
            
            if((initialTrade.tp - initialTrade.entryPrice) / _Point > fixedTakeProfit)
            {
               initialTrade.tp = NormalizeDouble(averageEntry + fixedTakeProfit * _Point, _Digits);
            }
            
            if(initialTrade.lot > maxLotSize)
            {
               initialTrade.lot = maxLotSize;
            }
            
            initialTrade.lot = MathRound(initialTrade.lot / SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP))* SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
            trade.Buy(initialTrade.lot, NULL, initialTrade.entryPrice, initialTrade.sl, initialTrade.tp, NULL);
            updateAlltp();
            
            initialTrade.drawdown = 0;
         }
      }
   }
   if(haveOpenSells)
   {
      if(openSellPosCount() < maxOpenOrders)
      {
         initialTrade.drawdown = SymbolInfoDouble(_Symbol, SYMBOL_BID) - initialTrade.entryPrice;
         while (initialTrade.drawdown >= initialTrade.gridDistance * gridMultiplier)
         {
            double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
           
            initialTrade.entryPrice =  Bid;
            initialTrade.lot = NormalizeDouble((initialTrade.lot * lotMultiplier), 2);
            double averageEntry = findAverageEntry();
            initialTrade.tp = NormalizeDouble(calculateNewTp(2, averageEntry), _Digits);
            initialTrade.gridDistance = initialTrade.gridDistance * gridMultiplier;
            
            if((initialTrade.entryPrice - initialTrade.tp) / _Point > fixedTakeProfit)
            {
               initialTrade.tp = NormalizeDouble(averageEntry - fixedTakeProfit * _Point, _Digits);
            }
   
            if(initialTrade.lot > maxLotSize)
            {
               initialTrade.lot = maxLotSize;
            }
            
            initialTrade.lot = MathRound(initialTrade.lot / SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP))* SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
            trade.Sell(initialTrade.lot, NULL, initialTrade.entryPrice, initialTrade.sl, initialTrade.tp, NULL);
            updateAlltp();
            
            initialTrade.drawdown = 0;
         }
      }
   }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//CALCULATE GRID TRADES NEW TP/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
double calculateNewTp(int posSide, double averageTradeEntry)
{
   double newTp            = 0;
   
   if(posSide == 1)
   {
      if(myPositionsTotal() < changeTpAfterTrades)
      {
         return newTp = initialTrade.tp;
      }
      return newTp = averageTradeEntry + initialTrade.tpDistance * _Point;
   }
   if(myPositionsTotal() < changeTpAfterTrades)
   {
      return newTp = initialTrade.tp;
   }
   return newTp = averageTradeEntry - initialTrade.tpDistance * _Point;
}

void updateAlltp()
{
   int      posTot            = myPositionsTotal();
   long     orderSide         = 0;
   long     magic             = 0;
   ulong    ticket            = 0;
   string   symbol            = "";
   double   tp                = 0;
   
   for(int i = PositionsTotal()-1; i>=0; i--)
   {
      symbol         = PositionGetSymbol(i);
      magic          = PositionGetInteger(POSITION_MAGIC);
      ticket         = PositionGetInteger(POSITION_TICKET);
      tp             = PositionGetDouble(POSITION_TP);

      if(tp != initialTrade.tp && orderIsMine(symbol, magic))
      {
         trade.PositionModify(ticket, NULL, initialTrade.tp);
      }
   }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//FIND AVERAGE GRID TRADE ENTRY////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
double findAverageEntry()
{
   double   averageEntry      = 0;
   double   totalLots         = 0;
   double   entryPrice        = 0;
   double   lot               = 0;
   int      posTot            = PositionsTotal();
   ulong    ticket            = 0;
   long     magic             = 0;
   string   symbol            = "";
   
   int count = 0;
   
   for(int i = 0; i < posTot; ++i)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         symbol         = PositionGetString(POSITION_SYMBOL);
         magic          = PositionGetInteger(POSITION_MAGIC);
         
         if(orderIsMine(symbol, magic))
         {
        
         
            ticket         = PositionGetInteger(POSITION_TICKET);
            entryPrice     = PositionGetDouble(POSITION_PRICE_OPEN);
            lot            = PositionGetDouble(POSITION_VOLUME);
            
            averageEntry = averageEntry + (lot * entryPrice);
            totalLots = totalLots + lot;
         }
      }
   }
   averageEntry = averageEntry + (initialTrade.lot * initialTrade.entryPrice);
   totalLots = totalLots + initialTrade.lot;
   return NormalizeDouble(averageEntry / totalLots, _Digits);
}