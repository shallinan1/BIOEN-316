% Skyler Hallinan
% 6/1/19
% Homework 6: Part B

clear all; close all; clc;

% Changing our default fonts
set (0, 'defaultAxesFontName', 'CMU Serif')
set (0, 'defaultTextFontName', 'CMU Serif')

%% Setting the lower and upper cutoff frequencies (in radians)
whigh = 50*2* pi; % Converting lower cutoff to radians
wlow = 0.5*2*pi; % Converting upper cutoff to radians
alpha = (whigh - wlow)/2; % Calcuating the alpha value from whigh and wlow

% Below: Calculaing w0 from alpha, whigh, and wlow.
w0 = sqrt(((whigh +wlow)/2)^2-alpha^2);
% Alternative calculation methods of w0: 
% w01 = sqrt((whigh - alpha)^2-alpha^2);
% w02 = sqrt((wlow + alpha)^2-alpha^2);

%% RLC Filter Calculation

% Creating frequency axis (on a log scale) for our filter bode plot. Note
% that this frequency axis is in rads/sec (omega).
omegas = logspace(-3,6,100);

% Calculating RLC circuit gain (From formula)
gain = abs((2*alpha.*omegas*i)./((i.*omegas).^2+2*alpha.*omegas*i+w0^2));

% Semilogarthmic (bode plot) in dB scale of our omega frequency axis and 
% circuit gain (Bode plot)
semilogx(omegas,db(gain), 'linewidth', 2)
set(gca, 'fontsize', 16);
ylabel("Magnitude (dB)", 'fontsize', 24); xlabel("Frequency (rads/sec)", 'fontsize', 24);
title("Bandpass Filter Comparisons", 'fontsize' , 48);
grid on;
 
hold on;

%% FIR Filter

% Calculating the 3rd zero of our sinc function, for truncation limits
tlim = (3*pi)/alpha;
fs = 500; % Sampling frequency
ts = 1/fs; % 
% Creaing t vector to input into our sinc function with desired smapling
% frequency as specified above
t = -tlim:ts:tlim-ts; 

% Setting any t == 0 indeces to a small number to remove NaN values
t(t == 0) = 1e-9;

% Inputting our FIR filter with smoothing
filter = (cos((wlow+whigh)/2 *t).*sin(alpha*t).*(0.54+0.46*cos(alpha/3 * t)))./(pi*t);

% Calculating length of filter for frequency domain
nlen = length(filter);

% Creating the frequency domain for fftshifted data
fftdomain = (-nlen/2:1/25600:nlen/2)*(fs/nlen)*2*pi;

% Calculating gain of filter (in frequency domain) and removing it by
% dividing it from the filter (and re-ffting)
fft_FIR = fftshift(abs(fft(filter)));
gain = max(fft_FIR);
filter = filter/gain;

% Plotting the fftdomain along with the db scale of the fftshifted
% magnitude spectrum, on a semilog plot
semilogx(fftdomain, db(abs(fftshift(fft(filter, 1536001)))), 'c', 'linewidth', 2)
%%

% Calculating the nyquist frequency (half our fs, then multiply by 2 pi
% since we convert to rads/sec
nyq  = fs*pi;

% Implementing the butterworth filter with an order of 2 (1*2 = 2) and with
% cutoff frequencies relative to calculated nyquist frequency
[b,a] = butter(1, [wlow/nyq, whigh/nyq]);

% Converting butterworth coefficients into plotting variable and axes, with 
% 400000 points, and paremeter fs*2*pi
[h f] = freqz(b,a, 400000, fs*2*pi);

% Plotting butterworth filter on same plot, db scale, and with the axes
% generated in previous step
semilogx(f, db(h), 'm', 'linewidth', 2);

%% Graphing edits
% Setting bounds on graph for graphing
xlim([min(omegas), max(omegas)]);   
ylim([-80 0])

% Adding pass band lines
xline(whigh, 'g--','linewidth', 1)
xline(wlow, 'r--','linewidth', 1)

% Adding legend
legend("RLC Circuit", "FIR Filter", "Butterworth IIR Filter", ...
    'Upper cutoff frequency', 'Lower cutoff frequency', 'location', 'best', 'fontsize', 18);