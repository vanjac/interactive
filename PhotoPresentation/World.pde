class World {
  
  List<Picture> pictures;
  color backgroundColor;
  float width, height;
  
  World(float width, float height) {
    pictures = new ArrayList<Picture>();
    backgroundColor = color(255,255,255);
    this.width = width;
    this.height = height;
  }
  
  World clone() {
    World w = new World(this.width, this.height);
    List<Picture> pictureClones = new ArrayList<Picture>();
    for(Picture p : this.pictures)
      pictureClones.add(p.clone());
    w.pictures = pictureClones;
    w.backgroundColor = this.backgroundColor;
    return w;
  }
  
}


void simulateWorld(World world) {
  for(Picture p : world.pictures) {
    p.visibility += 1 / FADE_IN_TIME / frameRate;
    if(p.visibility > 1)
      p.visibility = 1;
    
    p.x += p.xVel / frameRate * 60.0;
    p.y += p.yVel / frameRate * 60.0;
    p.xVel *= pow(FLING_DECELERATION, 60.0/frameRate);
    p.yVel *= pow(FLING_DECELERATION, 60.0/frameRate);
  }
}


void drawWorld(World world) {
  background(world.backgroundColor);
  
  imageMode(CENTER);
  for(Picture p : world.pictures) {
    // don't draw images that are off-screen
    if(p.x - p.width/2 > world.width || p.x + p.width/2 < 0
          || p.y - p.height/2 > world.height || p.y + p.height/2 < 0)
        continue;
    if(p.visibility == 0.0)
      continue;
    if(p.visibility < 1.0)
      tint(255,255,255,p.visibility * 255.0);
    image(p.image, p.x, p.y,
          p.width - (1.0 - p.visibility) * ZOOM_IN_EFFECT,
          p.height - (1.0 - p.visibility) * ZOOM_IN_EFFECT);
    if(p.visibility < 1.0)
      noTint();
  }
}