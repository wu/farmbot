/*
 * ShiftBrite.pde
 *
 * Fade two shiftbrites between blue/purple/pink, the bi-pride colors
 *
 */

#include "HughesyShiftBrite.h"

#include "WubotStatusLight.h";

WubotStatusLight statuslight = WubotStatusLight( 10, 11, 12, 13 );
//WubotStatusLight statuslight2 = WubotStatusLight( 4, 5, 6, 7 );

int x;

void setup() {
  Serial.begin(9600);

  statuslight.setup();
  //statuslight2.setup();
}


void loop()  {

  statuslight.update_status( 0 );
  //statuslight2.update_status( 2 );

  delay( 100 );

}