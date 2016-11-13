%This MATLAB Function Filters an ECG for Noise and Artifact Removal%
% It uses 4 filters in series.LOWPASS, NOTCH, VON-HAN AND DERIVATIVE BASED.
close all
% The ECG signal in the file is sampled at 1000 Hz
usecg = load('ECG_60Hz.dat');
fs = 1000; %sampling rate
%1. First plot the origanal unfiltered signal.
t = [1:length(usecg)]/fs;
figure
plot(t, usecg)
xlabel('Time in seconds');
ylabel('ECG');
title('Original ECG signal');
axis tight;
%2. Plot the spectrum of the ECG before filtering
ecgft = fft(usecg);
ff= fix(slen/2) + 1;
maxft = max(abs(ecgft));
f = [1:ff]*fs/slen; % frequency axis up to fs/2.
ecgspectrum = 20*log10(abs(ecgft)/maxft);
figure
plot(f, ecgspectrum(1:ff));
xlabel('Frequency in Hz');
ylabel('Log Magnitude Spectrum (dB)');
title('Spectrum of the original ECG');
axis tight;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Down sample signal by 5, making the sampling freq = 200
k = 1;
for i = 1 : length(usecg)
if (rem(i,5) == 0)
ecg(k) = usecg(i);
k = k+1;
end;
end;
fs = 200; %effective sampling rate after downsampling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. NOW DO FILTERING %
% first apply a lowpass filter with cut of 75hz
fsh = fs/2; %half the sampling rate
[b,a] = butter(12, 75/fsh);
figure;
M = 512;
freqz(b, a, M, fs); % Butterworth filter frequency response
ecg_lp = filter(b, a, ecg);
t = [1:length(ecg_lp)]/fs;
% plot the ecg after the lowpass filter
plot(t,ecg_lp);
xlabel('Time in seconds');
ylabel('ECG');
title('ECG after Lowpass Filter');
axis tight;
% Second apply notch filter to remove powerline noise
[a] = 1;
[b] = [(1/2.61812) (.61812/2.61812) (1/2.61812)];
% Notch filter frequency response
figure;
M = 128;
freqz(b, a, M, fs);
figure;
% Output after the notch filter %
ecg_lp_notch = filter(b,a,ecg_lp);
% Plot the ECG after notch and lowpass filtering
plot(t,ecg_lp_notch);
xlabel('Time in seconds');
ylabel('ECG');
title('ECG after Notch and Lowpass Filters');
axis tight;
% Third aplly Von Hann filter %
% define Von Hann filter coefficient arrays a and b
a = [1];
b = [0.25 0.5 0.25];
% Von Hann filter frequency response
figure;
M = 128;
freqz(b, a, M, fs);
figure
% Output after the Von Hann filter %
ecg_lp_notch_von = filter(b,a,ecg_lp_notch);
% Plot of the ECG after the Von Hann, notch and lowpass filters
plot(t,ecg_lp_notch_von);
xlabel('Time in seconds');
ylabel('ECG');
title('ECG filtered with Von Hann, Notch and Lowpass filters');
axis tight;
% last, Apply Derivative-based filter %
% define derivative filter coefficient arrays a and b
a = [1 -0.995];
b = [fs -fs];
% derivative-based filter frequency response
figure;
M = 128;
freqz(b, a, M, fs);
figure
% Output after the derivative filter %
ecg_lp_notch_von_deriv = filter(b,a,ecg_lp_notch_von);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. Plot the ECG after all the filtering
plot(t,ecg_lp_notch_von_deriv);
xlabel('Time in seconds');
ylabel('ECG');
title('ECG after all the cascaded filters');
axis tight;
% Plot of the spectrum of the ECG after all the filtering
ecg_filter_ft = fft(ecg_lp_notch_von_deriv);
ff= fix(length(ecg_lp_notch_von_deriv)/2) + 1;
max_filt = max(abs(ecg_filter_ft));
f = [1:ff]*fs/length(ecg_lp_notch_von_deriv); % frequency axis up to fs/2.
ecgspectrum = 20*log10(abs(ecg_filter_ft)/max_filt);
figure
plot(f, ecgspectrum(1:ff));
xlabel('Frequency in Hz');
ylabel('Log Magnitude Spectrum (dB)');
title('Spectrum of the ECG after all the cascaded filters');
axis tight;