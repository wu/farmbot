/*
 *  officebot
 *
 *  monitors temperature in the office.  the office tends to heat up
 *  quickly on hot days unless the windows are open and the fan is on,
 *  so we have to make sure the laptops don't overheat.
 *
 *  has an LCD to display temp.  eventually would like to send temps
 *  or warnings from some other bots here, but i haven't tried that yet.
 *
 *  uses a shiftbrite attached to a status beacon, which flashes an
 *  alert when the temperature starts to get too high.  eventually
 *  this status beacon might report any problems states on any of the
 *  bots.
 *
 */

#include "Wire.h"
#include <LiquidCrystal.h>

#include <WubotTemperature.h>
#include <LibTemperature2.h>

#include "HughesyShiftBrite.h"
#include "WubotStatusLight.h";

LibTemperature2 temp1 = LibTemperature2( 0x2A );
WubotTemperature wubottemp = WubotTemperature( &temp1, "office" );

HughesyShiftBrite sb = HughesyShiftBrite( 11, 10, 9, 8 );
WubotStatusLight statuslight = WubotStatusLight( &sb );

LiquidCrystal lcd(7, 6, 2, 3, 4, 5 );

int loopcount;

int status;

void setup() {
  lcd.begin( 16, 2 );
  statuslight.setup();

  Serial.begin( 9600 );
  Serial.println( "OfficeBot Initialized" );
}

void loop() {

  loopcount++;

  if ( loopcount > 10 ) {
    loopcount = 0;

    float temp = wubottemp.check();

    if ( temp > 85 ) {
      status = 1;
    }
    else if ( temp > 95 ) {
      status = 2;
    }
    else {
      status = 0;
    }

    lcd.setCursor( 0, 0 );
    lcd.print( "temp: " );
    lcd.print( temp );
    lcd.print( " F" );
  }

  statuslight.update_status( status );

  delay(100);
}

