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

  redpin   = pin_1;
  greenpin = pin_2;
  bluepin  = pin_3;

  invert   = invert_flag;

}

void WubotStatusLight::setup( void )
{
  debug = 0;

  redbrightness  = 500;    // how bright the LED is
  redfadeAmount  = 10;    // how many points to fade the LED by
  redMin         = 0;
  redMax         = 800;

  bluebrightness = 500;    // how bright the LED is
  bluefadeAmount = -10;    // how many points to fade the LED by
  blueMin        = 50;
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

void WubotStatusLight::set_scale( int scale_arg )
{
  scale = scale_arg;
}

void WubotStatusLight::update_status(int status)
{
  last_status = status;

  if ( status == 0 ) {
    // normal fade mode
    if ( debug > 0 ) {
      Serial.println( "Status = 0: ok, normal pretty fade mode" );
    }

    redbrightness = redbrightness + redfadeAmount;
    if (redbrightness < redMin ) {
      redfadeAmount = random(10);
    }
    else if ( redbrightness > redMax ) {
      redfadeAmount = -random(10);
    }
    else if ( random(100) > 98 ) {
      redfadeAmount = -redfadeAmount;
    }

    bluebrightness = bluebrightness + bluefadeAmount;
    if (bluebrightness < blueMin ) {
      bluefadeAmount = random(10);
    }
    else if ( bluebrightness > blueMax ) {
      bluefadeAmount = -random(10);
    }
    else if ( random(100) > 98 ) {
      bluefadeAmount = -bluefadeAmount;
    }

    send_color(redbrightness,0,bluebrightness);
    
  }
  else if ( status == 1 ) {
    // warning, yellow
    if ( debug > 0 ) {
      Serial.println( "Status = 1: warning, yellow" );
    }

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
    if ( debug > 0 ) {
      Serial.println( "Status = 2: critical, red" );
    }

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
    if ( debug > 0 ) {
      Serial.println( "Status = 3: unknown, orange" );
    }

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
  if ( blue > 1000 ) {
    blue = 1000;
  }
  if ( green > 1000 ) {
    green = 1000;
  }

  if ( sb == NULL ) {
    // tri-color LED

    if ( red < 1 ) {
      red = 1;
    }
    if ( blue < 1 ) {
      blue = 1;
    }
    if ( green < 1 ) {
      green = 1;
    }

    int myred = red / 4 + 1;
    int myblue = blue / 4 + 1;
    int mygreen = green / 4 + 1;

    if ( ! invert == NULL ) {
      myred   = 254 - myred;
      myblue  = 254 - myblue;
      mygreen = 254 - mygreen;
    }

    if ( scale ) {
      red   /= scale;
      blue  /= scale;
      green /= scale;
    }

    analogWrite( redpin, myred );
    analogWrite( greenpin, mygreen );
    analogWrite( bluepin, myblue );
      
  }
  else {

    if ( red < 1 ) {
      red = 0;
    }
    if ( blue < 1 ) {
      blue = 0;
    }
    if ( green < 1 ) {
      green = 0;
    }

    if ( scale ) {
      red   /= scale;
      blue  /= scale;
      green /= scale;
    }

    if ( debug > 1 ) {
      Serial.print( "Shiftbrite color: r=" );
      Serial.print( red );
      Serial.print( ", g=" );
      Serial.print( green );
      Serial.print( ", b=" );
      Serial.print( blue );
    }

    // shiftbrite
    sb->sendColour( red, green, blue );
  }

}
