/*
 * growbot
 *
 * this is a prototype for the gardenbots.  it combines a temperature
 * sensor, a humidity sensor, and a soil moisture sensor.
 *
 */


#include "Wire.h"

#include <LibTemperature2.h>
#include <WubotTemperature.h>
#include <WubotSoilMoisture.h>
#include <WubotHumidity.h>

WubotSoilMoisture vegetronix = WubotSoilMoisture( 0, "growbot" );

LibTemperature2 temp1 = LibTemperature2( 0x2A );
WubotTemperature wubottemp = WubotTemperature( &temp1, "growbot" );

WubotHumidity wubothumidity = WubotHumidity( 1, "growbot" );

// real time clock
#define DS1307_ADDRESS 0x68

// powertail switch
int powerpin          = 12;
// heater state defaults to 'off'
int heater_state      = 0;
int last_heater_state = 0;

// setup
void setup() {
  Wire.begin();
  Serial.begin(9600);
  pinMode( powerpin, OUTPUT );
}

// loop
void loop() {

  // TEMEPRATURE
  float temp = wubottemp.check();

  // RELATIVE HUMIDITY
  wubothumidity.check( temp );

  // SOIL MOISTURE
  vegetronix.check();

  // TIME
  Wire.beginTransmission(DS1307_ADDRESS);
  Wire.send(0);
  Wire.endTransmission();
  Wire.requestFrom(DS1307_ADDRESS, 7);

  int second   = bcdToDec(Wire.receive());
  int minute   = bcdToDec(Wire.receive());
  int hour     = bcdToDec(Wire.receive() ); //24 hour time
  int weekDay  = bcdToDec(Wire.receive()); //0-6 -> sunday - Saturday
  int monthDay = bcdToDec(Wire.receive());
  int month    = bcdToDec(Wire.receive());
  int year     = bcdToDec(Wire.receive());

  /*********************************/
  // Heater Control
  if ( temp < 76 ) {
    // heater comes on when temp falls below this temp
    heater_state = 1;
  }
  else if ( temp > 80 ) {
    // heater goes when temp gets up above this temp
    heater_state = 0;
  }

  if ( heater_state != last_heater_state ) {
    last_heater_state = heater_state;

    if ( heater_state == 0 ) {
      digitalWrite( powerpin, LOW );
      Serial.println( "Turning power off" );
    }
    else {
      digitalWrite( powerpin, HIGH );
      Serial.println( "Turning power on" );
    }
  }

  // data is only read from the serial port every 5 seconds, so don't
  // bother getting a reading more often than that
  delay(5000);
}

byte bcdToDec(byte val)  {
// Convert binary coded decimal to normal decimal numbers
  return ( (val/16*10) + (val%16) );
}