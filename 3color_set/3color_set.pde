/*
  Blink
  Turns on an LED on for one second, then off for one second, repeatedly.
 
  This example code is in the public domain.
 */

int red = random(255);
int blue = random(255);
int green = random(255);

void setup() {                
  // initialize the digital pin as an output.
  // Pin 13 has an LED connected on most Arduino boards:
  pinMode(7, INPUT);

  pinMode(11, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(9, OUTPUT);
  
}

void loop() {

  int val = digitalRead(7);
  
  if ( val == HIGH ) {
      int red = random(255);
      int blue = random(255);
      int green = random(255);

      analogWrite(11, green);
      analogWrite(10, red);
      analogWrite(9, blue);
      
      delay( 500 );
   }

}
