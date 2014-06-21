// language based on rgb values, r g and b used to communicate colors desired
// u d l r used to communicate directions, evolves based on this

World world;

void setup() {
  size(displayWidth, displayHeight);
  world = new World();
}

void draw() {
  background(0);
  world.display();
}
