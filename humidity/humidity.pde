float val = 0;
float RH = 0;
float ZeroPercentVoltage = 0.8;

void setup()
{
  Serial.begin(9600);
}

void loop()
{
  val = analogRead(0);

  delay(500);

  int my_room_temperature = 70;

  float max_voltage = ( 3.27 - ( 0.00372549 * my_room_temperature ) ) ; // The max voltage value drops down 0.00372549 for each degree F over 32F. The voltage at 32F is 3.27 (corrected for zero precent voltage)

  float RH = ( ( ( ( val / 1023 ) * 5 ) - ZeroPercentVoltage ) / max_voltage ) * 100;
  
  Serial.println(RH);

  delay(500);            
} 

