//+------------------------------------------------------------------+
//|                                                        kelly.mqh |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"

#include <Expert\ExpertMoney.mqh>

class kellySimu: public CExpertMoney{
   public:
      double lot(double sl,int type=1);
      kellySimu(string _sym,bool t,double p,double l,double i,double s,double w);
      void setFixedLot(double l){fixedLot=l;fixLot=true;};
   protected:
      bool fixLot;
      double fixedLot;
      bool testMode;
      double init;
      double size;
      double weight;
      double loss;
      string sym;
      
      double fixedLoss(double sl,int type=1);
      void setTestMode(){testMode=true;}
      
};

kellySimu::kellySimu(string _sym,bool t,double p,double l,double i,double s,double w):
sym(_sym),testMode(t),init(i),size(s),weight(w),fixLot(false)
{
   Percent(p);
   loss=l;
   Print("test ",t);
};

double kellySimu::fixedLoss(double sl,int type=1){
   double lot;
   if(type!=1&&type!=-1){
      return 0;
   }
   if(type==1){
      lot=SymbolInfoDouble(sym,SYMBOL_ASK);
   }
   if(type==-1){
      lot=SymbolInfoDouble(sym,SYMBOL_BID);
   }
   //Print(" price ",lot);
   lot=MathAbs(lot-sl);
   //Print("sl ",sl," diff ",lot);
   lot/=SymbolInfoDouble(sym,SYMBOL_POINT);
   //Print("/point ",lot);
   lot*=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_VALUE);
   //Print("*value ",lot,"loss ",loss," return ", (lot==0?0:(loss/lot)));
   return (lot==0?0:(loss/lot));  
}


double kellySimu::lot(double sl,int type=1){
   if(fixLot){return fixedLot;}
   
   double fix=fixedLoss( sl,type);
   if(testMode){
      return NormalizeDouble(fix,2);
   }
   return NormalizeDouble((AccountInfoDouble(ACCOUNT_EQUITY)/init*size*weight*fix),2);
}

//-------------------------------------------------------------------------------------------
class kellyMoney: public CExpertMoney{
   protected:
      bool fixLot;
      double fixedLot;
      string sym;
      double loss;
      bool testMode;
      double weight;
      double fixedLoss(double sl,int type=1);
   public:
      kellyMoney(string s, double l,bool t,double w, double f):sym(s),loss(l),testMode(t),weight(w),fixLot(false){Percent(f);};
      double lot(double sl,int type=1);
      void setFixedLot(double l){fixedLot=l;fixLot=true;};
};

double kellyMoney::fixedLoss(double sl,int type=1){
   double lot;
   if(type!=1&&type!=-1){
      return 0;
   }
   if(type==1){
      lot=SymbolInfoDouble(sym,SYMBOL_ASK);
   }
   if(type==-1){
      lot=SymbolInfoDouble(sym,SYMBOL_BID);
   }
   //Print(" price ",lot);
   lot=MathAbs(lot-sl);
   //Print("sl ",sl," diff ",lot);
   lot/=SymbolInfoDouble(sym,SYMBOL_POINT);
   //Print("/point ",lot);
   lot*=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_VALUE);
   //Print("*value ",lot,"loss ",loss," return ", (lot==0?0:(loss/lot)));
   return (lot==0?0:(loss/lot*weight*m_percent));  
}


double kellyMoney::lot(double sl,int type=1){
   if(fixLot){return fixedLot;}
   
   double fix=fixedLoss( sl,type);
   if(testMode){
      return NormalizeDouble(fix,2);
   }
   return NormalizeDouble((AccountInfoDouble(ACCOUNT_EQUITY)/loss*fix),2);
}