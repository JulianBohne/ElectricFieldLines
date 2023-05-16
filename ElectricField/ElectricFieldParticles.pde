static float fieldConstant = 5;

class Particle extends Sphere{
  
  float a, b, c, ra, rb, rc, ao, bo, co; // just some stuff for animation
  boolean animated = false;
  
  Particle(float x, float y, float z){
    super();
    transform.position.set(x, y, z);
    transform.scale.mult(0.2); // basically set scale to 0.2
    
    float maxFreq = 2;
    a = random(-maxFreq, maxFreq);
    b = random(-maxFreq, maxFreq);
    c = random(-maxFreq, maxFreq);
    
    float maxRadius = 0.01;
    ra = random(0, maxRadius);
    rb = random(0, maxRadius);
    rc = random(0, maxRadius);
    
    ao = random(0, TWO_PI);
    bo = random(0, TWO_PI);
    co = random(0, TWO_PI);
  }
  
  Particle(){ this(0, 0, 0); }
  
  Particle(PVector pos){ this(pos.x, pos.y, pos.z); }
  
  @SuppressWarnings("unused")
  PVector getFieldInfluence(PVector fieldPos){
    return new PVector();
  }
  
  void update(){
    if(animated){
      transform.position.add(
        ra*sin(frameCount*dt*a + ao),
        rb*sin(frameCount*dt*b + bo),
        rc*sin(frameCount*dt*c + co)
      );
    }
  }
}

class Electron extends Particle{
  Electron(float x, float y, float z){
    super(x, y, z);
    style.fill = #0000FF; // Smthn blue for electrons ofc
    animated = true;
  }
  
  @Override
  PVector getFieldInfluence(PVector fieldPos){
    PVector difference = PVector.sub(transform.position, fieldPos);
    return difference.copy().normalize().mult(fieldConstant).div(difference.magSq());
  }
}

class Proton extends Particle{
  Proton(float x, float y, float z){
    super(x, y, z);
    style.fill = #FF0000; // Smthn red for protons ofc
    animated = true;
  }
  
  @Override
  PVector getFieldInfluence(PVector fieldPos){
    PVector difference = PVector.sub(fieldPos, transform.position);
    return difference.copy().normalize().mult(fieldConstant).div(difference.magSq());
  }
}
