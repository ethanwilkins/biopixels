// custom buttons for actions, pacman for eat, sword for attack, plus sheild for assist
// connected nodes for control, cell splitting for birth, + for assist, - for attack
// different colors for different action buttons, attack red, assist green
// circle buttons, like in github app, if over, highlight circle from center to edges

class Button {
  float x, y, w, h;
  boolean overAtPress;
  
  color _color;
  float red, green, blue, colorCR, sizeL=80;
  boolean fatR=false, fatG=false, fatB=false, fatW=false, fatH=false;
  
  Button (float xLoc, float yLoc) {
    overAtPress = false;
    colorOrient();
    x = xLoc;
    y = yLoc;
    w = 200;
    h = 100;
  }
  
  void display(String label) {
    textAlign(CENTER);
    noFill();
    if (overButton()) {
      stroke(255);
      strokeWeight(6);
      textSize(45);
    } else {
      stroke(_color);
      strokeWeight(4.5);
      textSize(40);
    } rect(x, y, w, h, 15);
    if (overButton()) {
      fill(255);
    } else fill(_color);
    text(label, x, y+15);
    colorMorph();
  }
  
  void pauseButton() {
    if (!(ei.paused || ei.intro)) {
      //noStroke();
      fill(_color);
      ellipseMode(CENTER);
      ellipse(x, y, w, h);
      //rect(x+25, y, 20, 40);
      colorMorph();
      sizeMorph();
    }
  }
  
  void pauseAtPress() {
    if (overPause()) {
      overAtPress = true;
    }
  }
  
  void checkPause() {
    if (overPause() && overAtPress) {
      gui.pauseExpanding = true;
      ei.paused = true;
    } overAtPress = false;
  }
  
  boolean overPause() {
    float disX = x+20 - mouseX;
    float disY = y - mouseY;
    if (sqrt(sq(disX) + sq(disY)) < 60) {
      return true;
    } else return false;
  }

  boolean overButton() {
    float disX = x - mouseX;
    float disY = y - mouseY;
    if (sqrt(sq(disX) + sq(disY)) < w/2) {
      return true;
    } else return false;
  }
  
  boolean pixelOverPause(PVector loc) {
    float disX = x+20 - loc.x;
    float disY = y - loc.y;
    if (sqrt(sq(disX) + sq(disY)) < 60) {
      return true;
    } else return false;
  }
  
  void colorOrient() {
    red = random(255);
    green = random(255);
    blue = random(255);
    _color = color(red, green, blue);
    colorCR = 1;
  }
  
  void sizeMorph() {
    // width morph
    if (w < 1) {
      fatW = false;
    } else if (w > sizeL) {
        fatW = true;
    } if (fatW) {
        w -= 0.5;
    } else w += 0.5;
    // height morph
    if (h < 1) {
      fatH = false;
    } else if (h > sizeL) {
        fatH = true;
    } if (fatH) {
        h -= 0.5;
    } else h += 0.5;
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
