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

#include <LibTemperature2.h>

LibTemperature2 temp = LibTemperature2(0x2A);
LibTemperature2 temp2 = LibTemperature2(0x1C);

float lasttemp   = 0;
float mindiff    = 1;
float newtemp    = 0;
int showtemp     = 0;

float lasttemp2  = 0;
float mindiff2   = 1;
float newtemp2   = 0;
int showtemp2    = 0;

long elapsed;
long lastupdate = 0;

long elapsed2;
long lastupdate2 = 0;

long maxupdate  = 60000;

void setup() {
  Serial.begin(9600);
}

void loop() {

  {
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
      Serial.print( "lab, temp, " );
      Serial.print( newtemp * 9 / 5 + 32 );
      Serial.println( ", F" );

      lasttemp = newtemp;
      lastupdate = millis();
    
      showtemp = 0;
    }
  }

  {
    newtemp2 = temp2.GetTemperature();

    elapsed2 = millis() - lastupdate2;

    float tempchange2 = abs( lasttemp2 - newtemp2 );
    if ( tempchange2 > mindiff2 ) {
      // temperature changed
      showtemp2 = 1;
    }
    else if ( elapsed2 > maxupdate ) {
      // refresh the display
      showtemp2 = 1;
    }

    // display
    if ( showtemp2 ) {
      Serial.print( "outside, temp, " );
      Serial.print( newtemp2 * 9 / 5 + 32 );
      Serial.println( ", F" );

      lasttemp2 = newtemp2;
      lastupdate2 = millis();
    
      showtemp2 = 0;
    }
  }

  delay(1000);
}


