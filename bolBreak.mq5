input int PERIOD=23;
input double RATIO=5;
input int LONGP=10;
input double SL=.5;
input double TP=1.5;
input bool LONG=1;
input bool SLLONG=1;
input bool test=true;
input double weight=1;
input double f=.28;
int magic=0;
#include <xsw\ea\bolBreak.mqh>
bolBreak* a;
int OnInit()
  {
//---
   a=new bolBreak(PERIOD,LONGP,RATIO,SL,TP,LONG,SLLONG,
      Symbol(),Period(),0,false,test,false,weight,f,magic);
      
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   delete a;
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
void OnTrade(){
   a.OnTrade();
}