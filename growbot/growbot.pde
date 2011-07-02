#include "Wire.h"

#include <WubotTemperature.h>
#include <LibTemperature2.h>

#include "WubotSoilMoisture.h";

LibTemperature2 temp1 = LibTemperature2( 0x2A );
WubotTemperature wubottemp = WubotTemperature( &temp1, "growbot" );

WubotSoilMoisture vegetronix = WubotSoilMoisture( 0, "growbot" );

void setup() {
  Serial.begin(9600);

}

void loop() {

  wubottemp.check();

  vegetronix.check();
  
  delay(1000);
}

