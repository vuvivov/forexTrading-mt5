#include <Expert\Expert.mqh>

const int nBrokers=3;

class spreadTester: public CExpert{
   protected:
      int nTest;
      double sumPingMarket;
      double sumPingPending;
      int rank;
      
      void getRank();
      bool Processing(void);
      void write();
      void test();
   public:
      spreadTester();
      void deleteRank();
};

spreadTester::spreadTester(void){
   getRank();
   Print("rank ",rank);
}

void spreadTester::getRank(void){
   string fileName="getRank";
   int file=FileOpen(fileName,FILE_BIN|FILE_WRITE|FILE_READ|FILE_COMMON);
   while(file==INVALID_HANDLE){
      file=FileOpen(fileName,FILE_BIN|FILE_WRITE|FILE_READ|FILE_COMMON);
      Print("while");
      Sleep(MathRand());      
   }
   int status=FileReadInteger(file);
   Print("stat ",status);
   FileClose(file);
   
   file=FileOpen(fileName,FILE_BIN|FILE_WRITE|FILE_COMMON);
   while(file==INVALID_HANDLE){
      file=FileOpen(fileName,FILE_BIN|FILE_READ|FILE_COMMON);
      Sleep(MathRand());  
   }
   if(status==-1){      
      MessageBox("exceed nBrokers");
   }
   if(status==0){
      FileWriteInteger(file,1);
      rank=1;
   }
   else{
      if(status==nBrokers-1){
        if(FileWriteInteger(file,-1)==0){Print(_LastError);}
         rank=nBrokers;     
      }
      else{
         FileWriteInteger(file,status+1);
         rank=status+1; 
      }
   }
   FileClose(file);
}

bool spreadTester::Processing(void){
   MqlDateTime t;
   TimeToStruct(Time(0),t);
   if(t.min==1){
      write();
   }
   test();
   return true;
}

void spreadTester::test(void){
   int ms=GetTickCount();
   m_trade.Buy(m_symbol.LotsMin());
   m_trade.PositionClose(Symbol());
   sumPingMarket+=(GetTickCount()-ms)/2;
   
   ms=GetTickCount();
   m_trade.BuyLimit(m_symbol.LotsMin(),m_symbol.Bid()-10*(m_symbol.Ask()-m_symbol.Bid()));
   int order=m_trade.ResultOrder();
   m_trade.OrderDelete(order);
   sumPingPending+=(GetTickCount()-ms)/2;
   
   nTest++;
}

void spreadTester::write(void){
      //check ready to write
      
      string fileName="spreadTest.csv";
      //~~~while
      int file=FileOpen(fileName,FILE_COMMON|FILE_CSV|FILE_WRITE|FILE_READ);
      
      nTest=0;
      sumPingMarket=sumPingPending=0;
      Sleep(1000*60);
}

void spreadTester::deleteRank(void){
   string fileName="getRank";
   Print(FileDelete(fileName,FILE_COMMON));
}
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
spreadTester* a;
int OnInit()
  {
//---
   
   a=new spreadTester();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   a.deleteRank();
   Print(_LastError);
   delete a;
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
