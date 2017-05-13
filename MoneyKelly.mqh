//+------------------------------------------------------------------+
//|                                                        kelly.mqh |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"

#include <Expert\ExpertMoney.mqh>

class fixedLoss: public CExpertMoney{
   public:
      virtual double lot(int type,double sl);
      void initialize(double l){loss=l;}
   protected:
      double loss;
};

double fixedLoss::lot(int type,double sl){
   double lot;
   if(type==1){
      lot=SymbolInfoDouble(m_symbol.Name(),SYMBOL_ASK);
   }
   if(type==-1){
      lot=SymbolInfoDouble(m_symbol.Name(),SYMBOL_BID);
   }
   else{
      return 0;
   }
   
   lot=MathAbs(lot-sl);
   lot/=SymbolInfoDouble(m_symbol.Name(),SYMBOL_POINT);
   lot*=SymbolInfoDouble(m_symbol.Name(),SYMBOL_TRADE_TICK_VALUE);
   return (loss/lot);  
}



/////////////////////////////////////////////////////////////////////////////////////////////////////
class kellySimu: public fixedLoss{
   public:
      double lot(int type,double sl);
      kellySimu(double p,double l,double i,double s,double w);
   protected:
      double init;
      double size;
      double weight;
      
};

kellySimu::kellySimu(double p,double l,double i,double s,double w):
init(i),size(s),weight(w)
{
   Percent(p);
   fixedLoss::initialize(l);
};


double kellySimu::lot(int type,double sl){
   return (AccountInfoDouble(ACCOUNT_EQUITY)/init*size*weight*fixedLoss::lot(type,sl));
}

