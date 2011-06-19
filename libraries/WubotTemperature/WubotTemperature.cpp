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

WubotTemperature::WubotTemperature( LibTemperature2* temp_obj, char name_char[] )
{
  // copy name to the 'name' variable
  strcpy( name, name_char );

  temp_obj_ptr = temp_obj;

  lasttemp   = 0;
  mindiff    = 1;
  showtemp   = 0;
  elapsed    = 0;
  lastupdate = 0;
  maxupdate  = 60000;
}

float WubotTemperature::check()
{
  float newtemp = temp_obj_ptr->GetTemperature();

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

  float newtempf = newtemp * 9 / 5 + 32;

  // display
  if ( showtemp ) {
    Serial.print( name );
    Serial.print( ", temp, " );
    Serial.print( newtempf );
    Serial.println( ", F" );

    lasttemp = newtemp;
    lastupdate = millis();
    
    showtemp = 0;
  }

  return newtempf;
}

float WubotTemperature::get_lasttemp()
{
  return lasttemp;
}
