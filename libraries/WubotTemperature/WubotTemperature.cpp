/*
 * WubotTemperature.h - handle wubot temperature
 *
 *   send temperature reading and any changes to serial output.  if
 *   temp does not change for longer than maxupdate (60 seconds),
 *   refresh the current temperature out to the serial.
 *
 *  Tested with the TMP421-Breakout
 *  Temperature Sensor from Modern Device
 *
 */

// include core Wiring API
#include "WProgram.h"

// include this library's description file
#include "WubotTemperature.h"

// include description files for other libraries used (if any)
#include "Wire.h"
// #include "HardwareSerial.h"
#include <LibTemperature2.h>

#include "string.h";

// Constructor /////////////////////////////////////////////////////////////////
// Function that handles the creation and setup of instances

WubotTemperature::WubotTemperature( uint8_t got_address, char name_char[] )
{
  // copy name to the 'name' variable
  strcpy( name, name_char );

  address    = got_address;

  lasttemp   = 0;
  mindiff    = 1;
  showtemp   = 0;
  elapsed    = 0;
  lastupdate = 0;
  maxupdate  = 60000;
}


void WubotTemperature::get_temp()
{
  if ( temp_obj_ptr == NULL ) {
    temp_obj_ptr = &( LibTemperature2( address ) );
  }

  float newtemp = (*temp_obj_ptr).GetTemperature();

  elapsed = millis() - lastupdate;

  float tempchange = abs( lasttemp - newtemp );

  if ( tempchange > mindiff ) {
    // temperature changed
    showtemp = 1;
  }
  else if ( elapsed > maxupdate ) {
    // refresh the display
    showtemp = 1;
  }

  // display
  if ( showtemp ) {
    Serial.print( name );
    Serial.print( ", temp, " );
    Serial.print( newtemp * 9 / 5 + 32 );
    Serial.println( ", F" );

    lasttemp = newtemp;
    lastupdate = millis();
    
    showtemp = 0;
  }
}
