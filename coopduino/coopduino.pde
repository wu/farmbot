/****************************
 * Super CoopDuino
 *****************************/
#include "Wire.h"
#include <LibTemperature.h>

LibTemperature temp = LibTemperature(0);

int redpin   = 13;
int bluepin  = 12;
int greenpin = 11;

int mytemp;
int tempcount = 90;
int last_temp = 0;


void setup() {

  pinMode( redpin,   OUTPUT );
  pinMode( bluepin,  OUTPUT );
  pinMode( greenpin, OUTPUT );
  
  Serial.begin( 9600 );
  Serial.println( "Initialized" );
}


void loop() {

  tempcount++;

  if ( tempcount > 10 ) {
    tempcount = 0;

    mytemp = temp.GetTemperature();

    if ( last_temp != mytemp ) {
      last_temp = mytemp;

      int tempf = mytemp * 9 / 5 + 32;

      Serial.print( "temp, " );
      Serial.println( tempf );

      if ( tempf > 85 ) {
        digitalWrite(redpin, HIGH);
        digitalWrite(bluepin,  LOW);
        digitalWrite(greenpin, LOW);
      }
      else if ( tempf < 75 ) {
        digitalWrite(redpin, LOW);
        digitalWrite(bluepin, HIGH);
        digitalWrite(greenpin, LOW);
      }
      else {
        digitalWrite(redpin, LOW);
        digitalWrite(bluepin,  LOW);
        digitalWrite(greenpin, HIGH);
      }
    }
  }

  delay(100);
}

