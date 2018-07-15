class World {
  ArrayList<Pixel> _pixels;
  int population = 250;
  int civilization;
  int safetyZone;
  
  // for press interaction
  float pressDiameter = 75;
  
  World () {
    genesis();
  }
  
  void genesis() {
    civilization = 0;
    safetyZone = 1;
    _pixels = new ArrayList<Pixel>();
    for (int i=0; i < population; i++) {
      _pixels.add(new Pixel());
    }
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
    }
    println(checkCiv());
  }
  
  int checkCiv() {
    int civ = 0, singleWildPixels = 0;
    float toCiv;
    for (int i=0; i < _pixels.size(); i++) {
      Pixel pixel = _pixels.get(i);
      if (pixel.withChild) {
        for (int x=0; x < pixel.childIndexes.size(); x++) {
          int childIndex = pixel.childIndexes.get(x);
          Pixel child = _pixels.get(childIndex);
          toCiv = dist(pixel.loc.x, pixel.loc.y, child.loc.x, child.loc.y);
          // adds if not green, subtracts otherwise
          if (pixel.red+pixel.blue > 0 && pixel.green == 0) {
            civ += toCiv;
          } else {
            civ -= toCiv;
          }
        }
      } else if (pixel.red+pixel.blue == 0) { 
        singleWildPixels++;
      }
    }
    // single wild pixels bring vitality
    civ = civ + singleWildPixels;
    // never starts at 1
    civ = (civ / _pixels.size()) - 1;
    // no negatives
    if (civ < 0) {
      civ = 0;
    }
    civilization = civ;
    return civilization;
  }
}