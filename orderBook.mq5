input string path="forexTime\\";

#include <Strings\String.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
class book{
   protected:
      string sym;
      int ms1;
      int ms2;
      int dms;
      MqlTick t;
      MqlBookInfo b[];
      CString write;
      
      void refresh();
      
   public:
      book(string s):sym(s),ms1(GetTickCount()),ms2(GetTickCount()){};
      void fileWrite(const int& file);
   
};

void book::refresh(void){
   ms1=GetTickCount();
   dms=ms1-ms2;
   ms2=ms1;
   
   SymbolInfoTick(sym,t);
   MarketBookGet(sym,b);
} 

void book::fileWrite(const int& file){
   refresh();
   write.Clear();
   write.Append(IntegerToString(ArraySize(b)));
   for(int i=0;i<ArraySize(b);i++){
      write.Append("\t");
      write.Append(DoubleToString(b[i].price));
      write.Append("\t");
      write.Append(DoubleToString(b[i].volume));
   }
   FileWrite(file,t.time,dms,t.bid,t.ask,t.last,t.volume,write.Str());
}

//------------------------------------------------------------------------------------------------------------------

MqlDateTime date1,date2;
int file;
book* b;


int OnInit()
  {   
      TimeToStruct(TimeCurrent(),date1);
      TimeToStruct(TimeCurrent(),date2);
      string fileName;
      StringConcatenate(fileName,AccountInfoString(ACCOUNT_COMPANY),"\\orderBookData\\",Symbol(),"\\book",Symbol(),TimeToString(TimeCurrent(),TIME_DATE),".csv");
      file=FileOpen(fileName,FILE_CSV|FILE_WRITE|FILE_COMMON);
      
      b=new book(Symbol());
      
      MarketBookAdd(Symbol());
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   FileClose(file);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| BookEvent function                                               |
//+------------------------------------------------------------------+
void OnBookEvent(const string &symbol)
  {
//---
      TimeToStruct(TimeCurrent(),date2);
      if(date2.day!=date1.day){
         FileClose(file);
         OnInit();
      }
      
      b.fileWrite(file);
  }
//+------------------------------------------------------------------+
