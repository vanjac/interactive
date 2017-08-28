interface ImageCreator {
  PImage create();
  JSONObject createJSON();
}

class ImageLoader implements ImageCreator {
  String name;
  color backgroundColor;
  int maxImageDimension;
  
  ImageLoader(String name, color background, World w) {
    this.name = name;
    backgroundColor = background;
    maxImageDimension = int(w.height * MAX_IMAGE_SIZE);
  }
  
  String toString() {
    return "Image " + name;
  }
  
  JSONObject createJSON() {
    JSONObject json = new JSONObject();
    json.setString("type", "image");
    json.setString("name", name);
    json.setInt("background", backgroundColor);
    return json;
  }
  
  PImage create() {
    PImage image = loadImage(imageDirectory.toPath().resolve(name).toString());
    if(image == null)
      return null;
    float w = image.width;
    float h = image.height;
    if(w > h) {
      if(w > maxImageDimension) {
        w *= float(maxImageDimension) / image.width;
        h *= float(maxImageDimension) / image.width;
      }
    } else {
      if(h > maxImageDimension) {
        w *= float(maxImageDimension) / image.height;
        h *= float(maxImageDimension) / image.height;
      }
    }
    
    PGraphics imageG = createGraphics(int(w), int(h));
    imageG.beginDraw();
    imageG.background(world.backgroundColor);
    imageG.image(image, 0, 0, w, h);
    imageG.endDraw();
    return imageG;
  }
}