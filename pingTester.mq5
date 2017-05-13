#include <xsw\expert.mqh>

double nTrail=99;
int sleep=1000;
int n=0;
class pingTester: public expert{
   protected:
      
   public:
      void OnTick();
};

void pingTester::OnTick(void){
   Refresh();
   double msMarket=0;
   double msPending=0;
   int t=GetTickCount();
   int order;
   for(int i=0;i<nTrail;i++){
      m_trade.BuyLimit(.1,Close(0)-.01);
      Sleep(sleep);
      order=m_trade.ResultOrder();
      Print("order ",order);
      m_trade.OrderDelete(order);
      
   }
   msPending=double(GetTickCount()-t-nTrail*sleep)/nTrail/2;
   t=GetTickCount();
   for(int i=0;i<nTrail;i++){
      m_trade.Buy(.1);
      Sleep(sleep);
      m_trade.PositionClose(Symbol());
      
   }
   msMarket=double(GetTickCount()-t-nTrail*sleep)/nTrail/2;
   
   string fileName="pingTester.csv";
   int file=FileOpen(fileName,FILE_CSV|FILE_WRITE|FILE_READ);
   FileSeek(file,0,SEEK_END);
   FileWrite(file,AccountInfoString(ACCOUNT_COMPANY),msMarket,msPending);
   FileClose(file);   
   PlaySound("timeout.wav");
}

pingTester a;
int OnInit()
  {
//---
   a.init(Symbol(),Period());
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   if(n==1){return;}
   a.OnTick();
   n++;
  }
//+------------------------------------------------------------------+
