#include <xsw\stack.mqh>
#include <xsw\ea\bolBreak.mqh>

double XAGf=10;
double XAUf=2;

stack* s;
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
   s=new stack(5);
   
   s.EAs[a][b]=new bolBreak(24,10,3.6,.48,1.64,1,1,
   "USDDKK",PERIOD_H1,0,0,false,1,1,.35,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(25,10,5.2,.71,1.42,1,1,
   "USDDKK",PERIOD_H1,0,0,false,1,1,1.059,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(24,10,3.9,.48,1.6,1,1,
   "USDDKK",PERIOD_H1,0,0,false,1,1,.388,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(24,10,3.5,.48,1.63,1,1,
   "USDDKK",PERIOD_H1,0,0,false,1,1,.333,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(24,10,3.7,.54,1.62,1,1,
   "USDDKK",PERIOD_H1,0,0,false,1,1,.36,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(23,10,5,.71,1.38,1,1,
   "USDDKK",PERIOD_H1,0,0,false,1,1,.946,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(24,10,3.8,.51,1.6,1,1,
   "USDDKK",PERIOD_H1,0,0,false,1,1,.352,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(25,10,3.4,.72,1.55,1,1,
   "USDDKK",PERIOD_H1,0,0,false,1,1,.465,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(24,10,3.4,.54,1.6,1,1,
   "USDDKK",PERIOD_H1,0,0,false,1,1,.32,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(26,10,5.3,.71,1.69,1,1,
   "USDDKK",PERIOD_H1,0,0,false,1,1,1.052,a*10+b);
   b++;
   
   a++;
   b=0;
   s.EAs[a][b]=new bolBreak(33,10,2.7,.61,1.57,1,1,
   "XAUUSD",PERIOD_H1,0,0,false,1,1,XAUf*1.446,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(40,10,2.8,.64,1.55,1,1,
   "XAUUSD",PERIOD_H1,0,0,false,1,1,XAUf*1.678,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(47,10,2.9,.62,1.64,1,1,
   "XAUUSD",PERIOD_H1,0,0,false,1,1,XAUf*1.571,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(39,10,2.8,.64,1.56,1,1,
   "XAUUSD",PERIOD_H1,0,0,false,1,1,XAUf*1.646,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(46,10,2.9,.57,1.59,1,1,
   "XAUUSD",PERIOD_H1,0,0,false,1,1,XAUf*1.504,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(32,10,2.5,.61,1.6,1,1,
   "XAUUSD",PERIOD_H1,0,0,false,1,1,XAUf*1.27,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(45,10,2.9,.57,1.59,1,1,
   "XAUUSD",PERIOD_H1,0,0,false,1,1,XAUf*1.543,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(32,10,2.7,.61,1.57,1,1,
   "XAUUSD",PERIOD_H1,0,0,false,1,1,XAUf*1.496,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(32,10,2.8,.61,1.56,1,1,
   "XAUUSD",PERIOD_H1,0,0,false,1,1,XAUf*1.496,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(32,10,2.6,.61,1.57,1,1,
   "XAUUSD",PERIOD_H1,0,0,false,1,1,XAUf*1.391,a*10+b);
   b++;
 
   
   a++;
   b=0;
   s.EAs[a][b]=new bolBreak(56,10,2.6,.49,1.97,1,1,
   "XAGUSD",PERIOD_H1,0,0,false,1,1,XAGf*.035,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(44,10,2.8,.51,1.91,1,1,
   "XAGUSD",PERIOD_H1,0,0,false,1,1,XAGf*0.033,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(66,10,3,.57,2.05,1,1,
   "XAGUSD",PERIOD_H1,0,0,false,1,1,XAGf*0.05,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(62,10,3.1,.6,1.9,1,1,
   "XAGUSD",PERIOD_H1,0,0,false,1,1,XAGf*0.036,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(53,10,2.7,.47,2.05,1,1,
   "XAGUSD",PERIOD_H1,0,0,false,1,1,XAGf*0.036,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(57,10,2.6,.59,1.96,1,1,
   "XAGUSD",PERIOD_H1,0,0,false,1,1,XAGf*.037,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(70,10,3.1,.58,1.59,1,1,
   "XAGUSD",PERIOD_H1,0,0,false,1,1,XAGf*.063,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(43,10,2.8,.51,2,1,1,
   "XAGUSD",PERIOD_H1,0,0,false,1,1,XAGf*.034,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(67,10,3.2,.58,1.6,1,1,
   "XAGUSD",PERIOD_H1,0,0,false,1,1,XAGf*.064,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(50,10,2.7,.54,1.6,1,1,
   "XAGUSD",PERIOD_H1,0,0,false,1,1,XAGf*.037,a*10+b);
   b++;
   
   a++;
   b=0;
   s.EAs[a][b]=new bolBreak(25,10,3.9,.43,1.42,1,1,
   "EURUSD",PERIOD_H1,0,0,false,1,1,0.297,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(24,10,5,.62,1.65,1,1,
   "EURUSD",PERIOD_H1,0,0,false,1,1,0.515,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(64,10,3.2,.61,1.44,1,1,
   "EURUSD",PERIOD_H1,0,0,false,1,1,0.38,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(24,10,3.9,.54,1.63,1,1,
   "EURUSD",PERIOD_H1,0,0,false,1,1,0.296,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(25,10,4.1,.05,1.48,1,1,
   "EURUSD",PERIOD_H1,0,0,false,1,1,0.277,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(23,10,5,.63,1.65,1,1,
   "EURUSD",PERIOD_H1,0,0,false,1,1,0.484,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(24,10,4,.54,1.63,1,1,
   "EURUSD",PERIOD_H1,0,0,false,1,1,0.306,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(24,10,4.1,.54,1.62,1,1,
   "EURUSD",PERIOD_H1,0,0,false,1,1,0.3,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(23,10,4.9,.62,1.65,1,1,
   "EURUSD",PERIOD_H1,0,0,false,1,1,0.449,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(60,10,3.1,.64,1.56,1,1,
   "EURUSD",PERIOD_H1,0,0,false,1,1,0.391,a*10+b);
   b++;
   
   a++;
   b=0;
   s.EAs[a][b]=new bolBreak(27,10,6.5,.44,1.98,1,1,
   "USDCHF",PERIOD_H1,0,0,false,1,1,0.594,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(24,10,6.4,.67,2,1,1,
   "USDCHF",PERIOD_H1,0,0,false,1,1,0.656,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(28,10,4.6,.45,1.72,1,1,
   "USDCHF",PERIOD_H1,0,0,false,1,1,0.268,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(42,10,4.8,.65,1.4,1,1,
   "USDCHF",PERIOD_H1,0,0,false,1,1,0.401,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(52,10,5.7,.36,1.4,1,1,
   "USDCHF",PERIOD_H1,0,0,false,1,1,1.087,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(27,10,6.7,.44,1.97,1,1,
   "USDCHF",PERIOD_H1,0,0,false,1,1,0.603,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(28,10,6.2,.67,2,1,1,
   "USDCHF",PERIOD_H1,0,0,false,1,1,0.67,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(27,10,6.6,.44,1.98,1,1,
   "USDCHF",PERIOD_H1,0,0,false,1,1,0.625,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(27,10,6.4,.45,1.98,1,1,
   "USDCHF",PERIOD_H1,0,0,false,1,1,0.547,a*10+b);
   b++;
   s.EAs[a][b]=new bolBreak(22,10,6.4,.67,2.04,1,1,
   "USDCHF",PERIOD_H1,0,0,false,1,1,0.648,a*10+b);
   b++;
                  
   s.initWeight();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   delete s;
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   s.OnTick();
  }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---
   s.OnTrade();
  }
//+------------------------------------------------------------------+
