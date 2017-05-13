#include <xsw\expert.mqh>

class bolBreak: public expert{
   protected:
      int period;
      int longPR;
      double ratio;
      double sl;
      double tp;
      bool longP;
      bool stopWithLong;
      
      CiBands band;
      CiStdDev sd;
      CiMA ma;
      double tempMa;
      //~~~ useless; if useful, need to store
      datetime modifyT;
      
      double openMA();
      
      virtual void initIndi();
      virtual double stopLoss();
      virtual double takeProfit();
      virtual int signal();
      virtual void trailing();
      virtual double ultimateSl();
      virtual void initStore();
      virtual void store();
 
   public:
      bolBreak(int period_,int longPR_,double ratio_,double sl_,double tp_,bool LP,bool SWL,
         string sym,ENUM_TIMEFRAMES per,double C=0,bool everyTick=false,bool t=false,double W=1,double F=.2,ulong magic=1);
};

bolBreak::bolBreak(int period_,int longPR_,double ratio_,double sl_,double tp_,bool LP,bool SWL,string sym,ENUM_TIMEFRAMES per,double C=0.000000,bool everyTick=false,bool t=false,double W=1,double F=0.200000,ulong magic=1){
   period=period_;longPR=longPR_;ratio=ratio_;sl=sl_;tp= tp_;longP=LP;stopWithLong=SWL;
   init(sym,per,C,everyTick,t,W,F,magic);   
}



void bolBreak::initIndi(void){
      band.Create(m_symbol.Name(),m_period,period,0,ratio,PRICE_CLOSE);
      m_indicators.Add(GetPointer(band));
      sd.Create(m_symbol.Name(),m_period,period,0,MODE_SMA,PRICE_CLOSE);
      m_indicators.Add(GetPointer(sd));
      ma.Create(m_symbol.Name(),m_period,longPR*period,0,MODE_SMA,PRICE_CLOSE);
      m_indicators.Add(GetPointer(ma));
}

double bolBreak::stopLoss(void){
         double result=0;
         if(!openOrder()){
            tempMa=band.Base(2);
            store();
         }
         else{
            modifyT=TimeCurrent();
            ENUM_ORDER_TYPE type=m_order.OrderType();
            if(type==ORDER_TYPE_BUY_STOP||type==ORDER_TYPE_BUY_LIMIT){
               direction=-1;
            }
            if(type==ORDER_TYPE_SELL_STOP||type==ORDER_TYPE_SELL_LIMIT){
               direction=1;
            }
         }
         if(direction==1){
            result=tempMa+sl*MathAbs(Close(1)-tempMa);
            if(stopWithLong){
               result=MathMax(result,ma.Main(1));
            }
            
         }
         if(direction==-1){
            result=tempMa-sl*MathAbs(Close(1)-tempMa);
            if(stopWithLong){
               result=MathMin(result,ma.Main(1));
            }
         }
         return result;
}

double bolBreak::ultimateSl(void){
   return band.Base(2);
}
//~~~need normalize in expert?
double bolBreak::takeProfit(void){        
         //Print("ma ",band.Base(2)," close ",Close(1)," tp ",tp);
         if(direction!=0){
            return NormalizeDouble(band.Base(2)+tp*(Close(1)-band.Base(2)),m_symbol.Digits());
         }
         return 0;
}

int bolBreak::signal(void){
   int result=0;
   if(Close(1)>band.Upper(2)){result= 1;}
   if(Close(1)<band.Lower(2)){result= -1;}
   if(longP){
      double dif=Close(1)-ma.Main(2);
      if((dif>0&&result==-1)||(dif<0&&result==1)){
         result=0;
      }
   }
   return result;
}

void bolBreak::trailing(void){
   if(Time(0)<modifyT){
      return;
   }
   double s=expert::sl;
   update();
   if(openOrder()){
      modifyStop(expert::sl);
   }
}

double bolBreak::openMA(void){
   if(openOrder()){
      datetime t=m_order.TimeSetup();
      int i=0;
      while(1){
         if(Time(i)<=t){
            return band.Base(i+2);
         }
         i++;
      }
   }
   return 0;
}

void bolBreak::initStore(void){
   openFileBinRead();
   fileBin.ReadDouble(tempMa);
   fileBin.Close();
}

void bolBreak::store(void){
   openFileBinWrite();
   fileBin.WriteDouble(tempMa);
   fileBin.Close();
}