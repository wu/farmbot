/*
 Triple Fade

 Fade a 3-color LED

 */

int redbrightness = 1;    // how bright the LED is
int redfadeAmount = 1;    // how many points to fade the LED by

int bluebrightness = 1;    // how bright the LED is
int bluefadeAmount = 1;    // how many points to fade the LED by

int greenbrightness = 1;    // how bright the LED is
int greenfadeAmount = 1;    // how many points to fade the LED by

void setup()  {

  // declare pin 9 to be an output:
  pinMode(11, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(9, OUTPUT);

}

void loop()  {
  // set the brightness of pin 9:
  analogWrite(11, greenbrightness);
  analogWrite(10, redbrightness);
  analogWrite(9, bluebrightness);

  // change the brightness for next time through the loop:
  redbrightness = redbrightness + redfadeAmount;
  if (redbrightness == 0 || redbrightness == 255 || random(100) > 95) {
    redfadeAmount = -redfadeAmount ;
  }

  bluebrightness = bluebrightness + bluefadeAmount;
  if (bluebrightness == 0 || bluebrightness == 255 || random(100) > 95) {
    bluefadeAmount = -bluefadeAmount ;
  }

  greenbrightness = greenbrightness + greenfadeAmount;
  if (greenbrightness == 0 || greenbrightness == 155 || random(100) > 95) {
    greenfadeAmount = -greenfadeAmount ;
  }

  delay(60);
}
