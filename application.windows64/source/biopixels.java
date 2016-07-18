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

World world;

public void setup() {
  
  background(0);
  world = new World();
}

public void draw() {
  world.display();
}
class Pixel {
  PVector loc, dest;
  int _color;
  int desR, desG, desB;
  float size, speed, red, green, blue;
  ArrayList<String> vocab;
  String avoid, speech;
  
  Pixel () {
    birth();
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
  }
  
  public void move() {
    int direction = PApplet.parseInt(random(20));
    switch (direction) {
      case 1: // left
          if (avoid != "l") {
            loc.x += speed;
          }
        break;
      case 2: // right
          if (avoid != "r") {
            loc.x -= speed;
          }
        break;
      case 3: // down
          if (avoid != "d") {
            loc.y += speed;
          }
        break;
      case 4: // up
          if (avoid != "u") {
            loc.y -= speed;
          }
        break;
    }
    avoid = "";
  }
  
  public void speak() {
    if (avoid != null) {
      speech = avoid;
    }
  }
  
  public void listen(Pixel pixel) {
    if (dist(loc.x, loc.y, pixel.loc.x, pixel.loc.y) < size*4) {
      if (pixel.speech == "u" || pixel.speech == "d" ||
        pixel.speech == "l" || pixel.speech == "r") {
        pixel._color = _color;
      }
    } 
  }
  
  public void avoid(Pixel pixel) {
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
  
  public void avoidEdges() {
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
  
  public void context() {
    for (int i=0; i < world._pixels.size(); i++) {
      Pixel pixel = world._pixels.get(i);
      if (pixel != this) {
        avoid(pixel);
        listen(pixel);
      }
    }
  }
  
  public void birth() {
    vocab = new ArrayList<String>();
    loc = new PVector(random(width), random(height));
    dest = new PVector(random(width), random(height));
    colorOrient();
    basicVocab();
    speed = 2;
    size = 1;
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
  }
  
  public void basicVocab() {
    String[] basic = {"r", "g", "b", "u", "d", "l", "r"};
    for (int i=0; i < basic.length; i++) {
      vocab.add(basic[i]);
    }
  }
}
class World {
  ArrayList<Pixel> _pixels;
  int population;
  
  World () {
    genesis();
  }
  
  public void display() {
    for (int i=0; i < _pixels.size(); i++) {
      Pixel pixel = _pixels.get(i);
      pixel.update();
      pixel.display();
    }
  }
  
  public void genesis() {
    population = 1000;
    _pixels = new ArrayList<Pixel>();
    for (int i=0; i < population; i++) {
      _pixels.add(new Pixel());
    }
  }
}
  public void settings() {  size(500, 500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "biopixels" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
