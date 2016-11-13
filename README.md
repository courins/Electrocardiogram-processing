# Electrocardiogram-processing
This repository contains code for filtering an electrocardiogram signal using digital filters in Matlab

Like all signals, biomedical signals are subject to interfrences in the form of noise. This noise could be due to powerline interference[50hz-60hz],
other physiological signals around the site of signal aquisition and noise due to the limitations of the aquisition systems.

To be able to get useful insight from an electrocardiogram, its necessary to remove or decrease the amount of noise in the signal.
An ECG signal has a freqeuncy spectrum of  [0.005hz-100hz]. I used a lowpass, hanning and derivative based highpass filter to attenuate parts of the signal outside this range.
To remove the powerline intefrence I have used a notch filter with cut of at 60HZ.

The ECG signal used was smapled at 1000hz.
I downsampled it to 200hz to reduce the amount of data.

This code is beerware licensed. Feel free to use it as you please however, you are encouraged to get me a round if we ever meet at a bar.

