input string path="forexTime\\";

#include <Arrays\ArrayObj.mqh>
#include <Arrays\List.mqh>
#include <tick.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
MqlTick temp;
MqlDateTime date1,date2;
tick* temp2;
int file;
      int ms1;
      int ms2;
      int dms;


int OnInit()
  {   
      TimeToStruct(TimeCurrent(),date1);
      TimeToStruct(TimeCurrent(),date2);
      string fileName;
      StringConcatenate(fileName,AccountInfoString(ACCOUNT_COMPANY),"\\tickData\\",Symbol(),"\\tick",Symbol(),TimeToString(TimeCurrent(),TIME_DATE),".csv");
      file=FileOpen(fileName,FILE_CSV|FILE_WRITE|FILE_COMMON);
      ms1=ms2=GetTickCount();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer

      FileClose(file);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      TimeToStruct(TimeCurrent(),date2);
      if(date2.day!=date1.day){
         FileClose(file);
         OnInit();
      }
      ms1=GetTickCount();
      dms=ms1-ms2;
      ms2=ms1;
      SymbolInfoTick(Symbol(),temp);
      temp2=new tick(temp);
      temp2.fileWrite(file,dms);
      delete temp2;

     
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---   
   double ret=0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
//| TesterInit function                                              |
//+------------------------------------------------------------------+
void OnTesterInit()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| TesterPass function                                              |
//+------------------------------------------------------------------+
void OnTesterPass()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| TesterDeinit function                                            |
//+------------------------------------------------------------------+
void OnTesterDeinit()
  {
//---
   
  }
//+------------------------------------------------------------------+
