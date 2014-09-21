//Nov6th2013 1st made. 
//modified from "oscP5message" example
//Noriyuki Fujimura
//nori_fujimura@me.com

import oscP5.*;
import netP5.*;

public class OSC {
  OscP5 oscP5;
  NetAddress myRemoteLocation;
  int RPORT;
  int SPORT;
  String HOST;

  OSC(Object theParent, int SNDPort, int RCVPort, String RHost) {
    this.RPORT=RCVPort;
    this.SPORT=SNDPort;
    this.HOST=RHost;

    /* start oscP5, listening for incoming messages at port 12000 */
    oscP5 = new OscP5(theParent, RPORT);
    myRemoteLocation = new NetAddress(HOST, SPORT);
  }

  void sendInt(String header, int val) {
    /* in the following different ways of creating osc messages are shown by example */
    //OscMessage myMessage = new OscMessage("/test");
    OscMessage myMessage = new OscMessage(header);
    myMessage.add(val); /* add an int to the osc message */

    /* send the message */
    oscP5.send(myMessage, myRemoteLocation);
  }

  void sendLight(String header, int time, int hue, int sat, int bri) {
    OscMessage myMessage = new OscMessage(header);
    myMessage.add(time); 
    myMessage.add(hue); 
    myMessage.add(sat); 
    myMessage.add(bri);
    oscP5.send(myMessage, myRemoteLocation);
  }

  void sendStringAndFloat(String header, String s, float f) {
    OscMessage myMessage = new OscMessage(header);
    myMessage.add(s); 
    myMessage.add(f); 
    /* send the message */
    oscP5.send(myMessage, myRemoteLocation);
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

