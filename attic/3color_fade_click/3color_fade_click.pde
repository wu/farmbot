int redbrightness = 100;    // how bright the LED is
int redfadeAmount = 5;    // how many points to fade the LED by

int bluebrightness = 100;    // how bright the LED is
int bluefadeAmount = 5;    // how many points to fade the LED by

int greenbrightness = 100;    // how bright the LED is
int greenfadeAmount = 5;    // how many points to fade the LED by

int fademode = 1;

void setup() {
  // initialize the digital pin as an output.
  // Pin 13 has an LED connected on most Arduino boards:
  pinMode(7, INPUT);

  pinMode(11, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(9, OUTPUT);

}

void loop()  {
  int val = digitalRead(7);

  if ( val == HIGH ) {
    if ( fademode == 1 ) {
      fademode = 0;
    }
    else {
      fademode = 1;
    }
  }

  if ( fademode == 1 ) {
    // set the brightness of pin 9:
    analogWrite(11, greenbrightness);
    analogWrite(10, redbrightness);
    analogWrite(9, bluebrightness);

    // change the brightness for next time through the loop:

    redbrightness = redbrightness + redfadeAmount;
    if ( redbrightness < 1 ) {
      redfadeAmount = random(5) + 1;
      redbrightness = 0;
    }
    else {
      if ( redbrightness > 254 ) {
        redfadeAmount = -random(5) - 1;
        redbrightness = 255;
      }
    }

    bluebrightness = bluebrightness + bluefadeAmount;
    if ( bluebrightness < 1 ) {
      bluefadeAmount = random(5) + 1;
      bluebrightness = 0;
    }
    else {
      if ( bluebrightness > 254 ) {
        bluefadeAmount = -random(5) - 1;
        bluebrightness = 255;
      }
    }


    greenbrightness = greenbrightness + greenfadeAmount;
    if ( greenbrightness < 1 ) {
      greenfadeAmount = random(5) + 1;
      greenbrightness = 0;
    }
    else {
      if ( greenbrightness > 254 ) {
        greenfadeAmount = -random(5) - 1;
        greenbrightness = 255;
      }
    }

    if ( greenbrightness + redbrightness + bluebrightness > 500 ) {
      if ( greenbrightness > 150 ) {
        greenfadeAmount = -random(5) - 1;
      }
      if ( redbrightness > 150 ) {
        redfadeAmount = -random(5) - 1;
      }
      if ( bluebrightness > 150 ) {
        bluefadeAmount = -random(5) - 1;
      }
    }

    delay(60);
  }
}
