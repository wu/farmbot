#include <LiquidCrystal.h>

LiquidCrystal lcd(8, 9, 5, 4, 3, 2);

int serIn;

void setup() {
  lcd.begin(16, 2);  
  lcd.setCursor(0, 0);
  Serial.begin(9600);
}

void loop() {

  while (Serial.available() > 0) {
    serIn = Serial.read();

    if ( serIn == 13 ) {
      lcd.print( "   " );
      // nop
    }
    else if ( serIn == 10 ) {
      Serial.println();
      lcd.setCursor(0, 0);
    }
    else {
      Serial.print(serIn, BYTE);
      lcd.print( serIn, BYTE );
    }
  }

  delay( 10 );
}

