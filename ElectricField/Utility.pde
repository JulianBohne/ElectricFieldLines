
void coords(){
  float axisLength = 10; // All in all 20 = 10 + 10
  float arrowSize = 1;
  
  PVector currentAxis = new PVector(axisLength*2, 0, 0);
  pushMatrix();
  translate(-axisLength, 0, 0);
  showVector(currentAxis, color(255, 0, 0), arrowSize); // X Axis
  popMatrix();
  
  currentAxis.set(0, axisLength*2, 0);
  pushMatrix();
  translate(0, -axisLength, 0);
  showVector(currentAxis, color(0, 255, 0), arrowSize); // Y Axis
  popMatrix();
  
  currentAxis.set(0, 0, axisLength*2);
  pushMatrix();
  translate(0, 0, -axisLength);
  showVector(currentAxis, color(0, 0, 255), arrowSize); // Z Axis
  popMatrix();
}

void showVector(PVector v){
  showVector(v, color(255), 1);
}

void showVector(PVector v, color col, float arrowSize){
  pushStyle();
  
  PVector vEnd = v.copy();
  vEnd.setMag(vEnd.mag() - arrowSize/2);
  
  stroke(col);
  strokeWeight(arrowSize / 8);
  line(0, 0, 0, vEnd.x, vEnd.y, vEnd.z);
  
  noStroke();
  fill(col);
  
  pushMatrix();
  translate(vEnd.x, vEnd.y, vEnd.z);
  
  // What follows is angle *magic*
  PVector vProjXY = new PVector(v.x, v.y);
  float angle = signedAngleBetween(vProjXY, new PVector(0,1));
  rotateZ(angle);
  PVector vRotYZToXY = new PVector(v.z, vProjXY.mag()); // TODO: clean this up a bit
  angle = signedAngleBetween(vRotYZToXY, new PVector(0, 1));
  rotateX(-angle);
  cone(arrowSize/2, arrowSize);
  popMatrix();
  
  popStyle();
}


float signedAngleBetween(PVector a, PVector b){ // only for 2D vectors
  return PVector.angleBetween(a, b) * Math.signum(a.y*b.x - a.x*b.y);
}

void cone(float d, float h){ // Cone pointing up the y-axis with a diameter of d and a height of h
  int vertCount = 16; // amount of vertices at the circle end
  float angle = TWO_PI/vertCount;
  
  PVector circ = new PVector(d/2, -h/2, 0);
  
  beginShape(TRIANGLE_FAN);
  vertex(0, h/2, 0);
  for(int i = 0; i <= vertCount; i ++){
    vertex(circ.x, circ.y, circ.z);
    rotateY(circ, angle);
  }
  endShape();
  
  beginShape(TRIANGLE_FAN);
  vertex(0, -h/2, 0); // not strictly necessary, but makes a nicer wireframe :D
  for(int i = 0; i <= vertCount; i ++){
    vertex(circ.x, circ.y, circ.z);
    rotateY(circ, angle);
  }
  endShape();
}

void cylinder(float d, float h){
  int vertCount = 16; // amount of vertices at the circle end
  float angle = TWO_PI/vertCount;
  
  PVector circ = new PVector(d/2, h/2, 0);
  beginShape(TRIANGLE_FAN);
  vertex(0, h/2, 0); // not strictly necessary, but makes a nicer wireframe :D
  for(int i = 0; i <= vertCount; i ++){
    vertex(circ.x, circ.y, circ.z);
    rotateY(circ, angle);
  }
  endShape();
  
  beginShape(QUAD_STRIP);
  for(int i = 0; i <= vertCount; i ++){
    vertex(circ.x, circ.y, circ.z);
    vertex(circ.x, -circ.y, circ.z);
    rotateY(circ, angle);
  }
  vertex(circ.x, circ.y, circ.z);
  endShape();
  
  circ.set(d/2, -h/2, 0);
  beginShape(TRIANGLE_FAN);
  vertex(0, -h/2, 0); // not strictly necessary, but makes a nicer wireframe :D
  for(int i = 0; i <= vertCount; i ++){
    vertex(circ.x, circ.y, circ.z);
    rotateY(circ, angle);
  }
  endShape();
}


PVector rotateY(PVector v, float angle){
  float tmpX = v.x;
  v.x = cos(angle)*v.x + sin(angle)*v.z;
  v.z = cos(angle)*v.z - sin(angle)*tmpX;
  return v;
}

// https://stackoverflow.com/questions/9600801/evenly-distributing-n-points-on-a-sphere
PVector[] fibonacciSphere(int numSamples){
  
  if(numSamples < 1) return new PVector[]{};
  if(numSamples == 1){
    return new PVector[]{
      new PVector(1, 0, 0)
    };
  }
  
  PVector[] points = new PVector[numSamples];
  float goldenAngle = PI*(sqrt(5) - 1);
  
  float x, y, z, radius, theta;
  for(int i = 0; i < numSamples; i ++){
    y = 1 - (i / float(numSamples - 1)) * 2; // y from -1 to 1
    radius = sqrt(1 - y*y);
    
    theta = goldenAngle * i; // golden angle increment
    
    x = cos(theta) * radius;
    z = sin(theta) * radius;
    
    points[i] = new PVector(x, y, z);
  }
  
  return points;
}

float mapAndConstrain(float x, float fromA, float fromB, float toA, float toB){
  return constrain(map(x, fromA, fromB, toA, toB), min(toA, toB), max(toA, toB));
}
