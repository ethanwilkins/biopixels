// custom buttons for actions, pacman for eat, sword for attack, plus sheild for assist
// connected nodes for control, cell splitting for birth, + for assist, - for attack
// different colors for different action buttons, attack red, assist green
// circle buttons, like in github app, if over, highlight circle from center to edges

class Button {
  float x, y, w, h;
  boolean overAtPress;
  
  Button (float xLoc, float yLoc) {
    overAtPress = false;
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
      stroke(gui._color);
      strokeWeight(4.5);
      textSize(40);
    } rect(x, y, w, h, 15);
    if (overButton()) {
      fill(255);
    } else fill(gui._color);
    text(label, x, y+15);
  }
  
  void pauseButton() {
    if (!ei.paused) {
      noStroke();
      fill(gui._color);
      rectMode(CENTER);
      rect(x, y, 20, 40);
      rect(x+25, y, 20, 40);
    }
  }
  
  void pauseAtPress() {
    if (overPause()) {
      overAtPress = true;
    }
  }
  
  void checkPause() {
    if (overButton() && overAtPress) {
      ei.paused = true;
    } overAtPress = false;
  }
  
  boolean overPause() {
    float disX = x+20 - mouseX;
    float disY = y - mouseY;
    if (sqrt(sq(disX) + sq(disY)) < 60) {
      println("1");
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
}
