class Pixel {
  PVector loc, dest;
  int directOctal;
  color _color;
  int desR, desG, desB;
  float size, speed, diameter, xSpeed, ySpeed,
    red, green, blue;
  ArrayList<String> vocab;
  String avoid, speech;
  boolean withChild, outOfBounds;
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
    speed = 1;
    xSpeed = speed;
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
        stroke(_color, 15); //fill(0, 0);
        line(loc.x, loc.y, child.loc.x, child.loc.y);
      }
    }
  }
  
  void move() {
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
    //avoid = "";
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
      // copies each color, one by one
      red = pixel.red; green = pixel.green; blue = pixel.blue;
      if (!pixel.withChild) {
        pixel._color = color(red, green, blue);
      }
      // determines whether to make as child
      makeAsChild(pixel, i);
    }
  }
  
  void makeAsChild(Pixel pixel, int i) {
    if (((withChild || random(25) <= 5)
      || (withChild && pixel.withChild))
        && (red > 0 || blue > 0)
        && (pixel.red > 0 || pixel.blue > 0)
        && (green <= 1 /*&& pixel.green <= 1*/)) {
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
    // avoids and bounces off edges
    if (loc.x <= world.safetyZone || loc.x >= width-world.safetyZone) {
      if (!outOfBounds) {
        xSpeed = -xSpeed;
        directOctal = 0;
        outOfBounds = true;
      }
    } if (loc.y <= world.safetyZone || loc.y >= height-world.safetyZone) {
        if (!outOfBounds) {
          ySpeed = -ySpeed;
          directOctal = 0;
          outOfBounds = true;
        }
    }
    if (outOfBounds) {
      _color = color(0, 0, 0);
    }
    // prioritizes edges
    avoidPixels(pixel);
  }
  
  void avoidPixels(Pixel pixel) {
    if (loc.x <= width-world.safetyZone && loc.x >= world.safetyZone
      && loc.y <= height-world.safetyZone && loc.y >= world.safetyZone) {
      // avoids other pixels
      if (dist(loc.x, loc.y, pixel.loc.x, pixel.loc.y) < diameter*2) {
        xSpeed = -xSpeed;
        ySpeed = -ySpeed;
        directOctal = 0;
      }
    }
  }
  
  void explore() {
    if (loc.x < width-world.safetyZone && loc.x > world.safetyZone
      && loc.y < width-world.safetyZone && loc.y > world.safetyZone) {
      directOctal = int(random(1, 9));
      outOfBounds = false;
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