import processing.serial.*;
import oscP5.*;
import netP5.*;  
OscP5 oscP5;
NetAddress puredata;
Serial myPort;        // The serial port
Serial myPort2;       // serial port for com6
int[] serialInArray = new int[2];    //where we will put what we receive
int serialCount = 0;                // A count of how many bytes we receive
int Lchange = 0;                  // where the left sensor values are stored
int Rchange = 0;  // where the right sensor values are stored
int ButtonL = 0;
int ButtonM = 0;
int ButtonR = 0;
int[] y;
int[] x;
boolean firstContact = false;    //wehether we've heard from the microcontroller

///////////////////////////   check time setup
int downcount = 0;          // 
int mintime = 200;
int stateRead = 0;
////////////////////////////

void setup(){
  fullScreen();
  //size(1000,1000);
  noStroke();          //no border on the next thing drawn
  y = new int[width];
  x = new int[width];
  printArray(Serial.list());
  myPort = new Serial(this, "COM10", 9600);
  /////////////////////setup for two arduinos
  
 // myPort2 = new Serial(this, "COM6", 9600);
  
  oscP5 = new OscP5(this,12000);
  
  puredata = new NetAddress("127.0.0.1",8000); 

}

void draw() {
  background(0);
  
noCursor();
  stroke(0,255,0);
  for (int i = y.length-1; i > 0; i--) {
    y[i] = y[i-1];
  }
  // Add new values to the beginning
  y[0] = Lchange;
  // Display each pair of values as a line
  for (int i = 1; i < y.length; i++) {
    line(i, y[i], i-1, y[i-1]);
  }
  
   stroke(255,0,0);
  for (int ii = x.length-1; ii > 0; ii--) {
    x[ii] = x[ii-1];
  }
  // Add new values to the beginning
  x[0] = Rchange;
  // Display each pair of values as a line
  for (int ii = 1; ii < x.length; ii++) {
    line(ii, x[ii], ii-1, x[ii-1]);
  }
  
  stroke(0,255,0);
  fill(0,Lchange,0);
  ellipse(200,450,300,300);
  fill(0,Rchange,0);
  ellipse(1100,450,300,300);
  
  //stroke(255,255,ButtonL);
  // fill(255,255,ButtonL);
  //ellipse(800,400,100,100);        //
  //stroke(255,ButtonR,ButtonR);
  // fill(255,ButtonR,ButtonR);
  //ellipse(500,400,100,100);
  //  stroke(255,ButtonM,255);
  // fill(255,ButtonM,255);
  //ellipse(650,600,100,100);
  

}
void serialEvent(Serial myPort) {
 // read a bytefrom the serial port:
  int inByte = myPort.read();
  // if this is the first byte received, and it's an A,
  //clear the serial buffer and note that you've
  //had first contact from the microcontroller.
  //Otherwise, add the incoming byte to the array:
  if (firstContact == false) {
    if (inByte == 'A') {
      myPort.clear();         // clear the serial port buffer
      firstContact = true;    //you've had first contact from the arduino
      myPort.write('A');      // ask for more
    }   
  }
  else {
    // Add the latest byte from the serial port to array:
    serialInArray[serialCount] = inByte;
    serialCount++;
    // If we have 3 bytes;
    if (serialCount > 1) {                // must be equal to amount of sensors
      Lchange = serialInArray[0];
      if (serialInArray[0] < 150) {
        Lchange = 0;
      }  
      
      
      Rchange = serialInArray[1];
       if (serialInArray[1] < 170) {
        Rchange = 0;
      }// 
      //ButtonL = serialInArray[2];
      //if (serialInArray[1] < 320) {
      //  ButtonL = 0;
      //} 
      //ButtonM = serialInArray[3];
      //if (serialInArray[1] < 500) {
      //  ButtonM = 0;
      //} 
      //ButtonR = serialInArray[4];
      //if (serialInArray[1] < 253) {
      //  ButtonR = 0;
      //} 
      // print the values (for debugging purposes only):
      println(Lchange + "\t" + Rchange);// + "\t" + ButtonL + "\t" + ButtonM + "\t" + ButtonR);   
      OscMessage msg = new OscMessage("/test");   
         msg.add(Lchange);
         msg.add(Rchange);
         //msg.add(ButtonL);
         //msg.add(ButtonR);
         //msg.add(ButtonM);
         oscP5.send(msg, puredata);
      // Send a capital A to request new sensor readings:
      myPort.write('A');
      //Reset serialCount:
      serialCount = 0;
    }
  }
//}
  
  //boolean checkTime(){
  //  downcount--;
  //  if(downcount == 0)
  //  {
  //    downcount = mintime + serialInArray[0];
  //    return(true);
  //  }
  //  else
  //{
  //  return(false);
    
  //  }
  }