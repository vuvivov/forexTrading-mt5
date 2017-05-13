#include <xsw\expert.mqh>
#include <Trade\OrderInfo.mqh>

class stack{
   protected:
      void AddLot();
   public:
      expert* EAs[][10];
      stack(int n);
      void OnTick();
      void OnTrade();
      void initWeight();
      ~stack();
};

stack::~stack(){
   int n=ArrayRange(EAs,0);
   int m=ArrayRange(EAs,1);
   for(int i=0;i<n;i++){
      for(int j=0;j<m;j++){
         EAs[i][j].OnDeinit();
      }
   }
}

stack::stack(int n){
   ArrayResize(EAs,n);
}

void stack::OnTick(void){
   int n=ArrayRange(EAs,0);
   int m=ArrayRange(EAs,1);
   bool fresh=false;
   for(int i=0;i<n;i++){
      for(int j=0;j<m;j++){
         EAs[i][j].OnTick();
      }
   }
   AddLot();
   for(int i=0;i<n;i++){
      for(int j=0;j<m;j++){
         EAs[i][j].stackTrade();
      }
   }
}

//~~~
void stack::AddLot(void){  
   //setStackLot back to 0
   double weight[];
   double totalWeight;
   int n=ArrayRange(EAs,0);
   int m=ArrayRange(EAs,1);
   ArrayResize(weight,n);
   for(int i=0;i<n;i++){
      for(int j=0;j<m;j++){
         EAs[i][j].setStackLot(0);
      }
   }   
   //add lot
   bool toContinue=true;
   double toAdd;
   while(toContinue){
      toContinue=false;
      //update weights
      totalWeight=0;
      for(int i=0;i<n;i++){
         weight[i]=0;
         for(int j=0;j<m;j++){
            weight[i]+=EAs[i][j].getStackWeight();
         }
         totalWeight+=weight[i];
      }
      //add lot
      for(int i=0;i<m;i++){
         for(int j=0;j<n;j++){
            if(EAs[j][i].getLotsFull()!=0){
               toAdd=double(EAs[j][i].getLotsMin())/double(EAs[j][i].getLotsFull());
               if(weight[j]==0){
                  if(totalWeight+toAdd>1){

                  }
                  else{
                     EAs[j][i].addStackLot();
                     weight[j]+=toAdd;
                     totalWeight+=toAdd;
                     //EAs[j][i].printInfo();
                     toContinue=true;
                  }
               }
               else{
                  if(!EAs[j][i].overWeight()){
                     if(weight[j]+toAdd<=1/double(n)&&totalWeight+toAdd<=1){
                        EAs[j][i].addStackLot();
                        //EAs[j][i].printInfo();
                        weight[j]+=toAdd;
                        totalWeight+=toAdd;
                        toContinue=true;
                     }
                     else{
                     
                     }
                  }
                  else{
                  
                  }
               }
            }
         }
      }
   }
}

//~~~
void stack::OnTrade(void){
   int n=ArrayRange(EAs,0);
   int m=ArrayRange(EAs,1);
   for(int i=0;i<n;i++){
      for(int j=0;j<m;j++){
         EAs[i][j].OnTrade();
         
      }
   }
}

void stack::initWeight(void){
   int n=ArrayRange(EAs,0);
   int m=ArrayRange(EAs,1);
   for(int i=0;i<n;i++){
      for(int j=0;j<m;j++){
         EAs[i][j].setSatckWeightMax(1/double(m*n));
         
      }
   }
}