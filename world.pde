class World {
  ArrayList<Pixel> _pixels;
  int population;
  
  // for press interaction
  float pressDiameter = 75;
  
  World () {
    genesis();
  }
  
  void display() {
    if (mousePressed) {
      fill(0);
      noStroke();
      ellipse(float(mouseX), float(mouseY),
        pressDiameter, pressDiameter);
    }
    for (int i=0; i < _pixels.size(); i++) {
      Pixel pixel = _pixels.get(i);
      pixel.update();
      pixel.display();
      // erases all bonds
      if (mousePressed) {
        pixel.childIndexes = new ArrayList<Integer>();
      }
    }
  }
  
  void genesis() {
    population = 1000;
    _pixels = new ArrayList<Pixel>();
    for (int i=0; i < population; i++) {
      _pixels.add(new Pixel());
    }
  }
}