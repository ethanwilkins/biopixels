class Engine {
  // mode may not be used
  int swipeDetected = 0, mode = 0;
  float up = height * 0.45;
  float down = -height * 0.45;
  float left = width * 0.60;
  float right = -width * 0.60;
  // swipe detection variables
  float pmousex, pmousey,
  xDist, yDist,
  pressTime, releaseTime;
  
  boolean paused = false;
  
  void update() {
    if (!paused) {
      world.display(); 
    }
    gui.display();
  }
  
  void renew() {
    // do something
    background(0);
    paused = false;
  }
  
  void bootStrap() {
    background(0);
    paused = false;
    world.genesis();
  }
  
  void startSwype() {
    pressTime = millis();
    pmousex = mouseX;
    pmousey = mouseY;
  }
  
  void swipeDetector() {
    releaseTime = millis();
    xDist = pmousex - mouseX;
    yDist = pmousey - mouseY;
    if (releaseTime < pressTime + 600) { // for long draws or non-swipes
      if (yDist >= up || yDist <= down || xDist >= left || xDist <= right) {
        if (mode < 1) {
          //mode++;
        } else mode--;
          // do something
        // up
        if (yDist >= up) {
          swipeDetected = 1;
          world.collapse();
        } // down
        else if (yDist <= down) {
          swipeDetected = 2;
        } // left
        if (xDist >= left) {
          swipeDetected = 3;
          background(0);
        } // right
        else if (xDist <= right) {
          swipeDetected = 4;
          setup();
        }
      }
    }
  }
}
