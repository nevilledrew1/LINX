//+------------------------------------------------------------------+
//|                                                     LRB-TsBe.mqh |
//|                             Copyright 2023, Linx Trading Co. LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co. LLC"
#property link      "https://www.linxtradingco.com"

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> UPDATE STOP LOSSES <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void updateTSandBE()
{
   checkForBreakeven();
   checkForTrailing();
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CHECK FOR BREAKEVEN <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void checkForBreakeven()
{
   if(useBreakeven)
   {
      updateBreakEven();
   }
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CHECK FOR TRAILING STOP <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void checkForTrailing()
{
   if(useTrailingStop)
   {
      updateTrailingStop();
   }
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> UPDATE BREAKEVEN <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void updateBreakEven()
{
   double   ask               = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double   bid               = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double   beStopNormal      = NormalizeDouble(breakevenStop*_Point, _Digits);
   double   beStartNormal     = NormalizeDouble(breakevenStart*_Point, _Digits);
   double   currentStop       = 0;
   double   entryPrice        = 0;
   double   currentPrice      = 0;
   int      posTot            = myPositionsTotal();
   long     orderSide         = 0;
   long     magic             = 0;
   ulong    ticket            = 0;
   string   symbol            = "";
   
   for(int i = 0; i < posTot; ++i)
   {
      symbol         = PositionGetSymbol(i);
      magic          = PositionGetInteger(POSITION_MAGIC);
      ticket         = PositionGetInteger(POSITION_TICKET);
      currentStop    = PositionGetDouble(POSITION_SL);
      entryPrice     = PositionGetDouble(POSITION_PRICE_OPEN);
      currentPrice   = PositionGetDouble(POSITION_PRICE_CURRENT);
      orderSide      = PositionGetInteger(POSITION_TYPE);
         
      if(orderSide == 0 && currentPrice >= entryPrice + beStartNormal && currentStop < entryPrice - beStopNormal)
      {
         trade.PositionModify(ticket, entryPrice+beStopNormal, NULL);
      }
      if(orderSide == 1 && currentPrice <= entryPrice - beStartNormal && currentStop > entryPrice + beStopNormal)
      {
         trade.PositionModify(ticket, entryPrice-beStopNormal, NULL);
      }
   }
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> UPDATE TRAILING STOP <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

void updateTrailingStop()
{
   double   ask               = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double   bid               = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double   trailStopNormal   = NormalizeDouble(trailingStop*_Point, _Digits);
   double   trailStartNormal  = NormalizeDouble(trailingStart*_Point, _Digits);
   double   trailStepNormal   = NormalizeDouble(trailingStep*_Point, _Digits);
   double   currentStop       = 0;
   double   entryPrice        = 0;
   double   currentPrice      = 0;
   int      posTot            = PositionsTotal();
   long     orderSide         = 0;
   long     magic             = 0;
   ulong    ticket            = 0;
   string   symbol            = "";
   
   for(int i = 0; i < posTot; ++i)
   {
      symbol         = PositionGetSymbol(i);
      magic          = PositionGetInteger(POSITION_MAGIC);
      ticket         = PositionGetInteger(POSITION_TICKET);
      currentStop    = PositionGetDouble(POSITION_SL);
      entryPrice     = PositionGetDouble(POSITION_PRICE_OPEN);
      currentPrice   = PositionGetDouble(POSITION_PRICE_CURRENT);
      orderSide      = PositionGetInteger(POSITION_TYPE);
         
      if(orderSide == 0 && currentPrice >= entryPrice + trailStartNormal && currentStop <= bid - trailStopNormal - trailStepNormal)
      {
         trade.PositionModify(ticket, bid-trailStopNormal, NULL);
      }
      if(orderSide == 1 && currentPrice <= entryPrice - trailStartNormal && currentStop >= ask + trailStopNormal + trailStepNormal)
      {
         trade.PositionModify(ticket, ask+trailStopNormal, NULL);
      }
   }
}
