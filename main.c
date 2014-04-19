//
//  main.c
//  LightweightTemporalCompression
//
//  Created by Pratyush Tottempudi on 4/18/14.
//  Copyright (c) 2014 Rajini's. All rights reserved.
//

#include <stdio.h>

typedef struct point{
    int t[1000];
    float v[1000];
    
}point;

typedef struct zed{
    float t;
    float v;
}zed;



int main(int argc, const char * argv[])
{
    int i=0;
    float error=0.5;
    point r;
    zed z;
    
    
    long orgArr[]={44.6227918,31.37826125,37.28760918,39.6628076,31.20987861,31.17619251,39.36681245,51.92453398,43.64968708,28.87805159,37.5192572,36.49220034,40.87696103,40.08989985,36.52537907,34.02811918,32.92363847,30.87287401,44.23389454,31.58021511};
    
    
    
    
    int length=sizeof(orgArr)/sizeof(orgArr[0]);
    //printf("length is %d\n",length);
    
    for(int i=0;i<length;i++)
    {
        r.v[i]=orgArr[i];
    }
    for(int i=0;i<length;i++)
    {
        r.t[i]=i+1;
    }
    
    int flag=0;
    
    z.v=r.v[flag];
    z.t=r.t[flag];
    
    flag++;
    
    //printf("z values %f %f \n", z.v, z.t);
    while(r.v[flag]!=0 && r.t[flag]!=0){
        
        
        
        flag++;
    }
    
    
    
    
    printf("Hello,,,, World!");
    return 0;
}

