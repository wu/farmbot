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

WubotStatusLight::WubotStatusLight( HughesyShiftBrite* sb_ptr )
{
  sb = sb_ptr;
}

WubotStatusLight::WubotStatusLight( int pin_1, int pin_2, int pin_3, int invert_flag )
{

  redpin = pin_1;
  greenpin = pin_2;
  bluepin = pin_3;

  invert = invert_flag;

}

void WubotStatusLight::setup( void )
{
  redbrightness  = 500;    // how bright the LED is
  redfadeAmount  = 10;    // how many points to fade the LED by
  redMin         = 100;
  redMax         = 900;

  bluebrightness = 500;    // how bright the LED is
  bluefadeAmount = -10;    // how many points to fade the LED by
  blueMin        = 100;
  blueMax        = 900;

  blink_on = 1;

  if ( sb == NULL ) {
    Serial.println( "Setting up LED" );

    send_color( 0, 0, 1000 );
  }
  else {
    Serial.println( "Setting up shiftbrite" );

    // we got 4 pins, this is a shiftbrite


    // initializing
    send_color(0,0,1000);
  }

  
}

// Public Methods //////////////////////////////////////////////////////////////
// Functions available in Wiring sketches, this library, and other libraries

void WubotStatusLight::update_status(int status)
{
  last_status = status;

  if ( status == 0 ) {
    Serial.println( "Status = 0: ok, normal pretty fade mode" );
    // normal fade mode

    redbrightness = redbrightness + redfadeAmount;
    if (redbrightness < redMin || redbrightness > redMax || random(100) > 95) {
      redfadeAmount = -redfadeAmount;
    }
    bluebrightness = bluebrightness + bluefadeAmount;
    if (bluebrightness < blueMin || bluebrightness > blueMax || random(100) > 95) {
      bluefadeAmount = -bluefadeAmount ;
    }

    send_color(redbrightness,0,bluebrightness);
    
  }
  else if ( status == 1 ) {
    // warning, yellow
    Serial.println( "Status = 1: warning, yellow" );

    if ( blink_on == 1 ) {
      send_color( 1000, 1000, 0 );
      blink_on = 0;
    }
    else {
      send_color( 0, 0, 0 );
      blink_on = 1;
    }
  }
  else if ( status == 2 ) {
    // error, red
    Serial.println( "Status = 2: critical, red" );

    if ( blink_on == 1 ) {
      send_color( 1000, 0, 0 );
      blink_on = 0;
    }
    else {
      send_color( 0, 0, 0 );
      blink_on = 1;
    }
  }
  else {
    // unknown, orange
    Serial.println( "Status = 3: unknown, orange" );

    if ( blink_on == 1 ) {
      send_color( 1000, 500, 0 );
      blink_on = 0;
    }
    else {
      send_color( 0, 0, 0 );
      blink_on = 1;
    }

  }

}

void WubotStatusLight::send_color( int red, int green, int blue )
{

  if ( red > 1000 ) {
    red = 1000;
  }
  else if ( red < 1 ) {
    red = 1;
  }

  if ( blue > 1000 ) {
    blue = 1000;
  }
  else if ( blue < 1 ) {
    blue = 1;
  }

  if ( green > 1000 ) {
    green = 1000;
  }
  else if ( green < 1 ) {
    green = 1;
  }

  if ( sb == NULL ) {
    // tri-color LED

    int myred = red / 4 + 1;
    int myblue = blue / 4 + 1;
    int mygreen = green / 4 + 1;

    if ( ! invert == NULL ) {
      myred   = 254 - myred;
      myblue  = 254 - myblue;
      mygreen = 254 - mygreen;
    }

    analogWrite( redpin, myred );
    analogWrite( greenpin, mygreen );
    analogWrite( bluepin, myblue );
      
  }
    else {

      // shiftbrite
      sb->sendColour( red, green, blue );
    }

}
