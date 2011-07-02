/****************************
 *
 * humidity
 *
 *  send humidity reading and any changes greater than 5% to serial
 *  output.  if humidity does not change for longer than maxupdate (60
 *  seconds), refresh the current temperature out to the serial.
 *
 *  note that measuring the humidity requires measuring the temperature
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
