/*
 * WubotHumidity.h - wubot library for monitoring humidity
 *
*/

// ensure this library description is only included once
#ifndef wubot_h
#define wubot_h

// include types & constants of Wiring core API
//#include "WConstants.h"

#include "Wire.h"

// library interface description
class WubotHumidity
{
  // user-accessible "public" interface
  public:
    WubotHumidity( int HumidityPin, char name_char[] );
    float check( float temp );
    char name[32];
    float get_lasthumidity();
    float ZeroPercentVoltage;


  // library-accessible "private" interface
  private:
    int humidity_pin;
    uint8_t address;
    float lasthumidity;
    float mindiff;
    int showhumidity;
    long elapsed;
    long lastupdate;
    long maxupdate;

};

#endif

