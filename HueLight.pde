//modified by Nori Fujimura
//original is by jvandewiel
//
// https://github.com/jvandewiel/hue
// http://www.everyhue.com/vanilla/discussion/111/processinghue-disco-lights/p1

// Hue class; one instance represents a lamp which is addressed using number
class HueLight {
  private int id; // lamp number/ID as known by the hub, e.g. 1,2,3
  // light variables
  private int hue=0; //0 to 360
  private int hueRaw =0; //0 to 65535 hue value for the lamp 
  int hueRatio;
  private int saturation = 255; // saturation value
  private int  brightness = 255; // brightness
  private boolean lightOn = false; // is the lamp on or off, true if on?
  //private byte transitiontime = 0; // transition time, how fast  state change is executed -> 1 corresponds to 0.1s
 private int transitiontime = 1   ; // transition time, how fast  state change is executed -> 1 corresponds to 0.1s
  // hub variables
  private HueHub hub; // hub to register at
  private String name = "noname"; // set when registering the lamp with the hub
  // graphic settings
  private byte radius = 40; // size of the ellipse drawn on screen
  private int x; // x position on screen
  private int y; // y position on screen


  // constructor, requires light ID and hub
  public HueLight(int lightID, HueHub aHub) {
    id = lightID;
    hub = aHub;
    // check if registered, get name [not implemented]
    name = hub.getLightName(this);
    hueRatio=65535/360;
  }

  // set the hue value; if outside bounds set to min/max allowed
  public void setHue(int hueValue) {
    hue=hueValue;
    hueRaw = hueValue*hueRatio;
    if (hueRaw < 0 || hueRaw > 65535) {
      hue = 0;
      hueRaw=0;
    }
  }

  // set the brightness value, max 255
  public void setBrightness(int bri) {
    brightness = bri;
  }

  // set the saturation value, max 255
  public void setSaturation(int sat) {
    saturation = sat;
  }

  // set the tranistion time; 1 = 0.1sec (not sure if there is a max)
  public void setTransitiontime(int transTime) {
    transitiontime = transTime;
  }

  // returns true if the light is on (based on last state change, not a query of the light) 
  public boolean isOn() {
    return this.lightOn;
  }

  /*
   have the changes to the settings applied to the lamp & visualize; this
   calls the hub which handles the actual updates of the lights
   */
  public void update() {
    hub.applyState(this);
    // debugging
    // println("send update " + id);
  }

  // convenience method to turn the light off
  public void turnOff() {
    this.lightOn = false;
    update();
  }

  // convenience method to turn the light on
  public void turnOn() {
    this.lightOn = true;
    update(); // apply new state
  }

  // convenience method to turn the light on with some passed settings
  public void turnOn(int hue,int saturation, int brightness) {
    this.lightOn = true;
    this.hue=hue;
    this.hueRaw = hue*hueRatio;
    this.saturation=saturation;
    this.brightness = brightness;
    
    if (brightness < 20 && lightOn) { // 20 is arbitrary threshold, could be higher/lower
      brightness = 0;
      lightOn=false;
      //update();
    }
    
    update(); // apply new state
  }

  /* 
   return data with lamp settings, JSON formatted string, to be send to hub
   sometimes after a while you get an error message that the light is off
   and it won’t change, even when it’s actually on. You can work around 
   this by always turning the light on first. 
   */
  public String getData() {
    StringBuilder data = new StringBuilder("{");
    data.append("\"on\" :"); 
    data.append(lightOn);
    // only if the light is on we need the rest
    if (lightOn) {
      data.append(", \"hue\":");
      data.append(hueRaw);
      data.append(", \"bri\":");
      data.append(brightness);
      data.append(", \"sat\":");
      data.append(saturation);
    }
    // always send transition time, to control how fast the state is changed
    data.append(", \"transitiontime\":");//1= 100ms 10=1sec
    data.append(transitiontime);
    data.append("}");
    return data.toString();
  }

  // get current values
  public int getBrightness() {
    return brightness;
  }

  public int getSaturation() {
    return saturation;
  }

  public int getHue() {
    return hue;//0-360
  }
  
    public int getHueRaw() {
    return hueRaw;//0-65535
  }
  
  public int getTransitionTime() {
    return transitiontime;
  }

  public int getID() {
    return id;
  }

  /*
   dim the light using damping factor; if brightness < x and lighton then turn if
   this could allow for smoother on/off changes but also risk for hub errors (to any changes) 
   */
  public void dim() {
    /*
    brightness *= damping;
    if (brightness < 20 && lightOn) { // 20 is arbitrary threshold, could be higher/lower
      brightness = 0;
      lightOn=false;
      update();
    }
    */
  }
}
