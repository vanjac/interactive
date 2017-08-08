int printStartTime;

void printStart(String message) {
  print(message + "... ");
  printStartTime = millis();
}

void printDone() {
  println("Done (" + (millis() - printStartTime) + " millis)");
}

void error(String message) {
  JOptionPane.showMessageDialog(null,
    message,
    "Error",
    JOptionPane.ERROR_MESSAGE);
  exit();
}