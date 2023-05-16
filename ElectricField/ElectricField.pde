public static float dt = 1f/60;
public static boolean pmousePressed = false;

float xAngle = 0, yAngle = 0; // Camera view angles
float mouseSensitivity = 0.5; // degrees per pixel
float zoom = 1, zoomMultiplier = 1.1;

Transform worldTransform = new Transform();

ArrayList<Particle> particles = new ArrayList<>(); // These interact with the field and emit field lines
ArrayList<PVector> fieldObservers = new ArrayList<>(); // These just emit field lines, but don't change the field

int framesSinceMousePressed = 0;

boolean showCoords = true;
boolean showFieldObservers = false;

void setup(){
  size(800, 600, P3D);
  frameRate(60);
  
  surface.setResizable(true);
  
  worldTransform.scale.z = -1;
  worldTransform.scale.mult(height/20);

  float maxSpread = 5;
  for(int i = 0; i < 5; i ++){
    if(random(0, 1) < 0.5){
      particles.add(new Proton(
        random(-maxSpread, maxSpread),
        random(-maxSpread, maxSpread),
        random(-maxSpread, maxSpread)
      ));
    }else{
      particles.add(new Electron(
        random(-maxSpread, maxSpread),
        random(-maxSpread, maxSpread),
        random(-maxSpread, maxSpread)
      ));
    }
  }
  
  //particles.add(new Proton(2, 2, 0));
  //particles.add(new Proton(-2, 2, 0));
  //particles.add(new Electron(-2, 2, 0));
  //particles.add(new Electron(2, -2, 0));
  
  //for(Particle p : particles) p.animated = false;
  
  
  int max_range = -1;
  for(int x : range(-max_range, max_range+1, 3)){
    for(int y : range(-max_range, max_range+1, 3)){
      for(int z : range(-max_range, max_range+1, 3)){
        fieldObservers.add(new PVector(x, y, z));
      }
    }
  }
  
  
  //particles.add(new Proton(2, 2, 0));
  //particles.add(new Proton(-2, -2, 0));
  //particles.add(new Electron(2, -2, 0));
  //particles.add(new Electron(-2, 2, 0));
}

void draw(){
  // SIMULATION STUFF HERE
  for(Particle p : particles){
    p.update();
  }
  
  if(!mousePressed){
    framesSinceMousePressed ++;
  }else{
    framesSinceMousePressed = 0;
  }
  
  if(framesSinceMousePressed > 120){
    xAngle += 0.003;
  }
  
  // DON'T TOUCH (ROTATE CAMERA)
  if (mousePressed && pmousePressed) { // pmousePressed bcs touch input is annoying otherwise
    xAngle += (pmouseX - mouseX)*mouseSensitivity/360*TWO_PI;
    yAngle += (pmouseY - mouseY)*mouseSensitivity/360*TWO_PI;
    yAngle = constrain(yAngle, -HALF_PI, HALF_PI);
  }
  pmousePressed = mousePressed;
  
  // RENDERING
  pushMatrix(); // Encapsulate whole 3D render part
  background(32);

  pushMatrix();
  worldTransform.apply(); // put the lights through the world transform, otherwise it looks strange
  lights();
  popMatrix();

  translate(width/2, height/2);
  scale(zoom);

  rotateX(PI); // Make Y point up

  rotateX(yAngle);
  rotateY(xAngle);

  worldTransform.apply();
  
  PMatrix3D mat = getMatrix((PMatrix3D)null);
  if(mousePressed && !pmousePressed){
    println(mat);
  }
  
  if(showCoords) coords();
  
  // Game Objects rendered here
  for(Particle p : particles){
    p.render();
  }
  
  // Render Field lines
  int numFieldLinesPerParticle = 12;
  PVector[] offsets = fibonacciSphere(numFieldLinesPerParticle);
  float startDistance = 0.1;
  
  
  for(Particle p : particles){
    PVector pos = p.transform.position;
    for(PVector vec : offsets){
      renderFieldLine(vec.copy().mult(startDistance).add(pos));
    }
  }
  
  for(PVector p : fieldObservers){
    renderFieldLine(p);
  }
  
  if(showFieldObservers){
    stroke(255);
    strokeWeight(0.2);
    for(PVector p : fieldObservers){
      point(p.x, p.y, p.z);
    }
  }
  
  popMatrix(); // Encapsulates whole 3D render part
  
  
  // OVERLAYS
  
  lights(); // The other lighting is not suitable for the overlays
  
  
  // END OF DRAW LOOP
  //if(keyPressed && key == 'r'){
  //  saveFrame("frames/frame####.png");
  //}
}

PVector getFieldVector(PVector fieldPos){
  PVector aggregate = new PVector();
  
  for(Particle p : particles){
    aggregate.add(p.getFieldInfluence(fieldPos));
  }
  
  return aggregate;
}

void renderFieldLine(PVector fieldPos){
  int maxIterations = 10000;
  float stepSize = 0.1;
  
  float deltaStrengthBreakpoint = 1000*stepSize; // This is a pretty silly way to break out of the loop since there are only ever a few Particles, but I'm keeping it :D 
  float distanceSqBreakpoint = 20*20; // 100 -> Break when currentPoint is further than 10 from the origin
  
  pushStyle();
  
  colorMode(HSB);
  strokeWeight(0.05);
  noFill();
  
  PVector currentPos;
  float pFieldStrength;
  for(int multiplier = -1; multiplier <= 1; multiplier += 2){ // Just do this for each direction
    
    currentPos = fieldPos.copy();
    pFieldStrength = Float.MAX_VALUE;
    
    beginShape();
    boolean begunShape = true;
    for(int i = 0; i < maxIterations; i ++){
      PVector fieldVec = getFieldVector(currentPos).mult(multiplier);
      float fieldStrength = fieldVec.mag();
      if(fieldStrength - pFieldStrength > deltaStrengthBreakpoint || currentPos.magSq() > distanceSqBreakpoint){
        break;
      }
      float hue = mapAndConstrain(log(1+fieldStrength), 0, 4, 180, 0);
      float alpha = pow(mapAndConstrain(fieldStrength, 0.5, 1, sqrt(0.3), 1), 2)*255; // change sqrt(_) to 0 for a slightly different effect
      float strokeWeight = pow(mapAndConstrain(fieldStrength, 0.5, 1, sqrt(0.3), 1), 2)*0.05; // change sqrt(_) to 0 for a slightly different effect
      strokeWeight(strokeWeight);
      stroke(hue, 200, 255, alpha);
      if(strokeWeight >= 0.0001){
        if(!begunShape){
          beginShape();
          begunShape = true;
        }
        vertex(currentPos.x, currentPos.y, currentPos.z);
      }else if(begunShape){
        endShape();
        begunShape = false;
      }
      
      pFieldStrength = fieldStrength;
      currentPos.add(fieldVec.normalize().mult(stepSize));
    }
    endShape();
  }
  
  popStyle();
}

void mousePressed() {
}

void keyPressed() {
  if(key == 'c') showCoords = !showCoords;
  else if(key == 'd') showFieldObservers = !showFieldObservers;
}

void mouseWheel(MouseEvent e) {
  zoom *= pow(zoomMultiplier, -e.getCount());
}
