/*
 *
 */

#include "Wire.h"
#include <WubotTemperature.h>
#include <LibTemperature2.h>

#include <ArduinoUnit.h>

LibTemperature2 temp1 = LibTemperature2( 0x2A );
WubotTemperature wubottemp = WubotTemperature( &temp1, "test1" );



// Create test suite
TestSuite suite;

void setup() {
}

test(check) {
  assertTrue( wubottemp.check() );
}

test(lasttemp) {
  float temp = wubottemp.check();
  assertEquals( temp, wubottemp.get_lasttemp() );
}

void loop() {
  // Run test suite, printing results to the serial port
  suite.run();
}

