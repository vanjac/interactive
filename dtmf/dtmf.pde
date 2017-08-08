import processing.sound.*;
import java.awt.*;
import java.awt.event.*;

Robot robot;
int robotMouseX, robotMouseY;
boolean leftClick = false;

AudioIn in;
FFT fft;
int bands = 2048;
float[] spectrum = new float[bands];

int[] rowValues = {65, 71, 79, 87};
int[] columnValues = {112, 124, 137};

String buttons = "123456789*0#";

void setup() {
  size(640, 480);

  try {
    robot = new Robot();
  } catch(Exception e) {
    e.printStackTrace();
  }
  robotMouseX = displayWidth/2;
  robotMouseY = displayHeight/2;
  moveMouse(0, 0);
  
  in = new AudioIn(this, 0);
  fft = new FFT(this, bands);
  
  in.start();
  fft.input(in);
}

void draw() {
  background(255);
  
  fill(0);
  textSize(128);
  textAlign(CENTER, CENTER);
  
  char t = getTone();
  switch(t) {
    case '2':
      moveMouse(0, -5);
      break;
    case '4':
      moveMouse(-5, 0);
      break;
    case '6':
      moveMouse(5, 0);
      break;
    case '8':
      moveMouse(0, 5);
      break;
    case '5':
      if(!leftClick) {
        leftClick();
        leftClick = true;
      }
      break;
    default:
      leftClick = false;
      unleftClick();
      break;
  }
  text(t, width/2, height/2);
}

void moveMouse(int x, int y) {
  robotMouseX += x;
  robotMouseY += y;
  robot.mouseMove(robotMouseX, robotMouseY);
}

void leftClick() {
  robot.mousePress(InputEvent.BUTTON1_DOWN_MASK);
}

void unleftClick() {
  robot.mouseRelease(InputEvent.BUTTON1_DOWN_MASK);
}


char getTone() {
  fft.analyze(spectrum);
  
  float maxValue = 0;
  int row = 0;
  for(int i = 0; i < rowValues.length; i++) {
    int index = rowValues[i];
    float value = spectrum[index];
    if(value > maxValue) {
      maxValue = value;
      row = i;
    }
  }
  if(maxValue < .001)
    return ' ';
  
  maxValue = 0;
  int column = 0;
  for(int i = 0; i < columnValues.length; i++) {
    int index = columnValues[i];
    float value = spectrum[index];
    if(value > maxValue) {
      maxValue = value;
      column = i;
    }
  }
  if(maxValue < .001)
    return ' ';
  
  return buttons.charAt(row * 3 + column);
}