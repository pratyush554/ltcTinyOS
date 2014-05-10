#include <Timer.h>
#include "ProjectSecond.h"
#include <stdlib.h>

module ProjectSecondC
{
  uses interface Boot;
  uses interface SplitControl as RadioControl;
  uses interface StdControl as RoutingControl;
  uses interface Send;
  uses interface Leds;
  uses interface Timer<TMilli>;
  uses interface RootControl;
  uses interface Receive;

  uses interface Read<uint16_t> as TempRead;

}

implementation {
  
  int oAV[15];
  int l;
  static int csize=0;
  static int length=0;
  message_t packet;
  message_t spacket;
  int decompress=0;
  bool sendBusy = FALSE;
  uint16_t t=0xffff,h=0xffff,v=0xffff, varyInput=1;
  
    float diablo,gta5;
    float outArrV[15];
    float outArrT[15];
 
/**************************************************************/
  event void Boot.booted() 
  {
    
    call RadioControl.start();

  }

/***************************************************************/
  
 
  event void RadioControl.startDone(error_t err) 
  {
    if (err != SUCCESS)
      call RadioControl.start();
    else {
	call RoutingControl.start();
      if (TOS_NODE_ID == 1) 
	call RootControl.setRoot();
      else
	call Timer.startPeriodic(1000);
    }
  }

/***************************************************************/
  event void RadioControl.stopDone(error_t err) {}

/****************************************************************/

/*
     //Decompressing part.
    
  */
 
/***************************************************************/

void sendMessage()
{
    int j;
    int outFlag = 0;
    int flag = 0;
    float e = 1;
    float LL, UL, ll, ul, zvh, zvl, ch, cl;
    float highline=0, lowline=0;
    point r;
    zed z, nextDataPoint;
    int i;
     
    ProjectSecondMsg* msg = (ProjectSecondMsg*)call Send.getPayload(&packet,sizeof(ProjectSecondMsg));
     
	/*Author copyright Pratyush Tottempudi*/
	
	if(call TempRead.read()!=SUCCESS)
	{
		 call TempRead.read();
                 
	}
	if(t!=65535)
	{
	oAV[length]=t;
	length++;
	}
	

    if(length%15==0 && length!=0)
	{

	for(i=0;i<length;i++)
	{	
		dbg("send","Original data values for NODE(%hhu) : %d \n",TOS_NODE_ID,oAV[i]);
	}
	
    for ( i = 0; i < length; i++) {
        r.v[i] = oAV[i];
    }
    for (i = 0; i < length; i++) {
        r.t[i] = i+1;
    }
    
   
    
    z.v = r.v[flag];
    z.t = r.t[flag];
    
    flag++;
    
    
    
    UL=(z.v-(r.v[flag] + e)) / (z.t - r.t[flag]);
    LL=(z.v-(r.v[flag] - e)) / (z.t - r.t[flag]);
    
    highline=(z.v-(r.v[flag] + e)) / (z.t - r.t[flag]);
    lowline=(z.v-(r.v[flag] - e)) / (z.t - r.t[flag]);
    
    outFlag=0;
    //printf("z values %f %f \n", z.v, z.t);
    while (flag < length){
        //finding the slope of UL and LL for second point.
        //First step of algorithm
        
        
        nextDataPoint.v = r.v[flag + 1];
        
        nextDataPoint.t = r.t[flag + 1];
        
        //checking the region of third point
        
        ul = (z.v-(nextDataPoint.v + e)) / (z.t - nextDataPoint.t);
        ll = (z.v-(nextDataPoint.v - e)) / (z.t - nextDataPoint.t);
        
        
        if (highline < ll || lowline > ul) {
           
            outArrV[outFlag] = z.v;
            outArrT[outFlag] = z.t;
            // midpoint calculation error
            // using y=mx+c concept here
            // formula : c = y-mx;
            ch = ((z.v) - ((highline)*(z.t)));
            cl = ((z.v) - ((lowline)*(z.t)));
            
            z.t = r.t[flag];
            
            //formula : y=mx+c;
            zvh=((highline)*z.t)+(ch);
            zvl=((lowline)*z.t)+(cl);
            
            z.v=(zvh+zvl)/2;

            UL = (z.v-(nextDataPoint.v + e)) / (z.t - nextDataPoint.t);
            highline=UL;
            LL = (z.v-(nextDataPoint.v - e)) / (z.t - nextDataPoint.t);
            lowline=LL;
            
            outFlag++;
            
        }
        
        else
        {
            
            if (highline > ul) {
                UL = ul;
                highline=UL;
            }
            
            if (lowline < ll) {
                LL = ll;
                lowline=LL;
            }
        }
        
        flag++;
        
        
    }
    //printf("outflag value %d\n",outFlag);
    msg->csize=outFlag;
    msg->node_id=TOS_NODE_ID;
    for (j = 0; j < outFlag; j++){
	
        msg->temperature[j][0]=(uint16_t) outArrV[j];
	msg->temperature[j][1]=(uint16_t) outArrT[j];
        dbg("send","compressed output for NODE(%hhu) VALUE : POSITION = %d %d \n",TOS_NODE_ID, msg->temperature[j][0], msg->temperature[j][1]); 
    }

	msg->temperature[outFlag][0]=(uint16_t) r.v[length-1];
	msg->temperature[outFlag][1]=(uint16_t) r.t[length-1];
	 dbg("send","compressed output for NODE(%hhu) VALUE : POSITION = %d %d \n",TOS_NODE_ID, msg->temperature[outFlag][0], msg->temperature[outFlag][1]);
   	length=0;
   if (call Send.send(&packet, sizeof(ProjectSecondMsg)) != SUCCESS) {
      dbg("send", " Node (%hhu) not sent packet.\n", TOS_NODE_ID);
      call Leds.led0On();}
    else {
      dbg("send", " Node(%hhu) sent compressed output in a packet .\n", TOS_NODE_ID);
      sendBusy = TRUE;}
}}
/***************************************************************/
event void TempRead.readDone(error_t result, uint16_t data){

if(result==SUCCESS)
{	
	//the readings are random every time, and they lie between 15 and 27.
    t = (rand() % (27 + 1 - 15))+15;
}	
	
}

/***************************************************************/

  event void Timer.fired() {

    if (sendBusy==FALSE){
    sendMessage();
    
} }
/***************************************************************/  
 event void Send.sendDone(message_t* m, error_t err) {
    if (err == SUCCESS) 
    sendBusy = FALSE;
  }
/***************************************************************/  

  event message_t* Receive.receive(message_t* m, void* payload, uint8_t len) 
	{
	int outFlag=0;
	int jack=0;
	int j=0;

	if(len==sizeof(ProjectSecondMsg))
        {
	ProjectSecondMsg* msg = (ProjectSecondMsg*)payload;
	outFlag=msg->csize;
	for(jack=0;jack<=outFlag;jack++)
	{
	 dbg("receive", "Node(%hhu) received packet with temperature %hhu and position %d from NODE(%hhu)\n", TOS_NODE_ID,msg->temperature[jack][0],msg->temperature[jack][1],msg->node_id);
  	}
           
	//Decompressing part.

	/*Author Copyright Pratyush Tottempudi*/
    
    dbg("receive","Decompressing\n");
    
    decompress=msg->temperature[0][1];
  
    for (j = 0; j < outFlag; j++){

        if(outFlag-j==1) { 
	diablo= (((msg->temperature[outFlag][0])-(msg->temperature[j][0]))/((msg->temperature[outFlag][1])-(msg->temperature[j][1])));
	 gta5=msg->temperature[j][0]; 
	}
          else{  
            diablo = (((msg->temperature[j+1][0])-(msg->temperature[j][0]))/((msg->temperature[j+1][1])-(msg->temperature[j][1])));
            gta5 = msg->temperature[j][0];
        }
        
        
        if(msg->temperature[j][1]<msg->temperature[j+1][1])
        {
            
            while(msg->temperature[j][1]<msg->temperature[j+1][1])
            {
                
                /* For the decompressed values we have earlier implemented decimal points, but according ti what TA said to us during the seminar, she said it is OK to
		round of the values. Hence we are not getting precision to floting points. We are only showing integer values*/
 		
		/* Due to the rounding of this values, I have noticed some slightly innacuracy during decompression because; for example 17.75 in float becomes 17 in uint16_t */

                dbg("receive","Decompressed output VALUE : POSITION = %hhu : %hhu \n", (uint16_t) gta5, msg->temperature[j][1]);
                msg->temperature[j][1]=decompress+msg->temperature[j][1];
                gta5=gta5+diablo;
            }
        }
    }

 	dbg("receive","Decompressed output VALUE : POSITION = %d : %hhu \n",  msg->temperature[outFlag][0], msg->temperature[outFlag][1]);


	}

		return m;
	} 
  


/***************************************************************/
 
}

