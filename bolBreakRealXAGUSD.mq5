input int PERIOD=56;
input double RATIO=5;
input int LONGP=10;
input double SL=.5;
input double TP=1.5;
input bool LONG=1;
input bool SLLONG=1;
input bool test=0;
input double weight=.1;
input int magic=1401080145;
input double f=.037;
#include <xsw\ea\bolBreak.mqh>
bolBreak a;
int OnInit()
  {
//---
   a.init(PERIOD,LONGP,RATIO,SL,TP,LONG,SLLONG,test,0,f,magic,weight);
   
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
   a.OnTick();
  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=a.onTest();
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
