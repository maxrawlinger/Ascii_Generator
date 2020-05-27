PImage source; 
int area = 10;
final int F = 255;
String picName = "test3.jpg";

Boolean colorEnabled = false;
Boolean colorInverted = false;
Boolean backgroundFilled = false;
Boolean areaOnMouseChangeEnabled = false;
Boolean reversedAscii = false;
Boolean enabledShakespeare = false;
Boolean rasterizationEnbaled = false;

String s;
String shakespeare;
String asciistr = "$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\\|()1{}[]?-_+~<>i!lI;:,\"^`'. ";
String revasciistr = " .'`^\",:;Il!i><~+_-?][}{1)(|\\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$";


// TODO: Multiple layer & Reduce layer color

void setup() {
  size(1, 1);
  smooth(8);
  noStroke();
  noLoop();
  background(255);
  source = loadImage(picName);
  //Auto adjust canvas to imagesize
  surface.setSize(source.width, source.height);
  //Load Macbeth as String
  String [] lines = loadStrings("shakespeare.txt");
  shakespeare = join(lines, " ");
  //Initial Ascii sequenz
  s = revasciistr;
}

void draw() {
  clear();
  textAlign(CENTER, CENTER);
  textSize(area);
  background(setBackground());

  String s = setAsciiString();
  int counter = 0;

  for (int y=0; y<source.height; y+=area) { 
    for (int x=0; x<source.width; x+=area) { 
      char character;
      color c = setInvertColor(getAverageColor(x, y, area, area, source));
      character = enabledShakespeare ? character = getChar(counter, shakespeare) : getChar(getPositionOfChar(getAverageBrightness(c), s), s);
      counter = enabledShakespeare ? counter>=shakespeare.length()-1 ?  0 : counter + 1 : 0;
      fill(setFill(c));
      text(character, x+area/2, y+area/2);
    }
  }
}

void isRastered() {
  rasterizationEnbaled = !rasterizationEnbaled;
}

void isShakespeare() {
  enabledShakespeare = !enabledShakespeare;
}
//++++++++++++++++++++++++++++++++++++++++++++
//Triggers invert color change global boolean
void invertColor() {
  colorInverted = !colorInverted;
}
//Inverts the of the given area 
color setInvertColor(color c) {
  return (colorInverted ? color(255-red(c), 255-green(c), 255-blue(c)):c);
}

//++++++++++++++++++++++++++++++++++++++++++++
//Triggers Ascii change global boolean
void changeAscii() {
  reversedAscii = !reversedAscii;
}
// Sets Ascii-Set.
String setAsciiString() {
  return (reversedAscii ? asciistr : revasciistr);
}

//++++++++++++++++++++++++++++++++++++++++++++
//Triggers area change global boolean
void changeAreaDim() {
  areaOnMouseChangeEnabled = !areaOnMouseChangeEnabled;
}
void mouseMoved() {
  int areaTmp = area;
  if (areaOnMouseChangeEnabled) {
    int areaFluid = (int)map(mouseX, 0, width, 2, width/4);
    if (rasterizationEnbaled) {
      //Area as an int fraction of width;
      if (width%areaFluid==0) {
        area = areaFluid;
      }
    } else {
      area = areaFluid;
    }
    println("Subdivision dimension is:" + " " + area + " px");
    redraw();
  } else {
    area = areaTmp;
  }
}

//++++++++++++++++++++++++++++++++++++++++++++
// Triggers background color change global boolean.
void changeBackgroundMode() {
  backgroundFilled = !backgroundFilled;
}

// Sets background color.
int setBackground() {
  return (backgroundFilled ? 0 : F);
}

//++++++++++++++++++++++++++++++++++++++++++++
// Changes Colormodes global boolean (Color/Greyscale).
void changeColorMode() {
  colorEnabled = !colorEnabled;
}
// Sets fill of characters. If not colored, fill is inverse to background color.
int setFill(color c) {
  return (colorEnabled ? c : backgroundFilled ? F : 0);
}

//++++++++++++++++++++++++++++++++++++++++++++
// Returns Charakter on position "p" in the String "s"
char getChar(int index, String s) {
  return s.charAt(index);
}
// Returns the positions of a charakter in a String depending on brightness
int getPositionOfChar(int index, String s) {
  return (int)map(index, 0, F, 0, s.length()-1);
}

// Returns the average brightness of a given color
int getAverageBrightness(color c) {
  return (int)brightness(c);
}

//++++++++++++++++++++++++++++++++++++++++++++
// Returns the average color of given area
color getAverageColor ( int x, int y, int w, int h, PImage img) { 
  float r = 0; 
  float g = 0; 
  float b = 0; 

  for (int i=0; i<w*h; i++) { 
    int index = x+(i%w)+y*img.width+(img.width*(i/w)); 
    if (index<img.pixels.length) {
      r += red(img.pixels[index]); 
      g += green(img.pixels[index]); 
      b += blue(img.pixels[index]);
    }
  }
  return color(r/(w*h), g/(w*h), b/(w*h));
}

//++++++++++++++++++++++++++++++++++++++++++++
// Input functions
void keyReleased() {
  redraw();
}

void mouseClicked() {
  redraw();
  println("Canvas was redrawn");
}

void keyPressed() {
  switch(key) {

  case 'b': 
    changeBackgroundMode();
    println("Background changed to this color:" + " " + setBackground()); 
    break;

  case 'c': 
    changeColorMode();
    println("Color mode changed to:" + " " + colorEnabled); 
    break;

  case 'a': 
    changeAreaDim();
    println("Subdivision mode is:" + " " + areaOnMouseChangeEnabled);
    break;

  case 's': 
    save("out.tif");
    println("Your exported the current image");
    break;

  case 'r': 
    changeAscii();
    println("Ascii String reversed:" + " " + reversedAscii);
    break;

  case 'i': 
    invertColor();
    println("Color inverted:" + " " + colorInverted);
    break;

  case 'w': 
    isShakespeare();
    println("Your reading Macbeth, a play of William Shakespeare:" + " " + enabledShakespeare);
    break;

  case 'z': 
    isRastered();
    println("Raster is enabled:" + " " + rasterizationEnbaled);
    break;

  default:
    println("***You can do more than you expect***\n Press B to invert background Color\n Press C to enable colors\n Press S to save the current picture\n Press A to change the subdivison manually through mouse position\n Press R to reverse the Ascii String\n Press I to invert colors\n Press W to activate Shakespeare\n Press Z while A is active to rasterize Ascii to Grid\n*************************************");
    break;
  }
}
