#include <xsw\expert.mqh>
//store datetime

class bolRev: public expert{
   protected:
      //para
      int period;
      double ratio1;
      double ratio2;
      double sl;
      double tp;
      
      bool break1;
      bool break2;
      bool backBol;
      bool level;
      int direction;
      
      datetime last;
      datetime current;
      
      CiBands band1;
      CiBands band2;
      CiStdDev sd;
      
      virtual void initIndi();
      virtual double stopLoss();
      virtual double takeProfit();
      virtual int signal();
      double deviation();
      double touch();
      double touch(int i,double r);
   public:
      void init(int period_,double ratio1_,double ratio2_,double sl_,double tp_,bool T=true,double P=.7,ulong magic=1,double W=1.000000,double L=100.000000);
};

void bolRev::init(int period_,double ratio1_,double ratio2_,double sl_,double tp_,bool T=true,double P=0.700000,ulong magic=1,double W=1.000000,double L=100.000000){
   period=period_;ratio1=ratio1_;ratio2=ratio2_;sl=sl_;tp= tp_;
   expert::init(T,P,magic,W,L);
}

void bolRev::initIndi(void){
   //Print(period," ",ratio1," ",ratio2," ");
      band1.Create(m_symbol.Name(),m_period,period,0,ratio1,PRICE_CLOSE);
      m_indicators.Add(GetPointer(band1));
      band2.Create(m_symbol.Name(),m_period,period,0,ratio2,PRICE_CLOSE);
      m_indicators.Add(GetPointer(band2));
      sd.Create(m_symbol.Name(),m_period,period,0,MODE_SMA,PRICE_CLOSE);
      m_indicators.Add(GetPointer(sd));
}


double bolRev::stopLoss(void){
         if(direction==1){
            return Close(0)-sl*sd.Main(0);
         }
         if(direction==-1){
            return Close(0)+sl*sd.Main(0);
         }
         return 0;
}

double bolRev::takeProfit(void){
         if(direction==1){
            return Close(0)+tp*sd.Main(0);
         }
         if(direction==-1){
            return Close(0)-tp*sd.Main(0);
         }
         return 0;
}

int bolRev::signal(void){
   if(MathAbs(deviation())>ratio1){return 0;}
   double touch=touch();
   
   if(touch==0){return 0;}
   if(current==last){return 0;}
   //Print(direction," ",Close(0)>touch?1:-1);
   if(direction==1&&Close(0)>touch){
      last=current;
      return 1;
   }
   if(direction==-1&&Close(0)<touch){
      last=current;
      return -1;
   }
   return 0;     
}




double bolRev::deviation(void){
   return (Close(0)-band1.Base(0))/sd.Main(0); 
}


double bolRev::touch(){
   int i=0;
   int count1=0;
   int count2=0;
   direction=0;
   double touch1=0;
   double touch2=0;
   int end=1000;
   
   while(count1<1&&i<end){
      touch1=touch(i,ratio1);
      touch2=touch(i,-ratio1);
      if(touch1!=0&&touch2!=0){return 0;}
      if(touch1!=0){
         direction=-1;
         count1++;
         current=Time(i);
      }      
      if(touch2!=0){
         direction=1;
         count1++;
         current=Time(i);
      }
      i++;
   }
   while(count1<2&&i<end){
      touch2=touch(i,-ratio2*direction);
      if(touch2!=0){
         count2++;
      }
      touch1=touch(i,-ratio1*direction);
      if(touch1!=0){
         count1++;
         if(count2!=0){
            return touch1;
         }
      } 
      i++;
   }
   return 0;   
}

double bolRev::touch(int i,double r){
//Print(i);
   double a=band1.Base(i)+r*(sd.Main(i));
   if(Low(i)<=a&&a<=High(i)){return a;}
   return 0;
}