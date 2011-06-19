/*
 *
 */

#include "Wire.h"
#include <LiquidCrystal.h>

#include <WubotTemperature.h>
#include <LibTemperature2.h>

#include "HughesyShiftBrite.h"
#include "WubotStatusLight.h";

LibTemperature2 temp1 = LibTemperature2( 0x2A );
WubotTemperature wubottemp = WubotTemperature( &temp1, "livingroom" );

HughesyShiftBrite sb = HughesyShiftBrite( 11, 10, 9, 8 );
WubotStatusLight statuslight = WubotStatusLight( &sb );

LiquidCrystal lcd(7, 6, 2, 3, 4, 5 );

int loopcount;

void setup() {
  lcd.begin(0, 0);
  statuslight.setup();

  Serial.begin( 9600 );
  Serial.println( "Devduino Initialized" );
}

void loop() {

  Serial.println( "Looping..." );

  loopcount++;

  if ( loopcount % 100 == 1 ) {

    float temp = wubottemp.check();

    lcd.setCursor(0, 1);
    //lcd.print( "lr=" );
    lcd.print( temp );
    Serial.println( temp );
  
  }

  statuslight.update_status( 0 );

  delay(10);
}

