final float X_SCROLL_SPEED = 512;
final boolean DYNAMIC_TICK_SIZE = false; // expand ticks closer to mouse?
final float ZOOM = 128; // pixels per year
final float LINE_WIDTH = 4; // stroke weight
final color LINE_COLOR = color(0, 63, 63);
final float TICK_LENGTH = 96; // height of minor ticks; major ticks are double height
final float MINOR_LINES = 1; // years between minor ticks
final float MAJOR_LINES = 10; // years between major ticks

final color BACKGROUND_COLOR = color(0, 0, 0);
final String BACKGROUND_IMAGE = "background.png"; // null for no background
final float BACKGROUND_IMAGE_WIDTH = 256;
final float BACKGROUND_IMAGE_HEIGHT = 256;
final float BACKGROUND_IMAGE_X_POSITION = 1.0 / 4.0; // 0 to 1
final float BACKGROUND_IMAGE_Y_POSITION = 1.0 / 4.0; // 0 to 1
final color TITLE_COLOR = color(255, 255, 255);
final String TITLE = "This is a timeline!!\n(you can change this title)";
final float ORIGIN_YEAR = 1940;

final float DOT_MIN_SIZE = 4; // only used if DYNAMIC_TICK_SIZE
final float DOT_SIZE = 24;
final color DOT_COLOR = color(31, 95, 127);
final color DOT_SELECTED_COLOR = color(0, 191, 255);

final color BOX_COLOR = color(31, 95, 127);
final float BOX_WIDTH = 256;
final float BOX_HEIGHT = 256;
final color BOX_TEXT_COLOR = color(255, 255, 255);


void addDots() {
  addDot(1940, 0, 0, "Dot with year");
  addDot(1941, 2, 0, "Dot with year and month");
  addDot(1942, 3, 10, "Dot with date");
  addTextDot(1943, 6, 28, "Dot with info",
    "Info info info info info info info info info info info info info info info info info info info info info info info info info info info info info info info info info info."
    );
  addImageDot(1944, 4, 17, "Dot with image",
    "Info info info info info info info info info info info info info info info info info info info info info info info info info info info info info info info info info info.",
    "background.png"
    );
  addTextDot(1945, 1, 9, "Dot with a long title Dot with a long title Dot with a long title",
    "Info info info info info info info info info info info info info info info info info info info info info info info info info info info info info info info info info info."
    );
}