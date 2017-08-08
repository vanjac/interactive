// TODO: try to use as little from other tabs as possible

class TimelineDot {
  private float time;
  protected String title;
  protected String subTitle;
  
  private int layer;
  
  private boolean detailsShown;
  
  TimelineDot(float t, String title1, String title2) {
    time = t;
    title = title1;
    subTitle = title2;
    layer = 0;
  }
  
  float getTime() {
    return time;
  }
  
  void draw(float xPos, float yPos, boolean selected, boolean othersSelected) {
    float size = calculateSize(xPos, yPos);
    
    // dot
    noStroke();
    fill(selected || detailsShown ? DOT_SELECTED_COLOR : DOT_COLOR);
    ellipse(xPos, yPos, size, size);
    
    // label below timeline
    textSize(size / 1.5);
    textAlign(CENTER, TOP);
    if(selected) {
      textSize(size / 1.5);
      text(title, xPos, yPos + (TICK_LENGTH / 2));
      textSize(size / 2);
      text(subTitle, xPos, yPos + (TICK_LENGTH / 2) + size);
    } else if(!othersSelected) {
      textSize(size / 1.5);
      text(title, xPos, yPos + (TICK_LENGTH / 2) + layer*size);
      fill(DOT_COLOR);
      
      textSize(size / 1.5);
      textAlign(CENTER, TOP);
    }
    
    fill(DOT_COLOR);
    if(selected | (!othersSelected && detailsShown)) {
      drawContent(xPos, yPos - TICK_LENGTH);
    }
  }
  
  void drawContent(float middleXPosition, float bottomYPostion) { }
  
  private float calculateSize(float xPosition, float yPosition) {
    if(DYNAMIC_TICK_SIZE) {
      float mouseDistance = dist(xPosition, yPosition, mouseX, mouseY);
      float maxMouseDistance = dist(0, 0, width, height);
      
      return lerp(DOT_SIZE, DOT_MIN_SIZE, mouseDistance / maxMouseDistance);
    } else {
      return DOT_SIZE;
    }
  }
  
  boolean isSelected(float xPosition, float yPosition, float mouseX, float mouseY) {
    float size = calculateSize(xPosition, yPosition) / 2;
    return (mouseX >= xPosition - size/1.5 && mouseX <= xPosition + size/1.5
        && mouseY >= yPosition - size && mouseY <= yPosition + size);
  }
  
  boolean isShown() {
    return detailsShown;
  }
  
  void setLayer(int layer) {
    this.layer = layer;
  }
  
  void mouseClick(float xPos, float yPos, float mouseX, float mouseY) {
    if(isSelected(xPos, yPos, mouseX, mouseY)) {
      showDetails();
    } else {
      hideDetails();
    }
  }
  
  void showDetails() {
    detailsShown = true;
  }
  
  void hideDetails() {
    detailsShown = false;
  }
}


class TextDot extends TimelineDot {
  protected String content;
  
  TextDot(float t, String title1, String title2, String content) {
    super(t, title1, title2);
    this.content = content;
  }
  
  //@Override
  void drawContent(float xPos, float yPos) {
    float boxY = yPos - BOX_HEIGHT / 2;
    
    //Box
    fill(BOX_COLOR, 191);
    rectMode(CENTER);
    rect(xPos, boxY, BOX_WIDTH, BOX_HEIGHT);
    
    fill(BOX_TEXT_COLOR);
    
    //Description
    textAlign(LEFT, TOP);
    rectMode(CORNER);
    textSize(12);
    text(content, xPos - BOX_WIDTH/2, boxY - BOX_HEIGHT/2, BOX_WIDTH, BOX_HEIGHT);
    
    //Title at top
    rectMode(CENTER);
    fill(BOX_COLOR, 191);
    rect(xPos, yPos - BOX_HEIGHT - 24, BOX_WIDTH, 48);
    fill(TITLE_COLOR);
    rectMode(CORNER);
    textAlign(CENTER, TOP);
    textSize(16);
    text(subTitle, xPos - BOX_WIDTH/2, yPos - BOX_HEIGHT - 48, BOX_WIDTH, 300);
  }
  
  String getText() {
    return content;
  }
}

class TextImageDot extends TextDot {
  private PImage img;
  
  TextImageDot(float time, String title1, String title2, String content, PImage img) {
    super(time, title1, title2, content);
    this.img = img;
  }
  
  //@Override
  void drawContent(float middleX, float bottomY) {
    super.drawContent(middleX, bottomY);
    
    if(img == null)
      return;
    float imgDrawHeight = BOX_HEIGHT;
    float imgDrawWidth = (float(img.width) / float(img.height)) * imgDrawHeight;
    rectMode(CORNER);
    float xPos = getText().length() != 0 ? middleX + (BOX_WIDTH / 2.0) : middleX - (BOX_WIDTH / 2.0);
    
    image(img,
        xPos, bottomY - BOX_HEIGHT, //Position
        imgDrawWidth, imgDrawHeight); //Dimensions
  }
}