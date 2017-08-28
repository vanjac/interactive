List<World> worldStates = new ArrayList<World>();
List<Action> actionStates = new ArrayList<Action>();

int undoLevel = 0;

void pushUndo() {
  worldStates.add(world.clone());
  actionStates.add(presentation.action.cloneWithState());
}

boolean canUndo() {
  return !worldStates.isEmpty();
}

void undo() {
  world = worldStates.remove(worldStates.size() - 1);
  presentation.action = actionStates.remove(actionStates.size() - 1);
}