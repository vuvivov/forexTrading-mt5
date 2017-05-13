//+------------------------------------------------------------------+
//|                                             bolMultiParaSets.mq5 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Expert\my\bol.mqh>
#include <optCriteria\kelly.mqh>

input   bool ALLOWLONGMA=true;
input   bool ALLOWSLWITHLONGMA=true;
input   bool ALLOWWITHIN=false;
input   bool ALLOWTRAILINGTP=false;
input   bool ALLOWCONSECUTIVEORDER=true;
input   bool ALLOWMONDAY=true;
input   bool ALLOWMONDAYOPENBREAK=false;

bol a[5];
double loss=500;
int OnInit()
  {
//---
   a[0].initialize(Symbol(),Period(),2013122614021,
                                 24,
                                 5,
                                 .5,
                                 1.5,
                                 
                                 1,
                                 10,
                                 1,
                                 loss,
                                 ALLOWLONGMA,
ALLOWSLWITHLONGMA,
ALLOWWITHIN,
 ALLOWTRAILINGTP,
 ALLOWCONSECUTIVEORDER,
 ALLOWMONDAY,
 ALLOWMONDAYOPENBREAK,
                                 1,
                                 .222,
                                 2,
                                 2);
   a[1].initialize(Symbol(),Period(),2013122614022,
                                 23,
                                 5,
                                 .5,
                                 1.5,
                                
                                 1,
                                 10,
                                 1,
                                 loss,
                                 ALLOWLONGMA,
ALLOWSLWITHLONGMA,
ALLOWWITHIN,
 ALLOWTRAILINGTP,
 ALLOWCONSECUTIVEORDER,
 ALLOWMONDAY,
 ALLOWMONDAYOPENBREAK,
                                 1,
                                 .207,
                                 2,
                                 2);  
    a[2].initialize(Symbol(),Period(),2013122614021,
                                 25,
                                 3.8,
                                 .5,
                                 1.5,
                                
                                 1,
                                 10,
                                 1,
                                 loss,
                                ALLOWLONGMA,
ALLOWSLWITHLONGMA,
ALLOWWITHIN,
 ALLOWTRAILINGTP,
 ALLOWCONSECUTIVEORDER,
 ALLOWMONDAY,
 ALLOWMONDAYOPENBREAK,
                                 1,
                                 .132,
                                 2,
                                 2);
   a[3].initialize(Symbol(),Period(),2013122614022,
                                 26,
                                 5.2,
                                 .5,
                                 1.5,
                             
                                 1,
                                 10,
                                 1,
                                 loss,
                                 ALLOWLONGMA,
ALLOWSLWITHLONGMA,
ALLOWWITHIN,
 ALLOWTRAILINGTP,
 ALLOWCONSECUTIVEORDER,
 ALLOWMONDAY,
 ALLOWMONDAYOPENBREAK,
                                 1,
                                 .251,
                                 2,
                                 2);  
   a[4].initialize(Symbol(),Period(),2013122614022,
                                 23,
                                 4.8,
                                 .5,
                                 1.5,
                              
                                 1,
                                 10,
                                 1,
                                 loss,
                                 ALLOWLONGMA,
ALLOWSLWITHLONGMA,
ALLOWWITHIN,
 ALLOWTRAILINGTP,
 ALLOWCONSECUTIVEORDER,
 ALLOWMONDAY,
 ALLOWMONDAYOPENBREAK,
                                 1,
                                 .185,
                                 2,
                                 2);                                                             
   //a[0].setTest();  a[1].setTest();                                                       
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Print("f ",kellyFEmpirical(loss));
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
   double ret=0.0;
//---
   return kellyREmpirical(loss)/double(ArraySize(a));
//---
   return(ret);
  }
//+------------------------------------------------------------------+
