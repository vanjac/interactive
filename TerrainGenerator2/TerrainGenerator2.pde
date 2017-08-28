import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
import peasy.test.*;

World world;
float cameraRotation;

void settings() {
  if(displayHeight >= 832) {
    size(768, 768, P3D);
  } else {
    size(512, 512, P3D);
  }
}

void setup() {
  initColors();
  world = generateWorld();
}

void draw() {
  background(255,255,255);
  perspective(radians(40), float(width)/height, 0.5, 1000);
  camera(-100, 0, 0,
         0, 0, 0,
         0, 1, 0);
  rotateZ(radians(-40));
  rotateY(cameraRotation);
  renderWorld(world);
}

void keyPressed() {
  if(key == ' ')
    world = generateWorld();
}

void mouseDragged() {
  cameraRotation += radians(mouseX - pmouseX);
}