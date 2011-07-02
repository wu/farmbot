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
#include <WubotHumidity.h>

WubotHumidity wubothumidity = WubotHumidity( 0, "test1" );

void setup() {
  Serial.begin(9600);

}

void loop() {

  // check humidity assuming temp is 70 degrees
  wubothumidity.check( 70 );

  delay(1000);
}
