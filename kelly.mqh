//+------------------------------------------------------------------+
//|                                                        kelly.mqh |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"

#include <Trade\DealInfo.mqh>
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
/*
double kellyR(double size){
   if(TesterStatistics(STAT_PROFIT)<0){
      return 0;
   }
   double p;
   double rl;
   double rw;
   double f;
   p=double(TesterStatistics(STAT_PROFIT_TRADES))/double(TesterStatistics(STAT_TRADES));
   Print("p ",p);
   rl=-TesterStatistics(STAT_GROSS_LOSS)/double(TesterStatistics(STAT_LOSS_TRADES))/500;
   rw=TesterStatistics(STAT_GROSS_PROFIT)/double(TesterStatistics(STAT_PROFIT_TRADES))/500;
   f=p/rl-(1-p)/rw;
   return (p*log(1+f*rw)+(1-p)*log(1-f*rl))*TesterStatistics(STAT_TRADES);
}
*/
double gPrime(double f,const double& r[]){
   double sum=0;
   for(int i=0;i<ArraySize(r);i++){
      sum+=r[i]/(1+r[i]*f);
   }
   return sum;
}

double g(double f,const double& r[] ){
   double sum=0;
   for(int i=0;i<ArraySize(r);i++){
      sum+=log(1+f*r[i]);
   }
   return sum;
}

double iEnd=100;

double kellyREmpirical(double loss){   
   //get pl
   HistorySelect(0,TimeCurrent());
   CDealInfo  deal;
   double r[];
   ArrayResize(r,TesterStatistics(STAT_TRADES));
   int j=0;
   for(int i=1;i<HistoryDealsTotal();i++){
      deal.SelectByIndex(i);
      if(deal.Entry()==DEAL_ENTRY_OUT){
         r[j]=deal.Profit()/loss;
         j++;
      }
   }
   //solve opt f
   double gap=.001;
   double i=gap;
   double f=0;
   while(i<iEnd){
      if(gPrime(i,r)<0){
         f=i-gap;
         break;
      }
      i+=gap;
   }
   Print("f ",f);
   deal.SelectByIndex(0);
   datetime start=deal.Time();
   deal.SelectByIndex(HistoryDealsTotal()-1);
   datetime end=deal.Time();
   if(start==end){return 0;}
   return g(f,r)*MathPow(10,10)/(end-start);
}


double kellyFEmpirical(double loss){   
   //get pl
   HistorySelect(0,TimeCurrent());
   CDealInfo  deal;
   double r[];
   ArrayResize(r,TesterStatistics(STAT_TRADES));
   int j=0;
   for(int i=1;i<HistoryDealsTotal();i++){
      deal.SelectByIndex(i);
      if(deal.Entry()==DEAL_ENTRY_OUT){
         r[j]=deal.Profit()/loss;
         j++;
      }
   }
   //solve opt f
   double gap=.001;
   double i=gap;
   double f=0;
   while(i<iEnd){
      if(gPrime(i,r)<0){
         f=i-gap;
         break;
      }
      i+=gap;
   }
   return f;
}