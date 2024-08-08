class TimeDomainDisplay {
  ControlP5 TDDControls;
  
  int xOffsetWindow = 0;
  int yOffsetWindow = 280;
  int windowWidth = 640;
  int windowHeight = 240;
  int xGridSpacing = 48;
  int yGridSpacing = 45;

  int graphWidth = 480;
  int graphHeight = 180;
  int yOffsetGraph = yOffsetWindow+(windowHeight-graphHeight)/2;
  int xOffsetGraph = yOffsetGraph - yOffsetWindow + bands-graphWidth;

  color stdFill = color(0, 255, 255);

  float[] sampleData = new float[samples];
  float[] sampleDataPrevious = new float[samples];
  float[] displayArray = new float[graphWidth];

  boolean triggerActivated;
  
  //float triggerThreshold = 0.4;
  int triggerLocation = graphWidth/2;
  int pixelsAfterTrigger = graphWidth-triggerLocation;
  int pixelsBeforeTrigger = graphWidth - pixelsAfterTrigger;

  int backFillEntries;
  int startIndex;
  int endFillEntries;
  
  int xOffsetSwitch = xOffsetGraph+graphWidth + 20;
  int yOffsetRisingSwitch = yOffsetGraph;
  int yOffsetFallingSwitch = yOffsetRisingSwitch+graphHeight/2;
  
  void init(PApplet p){
    TDDControls = new ControlP5(p);
    
    TDDControls.addToggle("detectRisingEdge")
      .setPosition(xOffsetSwitch, yOffsetRisingSwitch)
      .setSize(25, 50)
      .setCaptionLabel("Rising Edge")
      .setColorBackground(color(80))
      .setColorForeground(color(200))
      .setColorActive(color(255, 215, 0));
      
      TDDControls.addToggle("detectFallingEdge")
      .setPosition(xOffsetSwitch, yOffsetFallingSwitch)
      .setSize(25, 50)
      .setCaptionLabel("Falling Edge")
      .setColorBackground(color(80))
      .setColorForeground(color(200))
      .setColorActive(color(255, 165, 0));
  }

  float getPrevious(int index) {
    //Returns the entry at the index prior to the current index
    //If the current index is the beginning of the newest sample data array,
    //Return the last element of the previous sample data array
    float previous;
    if (index == 0) {
      previous = sampleDataPrevious[sampleDataPrevious.length - 1];
    } else {
      previous = sampleData[index-1];
    }
    return previous;
  }

  void backFill(int backFillEntries) {
    //Backfills the display array in the event that visible entries before trigger
    //exceeds elements in the current sample data array before trigger
    for (int i = 0; i<backFillEntries; i++) {
      displayArray[i] = sampleDataPrevious[sampleDataPrevious.length - backFillEntries + i];
    }
  }

  void update(float[] data, float triggerThreshold) {
    triggerActivated = false;
    arrayCopy(data, sampleData);

    //triggerIndex tracks the index in the current data set where the trigger is activated
    int triggerIndex = 0;
    int len = sampleData.length;
    //This loop runs until either the trigger is activated, or
    //the current data set is walked through entirely
    while ((triggerIndex < len) && (!triggerActivated)) {
      //Rising edge trigger
      if (this.getPrevious(triggerIndex) <= triggerThreshold &&
        sampleData[triggerIndex] > triggerThreshold &&
        detectRisingEdge) {
        triggerActivated = true;
      } 
      //Falling edge trigger
      if (this.getPrevious(triggerIndex) >= triggerThreshold &&
        sampleData[triggerIndex] < triggerThreshold &&
        detectFallingEdge) {
        triggerActivated = true;
      }
      triggerIndex++;
    }

    if (triggerActivated) {
      backFillEntries = 0;
      startIndex = triggerIndex - pixelsBeforeTrigger;
      endFillEntries = 0;

      //If the number of entries in the current data set before the trigger
      //is less than the number of visible entries before the trigger,
      //the program must access the previous data set to fill the gap.
      if (startIndex < 0) {
        backFillEntries -= startIndex;
        startIndex = 0;
        this.backFill(backFillEntries);
      }

      //Add all entries from end of graph, or end of backfill up to trigger
      for (int i = 0; i < (pixelsBeforeTrigger - backFillEntries); i++) {
        displayArray[i+backFillEntries] = sampleData[startIndex + i];
      }

      //Fill the display array from with sample data from and including trigger index
      //Until end of sample data or end of display array
      //Whichever happens sooner
      if ((sampleData.length - (triggerIndex + 1)) < pixelsAfterTrigger) {
        endFillEntries = (sampleData.length - (triggerIndex + 1));
      } else {
        endFillEntries = pixelsAfterTrigger;
      }

      for (int i = 0; i<endFillEntries-1; i++) {
        displayArray[displayArray.length-pixelsAfterTrigger-1+i] = sampleData[triggerIndex + i];
      }
    }

    sampleDataPrevious = sampleData;
  }

  void displayWindow() {
    noStroke();
    fill(0);
    rect(xOffsetWindow, yOffsetWindow, windowWidth, windowHeight);
    
    //Button details
    fill(80);
    rect(xOffsetSwitch-1, yOffsetRisingSwitch-1, 52, 52);
    rect(xOffsetSwitch-1, yOffsetFallingSwitch-1, 52, 52);
    fill(0);
    rect(xOffsetSwitch+25, yOffsetRisingSwitch, 25, 50);
    rect(xOffsetSwitch+25, yOffsetFallingSwitch, 25, 50);
    
    noFill();
    if(detectRisingEdge){
      stroke(255, 215, 0);
    } else {
      stroke(80);
    }
    arc(xOffsetSwitch+46, yOffsetRisingSwitch+18, 17, 17, PI, HALF_PI+PI);
    line(xOffsetSwitch+37, yOffsetRisingSwitch+18, xOffsetSwitch+37, yOffsetRisingSwitch+30);
    arc(xOffsetSwitch+29, yOffsetRisingSwitch+30, 17, 17, 0, HALF_PI);
    
    if(detectFallingEdge){
      stroke(255, 165, 0);
    } else {
      stroke(80);
    }
    arc(xOffsetSwitch+29, yOffsetFallingSwitch+18, 17, 17, HALF_PI+PI, TWO_PI);
    line(xOffsetSwitch+37, yOffsetFallingSwitch+18, xOffsetSwitch+37, yOffsetFallingSwitch+30);
    arc(xOffsetSwitch+46, yOffsetFallingSwitch+30, 17, 17, HALF_PI, PI);
  }

  void displayGridlines() {
    fill(0);
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

  void displayTrace() {
    stroke(stdFill);
    for (int i = 0; i<(displayArray.length)-1; i++) {
      float y1 = displayArray[i]*graphHeight;
      float y2 = displayArray[i+1]* graphHeight;
      line(xOffsetGraph+i, graphHeight/2+yOffsetGraph-y1,
        xOffsetGraph+i+1, graphHeight/2+yOffsetGraph-y2);
    }
  }

  void displayAxes() {
    stroke(255);
    //Borders
    //Top, bottom
    line(xOffsetGraph, yOffsetGraph,
      xOffsetGraph+graphWidth, yOffsetGraph);
    line(xOffsetGraph, yOffsetGraph+graphHeight,
      xOffsetGraph+graphWidth, yOffsetGraph+graphHeight);

    //Middle X-axis
    line(xOffsetGraph, yOffsetGraph +graphHeight/2,
      xOffsetGraph+graphWidth, yOffsetGraph +graphHeight/2);

    //Trigger line
    line(triggerLocation+xOffsetGraph, graphHeight+yOffsetGraph,
      triggerLocation+xOffsetGraph, yOffsetGraph);
    
    //Trigger threshold line
    line(xOffsetWindow+xOffsetGraph, graphHeight/2+yOffsetGraph - triggerThreshold*graphHeight/2,
    xOffsetWindow+xOffsetGraph+graphWidth, graphHeight/2+yOffsetGraph - triggerThreshold*graphHeight/2);

    //Left, right
    line(xOffsetGraph, yOffsetGraph,
      xOffsetGraph, yOffsetGraph+graphHeight);
    line(xOffsetGraph+graphWidth, yOffsetGraph,
      xOffsetGraph+graphWidth, yOffsetGraph+graphHeight);
  }

  void displayMaster() {
    this.displayWindow();
    this.displayGridlines();
    this.displayTrace();
    this.displayAxes();
  }
}
