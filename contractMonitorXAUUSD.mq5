//+------------------------------------------------------------------+
//|                                              contractMonitor.mq5 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
double point=.001;
double tickValue=1;

int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   string m;
   if(SymbolInfoDouble(Symbol(),SYMBOL_POINT)!=point){
      m=Symbol()+"point not match";
      SendNotification(m);
      Alert(m);
   }
   if(SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_VALUE)!=tickValue){
      m=Symbol()+"tickValue not match";
      SendNotification(m);
      Alert(m);
   }
  }
//+------------------------------------------------------------------+
