/*
  WubotStatusLight.h - WubotStatusLight library for Wiring - description
  Copyright (c) 2006 John Doe.  All right reserved.
*/

// ensure this library description is only included once
#ifndef WubotStatusLight_h
#define WubotStatusLight_h

// include types & constants of Wiring core API
#include "WConstants.h"

#include "HughesyShiftBrite.h"

// library interface description
class WubotStatusLight
{
  // user-accessible "public" interface
  public:
    WubotStatusLight(int,int,int,int);
    void setup(void);
    void update_status(int);
    

  // library-accessible "private" interface
  private:
    HughesyShiftBrite sb;
    int last_status;

    int pin1;
    int pin2;
    int pin3;
    int pin4;

    int redbrightness;
    int redfadeAmount;
    int bluebrightness;
    int bluefadeAmount;

    int blink_on;
};

#endif

