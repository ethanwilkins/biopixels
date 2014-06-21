class Pixel {
  PVector loc;
  color _color;
  float size;
  
  Pixel () {
    birth();
  }
  
  void display() {
    move();
    fill(_color);
    rect(loc.x, loc.y, size, size);
  }
  
  void move() {
    int direction = int(random(5));
    switch (direction) {
      case 1:
        loc.x++;
        break;
      case 2:
        loc.x--;
        break;
      case 3:
        loc.y++;
        break;
      case 4:
        loc.y--;
        break;
    }
  }
  
  void birth() {
    loc = new PVector(random(width), random(height));
    _color = color(random(255), random(255), random(255));
    size = 5;
  }
}
