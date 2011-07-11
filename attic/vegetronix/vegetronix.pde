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

#include "WubotSoilMoisture.h";

// use a shiftbrite
HughesyShiftBrite sb = HughesyShiftBrite( 11, 10, 9, 8 );
WubotStatusLight statuslight = WubotStatusLight( &sb );

// vegetronix soil moisture
WubotSoilMoisture vegetronix = WubotSoilMoisture( 0, "test" );

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

  if ( loopcount > 100 ) {
    loopcount = 0;

    int moisture = vegetronix.check();

    if ( moisture < 0 || moisture > 100 ) {
      status = 3;
    }
    else if ( moisture < moisture_min ) {
      status = 1;
    }
    else {
      status = 0;
    }
  }

  statuslight.update_status( status );

  delay( 100 );

}