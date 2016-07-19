class Pixel {
  PVector loc, dest;
  int directOctal;
  color _color;
  int desR, desG, desB;
  float size, speed, xSpeed, ySpeed,
    red, green, blue;
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
    xSpeed = 1;
    ySpeed = xSpeed;
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
    //int direction = int(random(16));
    switch (directOctal) {
      case 0: // applies bounce
        loc.x += xSpeed;
        loc.y += ySpeed;
      case 1: // right
        loc.x += speed;
        break;
      case 2: // down right
        loc.x += speed;
        loc.y += speed;
        break;
      case 3: // down
        loc.y += speed;
        break;
      case 4: // down left
        loc.x -= speed;
        loc.y += speed;
        break;
      case 5: // left
        loc.x -= speed;
        break;
      case 6: // top left
        loc.x -= speed;
        loc.y -= speed;
        break;
      case 7: // up
        loc.y -= speed;
        break;
      case 8: // top right
        loc.x += speed;
        loc.y -= speed;
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
        makeAsChild(pixel, i);
      }
    }
  }
  
  void makeAsChild(Pixel pixel, int i) {
    if (((withChild || random(25) <= 1)
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
    float diameter = size*2;
    // avoids and bounces off edges
    if (loc.x <= 10 || loc.x > width-10) {
      xSpeed = -xSpeed;
      directOctal = 0;
    } if (loc.y <= 10 || loc.y > height-10) {
        ySpeed = -ySpeed;
        directOctal = 0;
    }
    // prioritizes edges
    if (loc.x < width-25 && loc.x > 25 && loc.y < width-25 && loc.y > 25) {
      // avoids other pixels
      if (dist(loc.x, loc.y, pixel.loc.x, pixel.loc.y) < diameter) {
        xSpeed = -xSpeed;
        ySpeed = -ySpeed;
        directOctal = 0;
      }
    }
  }
  
  void explore() {
    int centerDist = 50;
    if (loc.x < width-centerDist && loc.x > centerDist
      && loc.y < width-centerDist && loc.y > centerDist) {
      directOctal = int(random(8));
    }
  }
  
  void context() {
    explore(); // for random movement when not bouncing
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