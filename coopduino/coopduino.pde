/****************************
 * Super CoopDuino
 *****************************/
#include "Wire.h"
#include <LibTemperature.h>
#include <LiquidCrystal.h>

#define DS1307_ADDRESS 0x68

LibTemperature temp = LibTemperature(0);
LiquidCrystal lcd(8, 9, 5, 4, 3, 2);

int redpin   = 13;
int bluepin  = 12;
int greenpin = 11;

int mytemp;
int tempcount = 0;
int last_temp = 0;


void setup() {

  Wire.begin();

  pinMode( redpin,   OUTPUT );
  pinMode( bluepin,  OUTPUT );
  pinMode( greenpin, OUTPUT );

  lcd.begin(16, 2);

  Serial.begin( 9600 );
  Serial.println( "Initialized" );

  //lcd.print( "SuperCoopduino" );

}


void loop() {

  lcd.setCursor(0, 0);
  printDate();

  tempcount = 0;

  mytemp = temp.GetTemperature()  * 9 / 5 + 32;

  lcd.setCursor(0, 1);
  lcd.print( "temp: " );
  lcd.print( mytemp );
  lcd.print( " F" );

  if ( last_temp != mytemp ) {
    last_temp = mytemp;

    Serial.print( "temp, " );
    Serial.println( mytemp );

    if ( mytemp > 85 ) {
      digitalWrite(redpin, HIGH);
      digitalWrite(bluepin,  LOW);
      digitalWrite(greenpin, LOW);
    }
    else if ( mytemp < 75 ) {
      digitalWrite(redpin, LOW);
      digitalWrite(bluepin, HIGH);
      digitalWrite(greenpin, LOW);
    }
    else {
      digitalWrite(redpin, LOW);
      digitalWrite(bluepin,  LOW);
      digitalWrite(greenpin, HIGH);
    }
  }

  delay(1000);
}



byte bcdToDec(byte val)  {
// Convert binary coded decimal to normal decimal numbers
  return ( (val/16*10) + (val%16) );
}

void printDate(){

  // Reset the register pointer
  Wire.beginTransmission(DS1307_ADDRESS);
  Wire.send(0);
  Wire.endTransmission();

  Wire.requestFrom(DS1307_ADDRESS, 7);

  int second = bcdToDec(Wire.receive());
  int minute = bcdToDec(Wire.receive());
  int hour = bcdToDec(Wire.receive() & 0b111111); //24 hour time
  int weekDay = bcdToDec(Wire.receive()); //0-6 -> sunday - Saturday
  int monthDay = bcdToDec(Wire.receive());
  int month = bcdToDec(Wire.receive());
  int year = bcdToDec(Wire.receive());

  //print the date EG   3/1/11 23:59:59
  //lcd.print(month);
  //lcd.print("/");
  //lcd.print(monthDay);
  //lcd.print("/");
  //lcd.print(year);
  //lcd.print(" ");
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

