/*
  WubotStatusLight.h - WubotStatusLight library for Wiring - implementation
  Copyright (c) 2006 John Doe.  All right reserved.
*/

// include core Wiring API
#include "WProgram.h"

// include this library's description file
#include "WubotStatusLight.h"

// include description files for other libraries used (if any)
#include "HughesyShiftBrite.h"
#include "HardwareSerial.h"

// Constructor /////////////////////////////////////////////////////////////////
// Function that handles the creation and setup of instances

WubotStatusLight::WubotStatusLight( int pin_1, int pin_2, int pin_3, int pin_4 )
{

  pin1 = pin_1;
  pin2 = pin_2;
  pin3 = pin_3;
  pin4 = pin_4;

  redbrightness = 500;    // how bright the LED is
  redfadeAmount = 10;    // how many points to fade the LED by
  bluebrightness = 500;    // how bright the LED is
  bluefadeAmount = 10;    // how many points to fade the LED by

  blink_on = 1;
}

void WubotStatusLight::setup( void )
{
  sb = HughesyShiftBrite( pin1, pin2, pin3, pin4 );

  // initializing
  sb.sendColour(0,0,1000);
  
}

// Public Methods //////////////////////////////////////////////////////////////
// Functions available in Wiring sketches, this library, and other libraries

void WubotStatusLight::update_status(int status)
{
  last_status = status;

  Serial.print( "status = " );
  Serial.println( status );

  if ( status == 0 ) {
    Serial.println( "Status = 0: ok, normal pretty fade mode" );
    // normal fade mode

    redbrightness = redbrightness + redfadeAmount;
    if (redbrightness < 1 || redbrightness > 999 || random(100) > 95) {
      redfadeAmount = -redfadeAmount;
    }
    bluebrightness = bluebrightness + bluefadeAmount;
    if (bluebrightness < 1 || bluebrightness > 999 || random(100) > 95) {
      bluefadeAmount = -bluefadeAmount ;
    }

    sb.sendColour(redbrightness,0,bluebrightness);  
    
  }
  else if ( status == 1 ) {
    // warning, yellow
    Serial.println( "Status = 1: warning, yellow" );

    if ( blink_on == 1 ) {
      sb.sendColour( 1000, 1000, 0 );
      blink_on = 0;
    }
    else {
      sb.sendColour( 0, 0, 0 );
      blink_on = 1;
    }
  }
  else if ( status == 2 ) {
    // error, red
    Serial.println( "Status = 2: critical, red" );

    if ( blink_on == 1 ) {
      sb.sendColour( 1000, 0, 0 );
      blink_on = 0;
    }
    else {
      sb.sendColour( 0, 0, 0 );
      blink_on = 1;
    }
  }
  else {
    // unknown, orange
    Serial.println( "Status = 3: unknown, orange" );

    if ( blink_on == 1 ) {
      sb.sendColour( 1000, 500, 0 );
      blink_on = 0;
    }
    else {
      sb.sendColour( 0, 0, 0 );
      blink_on = 1;
    }

  }

}
