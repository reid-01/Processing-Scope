class Oscilloscope {
  //Static variables for window size (Includes graph, axes, and labels)
  int xOffsetWindow = 0;
  int yOffsetWindow = 0;
  int windowWidth = 640;
  int windowHeight = 480;
  int xGridSpacing = 64;
  int yGridSpacing = 60;

  //Static variables for graph size
  int graphWidth = bands;
  int graphHeight = 360;
  int xOffsetGraph = (windowWidth-graphWidth)/2;
  int yOffsetGraph = (windowHeight-graphHeight)/2;

  //maxVector holds highest peak value at any given band
  //minVector holds lowest peak value at any given band
  float[] maxVector = new float[bands];
  float[] minVector = new float[bands];

  //Average vector averages the n most recent spectrum rows, where n = avgLen.
  //If n = 1, the most recent trace, that is, real time, is shown.
  float[] avgVector = new float[bands];
  float columnAvg;

  boolean yConstrain = true;
  boolean maxedOut = false;

  void updateTraceVectors(float[][] avgSlice) {
    if (lockMax) {
      for (int i = 0; i<bands; i++) {
        maxVector[i] = max(avgVector[i], maxVector[i]);
      }
    } else {
      arrayCopy(avgVector, maxVector);
    }

    if (lockMin) {
      for (int i = 0; i<bands; i++) {
        minVector[i] = min(avgVector[i], minVector[i]);
      }
    } else {
      arrayCopy(avgVector, minVector);
    }

    for (int i = 0; i<bands; i++) {
      columnAvg = 0;
      for (int j = 0; j<avgLen; j++) {
        columnAvg += avgSlice[j][i];
      }
      columnAvg = columnAvg / avgLen;
      avgVector[i] = columnAvg;
    }
  }

  void displayWindow() {
    fill(0);
    rect(xOffsetWindow, yOffsetWindow, windowWidth, windowHeight);
  }

  void displayGridlines() {
    rect(xOffsetGraph, yOffsetGraph, graphWidth, graphHeight);
    //Y-axis gridlines
    for (int i = xGridSpacing + xOffsetGraph;
      i<graphWidth+xOffsetGraph;
      i+= xGridSpacing) {
      stroke(80);
      line(i, yOffsetGraph, i, yOffsetGraph+graphHeight);
    }

    //X-axis gridlines
    for (int i = yGridSpacing + yOffsetGraph;
      i<graphHeight+yOffsetGraph;
      i+= yGridSpacing) {
      stroke(80);
      line(xOffsetGraph, i, xOffsetGraph+graphWidth, i);
    }
  }

  void displayBands() {
    for (int i = 0; i<bands-1; i++) {
      float y1Std, y2Std, y1Max, y2Max, y1Min, y2Min;
      y1Max = graphHeight*maxVector[i]*6;
      y2Max = graphHeight*maxVector[i+1]*6;

      y1Min = graphHeight*minVector[i]*6;
      y2Min = graphHeight*minVector[i+1]*6;

      y1Std = graphHeight*avgVector[i]*6;
      y2Std = graphHeight*avgVector[i+1]*6;

      float[] constr = {y1Max, y2Max, y1Min, y2Min, y1Std, y2Std};
      if (yConstrain) {
        for (int j = 0; j<constr.length; j++) {
          if (constr[j] > graphHeight) {
            constr[j] = graphHeight;
            maxedOut = true;
          }
        }
        y1Max = constr[0];
        y2Max = constr[1];
        y1Min = constr[2];
        y2Min = constr[3];
        y1Std = constr[4];
        y2Std = constr[5];
      }

      stroke(0, 255, 255);
      line(xOffsetGraph+i, graphHeight+yOffsetGraph-y1Std,
        xOffsetGraph+i+1, graphHeight+yOffsetGraph-y2Std);

      if (lockMin) {
        stroke(255, 165, 0);
        line(xOffsetGraph+i, graphHeight+yOffsetGraph-y1Min,
          xOffsetGraph+i+1, graphHeight+yOffsetGraph-y2Min);
      }
      if (lockMax) {
        stroke(255, 215, 0);
        line(xOffsetGraph+i, graphHeight+yOffsetGraph-y1Max,
          xOffsetGraph+i+1, graphHeight+yOffsetGraph-y2Max);
      }
    }
  }

  void displayAxes() {
    textAlign(CENTER);
    stroke(255);

    //Borders
    //Top, bottom
    line(xOffsetGraph, yOffsetGraph,
      xOffsetGraph+graphWidth, yOffsetGraph);
    line(xOffsetGraph, yOffsetGraph+graphHeight,
      xOffsetGraph+graphWidth, yOffsetGraph+graphHeight);

    //Left, right
    line(xOffsetGraph, yOffsetGraph,
      xOffsetGraph, yOffsetGraph+graphHeight);
    line(xOffsetGraph+graphWidth, yOffsetGraph,
      xOffsetGraph+graphWidth, yOffsetGraph+graphHeight);

    for (int i = 0; i<= graphHeight; i += yGridSpacing) {
      line(xOffsetGraph, yOffsetGraph + i, xOffsetGraph-8, yOffsetGraph + i);

      fill(255);
      text((graphHeight-i)/yGridSpacing, xOffsetGraph-14, yOffsetGraph+i+4);
    }

    //X-axis grid markers
    for (int i = 0; i<= graphWidth; i += xGridSpacing) {
      line(xOffsetGraph + i, yOffsetGraph+graphHeight,
        xOffsetGraph + i, yOffsetGraph+graphHeight + 8);

      fill(255);
      text(i, xOffsetGraph+i, yOffsetGraph+graphHeight+20);
    }
    text("Frequency (Hz)", xOffsetWindow+(windowWidth/2),
      (yOffsetGraph*1.5)+graphHeight+8);

    if (maxedOut) {
      this.clipMarker();
    }
  }

  //Displays a red line at the top of the graph if a peak clips the top.
  void clipMarker() {
    push();
    if (maxedOut && showClipMarker) {
      stroke(255, 20, 0);
      line(xOffsetGraph, yOffsetGraph, xOffsetGraph+graphWidth, yOffsetGraph);
      maxedOut = false;
    }
    pop();
  }

  void displayMaster() {
    //Display order: 1: BG, 2: gridlines, 3: traces, 4: border & labels
    this.displayWindow();
    this.displayGridlines();
    this.displayBands();
    this.displayAxes();
  }
}
