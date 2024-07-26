This is a general-purpose signal input visualizer. The program currently works with either audio input from a microphone, or input from sound files. The SoundFile class supports .WAV, .AIFF, and .MP3 files. The two input types cannot currently be toggled while the program is running. The user will have to uncomment their desired input type and comment out the other under “Spectrum_Analyzer_Edit”. 


This program requires the processing.sound and controlP5 libraries to function.


A Fast Fourier Transform (FFT) is performed on the incoming signal input. This generates an array of float values of width ‘bands’ - currently 512. Each entry is the normalized amplitude at that particular band. 


The program has two main displays. A frequency vs amplitude plot is shown on the left, and an amplitude heatmap is shown on the right. Both displays are 512 bands wide. 


The frequency plot shows one trace by default, the running frequency and amplitude. An averaging function has been applied, which averages out the n most recent samples. ‘n’ can be adjusted from 1 to 15, where 1 gives an instantaneous readout. 


Two additional traces, “Lock Max” and “Lock Min” can be toggled. Lock Max displays an additional trace showing the maxima of the incoming signal peaks. Calculation begins at the time the trace is toggled on. Lock Min acts in a similar fashion, showing the minima of the incoming signal peaks. Both Lock Max and Lock Min are affected by the averaging. 


The frequency plot also has a toggleable “Clip Marker” that displays a red line at the top of the graph if a peak clips the top. 


The amplitude heat map shows a scrolling display of rows of pixels, where each pixel is coloured with respect to the amplitude at that particular band. The tallest is shown in red, followed by orange, yellow, green, blue, and finally, purple. The newest data is shown at the top of the scrolling display. The heat map shows a history of 6 seconds from top to bottom. 


A third display, a time domain plot, is currently in development. 


**Installation Instructions**


Create a sketch folder named ‘Spectrum_Analayser_Edit’. The name of the sketch folder must match the name of the main program. 


Make sure the following files are located in the Spectrum_Analyzer_Edit sketch folder:
        Controls.pde
        ModQueue.pde
        Oscilloscope.pde
        Spectrum.pde
        Spectrum_Analyzer_Edit.pde
	      TraceShade.pde


Any audio files to be used for input must be placed in the sketch folder as well. The name of the audio file must be written into the following line, under the setup() class in Spectrum_Analyzer_edit.pde


	track = new SoundFile(this, "anything");


Replace ‘anything’ with the name of the audio file to be used. Make sure the file extension is also correct.


Run the program through the Processing IDE.
