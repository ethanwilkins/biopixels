// language based on rgb values, r g and b used to communicate colors desired
// u d l r used to communicate directions, evolves based on this

// ability to press on screen and change all pixels to rainbow in press spot

Gui gui;
World world;
Engine ei;

boolean muted = false;

void setup() {
  //size(displayWidth, displayHeight);
  size(1000, 1000);
  orientation(PORTRAIT);
  background(0);
  gui = new Gui();
  world = new World();
  ei = new Engine();
}

void draw() {
  ei.update();
}

void mousePressed() {
  gui.pause.pauseAtPress();
  ei.startSwype();
}

void mouseReleased() {
  gui.checkButtons();
  ei.swipeDetector();
}
