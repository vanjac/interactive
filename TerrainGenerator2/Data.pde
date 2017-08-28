class Triangle {
  public PVector v1, v2, v3;
  public color c;
  public int type;
  
  public Triangle(PVector v1, PVector v2, PVector v3, int type) {
    this.v1 = v1;
    this.v2 = v2;
    this.v3 = v3;
    c = #BBBBBB;
    this.type = type;
  }
  
  public PVector vN(int n) {
    switch(n) {
      case 0:
        return v1;
      case 1:
        return v2;
      case 2:
        return v3;
    }
    return null;
  }
  
  public float dist1() {
    return v2.dist(v3);
  }
  
  public float dist2() {
    return v3.dist(v1);
  }
  
  public float dist3() {
    return v1.dist(v2);
  }
  
  public float distN(int n) {
    switch(n) {
      case 0:
        return dist1();
      case 1:
        return dist2();
      case 2:
        return dist3();
    }
    return -1;
  }
  
  public float perimeter() {
    return dist1() + dist2() + dist3();
  }
  
  public float semiperimeter() {
    return perimeter() / 2;
  }
  
  public PVector incenter() {
    return ( v1.copy().mult(dist1())
        .add(v2.copy().mult(dist2()))
        .add(v3.copy().mult(dist3()))
           ).div(perimeter());
  }
  
  public float incircleRadius() {
    float s = semiperimeter();
    return sqrt((s - dist1()) * (s - dist2()) * (s - dist3()) / s);
  }
  
  public float area() {
    float s = semiperimeter();
    return sqrt(s * (s - dist1()) * (s - dist2()) * (s - dist3()));
  }
  
  public PVector normal() {
    PVector a = v2.copy().sub(v1);
    PVector b = v3.copy().sub(v1);
    PVector normal = a.cross(b);
    return normal.normalize();
  }
}


class World {
  public ArrayList<Triangle> triangles;
  
  public World() {
    triangles = new ArrayList<Triangle>();
  }
  
  void addTriangle(Triangle t) {
    triangles.add(t);
  }
  
  void removeTriangle(Triangle t) {
    triangles.remove(t);
  }
}


class TerrainProperties {
  public float variation;
  
  TerrainProperties copy() {
    TerrainProperties n = new TerrainProperties();
    n.variation = variation;
    return n;
  }
}