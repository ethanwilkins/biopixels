// language based on rgb values, r g and b used to communicate colors desired
// u d l r used to communicate directions, evolves based on this

// ability to press on screen and change all pixels to rainbow in press spot

Gui gui;
World world;

void setup() {
  size(500, 500);
  background(0);
  gui = new Gui();
  world = new World();
}

void draw() {
  world.display();
  gui.display();
}