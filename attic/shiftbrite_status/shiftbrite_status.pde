/*
 * ShiftBrite.pde
 *
 * Fade two shiftbrites between blue/purple/pink, the bi-pride colors
 *
 */

#include "HughesyShiftBrite.h"
#include "WubotStatusLight.h";

// use a shiftbrite
HughesyShiftBrite sb = HughesyShiftBrite( 11, 10, 9, 8 );
WubotStatusLight statuslight = WubotStatusLight( &sb );

// use a 3-color LED, inverted for common annode
// WubotStatusLight statuslight2 = WubotStatusLight( 9, 10, 11, 1 );

int x;

void setup() {
  Serial.begin(9600);

  statuslight.setup();

  // statuslight2.setup();
}


void loop()  {

  statuslight.update_status( 0 );

  // statuslight2.update_status( 0 );

  delay( 100 );

}