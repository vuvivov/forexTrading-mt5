input int PERIOD=33;
input double RATIO=2.8;
input int LONGP=10;
input double SL=.5;
input double TP=1.5;
input bool LONG=1;
input bool SLLONG=1;
input bool test=0;
input double weight=.1;
input int magic=1401080145;
input double f=1.117;
#include <xsw\ea\bolBreak.mqh>
bolBreak* a;
int OnInit()
  {
//---
   a=new bolBreak(PERIOD,LONGP,RATIO,SL,TP,LONG,SLLONG,
      Symbol(),Period(),0,false,false,weight,f,magic);
   
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
   double ret=a.OnTester();
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
