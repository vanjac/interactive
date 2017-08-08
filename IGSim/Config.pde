String configFile = "config.txt";
Path configPath;

String userName;
PImage userImage;

Post[] posts;

boolean configFolderChosen = false;

void chooseConfigFolder(File file) {
  println("Folder chosen: " + file);
  configPath = file.toPath();
  configFolderChosen = true;
}

//return success
boolean loadConfig() {
  String[] lines = loadStrings(getConfigPath(configFile));
  if(lines == null) {
    error("Couldn't load config file at " + configFile);
    return false;
  }
  if(lines.length < 2 || (lines.length - 2) % 3 != 0) {
    error("Invalid config data");
    return false;
  }
  
  userName = lines[0];
  
  userImage = loadImage(getConfigPath(lines[1]));
  if(userImage == null) {
    error("Couldn't load user image at " + lines[1]);
    return false;
  }
  
  int numPosts = (lines.length - 2) / 3;
  posts = new Post[numPosts];
  
  int post = 0;
  for(int i = 2; i < lines.length; i+=3) {
    String postImageFile = lines[i].trim();
    String postText = lines[i+1];
    String postTimeAgo = lines[i+2];
    
    PImage image = null;
    if(!postImageFile.isEmpty()) {
      image = loadImage(getConfigPath(postImageFile));
      if(image == null) {
        error("Couldn't load image " + (post+1) + " at " + postImageFile);
        return false;
      }
    }
    posts[post++] = new Post(image, postText, postTimeAgo);
  }
  
  return true;
}


String getConfigPath(String fileName) {
  return configPath.resolve(fileName).toString();
}