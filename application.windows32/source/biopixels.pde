// language based on rgb values, r g and b used to communicate colors desired
// u d l r used to communicate directions, evolves based on this

// ability to press on screen and change all pixels to rainbow in press spot

World world;

void setup() {
  size(500, 500);
  background(0);
  world = new World();
}

void draw() {
  world.display();
}