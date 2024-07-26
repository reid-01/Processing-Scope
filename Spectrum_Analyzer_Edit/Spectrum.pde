class Spectrum {
  //Static variables for window size (Includes graph, axes, and labels)
  int xOffsetWindow = width/2;
  int yOffsetWindow = 0;
  int windowWidth = 640;
  int windowHeight = 480;

  //Static variables for graph size
  int spectrumWidth = bands;
  int spectrumHeight = 360;
  int xOffsetSpectrum = xOffsetWindow+(windowWidth-spectrumWidth)/2;
  int yOffsetSpectrum = yOffsetWindow+(windowHeight-spectrumHeight)/2;
  int xGridSpacing = 64;
  int yGridSpacing = 60;

  //Static variables for scrolling display
  int fillColour;
  PGraphics pg, pgCopy;

  ModQueue heatMap = new ModQueue(spectrumWidth, spectrumHeight);

  void update(float[] spectrumData) {
    heatMap.insert(spectrumData);
  }

  void displayMaster() {
    //heatMap.display(xOffset, yOffset);
    fill(0);
    noStroke();
    rect(xOffsetWindow, yOffsetWindow, windowWidth, windowHeight);
    this.pgDisplay();
    this.displayAxes();
  }

  void pgSetup() {
    pg = createGraphics(spectrumWidth, spectrumHeight);
    pg.beginDraw();
    pg.colorMode(HSB, 360, 256, 256);
    pg.background(255);
    pg.noStroke();
    pg.rect(0, 0, spectrumWidth, spectrumHeight);
    pg.endDraw();
  }

  void pgDisplay() {
    int currentRow = heatMap.getNewest();

    PImage c = pg.get(0, 0, spectrumWidth, spectrumHeight-1);

    pg.beginDraw();
    pg.colorMode(HSB, 360, 256, 256);
    pg.image(c, 0, 1);

    for (int j = 0; j<bands; j++) {
      float element = heatMap.getValue(j, currentRow);
      fillColour = round(map(element, 0, 0.1, 0, 270));
      pg.stroke((270-fillColour), 255, 255);
      pg.point(j, 0);
    }
    pg.endDraw();

    image(pg, xOffsetSpectrum, yOffsetSpectrum);
  }

  void displayAxes() {
    //X-axis grid markers
    stroke(255);
    line(xOffsetSpectrum, yOffsetSpectrum+spectrumHeight,
      xOffsetSpectrum+spectrumWidth, yOffsetSpectrum+spectrumHeight);
    for (int i = 0; i<= spectrumWidth; i += xGridSpacing) {
      line(xOffsetSpectrum + i, yOffsetSpectrum+spectrumHeight,
        xOffsetSpectrum + i, yOffsetSpectrum+spectrumHeight + 8);

      fill(255);
      text(i, xOffsetSpectrum+i, yOffsetSpectrum+spectrumHeight+20);
    }
    text("Frequency (Hz)", xOffsetWindow+(windowWidth/2), 
    (yOffsetSpectrum*1.5)+spectrumHeight+8);

    //Y-axis grid markers
    stroke(255);
    line(xOffsetSpectrum, yOffsetSpectrum,
      xOffsetSpectrum, yOffsetSpectrum+spectrumHeight);
    for (int i = 0; i<= spectrumHeight; i += yGridSpacing) {
      line(xOffsetSpectrum, yOffsetSpectrum + i,
        xOffsetSpectrum-8, yOffsetSpectrum + i);

      fill(255);
      String j = nf(i/yGridSpacing);
      String label = String.format("t - %s", j);
      text(label, xOffsetSpectrum-20, yOffsetSpectrum+i+4);
    }
  }
  
  //Helper method for show average function
  float[][] getSlice(int numRows){
    float[][] slice = heatMap.getQueueSlice(numRows);
    return slice;
  }
}
