/*
 * ShiftBrite.pde
 */

#include "HughesyShiftBrite.h"

HughesyShiftBrite sb;

int redbrightness = 500;    // how bright the LED is
int redfadeAmount = 10;    // how many points to fade the LED by

int bluebrightness = 500;    // how bright the LED is
int bluefadeAmount = 10;    // how many points to fade the LED by

int greenbrightness = 500;    // how bright the LED is
int greenfadeAmount = 10;    // how many points to fade the LED by

int fade; // code_smell: used for saving loop state

void setup() {
  sb = HughesyShiftBrite(10,11,12,13);
  sb.sendColour(10,10,10);
  Serial.begin(9600);
}


void loop()  {

  redbrightness = get_color( redbrightness, redfadeAmount );
  redfadeAmount = fade;

  bluebrightness = get_color( bluebrightness, bluefadeAmount );
  bluefadeAmount = fade;

  greenbrightness = get_color( greenbrightness, greenfadeAmount );
  greenfadeAmount = fade;

  sb.sendColour( redbrightness, greenbrightness, bluebrightness);

  Serial.print( redbrightness );
  Serial.print( ", " );
  Serial.print( greenbrightness );
  Serial.print( ", " );
  Serial.println( bluebrightness );

  delay(100);
}

int get_color( int brightness, int fadeAmount ) {

  // code_smell - storing state variable within method
  fade = fadeAmount;

  brightness += fadeAmount;

  if ( brightness < 0 ) {
    brightness = 0;
    fade = -fade;
  }
  else if ( brightness > 999 ) {
    brightness = 999;
    fade = -fade;
  }
  else {
    if ( random(100) > 98 ) {
      if ( fade < 0 ) {
        fade = -random(20);
      }
      else {
        fade = random(20);
      }
    }
  }

  return brightness;
}