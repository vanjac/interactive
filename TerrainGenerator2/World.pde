final float WORLD_SCALE = 30;

World generateWorld() {
  World w = new World();

  int terrainIndex = addTerrain(w);
  int waterIndex = addWater(w);
  
  colorize(w, terrainIndex, waterIndex);
  
  return w;
}




int addTerrain(World w) {
  int index = w.triangles.size();
  float terrainElevation = random(-0.3*WORLD_SCALE, 0.3*WORLD_SCALE);
  TerrainProperties terrainProperties = new TerrainProperties();
  terrainProperties.variation = random(1);
  int type = int(floor(random(TYPE_MIN_GROUND, TYPE_MAX_GROUND)));
  HashMap<PVector, PVector> pointTable = new HashMap<PVector, PVector>();
  subdivideTerrainTriangle(w, makeBaseTriangle(2, terrainProperties.variation, terrainElevation, type, pointTable),
                           pointTable, terrainProperties, NUM_SUBDIVISONS);
  subdivideTerrainTriangle(w, makeBaseTriangle(3, terrainProperties.variation, terrainElevation, type, pointTable),
                           pointTable, terrainProperties, NUM_SUBDIVISONS);
  return index;
}

int addWater(World w) {
  int index = w.triangles.size();
  float waterElevation = random(-0.3*WORLD_SCALE, 0.3*WORLD_SCALE);
  TerrainProperties waterProperties = new TerrainProperties();
  waterProperties.variation = random(0.2);
  HashMap<PVector, PVector> pointTable = new HashMap<PVector, PVector>();
  subdivideTerrainTriangle(w, makeBaseTriangle(2, waterProperties.variation, waterElevation, TYPE_WATER, pointTable),
                           pointTable, waterProperties, NUM_SUBDIVISONS);
  subdivideTerrainTriangle(w, makeBaseTriangle(3, waterProperties.variation, waterElevation, TYPE_WATER, pointTable),
                           pointTable, waterProperties, NUM_SUBDIVISONS);
  return index;
}


void colorize(World w, int terrainIndex, int waterIndex) {
  for(int i = 0; i < w.triangles.size(); i++) {
    Triangle triangle = w.triangles.get(i);
    if(i >= terrainIndex && i < waterIndex) {
      float terrainHeight = triangle.incenter().z;
      float waterHeight = w.triangles.get(i - terrainIndex + waterIndex).incenter().z;
      if(abs(terrainHeight-waterHeight) < WORLD_SCALE * .05 && triangle.type != TYPE_SNOW)
        triangle.type = TYPE_SAND;
    }
    
    float scale = abs(triangle.normal().z);
    color typeColor = TYPE_COLORS[triangle.type];
    triangle.c = color(red(typeColor) * scale,
                       green(typeColor) * scale,
                       blue(typeColor) * scale,
                       alpha(typeColor));
  }
}