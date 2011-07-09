/*
 * WubotSoilMoisture.h - handle wubot soil moisture
 *
 *   measure soil moisture from vegetronix sensor
 *
 *   - http://www.cheapvegetablegardener.com/2009/08/how-to-use-vegetronix-soil-moisture.html
 *
 *   send soil moisture reading and any changes to serial output.  if
 *   moisture does not change for longer than maxupdate (60 seconds),
 *   refresh the current moisture out to the serial.
 *
 *  Tested with the Vegetronix VG400
 *  Soil Sensor from http://www.vegetronix.com/Products/VG400/
 *
 */

// include core Wiring API
#include "WProgram.h"

// include this library's description file
#include "WubotSoilMoisture.h"

// include description files for other libraries used (if any)
//#include "Wire.h"
// #include "HardwareSerial.h"

#include "string.h";

// Constructor /////////////////////////////////////////////////////////////////
// Function that handles the creation and setup of instances

WubotSoilMoisture::WubotSoilMoisture( int analog_pin, char name_char[] )
{

  // copy name to the 'name' variable
  strcpy( name, name_char );

  pin            = analog_pin;

  debug          = 0;

  vegetronix_max = 614;
  last_value     = -999;
  min_change     = 5;
  showvalue      = 0;
  elapsed        = 0;
  lastupdate     = 0;
  maxupdate      = 60000;
}


float WubotSoilMoisture::check()
{

  moisture = analogRead(0);

  if ( debug > 0 ) {
    Serial.print( "Read moisture: " );
    Serial.println( moisture );
  }

  newvalue = moisture / vegetronix_max * 100;

  if ( debug > 0 ) {
    Serial.print( "Calculated percent: " );
    Serial.println( newvalue );
  }

  elapsed = millis() - lastupdate;

  float valuechange = abs( last_value - newvalue );

  if ( valuechange > min_change ) {
    // value changed
    showvalue = 1;
  }
  else if ( elapsed > maxupdate ) {
    // refresh the display
    showvalue = 1;
  }

  // display
  if ( showvalue ) {
    Serial.print( name );
    Serial.print( ", moisture, " );
    Serial.print( newvalue );
    Serial.println( ", %" );

    last_value = newvalue;
    lastupdate = millis();
    
    showvalue = 0;
  }

  return newvalue;
}
