/*
 * WubotHumidity.h - handle wubot humidity
 *
 *   monitor humidity sensor, and send any humidity changes greater
 *   than 5% to serial output.  if humidity does not change more than
 *   5% for longer than maxupdate (60 seconds), refresh the current
 *   humidity out to the serial.
 *
 *   tested with: HIH-4030 Breakout from www.sparkfun.com
 *
 */

// include core Wiring API
#include "WProgram.h"

// include this library's description file
#include "WubotHumidity.h"

// include description files for other libraries used (if any)
#include "Wire.h"

#include "string.h";

// Constructor /////////////////////////////////////////////////////////////////
// Function that handles the creation and setup of instances

WubotHumidity::WubotHumidity( int HumidityPin, char name_char[] )
{
  // copy name to the 'name' variable
  strcpy( name, name_char );

  humidity_pin = HumidityPin;

  ZeroPercentVoltage = 0.8;

  lasthumidity   = 0;
  mindiff    = 5;
  showhumidity   = 0;
  elapsed    = 0;
  lastupdate = 0;
  maxupdate  = 60000;
}

float WubotHumidity::check( float temp )
{

  float readhumidity = analogRead( humidity_pin );

  float max_voltage = ( 3.27 - ( 0.00372549 * temp ) ) ; // The max voltage value drops down 0.00372549 for each degree F over 32F. The voltage at 32F is 3.27 (corrected for zero precent voltage)

  float newhumidity = ( ( ( ( readhumidity / 1023 ) * 5 ) - ZeroPercentVoltage ) / max_voltage ) * 100;

  elapsed = millis() - lastupdate;

  float humiditychange = abs( lasthumidity - newhumidity );

  if ( humiditychange > mindiff ) {
    // humidityerature changed
    showhumidity = 1;
  }
  else if ( elapsed > maxupdate ) {
    // refresh the display
    showhumidity = 1;
  }

  // display
  if ( showhumidity ) {
    Serial.print( "^" );
    Serial.print( name );
    Serial.print( ", humidity, " );
    Serial.print( newhumidity );
    Serial.println( ", percent" );

    lasthumidity = newhumidity;
    lastupdate = millis();
    
    showhumidity = 0;
  }

  return newhumidity;
}

float WubotHumidity::get_lasthumidity()
{
  return lasthumidity;
}
