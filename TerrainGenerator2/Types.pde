final int TYPE_WATER = 1;
final int TYPE_MIN_GROUND = 100;
final int TYPE_DIRT = 100;
final int TYPE_GRASS = 101;
final int TYPE_SNOW = 102;
final int TYPE_SAND = 103;
final int TYPE_STONE = 104;
final int TYPE_MAX_GROUND = 105;

color[] TYPE_COLORS;

void initColors() {
  TYPE_COLORS = new color[200];
  TYPE_COLORS[TYPE_WATER] = color(0,0,255,191);
  TYPE_COLORS[TYPE_DIRT] = #AA6600;
  TYPE_COLORS[TYPE_GRASS] = #00FF00;
  TYPE_COLORS[TYPE_SNOW] = #EEEEEE;
  TYPE_COLORS[TYPE_SAND] = #FFBF22;
  TYPE_COLORS[TYPE_STONE] = #5F5F5F;
}

boolean isGround(int type) {
  return type >= TYPE_MIN_GROUND && type < TYPE_MAX_GROUND;
}