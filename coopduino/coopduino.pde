/****************************
 * Super CoopDuino
 *****************************/
#include "Wire.h"
#include <LibTemperature.h>
#include <LiquidCrystal.h>

#define DS1307_ADDRESS 0x68

LibTemperature temp = LibTemperature(0);
LiquidCrystal lcd(8, 9, 5, 4, 3, 2);

int temp_max         = 75;
int temp_min         = 65;

float lasttemp  = 0;
float mindiff   = 1;
float newtemp   = 0;
int showtemp    = 0;

long elapsed;
long lastupdate = 0;
long maxupdate  = 60000;


int redpin           = 13;
int bluepin          = 12;
int greenpin         = 11;

int powerpin         = 10;

int light_state      = 0;
int last_light_state = 2;

int mytemp;
int last_temp        = 0;

void setup() {

  Wire.begin();

  pinMode( redpin,   OUTPUT );
  pinMode( bluepin,  OUTPUT );
  pinMode( greenpin, OUTPUT );

  pinMode( powerpin, OUTPUT );

  lcd.begin(16, 2);

  Serial.begin( 9600 );
  Serial.println( "SuperCoopduino Initialized" );
}


void loop() {

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

  // Light Control
  if ( hour < 10 || hour > 22 ) {
    light_state = 0;
  }
  else {
    light_state = 1;
  }
  if ( light_state != last_light_state ) {
    last_light_state = light_state;
    lcd.setCursor(11, 0);

    lcd.print( "l=" );

    if ( light_state == 0 ) {
      digitalWrite( powerpin, LOW );
      lcd.print( "off" );
    }
    else {
      digitalWrite( powerpin, HIGH );
      lcd.print( "on " );
    }
  }

  // TEMPERATURE
  newtemp = temp.GetTemperature();

  elapsed = millis() - lastupdate;

  float tempchange = abs( lasttemp - newtemp );
  if ( tempchange > mindiff ) {
    // temperature changed
    showtemp = 1;
  }
  else if ( elapsed > maxupdate ) {
    // refresh the display
    showtemp = 1;
  }

  // display
  if ( showtemp ) {
    showtemp = 0;

    float newtempf = newtemp * 9 / 5 + 32;
    Serial.print( "coop, temp, " );
    Serial.print(  newtempf );
    Serial.println( ", F" );

    lcd.setCursor(0, 1);
    lcd.print( "temp: " );
    lcd.print( newtempf );
    lcd.print( " F" );

    lasttemp = newtemp;
    lastupdate = millis();
    
    lcd.setCursor(11, 1);

    if ( newtempf > temp_max ) {
      digitalWrite(redpin, HIGH);
      digitalWrite(bluepin,  LOW);
      digitalWrite(greenpin, LOW);
      lcd.print( "high" );
    }
    else if ( newtempf < temp_min ) {
      digitalWrite(redpin, LOW);
      digitalWrite(bluepin, HIGH);
      digitalWrite(greenpin, LOW);
      lcd.print( "low " );
    }
    else {
      digitalWrite(redpin, LOW);
      digitalWrite(bluepin,  LOW);
      analogWrite(greenpin, HIGH);
      lcd.print( "ok  " );
    }
  }


  delay(1000);
}


byte bcdToDec(byte val)  {
// Convert binary coded decimal to normal decimal numbers
  return ( (val/16*10) + (val%16) );
}
