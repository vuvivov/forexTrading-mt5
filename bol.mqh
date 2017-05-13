//+------------------------------------------------------------------+
//|                                                          bol.mqh |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Expert\myExpert.mqh>
#include <Indicators\Trend.mqh>

#include <Trade\HistoryOrderInfo.mqh>
#include <Arrays\ArrayLong.mqh>

#define  bolStopLevel 50
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class bol : public myExpert
  {
private:
   //para
   int               period;
   double            ratio;
   double            sl;
   double            tp;
   
   double            longP;
   int               consecutive;
   
   bool              allowLongMa;
   bool              allowSlWithLongMa;
   bool              allowWithin;
   bool              allowTrailingTp;
   bool              allowConsecutiveOrder;
   bool              allowMonday;
   bool              allowMondayOpenBreak;
   int               maShift;
   int               sdShift;

   CArrayLong        slID;
   CArrayLong        tpID;
   storeDouble      *ma;
   storeDouble      *close;
   

   CiMA              longMa;
   CiBands          *bands;
   CiMA             *MA;

   //void              initMoney();
   void              initDefaultPara();
   void              initIndicators();
   void              initStores();
   void              initPending();

   bool              allowEnter();
   int               sigalForEntry();
   double            stopLoss();
   double            takeProfit();

   void              deletePending();
   bool              Processing();

public:
   void              initialize(string s,ENUM_TIMEFRAMES p,ulong magic,
                                int period_,
                                double ratio_,
                                double sl_,
                                double tp_,
                                bool testMode_,
                                double longP_,
                                int consecutive_,
                                double loss_,
                                bool allowLongMa_,
                                bool allowSlWithLongMa_,
                                bool allowWithin_,
                                bool allowTrailingTp_,
                                bool allowConsecutiveOrder_,
                                bool allowMonday_,
                                bool allowMondayOpenBreak_,
                                double weight_,
                                double init_,
                                int maShift_,
                                int sdShift_);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void bol::initialize(string s,ENUM_TIMEFRAMES p,ulong magic,
                     int period_,
                     double ratio_,
                     double sl_,
                     double tp_,
                     bool testMode_,
                     double longP_,
                     int consecutive_,
                     double loss_,
                     bool allowLongMa_,
                     bool allowSlWithLongMa_,
                     bool allowWithin_,
                     bool allowTrailingTp_,
                     bool allowConsecutiveOrder_,
                     bool allowMonday_,
                     bool allowMondayOpenBreak_,
                     double weight_,
                     double f_,
                     int maShift_,
                     int sdShift_)
  {

   Init(s,p,1,magic);

   period=period_;
   ratio=ratio_;
   sl=sl_;
   tp=tp_;
   testMode=testMode_;
   longP=longP_;
   consecutive=consecutive_;
   loss=loss_;
   allowLongMa=allowLongMa_;
   allowSlWithLongMa=allowSlWithLongMa_;
   allowWithin=allowWithin_;
   allowTrailingTp=allowTrailingTp_;
   allowConsecutiveOrder=allowConsecutiveOrder_;
   allowMonday=allowMonday_;
   allowMondayOpenBreak=allowMondayOpenBreak_;
   weight=weight_;
   f=f_;
   maShift=maShift_;
   sdShift=sdShift_;

   myExpert::initialize();

   initPending();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void bol::initIndicators(void)
  {
   longMa.Create(m_symbol.Name(),m_period,longP*period,0,MODE_SMA,PRICE_CLOSE);
   m_indicators.Add(GetPointer(longMa));

   bands=new CiBands;
   bands.Create(m_symbol.Name(),m_period,period,0,ratio,PRICE_CLOSE);
   m_indicators.Add(bands);

   longMa.Refresh();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void bol::initStores(void)
  {
   ma=new storeDouble(stores);
   close=new storeDouble(stores);
  }


void bol::initPending(void)
  {
   for(int i=0;i<OrdersTotal();i++)
     {
      m_order.Select(i);
      if(m_order.Magic()==m_magic && m_order.Symbol()==m_symbol.Name())
        {
         if(m_order.OrderType()==ORDER_TYPE_BUY_STOP || m_order.OrderType()==ORDER_TYPE_SELL_STOP)
           {
            slID.Add(m_order.Ticket());
           }
         if(m_order.OrderType()==ORDER_TYPE_BUY_LIMIT || m_order.OrderType()==ORDER_TYPE_SELL_STOP_LIMIT)
           {
            tpID.Add(m_order.Ticket());
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool bol::allowEnter(void)
  {
//within
   if(!allowWithin)
     {
      if(Close(1)==close.get())
        {
         return false;
        }
     }

//consecutive
   if(!allowConsecutiveOrder)
     {
      for(int i=HistoryOrdersTotal()-1;i>=0;i--)
        {
         hist.SelectByIndex(i);
         if(hist.Magic()==m_magic && hist.Symbol()==m_symbol.Name())
           {
            break;
           }
        }
      MqlDateTime t1,t2;
      TimeToStruct(TimeCurrent(),t1);
      TimeToStruct(hist.TimeDone(),t2);
      if(t1.day_of_year==t2.day_of_year)
        {
         if(t2.hour-t1.hour<=consecutive)
           {
            return false;
           }
        }
      else
        {
         if(t2.hour+24*(t2.day_of_year-t1.day_of_year)-t1.hour<=consecutive)
           {
            return false;
           }
        }
     }

//Monday
   if(!allowMonday)
     {
      MqlDateTime t;
      TimeToStruct(Time(period),t);
      if(t.day_of_week==5)
        {
         return false;
        }
     }
   if(!allowMondayOpenBreak)
     {
      MqlDateTime t;
      TimeToStruct(TimeCurrent(),t);
      if(t.day_of_week==1 && t.hour==0)
        {
         return false;
        }
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int bol::sigalForEntry()
  {
   if(!allowEnter())
     {
      return 0;
     }
   int result=0;
   int resultLong=0;
   int oldType=0;
   if(slID.Total()!=0)
     {
      m_order.Select(slID[0]);
      if(m_order.OrderType()==ORDER_TYPE_SELL_STOP)
        {
         oldType=1;
        }
      else
        {
         oldType=-1;
        }
     }
   if(allowLongMa)
     {
      if(Close(1)>longMa.Main(1))
        {
         resultLong=1;
        }
      else
        {
         resultLong=-1;
        }
     }

   if(Close(1)>bands.Upper(maShift))
     {
      result=1;
      if((oldType!=0 && result!=oldType) || (resultLong!=0 && resultLong!=result))
        {
         return 0;
        }
      ma.set(bands.Base(maShift));
      close.set(Close(1));
     }
   if(Close(1)+m_symbol.Spread()*m_symbol.Point()<bands.Lower(maShift))
     {
      result=-1;
      if((oldType!=0 && result!=oldType) || (resultLong!=0 && resultLong!=result))
        {
         return 0;
        }
      ma.set(bands.Base(maShift));
      close.set(Close(1));
     }
   return result;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double bol::stopLoss(void)
  {
   double result;
   result=ma.get()+(Close(1)-ma.get())*sl;
   if(allowSlWithLongMa)
     {
      if(Close(1)>ma.get())
        {
         result=MathMax(result,longMa.Main(1));
        }
      else
        {
         result=MathMin(result,longMa.Main(1));
        }
     }
   return NormalizeDouble(result,m_symbol.Digits());
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double bol::takeProfit(void)
  {
   if(tpID.Total()!=0 && allowTrailingTp==false)
     {
      m_order.Select(tpID[0]);
      return m_order.PriceOpen();
     }
   //Print("ma ",ma.get()," close ",close.get()," tp ",tp);
   return NormalizeDouble(ma.get()+(close.get()-ma.get())*tp,m_symbol.Digits());
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void bol::deletePending(void)
  {
   if(slID.Total()==0 || tpID.Total()==0)
     {
      return;
     }
   if(!m_order.Select(slID[0]))
     {
      for(int i=0;i<tpID.Total();i++)
        {
         m_trade.OrderDelete(tpID[i]);
        }
      slID.Shutdown();
      tpID.Shutdown();
      return;
     }
   if(!m_order.Select(tpID[0]))
     {
      for(int i=0;i<slID.Total();i++)
        {
         m_trade.OrderDelete(slID[i]);
        }
      slID.Shutdown();
      tpID.Shutdown();
      return;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool bol::Processing(void)
  {
//delete
   deletePending();

   int sig=sigalForEntry();
   double stop=stopLoss();
   double take=takeProfit();

   double l=money.lot(ma.get());
   bool fill=false;

//first entry
   if(slID.Total()==0 && tpID.Total()==0 && sig!=0)
     {

      if(MathAbs(stop-close.get())/m_symbol.Point()<bolStopLevel)
        {
         return true;
        }
      if(sig==1)
        {

         if(execute(ORDER_TYPE_SELL_STOP,l,slID,stop) && 
            execute(ORDER_TYPE_SELL_LIMIT,l,tpID,take))
           {
            fill=true;
            if(!execute(ORDER_TYPE_BUY,l,slID))
              {
               fill=false;
              }
           }
         if(!fill)
           {
            Delete(slID);
            Delete(tpID);
           }
        }
      else
        {
         if(execute(ORDER_TYPE_BUY_STOP,l,slID,stop) && 
            execute(ORDER_TYPE_BUY_LIMIT,l,tpID,take))//~~~spread or not +m_symbol.Spread()*m_symbol.Point()
           {
            fill=true;
            if(!execute(ORDER_TYPE_SELL,l,slID))
              {
               fill=false;
              }
           }
         if(!fill)
           {
            Delete(slID);
            Delete(tpID);
           }
        }
     }

//trailing
   if(slID.Total()!=0 && tpID.Total()!=0)
     {
      //trailing tp
      m_order.Select(tpID[0]);
      if(take!=m_order.PriceOpen())
        {
         m_order.Select(slID[0]);
         double oldL=m_order.VolumeCurrent();
         double diffL=l-oldL;
         bool modifyResult;
         if((diffL>0 && sig>0) || (diffL<0 && sig<0))
           {
            modifyResult=execute(ORDER_TYPE_BUY,MathAbs(diffL),slID);
           }
         else
           {
            modifyResult=execute(ORDER_TYPE_SELL,MathAbs(diffL),slID);
           }
         if(modifyResult)
           {
            Delete(slID);
            Delete(tpID);


            if(sig==1)
              {

               if(execute(ORDER_TYPE_SELL_STOP,l,slID,stop) && 
                  execute(ORDER_TYPE_SELL_LIMIT,l,tpID,take))
                 {
                  fill=true;

                 }
               if(!fill)
                 {
                  Delete(slID);
                  Delete(tpID);
                 }
              }
            else
              {
               if(execute(ORDER_TYPE_BUY_STOP,l,slID,stop) && 
                  execute(ORDER_TYPE_BUY_LIMIT,l,tpID,take))
                 {
                  fill=true;

                 }
               if(!fill)
                 {
                  Delete(slID);
                  Delete(tpID);
                 }
              }
           }


        }

      //modify sl
      m_order.Select(slID[0]);
      if(stop!=m_order.PriceOpen())
        {
         modify(stop,slID);
        }
     }

   return true;
  }
//~~~~ eur para

/*
void bol::initDefaultPara()
  {
   if(m_symbol.Name()=="EURUSD")
     {
      period=25;
      ratio=3.75;
      sl=.55;
      tp=1.35;
      size=7.4;
      testMode=false;
      longP=10;
      consecutive=1;
      loss=500;
      allowLongMa=true;
      allowSlWithLongMa=false;
      allowWithin=false;
      allowTrailingTp=false;
      allowConsecutiveOrder=true;
      allowMonday=false;
      allowMondayOpenBreak=false;
      weight=.578;
      f=7000;
      maShift=2;
      sdShift=2;
     }
   if(m_symbol.Name()=="USDCHF")
     {
      period=17;
      ratio=3.9;
      sl=.15;
      tp=1.7;
      size=3.7;
      testMode=false;
      longP=10;
      consecutive=1;
      loss=500;
      allowLongMa=true;
      allowSlWithLongMa=true;
      allowWithin=false;
      allowTrailingTp=false;
      allowConsecutiveOrder=true;
      allowMonday=true;
      allowMondayOpenBreak=false;
      weight=.265;
      init=7000;
      maShift=2;
      sdShift=2;
     }
   if(m_symbol.Name()=="XAUUSD")
     {
      period=28;
      ratio=2.9;
      sl=.4;
      tp=2;
      size=3.8;
      testMode=false;
      longP=10;
      consecutive=1;
      loss=500;
      allowLongMa=true;
      allowSlWithLongMa=false;
      allowWithin=false;
      allowTrailingTp=true;
      allowConsecutiveOrder=true;
      allowMonday=true;
      allowMondayOpenBreak=false;
      weight=.217;
      init=7000;
      maShift=2;
      sdShift=2;
     }

  }
  */
//+------------------------------------------------------------------+
