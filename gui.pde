class Gui {
  Button pause, resume, reset, exit;
  color _color;
  float red, green, blue, colorCR;
  boolean fatR=false, fatG=false, fatB=false;
  
  Gui () {
    colorOrient();
    // pause button/menu
    pause = new Button(60, 50);
    resume = new Button(width*0.5, height*0.4);
    reset = new Button(width*0.5, height*0.6);
    exit = new Button(width*0.5, height*0.8);
  }
  
  void display() {
    colorMorph();
    showCivLevel();
    pauseScreen();
    pause.pauseButton();
  }
  
  void pauseScreen() {
    if (ei.paused) {
      background(0);
      text("Number of pixels: " + world._pixels.size(),
        width/2, height*0.2);
      resume.display("Resume");
      reset.display("Reset");
      exit.display("Quit");
    }
  }
  
  void checkButtons() {
    if (ei.paused) {
      if (resume.overButton()) {
        ei.bootStrap();
      } else if (reset.overButton()) {
        ei.renew();
      } else if (exit.overButton()) {
        exit();
      }
    } else {
      pause.checkPause();
    }
  }
  
  void showCivLevel() {
    if (world.civilization > 0) {
      colorCR = world.civilization;
      fill(_color); textSize(35);
      text(world.civilization, width-75, 55);
    }
  }
  
  void colorOrient() {
    red = random(255);
    green = random(255);
    blue = random(255);
    _color = color(red, green, blue);
    colorCR = 1;
  }
  
  void colorMorph() {
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
