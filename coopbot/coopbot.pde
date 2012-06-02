/****************************
 * Super CoopDuino
 *****************************/
#include "Wire.h"
#include <LiquidCrystal.h>

#include <LibTemperature2.h>
#include <WubotTemperature.h>

#define DS1307_ADDRESS 0x68

LibTemperature2 temp1 = LibTemperature2( 0x2A );
WubotTemperature wubottemp1 = WubotTemperature( &temp1, "coop" );

// LibTemperature2 temp2 = LibTemperature2( 0x1C );
// WubotTemperature wubottemp2 = WubotTemperature( &temp2, "outside" );

int debug            = 0;

int temp_max         = 90;
int temp_min         = 60;

int temp1led         = 8;
int power_light      = 7; // blue
int power_heat       = 6; // brown

int light_state      = 0;
int last_light_state = 2;

void setup() {

  Wire.begin();

  pinMode( temp1led, OUTPUT );
  pinMode( power_light, OUTPUT );
  pinMode( power_heat, OUTPUT );

  Serial.begin( 9600 );
  Serial.println( "SuperCoopduino Initialized" );
}


/////////////////////////////////////////////////////////////////////////////
// main
void loop() {

  if ( debug == 1 ) {
    Serial.println( "DEBUG: Loop" );
  }

  /*********************************/
  // TIME
  if ( debug == 1 ) {
    Serial.println( "DEBUG: getting time" );
  }
  Wire.beginTransmission(DS1307_ADDRESS);
  Wire.send(0);
  Wire.endTransmission();
  Wire.requestFrom(DS1307_ADDRESS, 7);
  int second   = bcdToDec( Wire.receive() );
  int minute   = bcdToDec( Wire.receive() );
  int hour     = bcdToDec( Wire.receive() ); //24 hour time
  int weekDay  = bcdToDec( Wire.receive() ); //0-6 -> sunday - Saturday
  int monthDay = bcdToDec( Wire.receive() );
  int month    = bcdToDec( Wire.receive() );
  int year     = bcdToDec( Wire.receive() );

  if ( debug == 1 ) {
    Serial.println( "DEBUG: controlling light" );
  }

  /*********************************/
  // Light Control
  if ( hour < 8 || hour > 20 ) {
    light_state = 0;
  }
  else {
    light_state = 1;
  }
  if ( light_state != last_light_state ) {
    last_light_state = light_state;

    if ( light_state == 0 ) {
      if ( debug == 1 ) {
        Serial.println( "DEBUG: turning off light" );
      }
      digitalWrite( power_light, LOW );
    }
    else {
      if ( debug == 1 ) {
        Serial.println( "DEBUG: turning on light" );
      }
      digitalWrite( power_light, HIGH );
    }
  }

  /*********************************/
  // TEMPERATURE
  if ( debug == 1 ) {
    Serial.println( "DEBUG: reading temp1" );
  }
  digitalWrite( temp1led, HIGH );
  float newtemp1f = wubottemp1.check();
  digitalWrite( temp1led, LOW );
  if ( debug == 1 ) {
    Serial.println( "DEBUG: got temp1" );
  }

  // //Serial.println( "DEBUG: reading temp2" );
  // float newtemp2f = wubottemp2.check();

  /*********************************/
  // Heater Control
  if ( newtemp1f < 45 ) {
    if ( debug == 1 ) {
      Serial.println( "DEBUG: temp is below 45, turning on heat lamp" );
    }
    digitalWrite( power_heat, HIGH );
  }
  else {
    if ( debug == 1 ) {
      Serial.println( "DEBUG: temp is above 45, turning off heat lamp" );
    }
    digitalWrite( power_heat, LOW );
  }

  if ( debug == 1 ) {
    Serial.println( "DEBUG: done with loop" );
  }

  delay(1000);
}


byte bcdToDec(byte val)  {
// Convert binary coded decimal to normal decimal numbers
  return ( (val/16*10) + (val%16) );
}
