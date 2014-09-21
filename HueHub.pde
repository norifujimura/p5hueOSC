//modified by Nori Fujimura
//original is by jvandewiel
//
// https://github.com/jvandewiel/hue
// http://www.everyhue.com/vanilla/discussion/111/processinghue-disco-lights/p1

// Hub class, contains the http stuff as well
// Handles url as url = http://<IP>/api/<KEY>/lights/<id>/state";

class HueHub {

  String KEY="";
  String IP="";
  private static final boolean ONLINE = true; // for debugging purposes, set to true to allow communication

  private DefaultHttpClient httpClient; // http client to send/receive data

  // constructor, init http
  public HueHub(String KEY,String IP) {
    this.KEY=KEY;
    this.IP=IP;
    httpClient = new DefaultHttpClient();
  }

  // Query the hub for the name of a light
  public String getLightName(HueLight light) {
    // build string to get the name,   
    return "noname";
  }
  

  // apply the state for the passed hue light based on the values
  public void applyState(HueLight light) { 
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    try {
      // format url for specific light
      StringBuilder url = new StringBuilder("http://");
      url.append(IP);
      url.append("/api/");
      url.append(KEY);
      url.append("/lights/");
      url.append(light.getID());
      url.append("/state");
      // get the data from the light instance
      String data = light.getData();
      StringEntity se = new StringEntity(data);
      HttpPut httpPut = new HttpPut(url.toString());
      // debugging
      // println(url);
      //println(light.getID() + "->" + data);

      //with post requests you can use setParameters, however this is
      //the only way the put request works with the JSON parameters
      httpPut.setEntity(se);
      // println( "executing request: " + httpPut.getRequestLine() );

      // sending data to url is only executed when ONLINE = true
      if (ONLINE) { 
        HttpResponse response = httpClient.execute(httpPut);
        HttpEntity entity = response.getEntity();
        /*
        if (entity != null) {
          // only check for failures, eg [{"success":
          entity.writeTo(baos);
          //success = baos.toString();
          if (!baos.toString().startsWith("[{\"success\":")) println("error udating"); 
          println(baos.toString());
        }
        */
        // needs to be done to ensure next put can be executed and connection is released
        if (entity != null) entity.consumeContent();
      }
    } 
    catch( Exception e ) { 
      e.printStackTrace();
    }
  }

  // close connections and cleanup
  public void disconnect() {
    // when HttpClient instance is no longer needed, 
    // shut down the connection manager to ensure
    // deallocation of all system resources
    httpClient.getConnectionManager().shutdown();
  }
}
