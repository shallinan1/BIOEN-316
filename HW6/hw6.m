% Skyler Hallinan
% 6/1/19
% Homework 6: Part B

clear all; close all; clc;

% Changing our default fonts
set (0, 'defaultAxesFontName', 'CMU Serif')
set (0, 'defaultTextFontName', 'CMU Serif')
%% Loading in data
data = csvread('samples.csv', 2,0);

%% Creating filter and filtered data
% Vector representing bounds of our discretized filter function
n = -80:1:80;

% Manually setting our 0 index to a small value (so we don't get an
% undefined value when we plug it into our sinc fucnction)
n(81) = 1e-7;

% Creating our filter as derived in part A
filter = (160*cos(pi/5.*n).*sin(pi/20.*n).*(0.54+0.46*cos(pi/80.*n)))./(n*pi);

% Convolving our data with the filter (and using only the central part of
% the convolution so that our filtered data is the same length)
filtered = conv(data(:,2),filter, 'same');


% Calclating the fft of our filtered and original data
fft_filtered = fftshift(abs(fft(filtered)));
fft_original = fftshift(abs(fft(data(:,2))));

% Callculating gain by looking at the index corresopnding to the 16 Hz
% mark.
gain = fft_filtered(961)/fft_original(961)

% Readjusting the filter coefficients so that we do not amplify the signal
filter = filter/gain;
% Reconvolving to find the filtered data once more
filtered = conv(data(:,2),filter, 'same');

% To remove gain, can also do the following (instead of redefining the
% filter): filtered = filtered/gain

%% Time Domain Plots: Original Signal vs Filtered Signal
close all;

subplot(2,1,1);
plot(data(:,1), data(:,2), 'b');
grid on;
xlabel("Time (s)"); ylabel("Voltage (\muV)");
set(gca, 'fontsize', 16);
title("Original EEG Signal", 'fontsize', 30);

subplot(2,1,2)
plot(data(:,1), filtered, 'r');
grid on;
xlabel("Time (s)"); ylabel("Voltage (\muV)");
set(gca, 'fontsize', 16);
title("Filtered EEG Signal", 'fontsize', 30);

sgtitle("Original and Filtered Time-Domain EEG Signals", 'fontsize', 40);

%% Magnitude Spectra: Original Signal vs Filtered Signal
close all;

fftdomain = -80:0.1:80-0.1;

subplot(1,2,1);
plot(fftdomain, fftshift(abs(fft(data(:,2)))),'b');
xlabel("Frequency (Hz)", 'fontsize', 24); ylabel("Magnitude", 'fontsize', 24);
set(gca, 'fontsize', 16);
title("Original EEG Signal", 'fontsize', 30);
xlim([min(fftdomain), 80]);
grid on;

subplot(1,2,2);
plot(fftdomain, fftshift(abs(fft(filtered))),'r');
xlabel("Frequency (Hz)", 'fontsize', 24); ylabel("Magnitude", 'fontsize', 24);
set(gca, 'fontsize', 16);
title("Filtered EEG Signal", 'fontsize', 30);
xlim([min(fftdomain), 80]);
grid on;

sgtitle("Magnitude Spectra of Original and Filtered EEG Signals", 'fontsize', 40);

