
#include <xsw\ea\bolBreak.mqh>

double XAGf=10;
double XAUf=2;

bolBreak* s[5][10];
int a=0;
int b=0;
int OnInit()
  {
//---
   SymbolSelect("EURUSD",1);
   SymbolSelect("XAUUSD",1);
   SymbolSelect("XAGUSD",1);
   SymbolSelect("USDDKK",1);
   SymbolSelect("USDCHF",1);
   
   
   s[a][b]=new bolBreak(24,10,3.6,.54,1.63,1,1,
   "USDDKK",PERIOD_H1,0,0,1,0,1,.379,a*10+b);
   b++;
   s[a][b]=new bolBreak(25,10,5.2,.71,1.68,1,1,
   "USDDKK",PERIOD_H1,0,0,1,0,1,.963,a*10+b);
   b++;
   s[a][b]=new bolBreak(24,10,3.9,.47,1.64,1,1,
   "USDDKK",PERIOD_H1,0,0,1,0,1,.359,a*10+b);
   b++;
   s[a][b]=new bolBreak(24,10,3.5,.72,1.57,1,1,
   "USDDKK",PERIOD_H1,0,0,1,0,1,.499,a*10+b);
   b++;
   s[a][b]=new bolBreak(24,10,3.7,.72,1.64,1,1,
   "USDDKK",PERIOD_H1,0,0,1,0,1,.463,a*10+b);
   b++;
   s[a][b]=new bolBreak(23,10,5,.72,1.43,1,1,
   "USDDKK",PERIOD_H1,0,0,1,0,1,.956,a*10+b);
   b++;
   s[a][b]=new bolBreak(24,10,3.8,.67,1.57,1,1,
   "USDDKK",PERIOD_H1,0,0,1,0,1,.401,a*10+b);
   b++;
   s[a][b]=new bolBreak(25,10,3.4,.67,1.64,1,1,
   "USDDKK",PERIOD_H1,0,0,1,0,1,.344,a*10+b);
   b++;
   s[a][b]=new bolBreak(24,10,3.4,.48,1.44,1,1,
   "USDDKK",PERIOD_H1,0,0,1,0,1,.307,a*10+b);
   b++;
   s[a][b]=new bolBreak(26,10,5.3,.7,1.38,1,1,
   "USDDKK",PERIOD_H1,0,0,1,0,1,1.007,a*10+b);
   b++;
   
   a++;
   b=0;
   s[a][b]=new bolBreak(33,10,2.7,.63,1.57,1,1,
   "XAUUSD",PERIOD_H1,0,0,1,0,5,XAUf*1.466,a*10+b);
   b++;
   s[a][b]=new bolBreak(40,10,2.8,.63,1.53,1,1,
   "XAUUSD",PERIOD_H1,0,0,1,0,5,XAUf*1.619,a*10+b);
   b++;
   s[a][b]=new bolBreak(47,10,2.9,.62,1.64,1,1,
   "XAUUSD",PERIOD_H1,0,0,1,0,5,XAUf*1.582,a*10+b);
   b++;
   s[a][b]=new bolBreak(39,10,2.8,.63,1.56,1,1,
   "XAUUSD",PERIOD_H1,0,0,1,0,5,XAUf*1.6,a*10+b);
   b++;
   s[a][b]=new bolBreak(46,10,2.9,.67,1.62,1,1,
   "XAUUSD",PERIOD_H1,0,0,1,0,5,XAUf*1.67,a*10+b);
   b++;
   s[a][b]=new bolBreak(32,10,2.5,.61,1.61,1,1,
   "XAUUSD",PERIOD_H1,0,0,1,0,5,XAUf*1.268,a*10+b);
   b++;
   s[a][b]=new bolBreak(45,10,2.9,.49,1.58,1,1,
   "XAUUSD",PERIOD_H1,0,0,1,0,5,XAUf*1.39,a*10+b);
   b++;
   s[a][b]=new bolBreak(32,10,2.7,.67,1.62,1,1,
   "XAUUSD",PERIOD_H1,0,0,1,0,5,XAUf*1.467,a*10+b);
   b++;
   s[a][b]=new bolBreak(32,10,2.8,.61,1.55,1,1,
   "XAUUSD",PERIOD_H1,0,0,1,0,5,XAUf*1.532,a*10+b);
   b++;
   s[a][b]=new bolBreak(32,10,2.6,.67,1.54,1,1,
   "XAUUSD",PERIOD_H1,0,0,1,0,5,XAUf*1.398,a*10+b);
   b++;
 
   
   a++;
   b=0;
   s[a][b]=new bolBreak(56,10,2.6,.59,1.93,1,1,
   "XAGUSD",PERIOD_H1,0,0,1,0,.1,XAGf*.039,a*10+b);
   b++;
   s[a][b]=new bolBreak(44,10,2.8,.6,1.6,1,1,
   "XAGUSD",PERIOD_H1,0,0,1,0,.1,XAGf*0.034,a*10+b);
   b++;
   s[a][b]=new bolBreak(66,10,3,.58,1.77,1,1,
   "XAGUSD",PERIOD_H1,0,0,1,0,.1,XAGf*0.056,a*10+b);
   b++;
   s[a][b]=new bolBreak(62,10,3.1,.6,1.6,1,1,
   "XAGUSD",PERIOD_H1,0,0,1,0,.1,XAGf*0.06,a*10+b);
   b++;
   s[a][b]=new bolBreak(53,10,2.7,.6,1.6,1,1,
   "XAGUSD",PERIOD_H1,0,0,1,0,.1,XAGf*0.042,a*10+b);
   b++;
   s[a][b]=new bolBreak(57,10,2.6,.6,1.6,1,1,
   "XAGUSD",PERIOD_H1,0,0,1,0,.1,XAGf*.044,a*10+b);
   b++;
   s[a][b]=new bolBreak(70,10,3.1,.6,1.6,1,1,
   "XAGUSD",PERIOD_H1,0,0,1,0,.1,XAGf*.059,a*10+b);
   b++;
   s[a][b]=new bolBreak(43,10,2.8,.6,1.6,1,1,
   "XAGUSD",PERIOD_H1,0,0,1,0,.1,XAGf*.03,a*10+b);
   b++;
   s[a][b]=new bolBreak(67,10,3.2,.6,1.6,1,1,
   "XAGUSD",PERIOD_H1,0,0,1,0,.1,XAGf*.066,a*10+b);
   b++;
   s[a][b]=new bolBreak(50,10,2.7,.6,1.6,1,1,
   "XAGUSD",PERIOD_H1,0,0,1,0,.1,XAGf*.038,a*10+b);
   b++;
   
   a++;
   b=0;
   s[a][b]=new bolBreak(25,10,3.9,.53,1.64,1,1,
   "EURUSD",PERIOD_H1,0,0,1,0,1,0.277,a*10+b);
   b++;
   s[a][b]=new bolBreak(24,10,5,.42,1.44,1,1,
   "EURUSD",PERIOD_H1,0,0,1,0,1,0.473,a*10+b);
   b++;
   s[a][b]=new bolBreak(64,10,3.2,.63,1.51,1,1,
   "EURUSD",PERIOD_H1,0,0,1,0,1,0.374,a*10+b);
   b++;
   s[a][b]=new bolBreak(24,10,3.9,.43,1.43,1,1,
   "EURUSD",PERIOD_H1,0,0,1,0,1,0.261,a*10+b);
   b++;
   s[a][b]=new bolBreak(25,10,4.1,.61,1.64,1,1,
   "EURUSD",PERIOD_H1,0,0,1,0,1,0.307,a*10+b);
   b++;
   s[a][b]=new bolBreak(23,10,5,.62,1.65,1,1,
   "EURUSD",PERIOD_H1,0,0,1,0,1,0.488,a*10+b);
   b++;
   s[a][b]=new bolBreak(24,10,4,.44,1.64,1,1,
   "EURUSD",PERIOD_H1,0,0,1,0,1,0.238,a*10+b);
   b++;
   s[a][b]=new bolBreak(24,10,4.1,.6,1.42,1,1,
   "EURUSD",PERIOD_H1,0,0,1,0,1,0.345,a*10+b);
   b++;
   s[a][b]=new bolBreak(23,10,4.9,.62,1.4,1,1,
   "EURUSD",PERIOD_H1,0,0,1,0,1,0.533,a*10+b);
   b++;
   s[a][b]=new bolBreak(60,10,3.1,.65,1.53,1,1,
   "EURUSD",PERIOD_H1,0,0,1,0,1,0.385,a*10+b);
   b++;
   
   a++;
   b=0;
   s[a][b]=new bolBreak(27,10,6.5,.44,1.99,1,1,
   "USDCHF",PERIOD_H1,0,0,1,0,1,0.609,a*10+b);
   b++;
   s[a][b]=new bolBreak(24,10,6.4,.67,1.99,1,1,
   "USDCHF",PERIOD_H1,0,0,1,0,1,0.647,a*10+b);
   b++;
   s[a][b]=new bolBreak(28,10,4.6,.45,1.72,1,1,
   "USDCHF",PERIOD_H1,0,0,1,0,1,0.265,a*10+b);
   b++;
   s[a][b]=new bolBreak(42,10,4.8,.65,1.4,1,1,
   "USDCHF",PERIOD_H1,0,0,1,0,1,0.453,a*10+b);
   b++;
   s[a][b]=new bolBreak(52,10,5.7,.36,1.38,1,1,
   "USDCHF",PERIOD_H1,0,0,1,0,1,1.086,a*10+b);
   b++;
   s[a][b]=new bolBreak(27,10,6.7,.43,1.99,1,1,
   "USDCHF",PERIOD_H1,0,0,1,0,1,0.61,a*10+b);
   b++;
   s[a][b]=new bolBreak(28,10,6.2,.67,2.02,1,1,
   "USDCHF",PERIOD_H1,0,0,1,0,1,0.682,a*10+b);
   b++;
   s[a][b]=new bolBreak(27,10,6.6,.45,1.73,1,1,
   "USDCHF",PERIOD_H1,0,0,1,0,1,0.658,a*10+b);
   b++;
   s[a][b]=new bolBreak(27,10,6.4,.67,2,1,1,
   "USDCHF",PERIOD_H1,0,0,1,0,1,0.719,a*10+b);
   b++;
   s[a][b]=new bolBreak(22,10,6.4,.67,2.03,1,1,
   "USDCHF",PERIOD_H1,0,0,1,0,1,0.638,a*10+b);
   b++;
       
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
      int m=ArrayRange(s,0);
   int n=ArrayRange(s,1);
   for(int i=0;i<m;i++){
      for(int j=0;j<n;j++){
         delete s[i][j];
      }
   }
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   int m=ArrayRange(s,0);
   int n=ArrayRange(s,1);
   for(int i=0;i<m;i++){
      for(int j=0;j<n;j++){
         s[i][j].OnTick();
      }
   }
   
  }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---
      int m=ArrayRange(s,0);
   int n=ArrayRange(s,1);
   for(int i=0;i<m;i++){
      for(int j=0;j<n;j++){
         s[i][j].OnTrade();
      }
   }
 
  }
//+------------------------------------------------------------------+


double OnTester(){
   return s[0][0].OnTester();
}

