class Circle {
  // Attributes
  private float sr; // Spin Rate
  private float r; // Radius
  private float x; // X position
  private float y; // Y position
  private float vx; // X velocity
  private float vy; // Y velocity
  private float angle;
  private boolean fixed;

  // Constructor
  public Circle(float sr, float r, float x, float y, float a, boolean fixed) {
    this.sr = sr;
    this.r = r;
    this.x = x;
    this.y = y;
    angle = a;
    vx = cos(angle)*r;
    vy = sin(angle)*r;
    this.fixed = fixed;
  }
  
  // Single Circle and line
  public void display() {
    pushMatrix();
    translate(x,y);
    strokeWeight(1);
    stroke(255);
    noFill();
    vx = cos(angle)*r;
    vy = sin(angle)*r;
    ellipse(0,0,2*r,2*r);
    strokeWeight(2);
    line(0,0,vx,vy);
    popMatrix();
  }
  
  // Setters
  public void setAngle() {
    angle += sr/100;
  }
  public void setX(float x) {
    this.x = x;
  } 
  public void setY(float y) {
    this.y = y;
  }
  
  // Getters
  public float getVX() {
    return vx;
  }
  public float getVY() {
    return vy;
  }
  public float getX() {
    return x;
  }
  public float getY() {
    return y;
  }
  public boolean isFixed() {
    return fixed;
  } 
  public float getAmp() {
    return r;
  }
}
