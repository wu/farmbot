#include "Wire.h"

int serIn;

int place = 0;
char Str[80];


void setup() {
  Serial.begin(9600);
}

void loop() {

  while (Serial.available() > 0) {

    serIn = Serial.read();

    if ( serIn == 10 ) {
      Serial.print( "GOT: " );

      for ( int i = 0; i < place; i++ ) {
        Serial.print( Str[i] );
      }
      Serial.println();
      place = 0;

    }
    else {
      Str[ place ] = serIn;
      place++;
    }
  
    delay(10);
  }

}


