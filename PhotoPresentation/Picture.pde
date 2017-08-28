class Picture {
  
  PImage image;
  float width, height;
  float x, y, xVel, yVel;
  float visibility; // out of 1
  
  Picture(PImage image, float x, float y,
          float width, float height) {
    this.image = image;
    this.x = x;
    this.y = y;
    xVel = 0;
    yVel = 0;
    this.width = width;
    this.height = height;
    visibility = 0;
  }
  
  Picture clone() {
    Picture p = new Picture(image, x, y, this.width, this.height);
    p.xVel = this.xVel;
    p.yVel = this.yVel;
    p.visibility = this.visibility;
    return p;
  }
  
}