#include <LiquidCrystal.h>

LiquidCrystal lcd(8, 9, 5, 4, 3, 2);

int serIn;
int line_length;
int line = 0;
int comma_count = 0;

void setup() {
  lcd.begin(16, 2);  
  lcd.setCursor(0, 0);
  Serial.begin(9600);
}

void loop() {

  while (Serial.available() > 0) {
    serIn = Serial.read();

    line_length++;

    if ( serIn == 13 ) {
      lcd.print( "   " );
      // nop
    }
    else if ( serIn == 10 ) {
      Serial.println();
      line_length = 0;
      comma_count = 0;

      line++;
      if ( line > 1 ) { line = 0; }
      lcd.setCursor( 0, line );
    }
    else if ( serIn == 44 ) {
      // comma
      comma_count++;

      if ( comma_count == 1 ) {
        lcd.setCursor( 0, line );
      }
      Serial.print( serIn, BYTE );
    }
    else {
      Serial.print( serIn, BYTE );
      lcd.print( serIn, BYTE );
    }
  }

  delay( 10 );
}

