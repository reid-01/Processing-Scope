class TraceShade {
  //creates a polygon bounded by y1 and y2 of any given spectrum points
  float peak1, peak2, base1, base2, xShift1, xShift2;
  color c;
  PShape shade;

  TraceShade(float y1, float y2, float b1, float b2, float x1, float x2, color c) {
    peak1 = y1;
    peak2 = y2;
    base1 = b1;
    base2 = b2;
    xShift1 = x1;
    xShift2 = x2;

    shade = createShape();
    shade.beginShape();
    shade.noStroke();
    shade.fill(c, 50);
    shade.vertex(xShift1, peak1);
    shade.vertex(xShift2, peak2);
    shade.vertex(xShift2, base2);
    shade.vertex(xShift1, base1);
    shade.endShape(CLOSE);
  }

  void display() {
    shape(shade);
  }
}
