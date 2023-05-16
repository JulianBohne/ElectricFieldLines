
class Transform{
  public PVector position;
  public PMatrix3D rotation;
  public PVector scale;
  
  Transform(){
    position = new PVector(0, 0, 0);
    rotation = new PMatrix3D();
    scale = new PVector(1, 1, 1);
  }
  
  public PVector getRotationVector(){ // yoinked from https://www.programcreek.com/java-api-examples/?api=javax.vecmath.Matrix3d
    float sy = sqrt(rotation.m00*rotation.m00 + rotation.m10*rotation.m10);
    boolean singular = sy < 1e-6;
    float x,y,z;
    
    if(!singular) {
      x = atan2( rotation.m21,rotation.m22);
      y = atan2(-rotation.m20,sy);
      z = atan2( rotation.m10,rotation.m00);
    } else {
      x = atan2(-rotation.m12, rotation.m11);
      y = atan2(-rotation.m20, sy);
      z = 0;
    }
    
    return new PVector(x,y,z);
  }
  
  public void setRotationVector(PVector rot){
    rotation.reset();
    rotation.rotateX(rot.x);
    rotation.rotateY(rot.y);
    rotation.rotateZ(rot.z);
  }
  
  public void reset(){
    rotation.reset();
    resetPosition();
    resetScale();
  }
  
  public void resetPosition(){
    position.set(0, 0, 0);
  }
  
  public void resetScale(){
    scale.set(1, 1, 1);
  }
  
  public void apply(){
    translate(position.x, position.y, position.z);
    PVector rot = getRotationVector();
    rotateX(rot.x);
    rotateY(rot.y);
    rotateZ(rot.z);
    scale(scale.x, scale.y, scale.z);
  }
  
  public PMatrix3D asMatrix(){
    PMatrix3D current = new PMatrix3D();
    current.translate(position.x, position.y, position.z);
    current.apply(rotation);
    current.scale(scale.x, scale.y, scale.z);
    return current;
  }
}
