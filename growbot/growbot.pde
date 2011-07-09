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


void setup() {
  Serial.begin(9600);

}

void loop() {

  float temp = wubottemp.check();

  wubothumidity.check( temp );
  
  vegetronix.check();

  delay(1000);
}
