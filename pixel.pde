class Pixel {
  PVector loc, dest;
  color _color;
  int desR, desG, desB;
  float size, speed, red, green, blue;
  ArrayList<String> vocab;
  String avoid, speech;
  
  Pixel () {
    birth();
  }
  
  void update() {
    context();
    speak();
    move();
  }
  
  void display() {
    fill(_color);
    rect(loc.x, loc.y, size, size);
  }
  
  void move() {
    int direction = int(random(10));
    if (avoid == null) {
      switch (direction) {
        case 1:
            loc.x += speed;
          break;
        case 2:
            loc.x -= speed;
          break;
        case 3:
            loc.y += speed;
          break;
        case 4:
            loc.y -= speed;
          break;
      }
    }
  }
  
  void speak() {
    if (avoid != null) {
      speech = avoid;
    }
  }
  
  void listen(Pixel pixel) {
    if (dist(loc.x, loc.y, pixel.loc.x, pixel.loc.y) < size*4) {
      if (pixel.speech == "u" || pixel.speech == "d" ||
        pixel.speech == "l" || pixel.speech == "r") {
        pixel._color = color(255, 255, 255);
      }
    } 
  }
  
  void avoid(Pixel pixel) {
    float horizontal = abs(loc.x - pixel.loc.x), 
      vertical = abs(loc.y - pixel.loc.y),
      diameter = size*2;
    if (dist(loc.x, loc.y, pixel.loc.x,
      pixel.loc.y) < diameter) {
      if (horizontal < diameter) {
        if (loc.x - pixel.loc.x < diameter) {
          avoid = "l";
        } else if (loc.x - pixel.loc.x > diameter) {
          avoid = "r";
        }
      }
      if (vertical < diameter) {
        if (loc.y - pixel.loc.y < diameter) {
          avoid = "u";
        } else if (loc.y - pixel.loc.y > diameter) {
          avoid = "d";
        }
      }
    }
  }
  
  void context() {
    for (int i=0; i < world._pixels.size(); i++) {
      Pixel pixel = world._pixels.get(i);
      if (pixel != this) {
        avoid(pixel);
        listen(pixel);
      }
    }
  }
  
  void birth() {
    noStroke();
    vocab = new ArrayList<String>();
    loc = new PVector(random(width), random(height));
    _color = color(random(255), random(255), random(255));
    basicVocab();
    speed = 4;
    size = 4;
  }
  
  void basicVocab() {
    String[] basic = {"r", "g", "b", "u", "d", "l", "r"};
    for (int i=0; i < basic.length; i++) {
      vocab.add(basic[i]);
    }
  }
}
