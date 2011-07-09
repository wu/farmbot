/*
 * ShiftBrite.pde
 *
 * Fade two shiftbrites between blue/purple/pink, the bi-pride colors
 *
 */

#include "HughesyShiftBrite.h"

#include "WubotStatusLight.h";

HughesyShiftBrite sb1;
HughesyShiftBrite sb2;

int redbrightness1 = 1;    // how bright the LED is
int redfadeAmount1 = 1;    // how many points to fade the LED by
int bluebrightness1 = 1;    // how bright the LED is
int bluefadeAmount1 = 1;    // how many points to fade the LED by

int redbrightness2 = 1;    // how bright the LED is
int redfadeAmount2 = 5;    // how many points to fade the LED by
int bluebrightness2 = 1;    // how bright the LED is
int bluefadeAmount2 = 5;    // how many points to fade the LED by

void setup() {
  sb1 = HughesyShiftBrite(10,11,12,13);
  sb1.sendColour(0,0,1000);

  sb2 = HughesyShiftBrite(4,5,6,7);
  sb2.sendColour(0,0,1000);

  Serial.begin(9600);
}


void loop()  {

  // change the brightness for next time through the loop:
  redbrightness1 = redbrightness1 + redfadeAmount1;
  if (redbrightness1 < 1 || redbrightness1 > 999 || random(100) > 95) {
    redfadeAmount1 = -redfadeAmount1;
  }
  bluebrightness1 = bluebrightness1 + bluefadeAmount1;
  if (bluebrightness1 < 1 || bluebrightness1 > 999 || random(100) > 95) {
    bluefadeAmount1 = -bluefadeAmount1 ;
  }
  sb1.sendColour(redbrightness1,0,bluebrightness1);  


  redbrightness2 = redbrightness2 + redfadeAmount2;
  if (redbrightness2 < 6 || redbrightness2 > 994 || random(100) > 95) {
    redfadeAmount2 = -redfadeAmount2 ;
  }
  bluebrightness2 = bluebrightness2 + bluefadeAmount2;
  if (bluebrightness2 < 6 || bluebrightness2 > 994 || random(100) > 95) {
    bluefadeAmount2 = -bluefadeAmount2 ;
  }
  sb2.sendColour(redbrightness2,0,bluebrightness2);  

  delay( 100 );

}