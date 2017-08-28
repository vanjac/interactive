
void renderWorld(World w) {
  pushStyle();
  for(Triangle t : w.triangles) {
    renderTriangle(t);
  }
  popStyle();
}

void renderTriangle(Triangle t) {
  //stroke(0);
  noStroke();
  fill(t.c);
  beginShape(TRIANGLES);
  vertex(t.v1.y, t.v1.z, t.v1.x);
  vertex(t.v2.y, t.v2.z, t.v2.x);
  vertex(t.v3.y, t.v3.z, t.v3.x);
  endShape();
}