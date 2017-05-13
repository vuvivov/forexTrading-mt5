//+------------------------------------------------------------------+
//|                                                       pinger.mq5 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
MqlTick tick;

void OnStart()
  {
//---
   int t=GetTickCount();
   SymbolInfoTick("XAUUSD",tick);
   Print("tick ",tick.ask);
   Print(GetTickCount()-t);
   
   t=GetTickCount();
   SymbolInfoTick("AUDUSD",tick);
   Print("tick ",tick.ask);
   Print(GetTickCount()-t);
  }
//+------------------------------------------------------------------+
