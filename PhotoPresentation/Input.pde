int ppmouseX;
int ppmouseY;

List<WaitForUserInputAction> inputListeners = new ArrayList<WaitForUserInputAction>();

void advance() {
  pushUndo();
  for(WaitForUserInputAction a : inputListeners)
    a.userInput();
  inputListeners.clear();
}

void mouseClicked() {
  if(mouseButton == LEFT) {
    grabbedPicture = null;
    advance();
  }
}

void mousePressed() {
  if(mouseButton == LEFT)
    selectImage(mouseX, mouseY);
}

void keyPressed() {
  if(key == ' ' || keyCode == RIGHT)
    advance();
  if(key == BACKSPACE || keyCode == LEFT)
    if(canUndo())
      undo();
}

void getInput() {
  if(grabbedPicture != null) {
    if(mousePressed && mouseButton == LEFT) {
      dragImage(mouseX, mouseY, pmouseX, pmouseY);
    } else {
      // average of last 2 mouse changes
      releaseImage(mouseX, mouseY, ppmouseX, ppmouseY);
    }
  }
  
  if(mousePressed && mouseButton == RIGHT) {
    Action repelAction = new RepelAction(
      (float(mouseX)-width/2) / height * 2,
      (float(mouseY)-height/2) / height * 2, 1.0);
    repelAction.load();
    repelAction.start(world, float(millis()) / 1000.0);
    repelAction.end(world);
  }
  
  ppmouseX = pmouseX;
  ppmouseY = pmouseY;
}


void selectImage(float x, float y) {
  grabbedPicture = null;
    for(Picture p : world.pictures) {
      if(x > p.x - p.width/2 && x < p.x + p.width/2
          && y > p.y - p.height/2 && y < p.y + p.height/2) {
        grabbedPicture = p;
      }
    }
    if(grabbedPicture != null) {
      // move to front
      world.pictures.remove(grabbedPicture);
      world.pictures.add(grabbedPicture);
      grabbedPicture.xVel = 0;
      grabbedPicture.yVel = 0;
    }
}

void dragImage(float x, float y, float px, float py) {
  grabbedPicture.x += x - px;
  grabbedPicture.y += y - py;
}

void releaseImage(float x, float y, float ppx, float ppy) {
    grabbedPicture.xVel = (x - ppx) / 2.0;
    grabbedPicture.yVel = (y - ppy) / 2.0;
    
    grabbedPicture = null;
}