import processing.serial.*;

Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port
int h = 100; //Height
int s = 190; //Stretch
int r = 90; //Rotation
int interval = 10;  
int speed = 10000; // mm per minute
boolean moving = false;
boolean camera = false;
int lastSetialCommand;
PolarPositionSelector Selector;

public class Constrains
{
  // mm and degrees 
  public static final int minHeight = -50; 
  public static final int maxHeight = 150; 
  public static final int minStretch = 95;
  public static final int maxStretch = 330; 
  public static final int maxAngle = 180; 
};

void setup() {
  size(800, 800);
  println(Serial.list()); 
  String portName = Serial.list()[2]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 115200);
  myPort.bufferUntil('\n');
  delay(1000);
  // myPort.write("P2221");
  Selector = new PolarPositionSelector();
}

void draw() {
  background(255);
  noStroke();
  Selector.update();
}

boolean setPolarPosition() {
  setPolarPosition(s, r, h, 10000);
  return false;
}

boolean setPolarPosition(int st, int ro, int he, int speed) {
  println("G2201 S"+st+" R"+ro+" H"+he+" F"+speed);
  writeSerial("G2201 S"+st+" R"+ro+" H"+he+" F"+speed);
  return false;
}

boolean setHeight(int he, int speed) {
  writeSerial("G2205 S10 R10 H10 F1000"); // relative displacement
  return false;
}


void writeSerial(String CMD) {
// block sending message untill 100 millis have ellapsed to avoid flooding buffer
  while(lastSetialCommand>millis()-100) {
    delay(1);
   // wait... 
  }
   myPort.write(CMD);
   myPort.write("\n");
   lastSetialCommand = millis();
}

void serialEvent(Serial myPort) {
  //put the incoming data into a String - 
  //the '\n' is our end delimiter indicating the end of a complete packet
  val = myPort.readStringUntil('\n');
  //make sure our data isn't empty before continuing
  if (val != null) {
    //trim whitespace and formatting characters (like carriage return)
    println("return value:"+val);
    if (val.equals("ok") || val.equals("E22")) {
      moving = false;
    }
  }
}
