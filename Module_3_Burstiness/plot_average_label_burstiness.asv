%This protocol estimates burstiness and memory (using 'acf.m') from
%onset events collected by head-mounted cameras on two infants
%in the first year of life.
%Contact: Drew Abney (dhabney@indiana.edu)

%1. Estimate burstiness and memory for hand events
%2. Estimate burstiness and memory for face events
%3. Estimate burstiness and memory for periodic-ish signal
%4. Estimate burstiness and memory for random signal
%5. Plot Inter-Event-Interval (IEI) distributions and Burstiness/Memory space
%   The duration of time between the onset of consecutive events or to
%   construct likelihood models of an event’s occurrence.

%% Import and transform data to binary
% Import
%timeData=importfile('timeData.csv'); % 40 Hz

% Get the unique IDs
%babyCodes = unique(timeData.id);

%Transform to binary spikes
%binaryData = binarizeTimeData(timeData, babyCodes);

% Or import binary data
importmat('binary_mani_t3.mat');

%% Calculation and plots in a loop
%Import data for plotting
importmat('burstyData_mani_T3.mat');
%importmat('ieiData_mani_T3.mat');
importmat('babyCodes.mat');

memory_right_hand = burstyData.MemoryRight;
memory_left_hand = burstyData.MemoryLeft;
memory_position = burstyData.MemoryPosition;
burstiness_right_hand = burstyData.BurstyRight;
burstiness_left_hand = burstyData.BurstyLeft;
burstiness_position = burstyData.BurstyPosition;
%3. Simulate periodic-ish signal
a = 95;b = 105; r = (b-a).*rand(100,1) + a;
iei_periodic=round(r);

%Estimate Burstiness (as per Goh & Barabasi)
burstiness_periodic=(std(iei_periodic)-mean(iei_periodic))/(std(iei_periodic)+mean(iei_periodic));

%Estimate Memory (lag-1 ACF)
memory_periodic=acf(iei_periodic,1);

%4. Simulate random (poisson process) signal
mu = 1;
iei_random = exprnd(mu,100,1);

%Estimate Burstiness (as per Goh & Barabasi)
burstiness_random=(std(iei_random)-mean(iei_random))/(std(iei_random)+mean(iei_random));

%Estimate Memory (lag-1 ACF)
memory_random=acf(iei_random,1);

fig = figure('Position', [300, 300, 1100, 800]);
%fig = figure('Visible', 'off', 'Position', [300, 300, 1500, 800]);

scatter(memory_right_hand,burstiness_right_hand, 'MarkerFaceColor', '#549ba2')
hold on
scatter(memory_left_hand,burstiness_left_hand, 'MarkerFaceColor', '#DBCFB0', 'MarkerEdgeColor', '#DBCFB0')
scatter(memory_position,burstiness_position,'MarkerFaceColor', '#4F517D','MarkerEdgeColor', '#4F517D')
scatter(memory_periodic,burstiness_periodic, 50, 'MarkerFaceColor', '#BD6B73','MarkerEdgeColor', '#BD6B73')
scatter(memory_random,burstiness_random, 50, 'MarkerFaceColor', 'black','MarkerEdgeColor', 'black')
yline(0, '--', 'random','LineWidth',3);
title('Burstiness/Memory Space')
xlabel('Memory')
ylabel('Burstiness')
xlim([-1 1])
ylim([-1 1])
legend({'Right Hand', 'Left Hand', 'Position', 'Periodic', 'Random'});

% Save the figure in high quality
saveas(fig, 'burstiness_label_average.png');%, 'Resolution', 300);  % High-quality PNG file

% Close the figure to avoid cluttering
clf; close all;


