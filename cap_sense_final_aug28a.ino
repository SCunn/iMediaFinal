#include <CapacitiveSensor.h>
  //com 10
/*
 * CapitiveSense Library Demo Sketch
 * Paul Badger 2008
 * Uses a high value resistor e.g. 10M between send pin and receive pin
 * Resistor effects sensitivity, experiment with values, 50K - 50M. Larger resistor values yield larger sensor values.
 * Receive pin is the sensor pin - try different amounts of foil/metal on this pin
 */
int val1 = 0;
int val2 = 0;
int val3 = 0;
int val4 = 0;
int val5 = 0;
int inByte = 0;
CapacitiveSensor   cs_4_2 = CapacitiveSensor(4,2);        // 1M resistor between pins 4 & 2, pin 2 is sensor pin, add a wire and or foil if desired
CapacitiveSensor   cs_4_6 = CapacitiveSensor(4,6);        // 1M resistor between pins 4 & 6, pin 6 is sensor pin, add a wire and or foil
//CapacitiveSensor   cs_11_8 = CapacitiveSensor(11,8);        // 1M resistor between pins 4 & 8, pin 8 is sensor pin, add a wire and or foil
//CapacitiveSensor   cs_11_10 = CapacitiveSensor(11,10);        // 1M resistor between pins 4 & 8, pin 8 is sensor pin, add a wire and or foil
//CapacitiveSensor   cs_12_3 = CapacitiveSensor(12,3);        // 1M resistor between pins 4 & 8, pin 8 is sensor pin, add a wire and or foil

void setup()                    
{
    cs_4_2.set_CS_AutocaL_Millis(0xFFFFFFFF);     // turn off autocalibrate on channel 1 - just as an example
    cs_4_6.set_CS_AutocaL_Millis(0xFFFFFFFF);
//    cs_11_8.set_CS_AutocaL_Millis(0xFFFFFFFF);
//    cs_11_10.set_CS_AutocaL_Millis(0xFFFFFFFF);
//    cs_12_3.set_CS_AutocaL_Millis(0xFFFFFFFF);

   Serial.begin(9600);
   
   pinMode(2, INPUT);
  // pinMode(3, INPUT);
   pinMode(6, INPUT);
//   pinMode(8, INPUT);
//   pinMode(10, INPUT);  
   establishContact();     // send a byte to establish contact until receiver responds 
}

void loop()  {
  // if we get a valid byte, read inputs:
  if (Serial.available() > 0){
  // get incoming byte:
    inByte = Serial.read();
    //long start = millis();
    long total1 =  cs_4_2.capacitiveSensor(50);
    long total2 =  cs_4_6.capacitiveSensor(40);
//    long total3 =  cs_11_8.capacitiveSensor(10);
//    long total4 =  cs_11_10.capacitiveSensor(10);
//    long total5 =  cs_12_3.capacitiveSensor(10);
//    
val1 = map(total1, 450, 95, 0, 255);
val2 = map(total2, 420, 420, 0, 255);
//val3 = map(total3, 200, 140, 0, 255);
//val4 = map(total4, 100, 50, 0, 255);
//val5 = map(total4, 12, 11, 0, 255);

Serial.write(val1);
Serial.write(val2);
//Serial.write(val3);
////Serial.println(val2);
//Serial.write(val4);
////Serial.println(val2);//delay(50);
//Serial.write(val5);
//
//    Serial.print(millis() - start);        // check on performance in milliseconds
//    Serial.print("\t");                    // tab character for debug windown spacing

//                          CALIBRATE IN SERIAL MONITOR

//   Serial.println(total1);                  // print sensor output 1
//    Serial.print("\t");
//    Serial.println(total3);                  // print sensor output 2
//    Serial.print("\t");
//    Serial.println(total3);                // print sensor output 3

//    delay(10);                             // arbitrary delay to limit data to serial port 
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.print('A');
    delay(300);
    }


}

