class World {
  ArrayList<Pixel> _pixels;
  int population = 750;
  int civilization;
  
  // for press interaction
  float pressDiameter = 50;
  
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
          int childIndex = pixel.childIndexes.get(x);
          Pixel child = _pixels.get(childIndex);
          toCiv = dist(pixel.loc.x, pixel.loc.y, child.loc.x, child.loc.y);
          // adds if not green, takes if green
          if (pixel.green < (pixel.red+pixel.green+pixel.blue)*0.5) {
            civ += toCiv*2;
          } else {
            civ -= toCiv/2;
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
    civilization = 0;
    _pixels = new ArrayList<Pixel>();
    for (int i=0; i < population; i++) {
      _pixels.add(new Pixel());
    }
  }
}