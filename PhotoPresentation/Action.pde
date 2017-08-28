interface Action {
  
  Action cloneWithState();
  
  void load();
  void unload();
  
  void start(World world, float time);
  void step(World world, float time, float elapsed);
  boolean isFinished();
  void end(World world);
  
  JSONObject createJSON();
  
}


class ActionGroup implements Action {
  
  class Step {
    Action action;
    boolean waitUntilFinished;
    
    Step(Action action, boolean waitUntilFinished) {
      this.action = action;
      this.waitUntilFinished = waitUntilFinished;
    }
  }
  
  List<Step> steps;
  int stepI;
  List<Action> runningActions;
  Action waitAction;
  
  ActionGroup() {
    steps = new ArrayList<Step>();
    stepI = -1;
    runningActions = new ArrayList<Action>();
    waitAction = null;
  }
  
  ActionGroup cloneWithState() {
    ActionGroup a = new ActionGroup();
    for(Step s : this.steps) {
      a.steps.add(new Step(s.action.cloneWithState(), s.waitUntilFinished));
    }
    a.stepI = this.stepI;
    for(Action action : this.runningActions) {
      a.runningActions.add(a.steps.get(indexOfStepWithAction(action)).action);
    }
    if(this.waitAction != null)
      a.waitAction = a.steps.get(indexOfStepWithAction(this.waitAction)).action;
    return a;
  }
  
  private int indexOfStepWithAction(Action a) {
    int i = 0;
    for(Step s : steps) {
      if(s.action == a)
        break;
      i++;
    }
    if(i == steps.size())
      i = -1;
    return i;
  }
  
  String toString() {
    StringBuilder message = new StringBuilder();
    message.append("Action group:\n");
    for(Step s : steps) {
      message.append(s.action.toString());
      if(s.waitUntilFinished)
        message.append(" and wait until finished, then...\n");
      else
        message.append(", meanwhile...\n");
    }
    message.append("Done");
    return message.toString();
  }
  
  JSONObject createJSON() {
    JSONObject json = new JSONObject();
    json.setString("type", "group");
    JSONArray stepsArray = new JSONArray();
    int i = 0;
    for(Step s : steps) {
      JSONObject stepObject = new JSONObject();
      stepObject.setJSONObject("action", s.action.createJSON());
      stepObject.setBoolean("wait", s.waitUntilFinished);
      stepsArray.setJSONObject(i, stepObject);
      i++;
    }
    json.setJSONArray("steps", stepsArray);
    return json;
  }
  
  void addAction(Action action, boolean waitUntilFinished) {
    steps.add(new Step(action, waitUntilFinished));
  }
  
  void load() {
    for(Step s : steps)
      s.action.load();
  }
  
  void unload() {
    for(Step s : steps)
      s.action.unload();
  }
  
  void start(World world, float time) {
    stepI = 0;
    runningActions = new ArrayList<Action>();
    waitAction = null;
  }
  
  void step(World world, float time, float elapsed) {
    while(stepI < steps.size() &&
        (waitAction == null || waitAction.isFinished())) {
      Step s = steps.get(stepI);
      s.action.start(world, time);
      runningActions.add(s.action);
      if(s.waitUntilFinished)
        waitAction = s.action;
      stepI++;
    }
    
    List<Action> toRemove = new ArrayList<Action>();
    for(Action a : runningActions) {
      if(a.isFinished())
        toRemove.add(a);
      else
        a.step(world, time, elapsed);
    }
    for(Action a : toRemove) {
      a.end(world);
      runningActions.remove(a);
    }
  }
  
  boolean isFinished() {
    return stepI == steps.size() && (waitAction == null || waitAction.isFinished());
  }
  
  void end(World world) {
    for(Action a : runningActions)
      a.end(world);
    
    stepI = -1;
    runningActions = new ArrayList<Action>();
    waitAction = null;
  }
  
}

class WaitAction implements Action {
  
  float waitTime;
  float startTime;
  float currentWaitTime;
  
  WaitAction(float time) {
    waitTime = time;
    startTime = 0;
    currentWaitTime = 0;
  }
  
  WaitAction cloneWithState() {
    WaitAction a = new WaitAction(this.waitTime);
    a.startTime = this.startTime;
    a.currentWaitTime = this.currentWaitTime;
    return a;
  }
  
  String toString() {
    return "Wait " + waitTime + " seconds";
  }
  
  JSONObject createJSON() {
    JSONObject json = new JSONObject();
    json.setString("type", "wait");
    json.setFloat("time", waitTime);
    return json;
  }
  
  void load() { }
  void unload() { }
  
  void start(World world, float time) {
    startTime = time;
    currentWaitTime = 0;
  }
  
  void step(World world, float time, float elapsed) {
    currentWaitTime = time - startTime;
  }
  
  boolean isFinished() {
    return currentWaitTime > waitTime;
  }
  
  void end(World world) { }
  
}


class WaitForUserInputAction implements Action {
  
  boolean finished;
  List<WaitForUserInputAction> listenersList;
  
  WaitForUserInputAction(List<WaitForUserInputAction> listenersList) {
    finished = false;
    this.listenersList = listenersList;
  }
  
  WaitForUserInputAction cloneWithState() {
    WaitForUserInputAction a = new WaitForUserInputAction(this.listenersList);
    a.finished = this.finished;
    return a;
  }
  
  String toString() {
    return "Wait for user input";
  }
  
  JSONObject createJSON() {
    JSONObject json = new JSONObject();
    json.setString("type", "input");
    return json;
  }
  
  void userInput() {
    finished = true;
  }
  
  void load() { }
  void unload() { }
  
  void start(World world, float time) {
    listenersList.add(this);
  }
  
  void step(World world, float time, float elapsed) { }
  
  boolean isFinished() {
    return finished;
  }
  
  void end(World world) { }
  
}


class AddImageAction implements Action {
  
  ImageCreator imageCreator;
  PImage image;
  float x, y;
  
  AddImageAction(ImageCreator imageCreator, float x, float y) {
    this.imageCreator = imageCreator;
    this.x = x;
    this.y = y;
  }
  
  AddImageAction cloneWithState() {
    AddImageAction a = new AddImageAction(this.imageCreator, this.x, this.y);
    a.image = this.image;
    return a;
  }
  
  String toString() {
    return "Add " + imageCreator + " at " + x + ", " + y;
  }
  
  JSONObject createJSON() {
    JSONObject json = new JSONObject();
    json.setString("type", "add");
    json.setJSONObject("image", imageCreator.createJSON());
    return json;
  }
  
  void load() {
    image = imageCreator.create();
  }
  
  void unload() {
    image = null;
  }
  
  void start(World world, float time) {
    float xPos, yPos;
    if(freeForm) {
      xPos = mouseX;
      yPos = mouseY;
    } else {
      xPos = world.width/2 + x * (height/2);
      yPos = world.height/2 + y * (height/2);
    }
    Picture newPicture = new Picture(image, xPos, yPos,
                             image.width, image.height);
    world.pictures.add(newPicture);
  }
  
  void step(World world, float time, float elapsed) { }
  
  boolean isFinished() {
    return true;
  }
  
  void end(World world) { }
  
}


class RepelAction implements Action {
  
  float originX, originY;
  float strength;
  
  RepelAction(float originX, float originY, float strength) {
    this.originX = originX;
    this.originY = originY;
    this.strength = strength;
  }
  
  RepelAction cloneWithState() {
    return new RepelAction(this.originX, this.originY, this.strength);
  }
  
  String toString() {
    return "Repel images from " + originX + ", " + originY
      + " with strength " + strength;
  }
  
  JSONObject createJSON() {
    JSONObject json = new JSONObject();
    json.setString("type", "repel");
    json.setFloat("x", originX);
    json.setFloat("y", originY);
    json.setFloat("strength", strength);
    return json;
  }
  
  void load() { }
  void unload() { }
  
  void start(World world, float time) {
    float xPos, yPos;
    if(freeForm) {
      xPos = mouseX;
      yPos = mouseY;
    } else {
      xPos = world.width/2 + originX * (height/2);
      yPos = world.height/2 + originY * (height/2);
    }
    float amount = strength * height;
    for(Picture p : world.pictures) {
      PVector direction = new PVector(p.x - xPos, p.y - yPos);
      direction = direction.normalize();
      p.xVel += direction.x * amount;
      p.yVel += direction.y * amount;
    }
  }
  
  void step(World world, float time, float elapsed) { }
  
  boolean isFinished() {
    return true;
  }
  
  void end(World world) { }
  
}