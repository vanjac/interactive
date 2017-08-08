float timelineXPos;
float timelineYPos;

int lastDotLayer = -1;

ArrayList<TimelineDot> dots;

void setupTimeline() {
  timelineXPos = width / 2;
  timelineYPos = height / 2;
  dots = new ArrayList<TimelineDot>();
}

void drawTimeline() {
  stroke(LINE_COLOR);
  fill(LINE_COLOR);
  strokeWeight(LINE_WIDTH);
  line(0, timelineYPos, width, timelineYPos);
  
  drawTick(0, true);
  
  if(MINOR_LINES > 0) {
    for(float x = ceil(getTimeForXPos(1) / MINOR_LINES) * MINOR_LINES; drawTick(x, x%MAJOR_LINES == 0); x += MINOR_LINES);
  }
  
  // draw arrow
  strokeWeight(16);
  float arrowYPos = timelineYPos - 160;
  float arrowStartX = getXPosForTime(0);
  float arrowEndX = arrowStartX + 192;
  line(arrowStartX, arrowYPos, arrowEndX, arrowYPos);
  line(arrowEndX, arrowYPos, arrowEndX - 48, arrowYPos - 32);
  line(arrowEndX, arrowYPos, arrowEndX - 48, arrowYPos + 32);
  strokeWeight(LINE_WIDTH);
  
  TimelineDot selectedDot = null;
  for(TimelineDot d : dots) {
    if(d.isSelected(getXPosForTime(d.getTime()), timelineYPos, mouseX, mouseY)) {
      selectedDot = d;
      break;
    }
  }
  
  for(TimelineDot d : dots) {
    d.draw(getXPosForTime(d.getTime()), timelineYPos, d == selectedDot, selectedDot != null);
  }
}

int getNextDotLayer() {
  lastDotLayer++;
  if(lastDotLayer >= 4)
    lastDotLayer = 0;
  return lastDotLayer;
}


boolean drawTick(float n, boolean large) { //return true if tick is on the screen
  float xPos = getXPosForTime(n);
  
  float len;
  if(DYNAMIC_TICK_SIZE) {
    float mouseDistance = dist(xPos, timelineYPos, mouseX, mouseY);
    float maxMouseDistance = dist(0, 0, width, height);
    
    len = lerp(TICK_LENGTH/2, 0, mouseDistance / maxMouseDistance);
  } else {
    len = TICK_LENGTH/2;
  }
  len = large ? len*2 : len;
  
  line(xPos, timelineYPos + len, xPos, timelineYPos - len);
  
  if(large) {
    textSize(len / 3);
    textAlign(CENTER, TOP);
    text((int)(n + ORIGIN_YEAR), xPos, timelineYPos + (len * 1.25));
  }
  
  return xPos <= width && xPos >= 0;
}

float getXPosForTime(float n) {
  return n*ZOOM + timelineXPos;
}

float getTimeForXPos(float x) {
  return (x - timelineXPos) / ZOOM;
}

void addTimelineDot(TimelineDot dot) {
  dots.add(dot);
  dot.setLayer(getNextDotLayer());
}