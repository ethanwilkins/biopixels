package processing.test.biopixels;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class biopixels extends PApplet {

// language based on rgb values, r g and b used to communicate colors desired
// u d l r used to communicate directions, evolves based on this

// ability to press on screen and change all pixels to rainbow in press spot

Gui gui;
World world;

public void setup() {
  
  orientation(PORTRAIT);
  background(0);
  gui = new Gui();
  world = new World();
}

public void draw() {
  world.display();
  gui.display();
}
class Gui {
  int _color;
  float red, green, blue, colorCR;
  boolean fatR=false, fatG=false, fatB=false;
  
  Gui () {
    colorOrient();
  }
  
  public void display() {
    if (world.civilization > 0) {
      showCivLevel();
    }
  }
  
  public void showCivLevel() {
    colorCR = world.civilization;
    colorMorph();
    fill(_color); textSize(35);
    text(world.civilization, width-75, 55);
  }
  
  public void colorOrient() {
    red = random(255);
    green = random(255);
    blue = random(255);
    _color = color(red, green, blue);
    colorCR = 1;
  }
  
  public void colorMorph() {
    if (red <= colorCR) {
      fatR = false;
    } else if (red >= 255-colorCR) {
        fatR = true;
    } if (fatR) {
        red -= colorCR;
    } else red += colorCR;
    // Green
    if (green < 100) {
      fatG = false;
    } else if (green > 200) {
        fatG = true;
    } if (fatG) {
        green -= colorCR;
    } else green += colorCR;
    // Blue
    if (blue <= colorCR) {
      fatB = false;
    } else if (blue >= 255-colorCR) {
        fatB = true;
    } if (fatB) {
        blue -= colorCR;
    } else blue += colorCR;
    _color = color(red, green, blue);
  }
}
class Pixel {
  PVector loc, dest;
  int directOctal, lastDirChange=0;
  int _color;
  int desR, desG, desB;
  float size, speed, diameter, xSpeed, ySpeed,
    red, green, blue, colorCR;
  ArrayList<String> vocab;
  String avoid, speech;
  boolean withChild, touched, outOfBounds=false, targeting=false,
    fatR=false, fatG=false, fatB=false;
  ArrayList<Integer> childIndexes;
  
  Pixel () {
    birth();
  }
  
  public void birth() {
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
  
  public void update() {
    context();
    speak();
    move();
  }
  
  public void display() {
    noStroke();
    fill(_color);
    rectMode(CENTER);
    rect(loc.x, loc.y, size, size);
    // shows child connection
    if (withChild) {
      _color = colorMorph();
      for (int i=0; i < childIndexes.size(); i++) {
        int index = childIndexes.get(i);
        Pixel child = world._pixels.get(index);
        child._color = _color;
        //rectMode(CORNER);
        stroke(_color, 5); //fill(0, 0);
        line(loc.x, loc.y, child.loc.x, child.loc.y);
      }
    }
  }
  
  public void move() {
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
  
  public void speak() {
    if (avoid != null) {
      speech = avoid;
    }
  }
  
  public void listen(Pixel pixel, int i) {
    listenForPress();
    // tells other pixel that's bumped into, copies it's color
    if (abs(red-blue)-green >= abs(pixel.red-pixel.blue)-pixel.green &&
      dist(loc.x, loc.y, pixel.loc.x, pixel.loc.y) < size*4) {
      pixel._color = color(red, green, blue);
      // determines whether to make as child
      makeAsChild(pixel, i);
    }
  }
  
  public void makeAsChild(Pixel pixel, int i) {
    int chanceOfChild = 3;
    if (((withChild || random(chanceOfChild) <= 1)
      || (withChild && pixel.withChild))
        && (red > 0 || blue > 0)
        && (pixel.red > 0 || pixel.blue > 0)
        && green+pixel.green == 0) {
      // revolution: small group takes over larger group
      if (childIndexes.size() < pixel.childIndexes.size()) {
        // steals any of new childs connections
        for (int x=0; x < pixel.childIndexes.size(); x++) {
          int childIndex = pixel.childIndexes.get(x);
          childIndexes.add(childIndex);
        }
        pixel.childIndexes = new ArrayList<Integer>();
      }
      childIndexes.add(i);
      withChild = true;
      targeting = false;
      pixel.withChild = false;
      pixel.targeting = false;
    }
  }
  
  public void listenForPress() {
    // changes to rainbow colors when pressed
    if (mousePressed && dist(mouseX, mouseY, loc.x,
      loc.y) < world.pressDiameter) {
      red = random(255);
      green = 0; // only civil pixels
      blue = random(255);
      _color = color(red, green, blue);
      childIndexes = new ArrayList<Integer>();
      withChild = targeting = false;
      touched = true;
    }
  }
  
  public void avoid(Pixel pixel) {
    avoidPixels(pixel);
    // avoids and bounces off edges
    if (loc.x < world.safetyZone) {
      loc.x = width-world.safetyZone;
    } else if (loc.x > width-world.safetyZone) {
      loc.x = world.safetyZone;
    }
    if (loc.y < world.safetyZone) {
      loc.y = height-world.safetyZone;
    } else if (loc.y > height-world.safetyZone) {
      loc.y = world.safetyZone;
    }
  }
  
  public void avoidPixels(Pixel pixel) {
    // prioritizes edges
    if (loc.x < width-world.safetyZone && loc.x > world.safetyZone
      && loc.y < height-world.safetyZone && loc.y > world.safetyZone) {
      // avoids other pixels
      if (dist(loc.x, loc.y, pixel.loc.x, pixel.loc.y) < size*2) {
        int oldDirection = directOctal;
        do {
          directOctal = PApplet.parseInt(random(1, 9));
        } while (oldDirection == directOctal);
      }
    }
  }
  
  public void findOtherParents(Pixel pixel) {
    if (withChild && pixel.withChild
      // if !targeting or this pixel is closer than one already targeted
      && (!targeting || dist(loc.x, loc.y, dest.x, dest.y)
      > dist(loc.x, loc.y, pixel.loc.x, pixel.loc.y)
      // or if they both have same number of children
      || (childIndexes.size() == pixel.childIndexes.size()
      // makes going after competitor less likely
      && random(pixel.childIndexes.size()) <= 1))) {
      dest = pixel.loc;
      targeting = true;
    }
    if (targeting) {
      getToDest();
    }
  }
  
  public void getToDest() {
    float bestPath = abs(dest.x - loc.x) + abs(dest.y - loc.y);
    float right = abs(dest.x - (loc.x + 1)) + abs(dest.y - loc.y);
    float downRight = abs(dest.x - (loc.x + 1)) + abs(dest.y - (loc.y + 1));
    float down = abs(dest.x - loc.x) + abs(dest.y - (loc.y + 1));
    float downLeft = abs(dest.x - (loc.x - 1)) + abs(dest.y - (loc.y + 1));
    float left = abs(dest.x - (loc.x - 1)) + abs(dest.y - loc.y);
    float topLeft = abs(dest.x - (loc.x - 1)) + abs(dest.y - (loc.y - 1));
    float up = abs(dest.x - loc.x) + abs(dest.y - (loc.y - 1));
    float topRight = abs(dest.y - (loc.x + 1)) + abs(dest.y - (loc.y - 1));
    // 1 go right
    if (right < bestPath) {
      bestPath = right;
      directOctal = 1;
    } // 2 go down right
    if (downRight < bestPath) {
      bestPath = downRight;
      directOctal = 2;
    } // 3 go down
    if (down < bestPath) {
      bestPath = down;
      directOctal = 3;
    } // 4 go down left
    if (downLeft < bestPath) {
      bestPath = downLeft;
      directOctal = 4;
    } // 5 go left
    if (left < bestPath) {
      bestPath = left;
      directOctal = 5;
    } // 6 go top left
    if (topLeft < bestPath) {
      bestPath = topLeft;
      directOctal = 6;
    } // 7 go up
    if (up < bestPath) {
      bestPath = up;
      directOctal = 7;
    } // 8 go top right
    if (topRight < bestPath) {
      bestPath = topRight;
      directOctal = 8;
    }
  }
  
  public void explore() {
    if (loc.x < width-world.safetyZone && loc.x > world.safetyZone
      && loc.y < height-world.safetyZone && loc.y > world.safetyZone) {
      if ((red+blue > 0 && (lastDirChange == 0
        || millis() >= lastDirChange+350)) || red+blue == 0) {
        directOctal = PApplet.parseInt(random(1, 9));
        if (red+blue > 0) {
          lastDirChange = millis();
        }
      }
      outOfBounds = false;
    }
  }
  
  public void collapse() {
    if (world.civilization >= 200) {
      childIndexes = new ArrayList<Integer>();
      withChild = false; targeting = false;
      _color = color(random(255), 0, random(255));
    }
  }
  
  public void context() {
    collapse(); // civilization collapses
    explore(); // for random movement when not bouncing
    for (int i=0; i < world._pixels.size(); i++) {
      Pixel pixel = world._pixels.get(i);
      if (pixel != this) {
        //findOtherParents(pixel);
        avoid(pixel);
        listen(pixel, i);
      }
    }
  }
  
  public void basicVocab() {
    String[] basic = {"r", "g", "b", "u", "d", "l", "r"};
    for (int i=0; i < basic.length; i++) {
      vocab.add(basic[i]);
    }
  }
  
  public void colorOrient() {
    red = 0; //random(255);
    green = random(255);
    blue = 0; //random(255);
    _color = color(red, green, blue);
    // desired color state
    desR = PApplet.parseInt(random(255));
    desG = PApplet.parseInt(random(255));
    desB = PApplet.parseInt(random(255));
    colorCR = 1;
  }
  
  public int colorMorph() {
    if (red <= colorCR) {
      fatR = false;
    } else if (red >= 255-colorCR) {
        fatR = true;
    } if (fatR) {
        red -= colorCR;
    } else red += colorCR;
    // Green
    //if (green <= colorCR) {
    //  fatG = false;
    //} else if (green >= 255-colorCR) {
    //    fatG = true;
    //} if (fatG) {
    //    green -= colorCR;
    //} else green += colorCR;
    // Blue
    if (blue <= colorCR) {
      fatB = false;
    } else if (blue >= 255-colorCR) {
        fatB = true;
    } if (fatB) {
        blue -= colorCR;
    } else blue += colorCR;
    return color(red, green, blue);
  }
  
  public float colorComp(Pixel other) {
    return (abs(red - other.red) +
    abs(green - other.green) +
    abs(blue - other.blue))/3;
  }
}
class World {
  ArrayList<Pixel> _pixels;
  int population = 300;
  int civilization;
  int safetyZone;
  
  // for press interaction
  float pressDiameter = 75;
  
  World () {
    genesis();
  }
  
  public void genesis() {
    civilization = 0;
    safetyZone = 1;
    _pixels = new ArrayList<Pixel>();
    for (int i=0; i < population; i++) {
      _pixels.add(new Pixel());
    }
  }
  
  public void display() {
    if (mousePressed) {
      fill(0);
      noStroke();
      ellipse(PApplet.parseFloat(mouseX), PApplet.parseFloat(mouseY),
        pressDiameter, pressDiameter);
    }
    for (int i=0; i < _pixels.size(); i++) {
      Pixel pixel = _pixels.get(i);
      pixel.update();
      pixel.display();
    }
    println(checkCiv());
  }
  
  public int checkCiv() {
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
  public void settings() {  size(displayWidth, displayHeight); }
}
