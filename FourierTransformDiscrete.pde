// All variables and arrays to store data and draw 2D Discrete Fourier transform
ArrayList<Circle> circles;
float[][] dots = new float[2000][2]; // Dots for mouse trace
int index = 0;
int index1 = 4000;
boolean display = false; // Displays x and y positions with respect to time
boolean mode = true; // Drawing (true) or modeling (false) mode
float[][] waveform = new float[index1][2];
int detail = 4000;
int index2 = 0;
int t = 0;
int[] xa = new int[detail];
int[] ya = new int[detail];
int el;

// Initialize Window
void setup() {
  circles = new ArrayList<Circle>();
  size(1200, 700);
  background(0);
}

// Draws the circles and shapes
void draw() {
  if (!mode) {
    background(0);
    for (int i = 0; i < circles.size(); i++) {
      circles.get(i).setAngle();
      if (!circles.get(i).isFixed() && i!=0) {
        circles.get(i).setX(circles.get(i-1).getVX()+circles.get(i-1).getX());
        circles.get(i).setY(circles.get(i-1).getVY()+circles.get(i-1).getY());
      }
      circles.get(i).display();
      // Last circle draws the mouse traced line
      if (i == circles.size()-1) {
        if (index == 2000) {
          for (int h = 0; h < 2000; h++) {
            dots[h][0] = 0;
            dots[h][1] = 0;
          }
          index = 0;
        }
        dots[index][0] = circles.get(i).getVX()+circles.get(i).getX();
        dots[index][1] = circles.get(i).getVY()+circles.get(i).getY();
        for (int w = index1-1; w >0; w--) {
          waveform[w][0] = waveform[w-1][0];
          waveform[w][1] = waveform[w-1][1];
        }
        waveform[0][0] = dots[index][0];
        waveform[0][1] = dots[index][1];
      }
    }
    // graphs the shape
    strokeWeight(4);
    stroke(255, 0, 0);
    int pel = waveform.length;
    for (int j = 0; j < index1; j++) {
      if (waveform[j][0] == 0 && waveform[j][1] == 0) {
        if (all0(j, index1, split(waveform, 0)) && all0(j, index1, split(waveform, 1))) {
          pel = j;
          break;
        }
      }
    }
    beginShape();
    for (int wf = 0; wf < pel; wf++) {
      vertex(waveform[wf][0], waveform[wf][1]);
    }
    endShape();
    index++;
  }
  // Displays relative x and y positions based on time
  if (display) {
    strokeWeight(2);
    stroke(0);
    rect(.5*width, .5*height, .5*width, .5*height);
    line(.5*width, .75*height, width, .75*height);
    stroke(0);
    while (t < detail-1) {
      float x = t*(float(width/2)/float(detail));
      float y = t*(float(width/2)/float(detail));
      point((width/2)+ x, (.75*height)-(xa[t]/8));
      point((width/2)+ y, (height)-(ya[t]/4));
      t++;
    }
    t = 0;
  }
}

// Traces the path of the mouse
void mouseDragged() {
  if (mode) {
    stroke(255);
    strokeWeight(3);
    point(mouseX, mouseY);
    xa[index2] = mouseX-(width/2);
    ya[index2] = mouseY-(height/2);
    index2++;
    if (index2 >= detail-1) {
      background(0);
      index2 = 0;
      for (int i =0; i < detail; i++) {
        xa[i] = 0;
        ya[i] = 0;
      }
    }
  }
}

void keyPressed() {
  // Runs the Fourier Transform Circle model
  if ((key == 'g' || key == 'G') && mode) {
    mode = false;
    for (int i = 0; i < detail; i++) {
      if (ya[i] == 0) {
        if (isAllZero(i, detail, ya)) {
          el = i;
          break;
        }
      }
    }
    int yel = el;
    int xel = el;
    if (odd(xa)) {
      el--;
    }
    int[] nnXA = stripZero(makeOdd(xa), xel);
    int[] nnYA = stripZero(makeOdd(ya), yel);
    float[][] A = dft2D(nnXA, nnYA);
    // Circles
    for (int k = 0; k < el; k++) {
      int f = k;
      if (k > (el-1)/2) {
        f = k-el;
      }
      float cx;
      float cy;
      if (k == 0) {
        cx = width/2;
        cy = height/2;
      } else {
        cx = circles.get(k-1).getVX() + circles.get(k-1).getX();
        cy = circles.get(k-1).getVY() + circles.get(k-1).getY();
      }
      float amp = sqrt(sq(A[k][0]) + sq(A[k][1]));
      float freq = f;
      float angle = atan2(A[k][1], A[k][0]);
      circles.add(new Circle(freq, amp, cx, cy, angle, false));
    }
    circles = reverse(sort(circles));
  } 
  else if (key == 'r' || key == 'R') {
    // Reset everything
    background(0);
    circles = new ArrayList<Circle>();
    dots = new float[2000][2];
    index = 0;
    index1 = 4000;
    display = false;
    mode = true;
    waveform = new float[index1][2];
    detail = 4000;
    index2 = 0;
    t = 0;
    xa = new int[detail];
    ya = new int[detail];
  }
}

boolean isAllZero(int currentI, int thisDetail, int[] tArray) {
  for (int d = currentI; d < thisDetail; d++) {
    if (tArray[d] != 0) {
      return false;
    }
  }
  return true;
}

int[] stripZero(int[] tArray, int EL) {
  int[] R = new int[EL];
  for (int i = 0; i < EL; i++) {
    R[i] = tArray[i];
  }
  return R;
} 

float[][] dft2D(int[] xa2, int[] ya2) {
  int N = xa2.length;
  float[][] TA = new float[N][2];
  for (int k = 0; k < N; k++) {
    float re = 0;
    float im = 0;
    for (int n = 0; n < N; n++) {
      float theta = (TWO_PI * k * n)/N;
      re+= xa2[n]*cos(theta);
      im-= xa2[n]*sin(theta);
      im+= ya2[n]*cos(theta);
      re+= ya2[n]*sin(theta);
    }
    re /= N;
    im /= N;
    TA[k][0] = re;
    TA[k][1] = im;
  }
  return TA;
}

// Removes last element if even
int[] makeOdd(int[] ta) {
  int a = ta.length;
  if (!odd(ta)) {
    a--;
  }
  int [] TA = new int[a];
  for (int i = 0; i < a; i++) {
    TA[i] = ta[i];
  }
  return TA;
}

// Even/Odd checker
boolean odd(int[] ta) {
  return ta.length%2 == 1;
}

// Helper method to graph shape
float[] split(float[][] ta, int column) {
  int l = ta.length;
  float[] TA = new float[l];
  for (int i = 0; i < l; i++) {
    TA[i] = ta[i][column];
  }
  return TA;
}

// Checks if all values of an array in a given range equal 0.0
boolean all0(int currentI, int thisDetail, float[] tArray) {
  for (int d = currentI; d < thisDetail; d++) {
    if (tArray[d] != 0.0) {
      return false;
    }
  }
  return true;
}

// Sort array using quicksort
ArrayList<Circle> sort(ArrayList<Circle> a) {
  ArrayList<Circle> A = copy(a);
  int n = a.size(); // size
  int lm = 0; // left
  int rm = n-1; // right
  int p = int(n/2); // pivot point

  while (lm <= rm) {
    while (A.get(lm).getAmp() < A.get(p).getAmp()) {
      lm++;
    }
    while (A.get(rm).getAmp() > A.get(p).getAmp()) {
      rm--;
    }
    if (lm <= rm) {
      // Swap left and right
      Circle temp = A.get(lm);
      A.set(lm, A.get(rm));
      A.set(rm, temp);
      lm++;
      rm--;
    }
  }
  // Add contents
  ArrayList<Circle> p1 = new ArrayList<Circle>();
  ArrayList<Circle> p2 = new ArrayList<Circle>();
  for (int i =0; i < n; i++) {
    if (i <= p) {
      p1.add(A.get(i));
    } else {
      p2.add(A.get(i));
    }
  }
  // Sorting
  while (!isSorted(p1)) {
    p1 = sort(p1);
  }
  while (!isSorted(p2)) {
    p2 = sort(p2);
  }
  for (int i = 0; i < n; i++) {
    if (i <= p) {
      A.set(i, p1.get(i));
    } else {
      A.set(i, p2.get(i-p-1));
    }
  }
  return A;
}

// Copies all contents of arraylist into new arraylist
ArrayList<Circle> copy(ArrayList<Circle> tal) {
  ArrayList<Circle> TAL = new ArrayList<Circle>();
  for (int i = 0; i< tal.size(); i++) {
    TAL.add(tal.get(i));
  }
  return TAL;
}

// Checks if arraylist is sorted from least to greatest
boolean isSorted(ArrayList<Circle> ta) {
  for (int i = 1; i < ta.size(); i++) {
    if (ta.get(i).getAmp() < ta.get(i-1).getAmp()) {
      return false;
    }
  }
  return true;
}

// Reverses contents of arraylist
ArrayList<Circle> reverse(ArrayList<Circle> ta) {
  ArrayList<Circle> TA = new ArrayList<Circle>();
  for (int i = ta.size()-1; i >= 0; i--) {
    TA.add(ta.get(i));
  }
  return TA;
}
