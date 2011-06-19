/****************************
 * Super CoopDuino
 *****************************/
#include "Wire.h"
#include <LiquidCrystal.h>

#include <LibTemperature2.h>
#include <WubotTemperature.h>

#include "HughesyShiftBrite.h"
#include "WubotStatusLight.h";

#define DS1307_ADDRESS 0x68

LibTemperature2 temp1 = LibTemperature2( 0x2A );
WubotTemperature wubottemp1 = WubotTemperature( &temp1, "coop" );

LibTemperature2 temp2 = LibTemperature2( 0x1C );
WubotTemperature wubottemp2 = WubotTemperature( &temp2, "outside" );

WubotStatusLight statuslight = WubotStatusLight( 9, 10, 11, 0 );

int lcd_flag = 1;
LiquidCrystal lcd(7, 6, 5, 4, 3, 2);

int status;

int temp_max         = 90;
int temp_min         = 60;

int powerpin         = 12;

int light_state      = 0;
int last_light_state = 2;

int loop_counter     = 0;

void setup() {

  Wire.begin();

  pinMode( powerpin, OUTPUT );

  if ( lcd_flag == 1 ) {
    lcd.begin(16, 2);
  }

  // dim the status light
  statuslight.set_scale(10);  

  statuslight.setup();

  Serial.begin( 9600 );
  Serial.println( "SuperCoopduino Initialized" );
}


void loop() {

  loop_counter++;

  if ( loop_counter > 10 ) {
    loop_counter = 0;

    // TIME
    Wire.beginTransmission(DS1307_ADDRESS);
    Wire.send(0);
    Wire.endTransmission();
    Wire.requestFrom(DS1307_ADDRESS, 7);

    int second = bcdToDec(Wire.receive());
    int minute = bcdToDec(Wire.receive());
    int hour = bcdToDec(Wire.receive() ); //24 hour time
    int weekDay = bcdToDec(Wire.receive()); //0-6 -> sunday - Saturday
    int monthDay = bcdToDec(Wire.receive());
    int month = bcdToDec(Wire.receive());
    int year = bcdToDec(Wire.receive());

    if ( lcd_flag == 1 ) {
      lcd.setCursor(0, 0);
      if ( hour < 10 ) {
        lcd.print( "0" );
      }
      lcd.print(hour);
      lcd.print(":");
      if ( minute < 10 ) {
        lcd.print( "0" );
      }
      lcd.print(minute);
      lcd.print(":");
      if ( second < 10 ) {
        lcd.print( "0" );
      }
      lcd.print(second);
    }

    // Light Control
    if ( hour < 10 || hour > 22 ) {
      light_state = 0;
    }
    else {
      light_state = 1;
    }
    if ( light_state != last_light_state ) {
      last_light_state = light_state;

      if ( lcd_flag == 1 ) {
        lcd.setCursor(11, 0);
        lcd.print( "l=" );
      }

      if ( light_state == 0 ) {
        digitalWrite( powerpin, LOW );

        if ( lcd_flag == 1 ) {
          lcd.print( "off" );
        }
      }
      else {
        digitalWrite( powerpin, HIGH );
        if ( lcd_flag == 1 ) {
          lcd.print( "on " );
        }
      }
    }

    // TEMPERATURE
    wubottemp2.check();

    float newtempf = wubottemp1.check();

    if ( lcd_flag == 1 ) {
      lcd.setCursor(0, 1);
      lcd.print( "temp: " );
      lcd.print( newtempf );
      lcd.print( " F" );

      lcd.setCursor(11, 1);
    }

    if ( newtempf > temp_max ) {
      status = 1;
      if ( lcd_flag == 1 ) {
        lcd.print( "high" );
      }
    }
    else if ( newtempf < temp_min ) {
      status = 2;
      if ( lcd_flag == 1 ) {
        lcd.print( "low " );
      }
    }
    else {
      status = 0;
      if ( lcd_flag == 1 ) {
        lcd.print( "ok  " );
      }
    }
  }

  statuslight.update_status( status );

  delay(100);
}


byte bcdToDec(byte val)  {
// Convert binary coded decimal to normal decimal numbers
  return ( (val/16*10) + (val%16) );
}
