//
//  main.c
//  LightweightTemporalCompression
//
//  Created by Pratyush Tottempudi on 4/18/14.
//  Copyright (c) 2014 Rajini's. All rights reserved.
//

#include <stdio.h>


int main(int argc, const char * argv[])
{
     int i=0;
     float error=0.5;
     long v[]={44.6227918,
     31.37826125,
     37.28760918,
     39.6628076,
     31.20987861,
     31.17619251,
     39.36681245,
     51.92453398,
     43.64968708,
     28.87805159,
     37.5192572,
     36.49220034,
     40.87696103,
     40.08989985,
     36.52537907,
     34.02811918,
     32.92363847,
     30.87287401,
     44.23389454,
     31.58021511};
     
     int length=sizeof(v) / sizeof(v[0]);
     printf("length is %d",length);
    
    long t[length];
     
     for(i=0;i<(length);i++)
     {
     t[i]=i+1;
     }
    
    
    
     
     
     //long compArr[1000];
    


    printf("Hello, World!");
    return 0;
}

