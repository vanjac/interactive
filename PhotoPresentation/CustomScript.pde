Action addImageAction(String name, float x, float y) {
  Action a = new AddImageAction(new ImageLoader(name, color(255,255,255), world),
  (x-.5) * 2 * 16 / 9, (y-.5) * 2);
  return a;
}

Action repelAction(float originX, float originY, float strength) {
  Action a = new RepelAction((originX-.5) * 2 * 16 / 9, (originY-.5) * 2, strength / 1080.0);
  return a;
}

Presentation createPresentation() {
  Presentation p = new Presentation();
  
  ActionGroup actionGroup = new ActionGroup();
  // add actions here...
  
  p.action = actionGroup;
  p.backgroundColor = color(255,255,255);
  
  return p;
}