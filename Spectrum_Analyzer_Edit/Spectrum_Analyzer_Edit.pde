import processing.sound.*;
import controlP5.*;

//JSON files, draw trigger threshold line

//Class declarations
FFT fft;
AudioIn in;
SoundFile track;
Waveform waveform;
FreqDomainDisplay f1;
Spectrograph s1;
TimeDomainDisplay t1;
Controls c1;

// Initialize spectrum with 512 bands
int bands = 512;
int avgLen = 15;
float[] spectrum = new float[bands];

int sampleRate = 44100;
int samples = round(sampleRate/frameRate);


//The Switchboard
//Any values modified by the ControlP5 objects are declared and stored here.

//FreqDomainDisplay
boolean lockMax;
boolean lockMin;
boolean showClipMarker;
boolean showShadingUnderTrace = true;

//TimeDomainDisplay
float triggerThreshold;
boolean detectRisingEdge;
boolean detectFallingEdge;

void setup() {
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
  track = new SoundFile(this, "d_runnin.mp3");
  track.loop();
  fft.input(track);

  waveform = new Waveform(this, samples);
  waveform.input(track);

  //Create new Oscilloscope and Spectrum objects
  f1 = new FreqDomainDisplay();
  s1 = new Spectrograph();
  t1 = new TimeDomainDisplay();
  c1 = new Controls(this);

  s1.pgSetup();
  c1.init();
  t1.init(this);
}

void draw() {
  noStroke();
  c1.display();

  //Since fft returns a float[] array of bands width, it is set to a variable.
  spectrum = fft.analyze();
  waveform.analyze();

  t1.update(waveform.data, triggerThreshold);

  s1.update(spectrum);

  f1.updateTraceVectors(s1.getSlice(avgLen));

  //Frequency domain display data
  f1.displayMaster();

  //Spectrograph data
  s1.displayMaster();
  
  //Time domain display data
  t1.displayMaster();
}
