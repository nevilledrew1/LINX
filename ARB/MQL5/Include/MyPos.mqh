//+------------------------------------------------------------------+
//|                                               LRB-MyPosTotal.mqh |
//|                              Copyright 2023, Linx Trading Co LLC |
//|                                    https://www.linxtradingco.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Linx Trading Co LLC"
#property link      "https://www.linxtradingco.com"

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> MY POSITIONS TOTAL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
int myPositionsTotal()
{
   int      count                = 0;
   uint     totalPos             = PositionsTotal();
   ulong    ticketNumber         = 0;
   string   symbol               = "";
   long     magic                = 0;
   
   for(uint i = 0; i<totalPos; ++i)
   {
      if((ticketNumber = PositionGetTicket(i)) > 0)
      {
         symbol         = PositionGetString(POSITION_SYMBOL);
         magic          = PositionGetInteger(POSITION_MAGIC);
         
         if(orderIsMine(symbol, magic))
         {
            ++count;
         }
      }
   }
   return count;
}

// ===============================================================================================      
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ORDER IS MINE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// ===============================================================================================
bool orderIsMine(string symbol, long magic)
{
   return (MQLInfoInteger(MQL_TESTER) || (symbol == _Symbol && magic == magicNumber));
}
