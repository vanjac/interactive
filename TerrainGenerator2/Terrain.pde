final int NUM_SUBDIVISONS = 6;

Triangle makeBaseTriangle(int i, float variation, float elevation, int type, HashMap<PVector, PVector> pointTable) {
  Triangle t = null;
  switch(i) {
    case 0:
      t = new Triangle(
        new PVector(WORLD_SCALE, 0),
        new PVector(cos(radians(-120)) * WORLD_SCALE, sin(radians(-120)) * WORLD_SCALE),
        new PVector(cos(radians(120))  * WORLD_SCALE, sin(radians(120))  * WORLD_SCALE),
        type
      );
      break;
    case 1:
      t = new Triangle(
        new PVector(cos(radians(120))  * WORLD_SCALE - WORLD_SCALE, 0),
        new PVector(cos(radians(120))  * WORLD_SCALE, sin(radians(120))  * WORLD_SCALE),
        new PVector(cos(radians(-120)) * WORLD_SCALE, sin(radians(-120)) * WORLD_SCALE),
        type
      );
      break;
    case 2:
      t = new Triangle(
        new PVector(WORLD_SCALE, WORLD_SCALE),
        new PVector(-WORLD_SCALE, WORLD_SCALE),
        new PVector(WORLD_SCALE, -WORLD_SCALE),
        type
      );
      break;
    case 3:
      t = new Triangle(
        new PVector(WORLD_SCALE, -WORLD_SCALE),
        new PVector(-WORLD_SCALE, -WORLD_SCALE),
        new PVector(-WORLD_SCALE, WORLD_SCALE),
        type
      );
      break;
  }
  variation *= t.incircleRadius();
  PVector v1h = t.v1.copy(); v1h.z = 0;
  PVector v2h = t.v2.copy(); v2h.z = 0;
  PVector v3h = t.v3.copy(); v3h.z = 0;
  if(pointTable.containsKey(v1h)) {
    t.v1 = pointTable.get(v1h);
  } else {
    pointTable.put(v1h, t.v1);
    t.v1.z += random(-variation, variation) + elevation;
  }
  if(pointTable.containsKey(v2h)) {
    t.v2 = pointTable.get(v2h);
  } else {
    pointTable.put(v2h, t.v2);
    t.v2.z += random(-variation, variation) + elevation;
  }
  if(pointTable.containsKey(v3h)) {
    t.v3 = pointTable.get(v3h);
  } else {
    pointTable.put(v3h, t.v3);
    t.v3.z += random(-variation, variation) + elevation;
  }
  return t;
}

void subdivideTerrainTriangle(World terrain, Triangle t, HashMap<PVector, PVector> pointTable,
                              TerrainProperties properties, int numSubdivisions) {
  if(numSubdivisions < 0) {
    terrain.addTriangle(t);
    return;
  }
  float radius = t.incircleRadius();
  PVector mid1 = t.v2.copy().lerp(t.v3, .5);
  PVector mid1h = mid1.copy(); mid1h.z = 0;
  PVector mid2 = t.v3.copy().lerp(t.v1, .5);
  PVector mid2h = mid2.copy(); mid2h.z = 0;
  PVector mid3 = t.v1.copy().lerp(t.v2, .5);
  PVector mid3h = mid3.copy(); mid3h.z = 0;
  
  if(pointTable.containsKey(mid1h)) {
    mid1 = pointTable.get(mid1h);
  } else {
    pointTable.put(mid1h, mid1);
    randomVariation(mid1, radius*properties.variation);
  }
  if(pointTable.containsKey(mid2h)) {
    mid2 = pointTable.get(mid2h);
  } else {
    pointTable.put(mid2h, mid2);
    randomVariation(mid2, radius*properties.variation);
  }
  if(pointTable.containsKey(mid3h)) {
    mid3 = pointTable.get(mid3h);
  } else {
    pointTable.put(mid3h, mid3);
    randomVariation(mid3, radius*properties.variation);
  }
  
  Triangle[] newTriangles = new Triangle[4];
  newTriangles[0] = new Triangle(t.v1, mid3, mid2, t.type);
  newTriangles[1] = new Triangle(t.v2, mid1, mid3, t.type);
  newTriangles[2] = new Triangle(t.v3, mid2, mid1, t.type);
  newTriangles[3] = new Triangle(mid1, mid2, mid3, t.type);
  
  for(Triangle newTriangle : newTriangles) {
    //TerrainProperties newProperties = properties.copy();
    //newProperties.variation *= random(1.0 - radius / WORLD_SCALE, 1.0 + radius / WORLD_SCALE);
    TerrainProperties newProperties = properties;
    subdivideTerrainTriangle(terrain, newTriangle, pointTable, newProperties, numSubdivisions - 1);
  }
}

void randomVariation(PVector v, float scale) {
  v.z += random(-scale, scale);
}