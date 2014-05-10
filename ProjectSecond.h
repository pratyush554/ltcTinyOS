#ifndef PROJECTSECOND_H
#define PROJECTSECOND_H

#include<AM.h>

enum {
  AM_EASYCOLLECTION = 0xee,
  AM_SERIALCOLLECTION = 0xee,
};

typedef nx_struct ProjectSecondMsg 
  {
    nx_uint16_t temperature[15][2];
    nx_uint16_t csize;
    nx_uint16_t node_id;
  } ProjectSecondMsg;

typedef struct point {
    int t[15];
    float v[15];
} point;

typedef struct zed {
    float t;
    float v;
} zed;


#endif

