/****************************
 *
 * temperature
 *
 *  send temperature reading and any changes to serial output.  if
 *  temp does not change for longer than maxupdate (60 seconds),
 *  refresh the current temperature out to the serial.
 *
 *****************************/
#include "Wire.h"
#include <WubotTemperature.h>
#include <LibTemperature2.h>

WubotTemperature wubottemp = WubotTemperature( 0x2A, "test" );

void setup() {
  Serial.begin(9600);

}

void loop() {

  wubottemp.check_temp();

  delay(1000);
}


