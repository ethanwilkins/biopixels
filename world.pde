class World {
  ArrayList<Pixel> _pixels;
  int population;
  int civilization;
  
  // for press interaction
  float pressDiameter = 75;
  
  World () {
    genesis();
  }
  
  void display() {
    if (mousePressed) {
      fill(0);
      noStroke();
      rect(float(mouseX), float(mouseY),
        pressDiameter, pressDiameter);
    }
    for (int i=0; i < _pixels.size(); i++) {
      Pixel pixel = _pixels.get(i);
      pixel.update();
      pixel.display();
    }
    println(checkCiv());
  }
  
  int checkCiv() {
    int civ = 0;
    float toCiv;
    for (int i=0; i < _pixels.size(); i++) {
      Pixel pixel = _pixels.get(i);
      if (pixel.withChild) {
        for (int x=0; x < pixel.childIndexes.size(); x++) {
          Pixel child = _pixels.get(x);
          toCiv = ((abs(pixel.loc.x-child.loc.x))
            + (abs(pixel.loc.y-child.loc.y)))/2;
          // adds if not green, takes if green
          if (pixel.green < (pixel.red+pixel.green+pixel.blue)*0.5) {
            civ += toCiv;
          } else {
            civ -= toCiv;
          }
        }
      } else if (pixel.red+pixel.blue == 0) {
        // tame wild pixels bring vitality 
        civ++;
      }
    }
    return civ / _pixels.size();
  }
  
  void genesis() {
    population = 1000;
    civilization = 0;
    _pixels = new ArrayList<Pixel>();
    for (int i=0; i < population; i++) {
      _pixels.add(new Pixel());
    }
  }
}