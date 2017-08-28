import java.util.List;

final float FLING_DECELERATION = 0.9;
final float ZOOM_IN_EFFECT = -64;
final float FADE_IN_TIME = 0.2;
final float MAX_IMAGE_SIZE = 0.47; // fraction of screen height

final boolean USE_DATA_DIR = true;

boolean freeForm = false;

World world;
Presentation presentation;
boolean actionStarted = false;
int lastMillis;

File imageDirectory;

boolean waitMessageShown = false;
boolean fileChooserOpened  = false;
boolean ready = false;

Picture grabbedPicture;

void settings() {
  size(640, 480);
}

void setup() {
  world = new World(width, height);
  
  lastMillis = millis();
}

void resetPresentation() {
  inputListeners.clear();
  worldStates.clear();
  undoLevel = 0;
  world = new World(width, height);
  world.backgroundColor = presentation.backgroundColor;
}

void fullScreenMessage(String message) {
  background(0);
  
  fill(255,255,255);
  textAlign(CENTER, CENTER);
  textSize(height/16);
  text(message, width/2, height/2);
}


void draw() {
  int time = millis();
  if(!waitMessageShown) {
    fullScreenMessage("loading");
    waitMessageShown = true;
  } else if(!fileChooserOpened) {
    if(USE_DATA_DIR)
      loadPresentation(dataFile(""));
    else
      selectFolder("Choose a folder of images", "loadPresentation");
    fileChooserOpened = true;
  } else if(!ready) {
    // wait
  } else if(!presentation.action.isFinished()) {
    if(!actionStarted) {
      actionStarted = true;
      presentation.action.start(world, float(time) / 1000.0);
    }
    presentation.action.step(world, float(time) / 1000.0, float(time - lastMillis) / 1000.0);
    
    getInput();
    simulateWorld(world);
    drawWorld(world);
  } else {
    fullScreenMessage("end of presentation\npress escape");
  }
  lastMillis = time;
}

void loadPresentation(File dir) {
  if(dir == null) {
    exit();
    return;
  }
  
  imageDirectory = dir;
  presentation = createPresentation();
  presentation.action.load();
  
  resetPresentation();
  
  ready = true;
}