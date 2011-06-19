/*
 * WubotSoilMoisture.h - wubot library for monitoring moisture
 *
*/

// ensure this library description is only included once
#ifndef WubotSoilMoisture_h
#define WubotSoilMoisture_h

// include types & constants of Wiring core API
//#include "WConstants.h"

//#include "Wire.h"

// library interface description
class WubotSoilMoisture
{
  // user-accessible "public" interface
  public:
    WubotSoilMoisture( int, char[] );
    float check();

  // library-accessible "private" interface
  private:
    char name[32];

    int moisture;
    int pin;

    float vegetronix_max;

    float newvalue;
    float last_value;
    float min_change;
    int showvalue;
    long elapsed;
    long lastupdate;
    long maxupdate;

    int debug;
};

#endif

