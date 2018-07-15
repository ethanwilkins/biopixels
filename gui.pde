class Gui {
  color _color;
  float red, green, blue, colorCR;
  boolean fatR=false, fatG=false, fatB=false;
  
  Gui () {
    colorOrient();
  }
  
  void display() {
    if (world.civilization > 0) {
      showCivLevel();
    }
  }
  
  void showCivLevel() {
    colorCR = world.civilization;
    colorMorph();
    fill(_color); textSize(35);
    text(world.civilization, width-50, 55);
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