//+------------------------------------------------------------------+
//|                                                bolSingleTest.mq5 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Expert\my\bol.mqh>
#include <optCriteria\kelly.mqh>

input   int PERIOD=33;
input   double RATIO=2.8;
input   double SL=.5;
input   double TP=1.5;
input   bool TESTMODE=false;
input   double LONGP=10;
input   int CONSECUTIVE=1;
input   double LOSS=500;
input   bool ALLOWLONGMA=true;
input   bool ALLOWSLWITHLONGMA=true;
input   bool ALLOWWITHIN=false;
input   bool ALLOWTRAILINGTP=true;
input   bool ALLOWCONSECUTIVEORDER=true;
input   bool ALLOWMONDAY=true;
input   bool ALLOWMONDAYOPENBREAK=false;
input   double WEIGHT=1;
input   double F=1.38;
 input  int MASHIFT=2;
input   int SDSHIFT=2;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
bol a;
int OnInit()
  {
//---
   a.initialize(Symbol(),Period(),2013122614021,
                                 PERIOD,
                                 RATIO,
                                 SL,
                                 TP,
                                 TESTMODE,
                                 LONGP,
                                 CONSECUTIVE,
                                 LOSS,
                                 ALLOWLONGMA,
                                 ALLOWSLWITHLONGMA,
                                 ALLOWWITHIN,
                                 ALLOWTRAILINGTP,
                                 ALLOWCONSECUTIVEORDER,
                                 ALLOWMONDAY,
                                 ALLOWMONDAYOPENBREAK,
                                 WEIGHT,
                                 F,
                                 MASHIFT,
                                 SDSHIFT);
                                 
   //a.setTest();                             
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Print("f ",kellyFEmpirical(LOSS));
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
   double ret=0.0;
//---

//---
   return kellyREmpirical(LOSS);
  }
//+------------------------------------------------------------------+
