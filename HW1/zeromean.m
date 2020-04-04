function sigOut = zeromean(sigIn, fs)
% Subtract moving baseline (slow drift) of signal such as ECG.
% Format: sigOut = zeromean(sigIn, fs)
% sigIn is input signal, and fs is the sampling frequency in Hz.
% Signal can include 1-12 channels, and should be at least 250 points long.
% Array is returned with 1 channel down each column.

arrsize = size(sigIn);
if max(arrsize) < 250
    disp('Error: Input array is too small. Use 250 points or more.')
else
    if arrsize(1) < arrsize(2)
        sigIn = sigIn';
    end
    [b,a]=cheby1(2,.1,2*1.25/fs,'high'); 
    sigOut = filtfilt(b,a,sigIn);    
end   
% Chris Neils, Spring 2019
end










