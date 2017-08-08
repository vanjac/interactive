boolean arrowKeyHelp = true;

PImage backgroundImage = null;

float xScroll = 0;

float xPos;
float yPos;


void setup() {
  fullScreen();
  smooth();
  
  if(BACKGROUND_IMAGE != null)
    backgroundImage = loadImage(BACKGROUND_IMAGE);

  xPos = width / 2;
  yPos = height * .6;

  setupTimeline();

  addDots();
}

void draw() {
  background(BACKGROUND_COLOR);
  float xOffset = -(mouseX - width/2)/12;
  float yOffset = -(mouseY - height/2)/12;
  if(backgroundImage != null) {
    imageMode(CENTER);
    image(backgroundImage,
      width * BACKGROUND_IMAGE_X_POSITION + xPos/8.0 + xOffset / 2.0,
      height * BACKGROUND_IMAGE_Y_POSITION + yOffset / 2.0,
      BACKGROUND_IMAGE_WIDTH, BACKGROUND_IMAGE_HEIGHT);
    imageMode(CORNER);
  }
  
  fill(TITLE_COLOR);
  noStroke();
  
  textAlign(CENTER, TOP);
  textSize(36);
  text(TITLE, width/2, 0);

  if(!arrowKeyHelp) {
    textSize(36);
    textAlign(CENTER, BOTTOM);
    text("Use the arrow keys to navigate", width/2, height - 16);
  }
  
  timelineXPos = xPos + xOffset;
  timelineYPos = yPos + yOffset;
  drawTimeline();
  xPos += xScroll / frameRate;
  
  if(arrowKeyHelp) {
    rectMode(CENTER);
    noStroke();
    fill(127, 127, 127, 191);
    
    float tXPos = width/2;
    float tYPos = height/2 - 128;
    
    rect(tXPos, tYPos, 576, 96);
    
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(36);
    text("Use the arrow keys to navigate", tXPos, tYPos);
  }
}

void mouseClicked() {
  for(TimelineDot d : dots) {
    d.mouseClick(getXPosForTime(d.getTime()), timelineYPos, mouseX, mouseY);
  }
}


void keyPressed() {
  switch(keyCode) {
  case LEFT:
    xScroll = X_SCROLL_SPEED;
    arrowKeyHelp = false;
    break;
  case RIGHT:
    xScroll = -X_SCROLL_SPEED;
    arrowKeyHelp = false;
    break;
  }
}


void keyReleased() {
  switch(keyCode) {
  case LEFT:
  case RIGHT:
    xScroll = 0;
    break;
  }
}