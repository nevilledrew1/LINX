//+------------------------------------------------------------------+
//|                                                OpenPositions.mqh |
//|                                             Linx Trading Co. LLC |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Linx Trading Co. LLC"
#property link      "https://www.mql5.com"
#property strict


// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> OPEN BUY POSITION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void openBuyPos()
{
   double S = calculateStopLoss(1);
   double L = calculateLotSize(S);
   double T = fixedTakeProfit;
   
   int buyticket = OrderSend(NULL, OP_BUY, L, Ask, 1000, Ask - S * Point, Bid + T*Point, tradeComment, magicNumber);

   if(!waitForClose && adjustForSlippage)
   {
      obtainOrderParameters(buyticket);
   }
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> OPEN SELL POSITION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
void openSellPos()
{
   double S = calculateStopLoss(2);
   double L = calculateLotSize(S);
   double T = fixedTakeProfit;
   
   int sellticket = OrderSend(NULL, OP_SELL, L, Bid, 1000, Bid + S*Point, Bid - T*Point, tradeComment, magicNumber);

   if(!waitForClose && adjustForSlippage)
   {
      obtainOrderParameters(sellticket);
   }
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> USE RANGE OR FIXED STOP <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
double calculateStopLoss(int posType)
{
   double stopToUse = 0;
   double sizeOfRange = ((range.highOfRange - range.lowOfRange) / Point);
   double minStopDist = SymbolInfoInteger(NULL, SYMBOL_TRADE_STOPS_LEVEL);
   
   if(stopTypeInp == 1)
   {
      if(waitForClose)
      {
         if(posType == 1)
         {
         stopToUse = ((Ask - range.lowOfRange)* rangeStopMult) / Point;
         }
         if(posType == 2)
         {
            stopToUse = ((range.highOfRange - Bid)* rangeStopMult) / Point;
         }
      }
      else{stopToUse = (sizeOfRange + (rangeBuffer*Point)) * rangeStopMult;}
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
   double lotToUse = 0;
   double contractSize = (SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE));
   
   if(lotTypeInp == 1 && fixedLotSize > 0)
   {
      lotToUse = fixedLotSize;
   }

   if(lotTypeInp == 0 && percentLot > 0)
   {
      double nTickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
      double nTickSize  = MarketInfo(_Symbol, MODE_TICKSIZE);

      // If the digits are 3 or 5, we normalize multiplying by 10.
      if ((Digits == 3) || (Digits == 5))
      {
         nTickValue = nTickValue * 1;
      }
      lotToUse = (AccountBalance() * percentLot / 100) / (SL * nTickValue);
      lotToUse = MathRound(lotToUse / MarketInfo(Symbol(), MODE_LOTSTEP)) * MarketInfo(Symbol(), MODE_LOTSTEP);
      
      if(lotToUse > maxLotSize)
      {
         lotToUse = maxLotSize;
      }
   }
   return lotToUse;
}
