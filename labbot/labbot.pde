/****************************
 *
 * labduino
 *
 *  monitor temperature in lab
 *  receive data from other monitors using xbee
 *
 *  Tested with the TMP421-Breakout
 *  Temperature Sensor from Modern Device
 *****************************/
#include "Wire.h"

#include <LibTemperature2.h>
#include <WubotTemperature.h>

LibTemperature2 temp1 = LibTemperature2( 0x2A );
WubotTemperature wubottemp = WubotTemperature( &temp1, "lab" );

//LibTemperature2 temp2 = LibTemperature2( 0x1C );
//WubotTemperature wubottemp2 = WubotTemperature( &temp2, "outside" );

int loopcounter;

// serial line
int serIn;
int line_length;
int line = 0;
int comma_count = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {

  loopcounter++;

  while (Serial.available() > 0) {
    serIn = Serial.read();

    line_length++;

    if ( serIn == 13 ) {
      //lcd.print( "   " );
      // nop
    }
    else if ( serIn == 10 ) {
      Serial.println();
      line_length = 0;
      comma_count = 0;

      line++;
      if ( line > 1 ) { line = 0; }
      //lcd.setCursor( 0, line );
    }
    else if ( serIn == 44 ) {
      // comma
      comma_count++;

      if ( comma_count == 1 ) {
        //lcd.setCursor( 0, line );
      }
      Serial.print( serIn, BYTE );
    }
    else {
      Serial.print( serIn, BYTE );
      //lcd.print( serIn, BYTE );
    }
  }
  

  // temperature
  if ( loopcounter > 100 ) {
    loopcounter = 0;
    wubottemp.check_temp();
    //wubottemp2.check_temp();
  }

  delay(10);
}


