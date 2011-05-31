/*
 * WubotTemperature.h - wubot library for monitoring temperature
 *
*/

// ensure this library description is only included once
#ifndef wubot_h
#define wubot_h

// include types & constants of Wiring core API
//#include "WConstants.h"

#include "Wire.h"
#include "LibTemperature2.h"

// library interface description
class WubotTemperature
{
  // user-accessible "public" interface
  public:
    WubotTemperature( LibTemperature2* temp_obj, char name_char[] );
    float check_temp();
    char name[32];

  // library-accessible "private" interface
  private:
    LibTemperature2* temp_obj_ptr;
    uint8_t address;
    float lasttemp;
    float mindiff;
    int showtemp;
    long elapsed;
    long lastupdate;
    long maxupdate;

};

#endif

