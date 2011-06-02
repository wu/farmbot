/*
 * vegetronix
 *
 *  measure soil moisture with vegetronix sensor
 *
 *  - http://www.cheapvegetablegardener.com/2009/08/how-to-use-vegetronix-soil-moisture.html
 *
 */

#include "HughesyShiftBrite.h"
#include "WubotStatusLight.h";

// use a shiftbrite
HughesyShiftBrite sb = HughesyShiftBrite( 11, 10, 9, 8 );
WubotStatusLight statuslight = WubotStatusLight( &sb );

int loopcount = 0;

int status = 0;

int moisture_min = 0;
int vegetronix_max = 614;

void setup() {
  Serial.begin(9600);

  statuslight.setup();
  //statuslight.set_scale(10);
}


void loop()  {

  loopcount++;

  if ( loopcount % 100 == 1 ) {

    int moisture = analogRead(0);
    moisture = moisture * 100 / vegetronix_max;

    Serial.print( "test, moisture, " );
    Serial.println( moisture );

    if ( moisture < moisture_min ) {
      status = 1;
    }
    else {
      status = 0;
    }
  }

  statuslight.update_status( status );

  delay( 100 );

}