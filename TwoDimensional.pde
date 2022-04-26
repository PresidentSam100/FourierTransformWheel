class twoD {
  int[] x;
  int[] y;
  int in;
  
  // Constructor
  twoD(int[] x, int[] y, int in) {
    this.x = x;
    this.y = y;
    this.in = in;
  }
  
  // Getters
  int[] getXA() {
    return x;
  }
  int[] getYA() {
    return y;
  } 
  int getIn() {
    return in;
  }
  
  // Setters
  void setXA(int[] x) {
    this.x = x;
  }
  void setYA(int[] y) {
    this.y = y;
  }
  void setIn(int in) {
    this.in = in;
  }
}
