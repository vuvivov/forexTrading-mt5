//+------------------------------------------------------------------+
//|                                                     myExpert.mqh |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//~~~ whileEnd++++++
#define whileEnd 1

#include <Expert\Expert.mqh>
#include <Arrays\ArrayObj.mqh>
#include <Files\FileBin.mqh>
#include <Trade\Trade.mqh>
#include <Trade\HistoryOrderInfo.mqh>
#include <Expert\Trailing\TrailingNone.mqh>
#include <Expert\myMoney.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class arrayForStore: public CArrayObj{
   protected:
      string fileName;  
      CFileBin file;   
   public:
      arrayForStore(string _fileName);
      bool Save();
      bool Load();
      
};

arrayForStore::arrayForStore(string _fileName):fileName(_fileName){ 
}

bool arrayForStore::Save(){
   file.Open(fileName,FILE_BIN|FILE_WRITE);
   bool result=true;
   for(int i=0;i<Total();i++){
      result=At(i).Save(file.Handle());
      if(!result){
         break;
      }
   }
   file.Close();
   return result;
}

bool arrayForStore::Load(void){
   file.Open(fileName,FILE_BIN|FILE_READ);
   bool result=true;
   for(int i=0;i<Total();i++){
      result=At(i).Load(file.Handle());
      if(!result){
         break;
      }
   }
   file.Close();
   return result;
}



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class storeDouble: public CObject{
   protected:
      double a;
      arrayForStore* arrayBelongTo;
      
   public:
      virtual bool      Save(const int file_handle);
      virtual bool      Load(const int file_handle);
      void set(double _a);
      double get(){return a;};
      storeDouble(arrayForStore* _array):arrayBelongTo(_array){_array.Add(GetPointer(this));};
};

bool storeDouble::Save(const int file_handle){
   return FileWriteDouble(file_handle,a);
}

bool storeDouble::Load(const int file_handle){
   a=FileReadDouble(file_handle);
   return true;
}

void storeDouble::set(double _a){
   a=_a;
   arrayBelongTo.Save();
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


class myExpert : public CExpert
  {
protected:
   arrayForStore* stores;
   CHistoryOrderInfo hist;
   double            loss;
   double            weight;
   double            f;
   bool              testMode;
   kellyMoney*        money;
   
   string storeFileName();
   void initStore();
   
   //functions to specify for diff experts:
   virtual string uniqueNameForStore(){return "a";};
   virtual void initStores(){};
   virtual void initIndicators(){};
   virtual void initDefaultPara(){};
   virtual void initMoney(){money=new kellyMoney(m_symbol.Name(), loss,testMode,weight, f);};

   bool execute(ENUM_ORDER_TYPE type,double lot,CArrayLong& id,double price=0);
   bool execute(ENUM_ORDER_TYPE type,double lot,double price=0);
   bool modify(double p,const CArrayLong& id);
   bool Delete( CArrayLong& id);
   bool deleteAll();
   bool buy(double l,double stop=0,double take=0);
   bool sell(double l,double stop=0,double take=0);
public:
   void initialize();                                     
  };
  

string myExpert::storeFileName(void){
   return (IntegerToString(m_magic)+m_symbol.Name()+uniqueNameForStore());
}  

void myExpert::initStore(void){
   stores=new arrayForStore(storeFileName());
}


void myExpert::initialize(void){
   //initDefaultPara();
   initStore();
   initStores();
   initIndicators();
   initMoney();
   InitIndicators();
}


bool myExpert::execute(ENUM_ORDER_TYPE type,double lot,CArrayLong& id,double price=0){
   bool result=false;
   bool read=false;
   int total=OrdersTotal();
   double margin=m_account.Margin();
   //int count=0;
   while(m_symbol.LotsMin()<=lot){//&&count<whileEnd){
      //count++;
      if(type==ORDER_TYPE_BUY){
         read=m_trade.Buy(MathMin(m_symbol.LotsMax(),lot),m_symbol.Name());
      }
      if(type==ORDER_TYPE_SELL){
         read=m_trade.Sell(MathMin(m_symbol.LotsMax(),lot),m_symbol.Name());
      }
      if(type==ORDER_TYPE_BUY_LIMIT){
         read=m_trade.BuyLimit(MathMin(m_symbol.LotsMax(),lot),price,m_symbol.Name());
      }
      if(type==ORDER_TYPE_BUY_STOP){
         read=m_trade.BuyStop(MathMin(m_symbol.LotsMax(),lot),price,m_symbol.Name());
      }
      if(type==ORDER_TYPE_SELL_LIMIT){
         read=m_trade.SellLimit(MathMin(m_symbol.LotsMax(),lot),price,m_symbol.Name());
      }
      if(type==ORDER_TYPE_SELL_STOP){
         read=m_trade.SellStop(MathMin(m_symbol.LotsMax(),lot),price,m_symbol.Name()); 
      }
      
      int countRead=0;
      while(!read&&countRead<5000){
         Sleep(1);
         countRead++;
      }
      if(!read){
         Print(222);
         return false;
      }
      if(m_trade.ResultRetcode()==TRADE_RETCODE_DONE){
         lot-=m_trade.ResultVolume();
         if(type!=ORDER_TYPE_BUY&&type!=ORDER_TYPE_SELL){
            id.Add(m_trade.ResultOrder());
         }
      }
   }
   
   if(m_symbol.LotsMin()>lot){
      result=true;
   }
   return result;
}


bool myExpert::execute(ENUM_ORDER_TYPE type,double lot,double price=0.000000){
   bool result=false;
   bool read=false;
   int total=OrdersTotal();
   double margin=m_account.Margin();
   int count=0;
   while(m_symbol.LotsMin()<=lot&&count<whileEnd){
      count++;
      Print(count);
      if(type==ORDER_TYPE_BUY){
         read=m_trade.Buy(MathMin(m_symbol.LotsMax(),lot),m_symbol.Name());
      }
      if(type==ORDER_TYPE_SELL){
         read=m_trade.Sell(MathMin(m_symbol.LotsMax(),lot),m_symbol.Name());
      }
      if(type==ORDER_TYPE_BUY_LIMIT){
         read=m_trade.BuyLimit(MathMin(m_symbol.LotsMax(),lot),price,m_symbol.Name());
      }
      if(type==ORDER_TYPE_BUY_STOP){
         read=m_trade.BuyStop(MathMin(m_symbol.LotsMax(),lot),price,m_symbol.Name());
      }
      if(type==ORDER_TYPE_SELL_LIMIT){
         read=m_trade.SellLimit(MathMin(m_symbol.LotsMax(),lot),price,m_symbol.Name());
      }
      if(type==ORDER_TYPE_SELL_STOP){
         read=m_trade.SellStop(MathMin(m_symbol.LotsMax(),lot),price,m_symbol.Name()); 
      }
      
      int countRead=0;
      while(!read&&countRead<5000){
         Sleep(1);
         countRead++;
      }
      if(!read){
         Print(222);
         return false;
      }
      if(m_trade.ResultRetcode()==TRADE_RETCODE_DONE){
         lot-=m_trade.ResultVolume();
         if(type!=ORDER_TYPE_BUY&&type!=ORDER_TYPE_SELL){
            //id.Add(m_trade.ResultOrder());
         }
      }
   }
   
   if(m_symbol.LotsMin()>lot){
      result=true;
   }
   return result;
}



bool myExpert::buy(double l,double stop=0,double take=0){
         bool fill=false;
         if(execute(ORDER_TYPE_SELL_STOP,l,stop) && 
            execute(ORDER_TYPE_SELL_LIMIT,l,take))
           {
            fill=true;
            if(!execute(ORDER_TYPE_BUY,l))
              {
               fill=false;
              }
           }
         if(!fill)
           {
            deleteAll();
           }
         return fill;
}

bool myExpert::sell(double l,double stop=0,double take=0){
         bool fill=false;
         if(execute(ORDER_TYPE_BUY_STOP,l,stop) && 
            execute(ORDER_TYPE_BUY_LIMIT,l,take))
           {
            fill=true;
            if(!execute(ORDER_TYPE_SELL,l))
              {
               fill=false;
              }
           }
         if(!fill)
           {
            deleteAll();
           }
         return fill;
}

bool myExpert::modify(double p,const CArrayLong& id){
   bool result=true;
   for(int i=0;i<id.Total();i++){
      m_order.Select(id[i]);
      m_trade.OrderModify(id[i],p,m_order.StopLoss(),m_order.TakeProfit(),m_order.TypeTime(),m_order.TimeExpiration());
      if(m_order.PriceOpen()!=p){
         result=false;
      }
   }
   return result;   
};

bool myExpert::Delete( CArrayLong& id){
   bool result=true;
   for(int i=0;i<id.Total();i++){
      m_trade.OrderDelete(id[i]);
      m_order.Select(id[i]);
      if(m_order.State()!=ORDER_STATE_CANCELED){
         result=false;
      }
   }
   id.Shutdown();
   return result;
};

bool myExpert::deleteAll(void){
   bool result=true;
   for(int i=0;i<OrdersTotal();i++){
      m_order.Select(i);
      if(m_order.Magic()==m_magic && m_order.Symbol()==m_symbol.Name()){
         m_trade.OrderDelete(m_order.Ticket());
         if(m_order.State()!=ORDER_STATE_CANCELED){
            result=false;
         }
      }
   }
   return result;
}