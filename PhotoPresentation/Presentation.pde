class Presentation {
  
  Action action;
  color backgroundColor;
  
  Presentation() {
    action = new ActionGroup();
    backgroundColor = color(255,255,255);
  }
  
  Presentation(Action action) {
    this.action = action;
    backgroundColor = color(255,255,255);
  }
  
  JSONObject createJSON() {
    JSONObject json = new JSONObject();
    json.setJSONObject("action", action.createJSON());
    json.setInt("background", backgroundColor);
    return json;
  }
  
}