#include <Expert\Expert.mqh>
#include <Indicators\Trend.mqh>
#include <Trade\HistoryOrderInfo.mqh>
#include <Files\FileBin.mqh>
#include <optCriteria\kelly.mqh>

class expert:public CExpert{
   protected:
      bool   testMode;
      double f;
      double weight;
      double loss;
      double cutTime;//in seconds
      
      double sl;
      double tp;
      double spread;
      int direction;

      CHistoryOrderInfo hist;
      CFileBin fileBin;
      
      virtual void initIndi(){};
      virtual double stopLoss(){return 0;};
      virtual double ultimateSl(){return 0;}
      virtual double takeProfit(){return 0;};
      virtual int signal(){return 0;};
      virtual void trailing(){};
      virtual void initStore(){};
      virtual void store(){};

      
      double lot(double s=0);
      bool Processing();
      void checkForOpen();
      void deleteAll(datetime t=0);
      int numOpenOrder(datetime t=0);
      bool openOrder(datetime t=0);
      bool orderTypeHomo(datetime t=0);
      void buy();
      void sell();
      void buyEx(double lot);
      void sellEx(double lot);
      void modifyStop(double a);
      void updateSpread();
      void update();
      void timeCut();
      void closePosition();
      bool withIn();
      void openFileBinRead();
      void openFileBinWrite();

   public:
      virtual void init(string sym,ENUM_TIMEFRAMES per,double C=0,bool everyTick=false,bool t=false,double W=1,double F=.2,ulong magic=1);
      virtual void OnTrade();
      double OnTester(bool f=false);
      void setWeight(double w){weight=w;}
};

void expert::init(string sym,ENUM_TIMEFRAMES per,double C=0,bool everyTick=false,bool t=false,double W=1,double F=.2,ulong magic=1){
         testMode=t;
         cutTime=C;
         f=F;
         m_magic=magic;
         weight=W;
         loss=100;
         Init(sym,per,everyTick,magic);
         initStore();
         initIndi();
         InitIndicators();
}

int expert::numOpenOrder(datetime t=0){
   int n=0;
   int e=OrdersTotal();
   for(int i=0;i<e;i++){
      m_order.SelectByIndex(i);
      if(m_order.Magic()==m_magic && m_order.Symbol()==m_symbol.Name()&&m_order.TimeSetup()>t){         
         n++;
      }
   }
   return n;
}

bool expert::openOrder(datetime t=0){
   int n=0;
   int e=OrdersTotal();
   for(int i=0;i<e;i++){
      m_order.SelectByIndex(i);
      if(m_order.Magic()==m_magic && m_order.Symbol()==m_symbol.Name()&&m_order.TimeSetup()>t){
         return true;
      }
   }
   return false;
}

bool expert::orderTypeHomo(datetime t=0){
   ENUM_ORDER_TYPE type;
   if(openOrder(t)){
      type=m_order.OrderType();
   }
   int e=OrdersTotal();
   for(int i=0;i<e;i++){
      m_order.SelectByIndex(i);            
      if(m_order.Magic()==m_magic && m_order.Symbol()==m_symbol.Name()&&m_order.TimeSetup()>t){
         if(type!=m_order.OrderType()){
            return false;
         }
      }
   }   
   return true;
}

bool expert::Processing(void){
   if(!openOrder()){
      checkForOpen();
      return true;
   }
   else{
      trailing();
   }
   return true;
}

void expert::deleteAll(datetime t){
   while(openOrder(t)){
      m_trade.OrderDelete(m_order.Ticket());
   }
}

double expert::lot(double s=0){
   double lot;
   if(s==0){
      s=sl;
   }
   lot=MathAbs(Close(0)-s)+spread;
   lot/=SymbolInfoDouble(m_symbol.Name(),SYMBOL_POINT);
   lot*=SymbolInfoDouble(m_symbol.Name(),SYMBOL_TRADE_TICK_VALUE);
   lot=loss/lot*weight; 
   if(!testMode){    
      lot=f*lot/loss*AccountInfoDouble(ACCOUNT_EQUITY);
   }
   return NormalizeDouble(lot,2);
}

void expert::checkForOpen(void){
   direction=signal();
   if(direction!=0){update();} 
   if(direction==1){ 
         buy();         
      }
   if(direction==-1){
         sell();
      }
}

int done=10009;
void expert::buy(void){
         if((sl>m_symbol.Bid())||(tp<m_symbol.Bid())){return ;}
         double lot=lot(ultimateSl());
         while(lot>0){
            double l=MathMin(lot,m_symbol.LotsMax());
            buyEx(l);
            lot-=l;
         }
}

void expert::buyEx(double lot){
         datetime t=TimeCurrent();
         int order1,order2;
         if(!m_trade.SellStop(lot,sl,m_symbol.Name())){
            deleteAll(t);
            return ;
         }
         else{
            order1=m_trade.ResultOrder();
            if(m_trade.ResultRetcode()!=done){
               m_trade.OrderDelete(order1);
               deleteAll(t);
               return ;
            }
         }
         
         if(!m_trade.SellLimit(lot,tp,m_symbol.Name())){
            m_trade.OrderDelete(order1);
            deleteAll(t);
            return ;
         }
         else{
            order2=m_trade.ResultOrder();
            if(m_trade.ResultRetcode()!=done){
               m_trade.OrderDelete(order1);
               m_trade.OrderDelete(order2);
               deleteAll(t);
               return;
            }
         } 
         
         m_trade.Buy(lot,m_symbol.Name());
         if(m_trade.ResultRetcode()!=done){
               m_trade.OrderDelete(order1);
               m_trade.OrderDelete(order2);
               deleteAll(t);
               return ;
         }
}

void expert::sell(void){
         if((sl<m_symbol.Ask())||(tp>m_symbol.Ask())){return ;}
         double lot=lot(ultimateSl());
         while(lot>0){
            double l=MathMin(lot,m_symbol.LotsMax());
            sellEx(l);
            lot-=l;
         } 
}

void expert::sellEx(double lot){
         datetime t=TimeCurrent();
         int order1,order2;
         if(!m_trade.BuyStop(lot,sl+spread,m_symbol.Name())){
            deleteAll(t);
            return ;
         }
         else{
            order1=m_trade.ResultOrder();
            if(m_trade.ResultRetcode()!=done){
               m_trade.OrderDelete(order1);
               deleteAll(t);
               return ;
            }
         }
         
         if(!m_trade.BuyLimit(lot,tp+spread,m_symbol.Name())){
            m_trade.OrderDelete(order1);
            deleteAll(t);
            return ;
         }
         else{
            order2=m_trade.ResultOrder();
            if(m_trade.ResultRetcode()!=done){
               m_trade.OrderDelete(order1);
               m_trade.OrderDelete(order2);
               deleteAll(t);
               return;
            }
         } 
         
         m_trade.Sell(lot,m_symbol.Name());
         if(m_trade.ResultRetcode()!=done){
               m_trade.OrderDelete(order1);
               m_trade.OrderDelete(order2);
               deleteAll(t);
               return ;
         }
}

void expert::modifyStop(double n){
   int e=OrdersTotal();
   for(int i=0;i<e;i++){
      m_order.SelectByIndex(i);
      ENUM_ORDER_TYPE type=m_order.OrderType();
      if(m_order.Magic()==m_magic && m_order.Symbol()==m_symbol.Name()&&(type==ORDER_TYPE_BUY_STOP||type==ORDER_TYPE_SELL_STOP)&&m_order.PriceOpen()!=n){
         updateSpread();
         if(type==ORDER_TYPE_BUY_STOP){
            m_trade.OrderModify(m_order.Ticket(),n+spread,m_order.StopLoss(),m_order.TakeProfit(),m_order.TypeTime(),m_order.TimeExpiration());
         }
         else{
            m_trade.OrderModify(m_order.Ticket(),n,m_order.StopLoss(),m_order.TakeProfit(),m_order.TypeTime(),m_order.TimeExpiration());         
         }
      }
   }
}

void expert::updateSpread(void){
   spread=SymbolInfoDouble(m_symbol.Name(),SYMBOL_ASK)-SymbolInfoDouble(m_symbol.Name(),SYMBOL_BID);  
}

void expert::update(void){
   updateSpread();
   sl=stopLoss();
   tp=takeProfit(); 
}

double expert::OnTester(bool f=false){
   if(f){return kellyFEmpirical(loss);}
   return kellyREmpirical(loss);
}



void expert::timeCut(void){
   if(cutTime==0){return ;}
   if(openOrder()&&m_order.TimeSetup()-TimeCurrent()>cutTime){      
      closePosition();
      deleteAll();
   }
}

void expert::closePosition(void){
   if(openOrder()){
      if(m_order.OrderType()==ORDER_TYPE_BUY_LIMIT||m_order.OrderType()==ORDER_TYPE_BUY_STOP){
         m_trade.Buy(m_order.VolumeInitial());
      }
      else{
         m_trade.Sell(m_order.VolumeInitial());
      }
   }
}

bool expert::withIn(void){
   HistorySelect(Time(0),TimeCurrent());
   int e=HistoryOrdersTotal();
   for(int i=e-1;i>-1;i--){
      hist.SelectByIndex(i);
      if(hist.Magic()==m_magic&&hist.Symbol()==m_symbol.Name()){
         return true;
      }
   }
   return false;
}

void expert::openFileBinRead(void){
   string r;
   StringConcatenate(r,"s",IntegerToString(m_magic));
   fileBin.Open(r,FILE_BIN|FILE_READ);
}

void expert::openFileBinWrite(void){
   string r;
   StringConcatenate(r,"s",IntegerToString(m_magic));
   fileBin.Open(r,FILE_BIN|FILE_WRITE);
}

//~~~bug if different sl, tp levels
void expert::OnTrade(void){
   if(orderTypeHomo()){
      deleteAll();
   }
}