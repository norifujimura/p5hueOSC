import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import java.io.*;

public class HUE {
  // Global variables
  // Hue objects
  String KEY,IP;
  HueHub hub; // the hub
  HueLight HL; // light instances

  int ID;  //Integer.toString(ID);
  int x, y;
  int w=100;
  int h=300;

  int r;
  int textSize=11;

  HUE(String KEY,String IP,int id, int x, int y) {
    this.KEY=KEY;
    this.IP=IP;
    this.ID=id;
    hub = new HueHub(KEY,IP);  
    HL=new HueLight(id,hub);
    this.x=x;
    this.y=y;
    setup();
  }

  void setup() {
    set(180,127,127,1);
  }

  void set(int hue, int saturation, int brightness,int transTime) {
    //transitiontme: 1=100ms 10=1sec
    //hue  0-360
    //brightness 0-255
    HL.setTransitiontime(transTime);
    HL.turnOn(hue, saturation, brightness);
  }

  void draw() {

    int hue=getHue();
    int sat=getSaturation();
    int brt=getBrightness();
    int trt=getTransitionTime();

    fill(hue, sat, brt);
    noStroke();
    rect(x, y,100,100);
    textSize(textSize);
    textAlign(LEFT, CENTER);
    
    fill(100);
    noStroke();
    int hueX=int(100.0/360.0*hue);
    rect(x,y+100,hueX,50);
     int satX=int(100.0/255.0*sat);
    rect(x,y+150,satX,50);
     int brtX=int(100.0/255.0*brt);
    rect(x,y+200,brtX,50);
     int timeX=trt;
    rect(x,y+250,timeX,50);
    
    fill(0);
    stroke(0);
    text("KEY:\n"+KEY+"\nIP:"+IP,x+5, y+25);
    text("ID:\n"+ID,x+5, y+75);
    text("HUE(0-360):\n"+hue, x+5, y+125);
    text("Saturation(0-255):\n"+sat,x+5, y+175);
    text("Brightness(0-255):\n"+brt,x+5, y+225);
    text("Transition\nTime(x0.1sec):"+trt, x+5, y+275);
    
    noFill();
    stroke(200);
    rect(x,y+100,w,50);
    rect(x,y+150,w,50);
    rect(x,y+200,w,50);
    rect(x,y+250,w,50);
    

  }

  public int getBrightness() {
    return HL.getBrightness();
  }

  public int getHue() {
    return HL.getHue();
  }

  public int getTransitionTime() {
    return HL.getTransitionTime();
  }

  public int getSaturation() {
    return HL.getSaturation();
  }
  
  public void onMouseDrag(int x,int y){
    println("onMouseDrag:"+ID+" X:"+x+" Y:"+y);
    if(100<y && y<150){
      int val=int((360.0/100.0)*x);
      println("set HUE:"+val);
      set(val,getSaturation(),getBrightness(),getTransitionTime());
    }
    
    if(150<y && y<200){
            int val=int((255.0/100.0)*x);
      println("set Saturation:"+val);
      set(getHue(),val,getBrightness(),getTransitionTime());
    }
    
    if(200<y && y<250){
             int val=int((255.0/100.0)*x);
      println("set Brightness:"+val);
      set(getHue(),getSaturation(),val,getTransitionTime());
    }
    
    if(250<y && y<300){
                   int val=x;
      println("set TransitionTime:"+val);
      set(getHue(),getSaturation(),getBrightness(),val);
    }
  }
  void stop() {
    // close connection to hub
    hub.disconnect();
  }
}

