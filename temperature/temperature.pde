/****************************
 *
 * temperature
 *
 *  send temperature reading and any changes to serial output.  if
 *  temp does not change for longer than maxupdate (60 seconds),
 *  refresh the current temperature out to the serial.
 *
 *  Tested with the TMP421-Breakout
 *  Temperature Sensor from Modern Device
 *****************************/
#include "Wire.h"
#include <LibTemperature.h>

LibTemperature temp = LibTemperature(0);

float lasttemp  = 0;
float mindiff   = 1;
float newtemp   = 0;
int showtemp    = 0;

long elapsed;
long lastupdate = 0;
long maxupdate  = 60000;

void setup() {
  Serial.begin(9600);
}

void loop() {

  newtemp = temp.GetTemperature();

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
    Serial.print( "test, temp, " );
    Serial.print( newtemp * 9 / 5 + 32 );
    Serial.println( ", F" );

    lasttemp = newtemp;
    lastupdate = millis();
    
    showtemp = 0;
  }

  delay(1000);
}


