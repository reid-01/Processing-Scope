This is a general-purpose signal input visualizer. The program currently works with either audio input from a microphone, or input from SoundFile objects. The SoundFile class supports .WAV, .AIFF, and .MP3 files. The two input types cannot currently be toggled while the program is running. The user will have to uncomment their desired input type and comment out the other under “Spectrum_Analyzer_Edit”.

This program requires the processing.sound and ControlP5 libraries to function. They can be downloaded under "Sketch -> Import Library -> Manage Libraries..."

Three displays are visible while the program is running: a freqnency domain plot sown on the top left, a time domain plot on the bottom left, and a freqency vs. time hitory map on the right. The program performs a Fast Fourier Transform (FFT) on the incoming data, with 512 bands as default. This returns an array of 512 entries, where each entry is the amplitude at that band, normalized to 1. The FFT data is used by the freqency domain plot, and the history map. The program likewise generates a time-domain waveform which is used in the time domain plot.

The frequency domain plot shows one trace by default, the running frequency and amplitude. An averaging function has been applied, which averages out the n most recent samples. ‘n’ can be adjusted from 1 to 15, where 1 gives an instantaneous readout. Two additional traces, “Lock Max” and “Lock Min” can be toggled. Lock Max displays an additional trace showing the maxima of the incoming signal peaks. Calculation begins at the time the trace is toggled on. Lock Min acts in a similar fashion, showing the minima of the incoming signal peaks. Both Lock Max and Lock Min are affected by the averaging, and both can be enabled at the same time. The frequency domain plot also has a toggleable “Clip Marker” that displays a red line at the top of the graph if a peak clips the top.

The time domain plot is off by default. The user must select one or both of the trigger modes - rising edge, or falling edge. Data is displayed once a peak in the incoming waveform passes the trigger threshold. The trigger location is the midpoint of the graph, and cannot currently be changed. This will be a feature at a later time. The trigger threshold can be adjusted, from -1 to 1, and is shown by a sliding horizontal bar on the graph.

The amplitude heat map uses the FFT data to show a scrolling display of rows of pixels, where each pixel is coloured with respect to the amplitude at that particular band. The tallest is shown in red, followed by orange, yellow, green, blue, and finally, purple. The newest data is shown at the top of the scrolling display. The heat map shows a history of 6 seconds from top to bottom.

**Installation Instructions**

Make sure the following files are located in the provided Spectrum_Analyzer_Edit sketch folder:
	
        Controls.pde
	FreqDomainDisplay.pde
        ModQueue.pde
	Spectrograph.pde
        Spectrum_Analyzer_Edit.pde
	TimeDomainDisplay.pde
	TraceShade.pde
	
Any audio files to be used for input must be placed in the sketch folder. The name of the audio file must be written into the following line, under the setup() class in Spectrum_Analyzer_Edit.pde
	
	track = new SoundFile(this, "anything");
	
Replace ‘anything’ with the name of the audio file to be used. Make sure the file extension is also correct.

Run the program through the Processing IDE.
