//+------------------------------------------------------------------+
//|                                                bolBreakMulti.mq5 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <xsw\ea\bolBreak.mqh>
 int PERIOD=23;
 int LONGP=10;
 double RATIO=4.9;
input double SL=.5;
input double TP=1.5;
input bool LONG=1;
input bool SLLONG=1;
input bool test=1;
input double weight=.1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
bolBreak a[3];
int OnInit()
  {
//---
   a[0].init(PERIOD,LONGP,RATIO,SL,TP,LONG,SLLONG,test,0,.28,1,weight);
   PERIOD=25;RATIO=3.8;
   a[1].init(PERIOD,LONGP,RATIO,SL,TP,LONG,SLLONG,test,0,.28,2,weight);
   PERIOD=60;RATIO=3.1;
   a[2].init(PERIOD,LONGP,RATIO,SL,TP,LONG,SLLONG,test,0,.28,3,weight);
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
   for(int i=0;i<ArraySize(a);i++){
      a[i].OnTick();
   }
  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=a[1].onTest();
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
