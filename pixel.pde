class Pixel {
  PVector loc, dest;
  color _color;
  int desR, desG, desB;
  float size, speed, red, green, blue;
  ArrayList<String> vocab;
  String avoid, speech;
  boolean withChild;
  ArrayList<Integer> childIndexes;
  
  Pixel () {
    birth();
  }
  
  void birth() {
    vocab = new ArrayList<String>();
    loc = new PVector(random(width), random(height));
    dest = new PVector(random(width), random(height));
    childIndexes = new ArrayList<Integer>();
    withChild = false;
    colorOrient();
    basicVocab();
    speed = 2;
    size = 1;
  }
  
  void update() {
    context();
    speak();
    move();
  }
  
  void display() {
    noStroke();
    fill(_color);
    rectMode(CENTER);
    rect(loc.x, loc.y, size, size);
    // shows child connection
    if (withChild) {
      for (int i=0; i < childIndexes.size(); i++) {
        int index = childIndexes.get(i);
        Pixel child = world._pixels.get(index);
        child._color = _color;
        //rectMode(CORNER);
        stroke(_color); //fill(0, 0);
        line(loc.x, loc.y, child.loc.x, child.loc.y);
      }
    }
  }
  
  void move() {
    int direction = int(random(16));
    switch (direction) {
      case 1: // right
          if (avoid != "r") {
            loc.x += speed;
          }
        break;
      case 2: // down right
        if (avoid != "d" || avoid != "r") {
          loc.x += speed;
          loc.y += speed;
        }
        break;
      case 3: // down
          if (avoid != "d") {
            loc.y += speed;
          }
        break;
      case 4: // down left
        if (avoid != "d" || avoid != "l") {
          loc.x -= speed;
          loc.y += speed;
        }
        break;
      case 5: // left
          if (avoid != "l") {
            loc.x -= speed;
          }
        break;
      case 6: // top left
        if (avoid != "u" || avoid != "l") {
          loc.x -= speed;
          loc.y -= speed;
        }
        break;
      case 7: // up
          if (avoid != "u") {
            loc.y -= speed;
          }
        break;
      case 8: // top right
        if (avoid != "u" || avoid != "r") {
          loc.x += speed;
          loc.y -= speed;
        }
        break;
    }
    avoid = "";
  }
  
  void speak() {
    if (avoid != null) {
      speech = avoid;
    }
  }
  
  void listen(Pixel pixel, int i) {
    listenForPress();
    // tells other pixel that's bumped into, copies it's color
    if (dist(loc.x, loc.y, pixel.loc.x, pixel.loc.y) < size*4) {
      if (pixel.speech != "" || pixel.speech != null) {
        // copies each color, one by one
        red = pixel.red; green = pixel.green; blue = pixel.blue;
        if (!pixel.withChild) {
          pixel._color = color(red, green, blue);
        }
        // determines whether to make as child
        if (((withChild || random(20) <= 1)
          || (withChild && pixel.withChild))
            && (red > 0 || blue > 0)
            && (pixel.red > 0 || pixel.blue > 0)
            && (green <= 1 && pixel.green <= 1)) {
          // steals any of new childs connections
          for (int x=0; x < pixel.childIndexes.size(); x++) {
            int childIndex = pixel.childIndexes.get(x);
            childIndexes.add(childIndex);
          }
          pixel.withChild = false;
          pixel.childIndexes = new ArrayList<Integer>();
          childIndexes.add(i);
          withChild = true;
        }
      }
    }
  }
  
  void listenForPress() {
    // changes to rainbow colors when pressed
    if (mousePressed && dist(mouseX, mouseY, loc.x,
      loc.y) < world.pressDiameter) {
      red = random(255);
      green = random(25);
      blue = random(255);
      _color = color(red, green, blue);
      childIndexes = new ArrayList<Integer>();
    }
  }
  
  void avoid(Pixel pixel) {
    float horizontal = abs(loc.x - pixel.loc.x), 
      vertical = abs(loc.y - pixel.loc.y),
      diameter = size*2;
    // stays on screen
    avoidEdges();
    // avoids other pixels
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
  
  void avoidEdges() {
    // avoids egdes of screen
    if (loc.x >= width) {
      avoid = "l";
    } else if (loc.x <= 0) {
      avoid = "r";
    }
    if (loc.y >= height) {
      avoid = "u";
    } else if (loc.y <= 0) {
      avoid = "d";
    }
  }
  
  void context() {
    for (int i=0; i < world._pixels.size(); i++) {
      Pixel pixel = world._pixels.get(i);
      if (pixel != this) {
        avoid(pixel);
        listen(pixel, i);
      }
    }
  }
  
  void colorOrient() {
    red = 0; //random(255);
    green = random(255);
    blue = 0; //random(255);
    _color = color(red, green, blue);
    // desired color state
    desR = int(random(255));
    desG = int(random(255));
    desB = int(random(255));
  }
  
  void basicVocab() {
    String[] basic = {"r", "g", "b", "u", "d", "l", "r"};
    for (int i=0; i < basic.length; i++) {
      vocab.add(basic[i]);
    }
  }
}