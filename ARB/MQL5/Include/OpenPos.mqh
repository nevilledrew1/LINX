//+------------------------------------------------------------------+
//|                                                  LRB-OpenPos.mqh |
//|                             Copyright 2023, Linx Trading Co. LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co. LLC"
#property link      "https://www.linxtradingco.com"

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> OPEN BUY POSITION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void openBuyPos()
{
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   
   double sl = calculateStopLoss(1);
   double lot = calculateLotSize(sl);
   double tp = fixedTakeProfit;
   
   trade.Buy(lot, NULL, 0.0, Ask - sl*_Point, Ask + tp*_Point, tradeComment);
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> OPEN SELL POSITION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void openSellPos()
{
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   
   double sl = calculateStopLoss(2);
   double lot = calculateLotSize(sl);
   double tp = fixedTakeProfit;
     
   trade.Sell(lot, NULL, 0.0, Bid + sl*_Point, Bid - tp*_Point, tradeComment);
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Calculate stop to use <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================

double calculateStopLoss(int posType)
{

   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   
   double stopToUse = 0;
   double sizeOfRange = ((range.highOfRange - range.lowOfRange) / _Point);
   long   minStopDist = SymbolInfoInteger(NULL, SYMBOL_TRADE_STOPS_LEVEL);
   
   if(stopTypeInp == 1)
   {
      if(waitForClose)
      {
         if(posType == 1)
         {
         stopToUse = ((Ask - range.lowOfRange)* rangeStopMult) / _Point;
         }
         if(posType == 2)
         {
            stopToUse = ((range.highOfRange - Bid)* rangeStopMult) / _Point;
         }
      }
      else{stopToUse = (sizeOfRange + (rangeBuffer*_Point)) * rangeStopMult;}
   }
   
   else
   {
      stopToUse = fixedStopLoss;
   }
   if(stopToUse < minStopDist)
   {
      stopToUse = minStopDist * 1.5;
   }
   if(stopToUse <= 0)
   {
      stopToUse = fixedStopLoss;
   }
   return stopToUse;
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CalculatingLotSize <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
double calculateLotSize(double SL)
{
   double lotToUse            = 0;
   double currentAccBalance   = AccountInfoDouble(ACCOUNT_BALANCE);
   double indexContSize       = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE);
   
   if(lotTypeInp == 1 && fixedLotSize > 0)
   {
      lotToUse = fixedLotSize;
   }

   if(lotTypeInp == 0 && percentLot > 0)
   {
      double nTickValue = SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);

      // If the digits are 3 or 5, we normalize multiplying by 10.
      if ((_Digits == 3) || (_Digits == 5))
      {
         nTickValue = nTickValue * 1;
      }
      lotToUse = (currentAccBalance * percentLot / 100) / (SL * nTickValue);
      lotToUse = MathRound(lotToUse / SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP)) * SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
      if(isIndex && indexContSize == 10)
      {
         lotToUse = lotToUse/10;
      }
      if(isIndex && indexContSize == 100)
      {
         lotToUse = lotToUse/100;
      }
      if(lotToUse > maxLotSize)
      {
         lotToUse = maxLotSize;
      }
   }
   return lotToUse;
}
