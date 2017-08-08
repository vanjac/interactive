import javax.swing.JOptionPane;
import java.nio.file.*;

//settings
int phoneWidth = 640;
int phoneHeight = 960;
float scale = 0.75;

float wheelScrollSpeed = 16;
float keyboardScrollSpeed = 256;
float mouseScrollSpeed = 0.5;


//internal vars
boolean initialized = false;
int frame = 0;

float scrollTick = 0;

PImage loadingScreen;
PImage statusBar;
PImage footer;
PImage header;

PImage[] postImages;

int displayedPostIndex; //the index of the topmost post shown onscreen

float headerShift = 0;
float scroll = 0;
float pageHeight = 0;

void setup() {
  size(480, 720, P2D); // .75 scale
  //size(320, 480, P2D); // .5 scale
  
  printStart("Loading the loading screen...");
    loadingScreen = loadImage("loading.png");
    background(18, 86, 136);
    image(loadingScreen, width/2-loadingScreen.width/2, height/2-loadingScreen.height/2);
  printDone();
}

void draw() {
  frame++;
  if(frame == 1) {
    selectFolder("Choose a IGSim data folder...", "chooseConfigFolder");
    return;
  }
  if(!configFolderChosen)
    return;
  if(!initialized) {
    initialized = true;
    printStart("Loading font");
      text(" ", 0, 0);
    printDone();
    printStart("Loading basic UI");
      statusBar = loadImage("headerCollapsed.png");
      footer = loadImage("footer.png");
      header = loadImage("headerOnly.png");
    printDone();
    printStart("Loading posts and user data");
      if(!loadConfig())
        return;
    printDone();
    println(posts.length + " posts loaded.");
    printStart("Loading post UI");
      setupPosts(posts.length);
    printDone();
    
    printStart("Drawing posts");
      int i = 0;
      for(Post p : posts) {
        postImages[i++] = makePostImage(p, false);
        print(i + " ");
      }
    printDone();
    return;
  }
  
  background(255,255,255);
  resetMatrix();
  scale(scale);
  
  //scroll:
  if(mousePressed)
    scrollTick += (mouseY - pmouseY) * mouseScrollSpeed;
  
  if(keyPressed && key == CODED && keyCode == UP)
    scrollTick += keyboardScrollSpeed/frameRate;
  if(keyPressed && key == CODED && keyCode == DOWN)
    scrollTick -= keyboardScrollSpeed/frameRate;
  
  if(scroll < 0)
    headerShift += scrollTick;
  if(headerShift > 0)
    headerShift = 0;
  if(headerShift < -header.height)
    headerShift = -header.height;
    
  scroll += scrollTick;
    
  //calc user header y pos
  float userHeaderY = statusBar.height + header.height + headerShift;
  
  //draw posts
  float y = statusBar.height + header.height;
  displayedPostIndex = -1;
  pageHeight = 0;
  int i = 0;
  for(PImage p : postImages) {
    float totalY = y + scroll;
    image(p, 0, totalY);
    y += p.height;
    //let posts push user header off screen
    if(totalY > userHeaderY && totalY < userHeaderY + userHeader.height)
      userHeaderY = totalY - userHeader.height;
    if(totalY > statusBar.height && displayedPostIndex == -1)
      displayedPostIndex = i - 1;
    pageHeight += p.height;
    i++;
  }
  if(displayedPostIndex == -1)
    displayedPostIndex = postImages.length - 1;
  
  //draw user header
  if(scroll < -headerShift)
    image(userHeader, 0, userHeaderY);
  
  image(header, 0, statusBar.height + headerShift);
  image(statusBar, 0, 0);
  image(footer, 0, phoneHeight - footer.height);
  
  //bounce back at top and bottom of page
  if(scroll > 0) {
    scrollTick -= .05*scroll;
    scrollTick *= 0.8;
  }
  float minScroll = -pageHeight
      + phoneHeight
      - header.height
      - statusBar.height
      - footer.height;
  if(scroll < minScroll) {
    scrollTick -= .05*(scroll - minScroll);
    scrollTick *= 0.8;
  }
  //slow down scroll over time
  scrollTick *= 0.9;
}

void mouseWheel(MouseEvent event) {
  float n = event.getCount();
  scrollTick += n*wheelScrollSpeed;
}

void mouseClicked() {
  float mouseXMovement = mouseX-pmouseX;
  float mouseYMovement = mouseY-pmouseY;
  float mouseMovement = sqrt(mouseXMovement*mouseXMovement + mouseYMovement*mouseYMovement);
  if(mouseMovement != 0)
    return;
  
  print("Click, ");
  color pixelUnderMouse = get(mouseX, mouseY);
  if(brightness(pixelUnderMouse) > 174 && saturation(pixelUnderMouse) < 10) {
    println("expand!");
    printStart("Expanding post");
    postImages[displayedPostIndex] = makePostImage(posts[displayedPostIndex], true);
    printDone();
  } else {
    println("don't expand.");
  }
}