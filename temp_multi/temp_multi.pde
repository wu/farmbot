/****************************
 *
 * temperature
 *
 *  send temperature reading and any changes to serial output.  if
 *  temp does not change for longer than maxupdate (60 seconds),
 *  refresh the current temperature out to the serial.
 *
 *  uses LibTemperature2 to read from multiple sensors.
 *
 *    http://log.liminastudio.com/programming/how-to-read-a-chain-of-tmp421-temperature-sensors-with-an-arduino
 *
 *  Tested with the TMP421-Breakout
 *  Temperature Sensor from Modern Device
 *****************************/

#include "Wire.h"
#include <WubotTemperature.h>
#include <LibTemperature2.h>

LibTemperature2 temp1 = LibTemperature2( 0x2A );
WubotTemperature wubottemp = WubotTemperature( &temp1, "test" );

LibTemperature2 temp2 = LibTemperature2( 0x1C );
WubotTemperature wubottemp2 = WubotTemperature( &temp2, "remote" );

void setup() {
  Serial.begin(9600);

}

void loop() {

  wubottemp.check_temp();

  wubottemp2.check_temp();

  delay(1000);
}

