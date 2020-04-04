close all; clear all; clc;

%% Import data, and convert to proper format
%NAMING CONVENTION: We will use 'H' for healthy and 'Uh' for unhealthy.

%Reading in both unhealthy and healthy ecg data
ecgDataH = readtable('healthy.csv');
ecgDataUh = readtable('unhealthy.csv');

%Removing the first row (corresponding to units = 'mV')
ecgDataH(1,:) =[];
ecgDataUh(1,:) = [];

%Extracting rows corresponding to leads 1, 2, and 3, then converting them
%from 'cell' type to 'double' type so we can perform analysis.
leadsH = ecgDataH(:, 2:4);
leadsH = cellfun(@str2num,table2array(leadsH));

leadsUh = ecgDataUh(:,2:4);
leadsUh = cellfun(@str2num,table2array(leadsUh));
%%
%Both unhealthy and healthy ecgs have same t, N, and fs.
t = 10;
N = size(leadsH,1);
fs = N/t;

%Performing the zeromean function on each column of data
sigOutH = zeromean(leadsH, fs);
sigOutUh = zeromean(leadsUh, fs);
%%
VHxH = sigOutH(:,1);
VHyH = -1*((2.*sigOutH(:,2)) - sigOutH(:,1))./sqrt(3);

VHxUh = sigOutUh(:,1);
VHyUh = -1*((2.*sigOutUh(:,2)) - sigOutUh(:,1))./sqrt(3);

%Naming Convention: Using 'other' to denote we are using the "other"
%leads (leads I and III) instead of I and II.
VHxHother = sigOutH(:,1);
VHyHother = -1*((2.*(sigOutH(:,1)+sigOutH(:,3))) - sigOutH(:,1))./sqrt(3);

%Converting our cartesian coordinates to polar.
[thetaH,rhoH] = cart2pol(VHxH,VHyH);
[thetaUh,rhoUh] = cart2pol(VHxUh,VHyUh);
[thetaHother, rhoHother] = cart2pol(VHxHother,VHyHother);
%%
close all; 

%Plotting our heart vector from leads I and II vs
%our heart vector from leads I and III
subplot(1,2,1)
polarplot(thetaH,rhoH, 'r')
title("Using leads I and II", "Fontsize", 20);

subplot(1,2,2)
polarplot(thetaHother, rhoHother, 'g')
title("Using leads I and III", "Fontsize", 20);

sgtitle("Healthy (Patient 104) VH Vector Over Time","Fontsize", 36);
%%

%Plot of an unhealthy heart vector (from leads I and II)
figure
polarplot(thetaUh,rhoUh)
title("Unhealthy (Patient 1) VH Vector Over Time", "Fontsize", 24);
