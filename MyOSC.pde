//Nov6th 1st made. modified from "oscP5message" example
//Nov19th modified for LimeLight 
import oscP5.*;
import netP5.*;

public class MyOSC {
  OscP5 oscP5;
  int RCVPORT;
  String HOST,MODE;
  int LightPort=10000;
  int TableAPort=10010;
  int TableASensorPort=10011;
  int TableBPort=10020;
  int TableCPort=10030;
  
  NetAddress Light, TableA,TableASensor,TableB, TableC;

  MyOSC(Object theParent, String mode) {
    
    this.HOST="10.0.1.255";//multicast
    this.MODE=mode;
    if (MODE.equals("Lights")) {
      this.RCVPORT=LightPort;
    }
    if (MODE.equals("TableA")) {
      this.RCVPORT=TableAPort;
    }
    if (MODE.equals("TableA/Sensor")) {
      this.RCVPORT=TableASensorPort;
    }
    if (MODE.equals("TableB")) {
      this.RCVPORT=TableBPort;
    }
    if (MODE.equals("TableC")) {
      this.RCVPORT=TableCPort;
    }
    oscP5 = new OscP5(theParent,RCVPORT);
    
    Light=new NetAddress(HOST,LightPort);
    TableA=new NetAddress(HOST,TableAPort);
    TableASensor=new NetAddress(HOST,TableASensorPort);
    TableB=new NetAddress(HOST,TableBPort);
    TableC=new NetAddress(HOST,TableCPort);
    
  }

  void sendLight(String header, int time, int hue, int sat, int bri) {
    OscMessage myMessage = new OscMessage(header);
    myMessage.add(time); 
    myMessage.add(hue); 
    myMessage.add(sat); 
    myMessage.add(bri);
    oscP5.send(myMessage,Light);
  }

  /* incoming osc message are forwarded to the oscEvent method. */
  void oscEvent2(OscMessage theOscMessage) {
    /* print the address pattern and the typetag of the received OscMessage */
    print("### received an osc message.");
    print(" addrpattern: "+theOscMessage.addrPattern());
    print(" typetag: "+theOscMessage.typetag());
    String content= theOscMessage.get(0).stringValue();
    print(" String: "+content);
    float mean= theOscMessage.get(1).floatValue();
    println(" Mean: "+mean);
  }
}

