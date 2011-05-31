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
    WubotStatusLight( HughesyShiftBrite* sb );
    WubotStatusLight(int,int,int,int);
    void setup(void);
    void update_status(int);
    

  // library-accessible "private" interface
  private:
    void send_color(int,int,int);

    HughesyShiftBrite *sb;
    int last_status;

    int redpin;
    int greenpin;
    int bluepin;

    int invert;

    int redbrightness;
    int redfadeAmount;
    int redMin;
    int redMax;

    int bluebrightness;
    int bluefadeAmount;
    int blueMin;
    int blueMax;

    int blink_on;
};

#endif

