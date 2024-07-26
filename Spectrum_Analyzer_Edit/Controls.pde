//Control panel
class Controls {
  int xOffsetWindow = 0;
  int yOffsetWindow = 480;
  int panelWidth = width;
  int panelHeight = height-480;

  ControlP5 cp5;
  Controls(PApplet Spectrum_Analyzer_Edit) {
    cp5 = new ControlP5(Spectrum_Analyzer_Edit);
  }

  void init() {
    //Toggle for lock max
    cp5.addToggle("lockMax")
      .setPosition(xOffsetWindow+20, yOffsetWindow+20)
      .setSize(50, 25)
      .setCaptionLabel("Lock Max")
      .setColorBackground(color(127))
      .setColorForeground(color(200))
      .setColorActive(color(255, 215, 0));

    //Toggle for lock min
    cp5.addToggle("lockMin")
      .setPosition(xOffsetWindow+100, yOffsetWindow+20)
      .setSize(50, 25)
      .setCaptionLabel("Lock Min")
      .setColorBackground(color(127))
      .setColorForeground(color(200))
      .setColorActive(color(255, 165, 0));

    //Toggle for showing clip marker
    cp5.addToggle("showClipMarker")
      .setPosition(xOffsetWindow+180, yOffsetWindow+20)
      .setSize(50, 25)
      .setCaptionLabel("Show Clip Marker")
      .setColorBackground(color(127))
      .setColorForeground(color(200))
      .setColorActive(color(255,20,0));

    //AVG slider
    cp5.addSlider("avgLen")
      .setPosition(xOffsetWindow+20, yOffsetWindow+80)
      .setSize(avgLen*15, 25)
      .setRange(1, avgLen)
      .setNumberOfTickMarks(avgLen)
      ;
  }

  void display() {
    push();
    stroke(127);
    fill(0);
    rect(xOffsetWindow, yOffsetWindow, panelWidth, panelHeight);
    pop();
  }
}
