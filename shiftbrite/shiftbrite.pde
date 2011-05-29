/*
 * ShiftBrite.pde
 *
 * Fade a shiftbrite by cycling the hue
 *
 * http://www.easyrgb.com/index.php?X=MATH
 * http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1207331496
 *
 */

#include "HughesyShiftBrite.h"

HughesyShiftBrite sb;

float h = 0;
float h_fade = .001;

int h_int;
int r=0, g=0, b=0;

int val=0;

void h2rgb(float h, int &R, int &G, int &B);

void setup() {
  sb = HughesyShiftBrite(10,11,12,13);
  sb.sendColour(0,0,100);
  Serial.begin(9600);
}


void loop()  {

  h += h_fade;

  if ( h > 1 ) {
    h = 0;
  }
  
  h_int = (int) 360*h;

  h2rgb(h,r,g,b);

  sb.sendColour( r, g, b);

  Serial.print( ", h=" );
  Serial.print( h );
  Serial.print( ", r=" );
  Serial.print( r );
  Serial.print( ", g=" );
  Serial.print( g );
  Serial.print( ", b=" );
  Serial.println( b );

  delay( 10 );

}

void h2rgb(float H, int& R, int& G, int& B) {

  int var_i;
  float S=1, V=1, var_1, var_2, var_3, var_h, var_r, var_g, var_b;

  if ( S == 0 )                       //HSV values = 0 ÷ 1
  {
    R = V * 1000;
    G = V * 1000;
    B = V * 1000;
  }
  else
  {
    var_h = H * 6;
    if ( var_h == 6 ) var_h = 0;      //H must be < 1
    var_i = int( var_h ) ;            //Or ... var_i = floor( var_h )
    var_1 = V * ( 1 - S );
    var_2 = V * ( 1 - S * ( var_h - var_i ) );
    var_3 = V * ( 1 - S * ( 1 - ( var_h - var_i ) ) );

    if      ( var_i == 0 ) {
      var_r = V     ;
      var_g = var_3 ;
      var_b = var_1 ;
    }
    else if ( var_i == 1 ) {
      var_r = var_2 ;
      var_g = V     ;
      var_b = var_1 ;
    }
    else if ( var_i == 2 ) {
      var_r = var_1 ;
      var_g = V     ;
      var_b = var_3 ;
    }
    else if ( var_i == 3 ) {
      var_r = var_1 ;
      var_g = var_2 ;
      var_b = V     ;
    }
    else if ( var_i == 4 ) {
      var_r = var_3 ;
      var_g = var_1 ;
      var_b = V     ;
    }
    else                   {
      var_r = V     ;
      var_g = var_1 ;
      var_b = var_2 ;
    }

    R = (1-var_r) * 999 + 1;                  //RGB results = 0 ÷ 255
    G = (1-var_g) * 999 + 1;
    B = (1-var_b) * 999 + 1;
  }
}
