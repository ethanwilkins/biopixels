class World {
  ArrayList<Pixel> _pixels;
  int population;
  
  World () {
    genesis();
  }
  
  void display() {
    for (int i=0; i < _pixels.size(); i++) {
      Pixel pixel = _pixels.get(i);
      pixel.update();
      pixel.display();
    }
  }
  
  void genesis() {
    rectMode(CENTER);
    population = 1000;
    _pixels = new ArrayList<Pixel>();
    for (int i=0; i < population; i++) {
      _pixels.add(new Pixel());
    }
  }
}
