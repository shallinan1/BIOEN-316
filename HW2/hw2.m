close all; clear all; clc;

%% Signal creation

%Upper and lower limit on voltage captured
upLim = 10;
lowLim = -10;

%Function used to give closed intervals on random value creation
mag = floor(log10( upLim - lowLim))  
signal = unifrnd(lowLim-(10^mag)*eps, upLim+(10^mag)*eps,1000,1);

%Copy of unmodified signal. This will end up being our "original" signal.
signalCopy = signal;
%Creating a "Analysis" signal which has the points shifted up by 10.
signalAnalysis = signal + 10;

%Calculating the voltage resolution.
bitSize = 20/(2^16)

%This is now the modified signal!
signal(~((signalAnalysis > (0 * bitSize) & signalAnalysis < (bitSize * (2^13-1))) |...
        (signalAnalysis > (2^14 * bitSize) & signalAnalysis < (bitSize * (2^14+2^13-1)))| ... 
        (signalAnalysis > (2^15 * bitSize) & signalAnalysis < (bitSize * (2^15+2^13-1)))| ... 
        (signalAnalysis > ((2^15+2^14) * bitSize) & signalAnalysis < (bitSize * (2^15+2^14+2^13-1))))) = ...
        signal(~((signalAnalysis > (0 * bitSize) & signalAnalysis < (bitSize * (2^13-1))) |...
        (signalAnalysis > (2^14 * bitSize) & signalAnalysis < (bitSize * (2^14+2^13-1)))| ... 
        (signalAnalysis > (2^15 * bitSize) & signalAnalysis < (bitSize * (2^15+2^13-1)))| ... 
        (signalAnalysis > ((2^15+2^14) * bitSize) & signalAnalysis < (bitSize * (2^15+2^14+2^13-1))))) - 2.5;
    
%% Plots
close all;

%Side by side index plots
figure
subplot(2,1,1)
plot(signalCopy, 'g', 'Linewidth', 1)
title("Input Voltage", "fontsize", 32)
xlabel("Sample Index"); ylabel("Voltage (V)");
subplot(2,1,2)
plot(signal, 'r', 'Linewidth', 1)
title("ADC Converted Signal Voltage", "fontsize", 32);
xlabel("Sample Index"); ylabel("Voltage (V)");

%Plot a guidline of proper signal
line = [-10:0.5:10];
axis = zeros(1,41);

%Plots against eachother
figure
plot(line, line, 'k--', 'Linewidth', 1);
hold on
plot(signalCopy, signal, 'ro')
hold on

plot(line, axis, 'k--');
plot(axis, line, 'k--');
xlabel("Input Signal (V)"); ylabel("ADC Converted Signal (V)");
title("ADC Converted Signal vs Input Signal", "fontsize", 32);
grid on

