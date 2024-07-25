import processing.sound.*;
import controlP5.*;

//Class declarations
FFT fft;
ControlP5 cp5;
AudioIn in;
SoundFile track;
Oscilloscope o1;
Spectrum s1;
Controls c1;

// Initialize spectrum with 512 bands
int bands = 512;
int avgLen = 15;
float[] spectrum = new float[bands];

//If lockMax is true, spectrum display reads from maxVextor and shows an additional trace.
//Same is true for minVector
boolean lockMax = false;
boolean lockMin = false;
boolean showClipMarker = false;

void setup() {
  //Spectrum and Oscilloscope windows must be bands wide - height can be anything.
  size(1280, 720);
  background(255);

  //Create FFT of bands width
  fft = new FFT(this, bands);

  //Get audio input from sound card. Disabled for now.
  //in = new AudioIn(this, 0);
  //in.start();
  //fft.input(in);

  //Open sound file and plug into FFT.
  //Replace title string with any mp3 or wav in the same directory as the pde files.
  track = new SoundFile(this, "anything.mp3");
  track.loop();
  fft.input(track);

  //Create new Oscilloscope and Spectrum objects
  o1 = new Oscilloscope();
  s1 = new Spectrum();
  c1 = new Controls(this);

  s1.pgSetup();
  c1.init();
}

void draw() {
  noStroke();
  c1.display();

  //Since fft returns a float[] array of bands width, it is set to a variable.
  spectrum = fft.analyze();
  s1.update(spectrum);
  o1.updateTraceVectors(s1.getSlice(avgLen));

  //Display oscilloscope data
  o1.displayMaster();

  //Display spectrum data
  s1.displayMaster();
}
