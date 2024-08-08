//Control panel
class Controls {
  //Window A: top control bar
  int xOffsetWindowA = 0;
  int yOffsetWindowA = 0;
  int panelWidthA = 1280;
  int panelHeightA = 40;

  //Window B: bottom control bar
  int xOffsetWindowB = 0;
  int yOffsetWindowB = 520;
  int panelWidthB = 1280;
  int panelHeightB = 200;

  ControlP5 cp5;
  Controls(PApplet Spectrum_Analyzer_Edit) {
    cp5 = new ControlP5(Spectrum_Analyzer_Edit);
  }

  void init() {
    //Toggle for lock max
    cp5.addToggle("lockMax")
      .setPosition(xOffsetWindowB+20, yOffsetWindowB+20)
      .setSize(50, 25)
      .setCaptionLabel("Lock Max")
      .setColorBackground(color(127))
      .setColorForeground(color(200))
      .setColorActive(color(255, 215, 0));

    //Toggle for lock min
    cp5.addToggle("lockMin")
      .setPosition(xOffsetWindowB+100, yOffsetWindowB+20)
      .setSize(50, 25)
      .setCaptionLabel("Lock Min")
      .setColorBackground(color(127))
      .setColorForeground(color(200))
      .setColorActive(color(255, 165, 0));

    //Toggle for showing clip marker
    cp5.addToggle("showClipMarker")
      .setPosition(xOffsetWindowB+180, yOffsetWindowB+20)
      .setSize(50, 25)
      .setCaptionLabel("Show Clip Marker")
      .setColorBackground(color(127))
      .setColorForeground(color(200))
      .setColorActive(color(255, 20, 0));

    //AVG slider
    cp5.addSlider("avgLen")
      .setPosition(xOffsetWindowB+20, yOffsetWindowB+80)
      .setSize(avgLen*15, 25)
      .setRange(1, avgLen)
      .setNumberOfTickMarks(avgLen);

    //Knob for trigger threshold
    cp5.addKnob("triggerThreshold")
      .setRange(-1.0, 1.0)
      .setValue(0.1)
      .setPosition(xOffsetWindowB+300, yOffsetWindowB+10)
      .setRadius(50)
      .setDragDirection(Knob.VERTICAL)
      .setCaptionLabel("Trigger Threshold")
      ;
  }

  void display() {
    push();
    stroke(127);
    fill(0);
    rect(xOffsetWindowA, yOffsetWindowA, panelWidthA, panelHeightA);
    rect(xOffsetWindowB, yOffsetWindowB, panelWidthB, panelHeightB);
    pop();
  }
}
