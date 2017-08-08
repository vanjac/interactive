PImage template;
PImage userHeaderTemplate;
PImage moreText;
PImage userHeader;

float captionTextLeading = 33;
float captionDefaultLines = 3; //unexpanded
float captionExpandedLines = 8;

class Post {
  PImage image;
  String caption;
  String timeAgo;
  
  Post(PImage image, String caption, String timeAgo) {
    this.image = image;
    this.caption = caption;
    this.timeAgo = timeAgo.toUpperCase();
  }
  
  PImage getImage() {
    return image;
  }
  
  String getCaption() {
    return caption;
  }
  
  String getTimeAgo() {
    return timeAgo;
  }
}

void setupPosts(int numPosts) {
  template = loadImage("pictureComponentBlank.png");
  userHeaderTemplate = loadImage("userHeaderBlank.png");
  moreText = loadImage("moreText.png");
  postImages = new PImage[numPosts];
  userHeader = makeUserHeader();
}

PImage makeUserHeader() {
  PGraphics gfx = createGraphics(userHeaderTemplate.width, userHeaderTemplate.height);
  gfx.beginDraw();
  
  //draw template
  gfx.image(userHeaderTemplate, 0, 0);
  
  //draw user image
  gfx.image(userImage, 22, 22, 64, 64);
  
  //draw username
  gfx.fill(18, 86, 136);
  gfx.textSize(27);
  gfx.textAlign(LEFT, CENTER);
  gfx.text(userName, 104, 48);
  
  gfx.endDraw();
  return gfx;
}

PImage makePostImage(Post p, boolean fullText) {
  int gfxHeight = template.height;
  if(fullText)
    gfxHeight += captionTextLeading * (captionExpandedLines - captionDefaultLines);
  PGraphics gfx = createGraphics(template.width, gfxHeight);
  gfx.beginDraw();
  
  //draw template
  gfx.image(template, 0, 0);
  
  //draw user header
  PImage header = userHeader;
  gfx.image(header, 0, 0);
  
  int captionX = 32;
  int captionY = 858;
  int captionMaxWidth = phoneWidth - 64;
  int captionMaxHeight = (int)(captionTextLeading * (fullText ? captionExpandedLines : captionDefaultLines));
  gfx.fill(255, 255, 255);
  gfx.noStroke();
  gfx.rect(0, captionY, gfx.width, gfx.height); // text background; try to remove gray line
  
  if(p != null) {
    //draw image
    if(p.getImage() != null)
      gfx.image(p.getImage(), 0, header.height, phoneWidth, phoneWidth);
    
    //caption
    gfx.fill(52, 55, 59);
    gfx.textSize(27);
    gfx.textAlign(LEFT, TOP);
    gfx.textLeading(captionTextLeading);
    gfx.text(userName + " " + p.getCaption(), captionX, captionY, captionMaxWidth, captionMaxHeight);
    
    //"more" label
    if(!fullText)
      gfx.image(moreText, phoneWidth - moreText.width, 927);
    
    //time ago
    gfx.fill(167, 169, 172);
    gfx.textSize(21);
    gfx.text(p.getTimeAgo(), 32, gfx.height - 71);
  }
  
  //username
  gfx.fill(18, 86, 136);
  gfx.textSize(27);
  gfx.textAlign(LEFT, TOP);
  gfx.text(userName, 32, 858);
  
  gfx.endDraw();
  return gfx;
}