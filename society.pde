// language based on rgb values, r g and b used to communicate colors desired
// u d l r used to communicate directions, evolves based on this

// ability to press on screen and change all pixels to rainbow in press spot

Gui gui;
World world;
Engine ei;

boolean paused = false;
boolean muted = false;

void setup() {
  size(displayWidth, displayHeight);
  orientation(PORTRAIT);
  background(0);
  gui = new Gui();
  world = new World();
  ei = new Engine();
}

void draw() {
  world.display();
  gui.display();
}

void mousePressed() {
  ei.startSwype();
  // do stuff
}

void mouseReleased() {
  ei.swipeDetector();
}