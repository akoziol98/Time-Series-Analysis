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
timeData=importfile('timeData.csv'); % 40 Hz

% Get the unique IDs
babyCodes = unique(timeData.id);

%Transform to binary spikes
%binaryData = binarizeTimeData(timeData, babyCodes);

% Or import binary data
importmat('binary_mani_t3.mat');

%% Calculation and plots

% Define the folder to save plots
outputFolder = 'burstiness_plots';

% Create the folder if it doesn't exist
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

for i = 1:length(babyCodes)
    current_id = babyCodes(i);
    
    %1. Estimate burstiness and memory for right hand events
    right_hand=binaryData(1, i).data.inhand_right_child;
    
    %Index onsets in spike train
    ix_hand=find(right_hand');
    
    %Compute IEI distribution of onsets
    iei_right_hand=diff(ix_hand);
    
    %Adjust IEI as per sample rate (40 Hz)
    iei_right_hand=iei_right_hand/40;
    
    %Estimate Burstiness (as per Goh & Barabasi)
    burstiness_right_hand=(std(iei_right_hand)-mean(iei_right_hand))/(std(iei_right_hand)+mean(iei_right_hand));
    
    %Estimate Memory (lag-1 ACF)
    memory_right_hand=acf(iei_right_hand',1);
    
    
    
    %2. Estimate burstiness and memory for left hand events
    left_hand=binaryData(1, 1).data.inhand_left_child;
    
    %Index onsets in spike train
    ix_left_hand=find(left_hand');
    
    %Compute IEI distribution of onsets
    iei_left_hand=diff(ix_left_hand);
    
    %Adjust IEI as per sample rate (40 Hz)
    iei_left_hand=iei_left_hand/40;
    
    %Estimate Burstiness (as per Goh & Barabasi)
    burstiness_left_hand=(std(iei_left_hand)-mean(iei_left_hand))/(std(iei_left_hand)+mean(iei_left_hand));
    
    %Estimate Memory (lag-1 ACF)
    memory_left_hand=acf(iei_left_hand',1);
    
    %2.5. Estimate burstiness and memory for position events
    position=binaryData(1, 1).data.Position;
    
    %Index onsets in spike train
    ix_position=find(position');
    
    %Compute IEI distribution of onsets
    iei_position=diff(ix_position);
    
    %Adjust IEI as per sample rate (40 Hz)
    iei_position=iei_position/40;
    
    %Estimate Burstiness (as per Goh & Barabasi)
    burstiness_position=(std(iei_position)-mean(iei_position))/(std(iei_position)+mean(iei_position));
    
    %Estimate Memory (lag-1 ACF)
    memory_position=acf(iei_position',1);
    
    
    
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
    
    
    
    %5. Plot IEI distributions and Burstiness/Memory space
    %fig = figure('Position', [300, 300, 1100, 800]);
    fig = figure('Visible', 'off', 'Position', [300, 300, 1500, 800]);
    sgtitle(sprintf('ID: %d\n', current_id))
    
    subplot(1,4,1)
    hist(iei_right_hand,10)
    title('IEI Distribution for Right Hand Events')
    xlabel('IEI (seconds)')
    ylabel('Count')
    xlim([0 100])
    ylim([0 100])
    
    subplot(1,4,2)
    hist(iei_left_hand,10)
    title('IEI Distribution for Left Hand Events')
    xlabel('IEI (seconds)')
    ylabel('Count')
    xlim([0 100])
    ylim([0 100])
    
    subplot(1,4,3)
    hist(iei_position,10)
    title('IEI Distribution for Body Position Events')
    xlabel('IEI (seconds)')
    ylabel('Count')
    xlim([0 100])
    ylim([0 100])
    
    subplot(1,4,4)
    scatter(memory_right_hand,burstiness_right_hand, 'MarkerFaceColor', '#549ba2')
    hold on
    scatter(memory_left_hand,burstiness_left_hand, 'MarkerFaceColor', '#DBCFB0', 'MarkerEdgeColor', '#DBCFB0')
    scatter(memory_position,burstiness_position,'MarkerFaceColor', '#4F517D','MarkerEdgeColor', '#4F517D')
    scatter(memory_periodic,burstiness_periodic,'MarkerFaceColor', '#BD6B73','MarkerEdgeColor', '#BD6B73')
    scatter(memory_random,burstiness_random,'MarkerFaceColor', 'black','MarkerEdgeColor', 'black')
    title('Burstiness/Memory Space')
    xlabel('Memory')
    ylabel('Burstiness')
    xlim([-1 1])
    ylim([-1 1])
    legend({'Right Hand', 'Left Hand', 'Position', 'Periodic', 'Random'});
    
    % Define the filename based on the current id
    fileName = fullfile(outputFolder, sprintf('burstiness_%d.png', current_id));
    
    % Save the figure in high quality
    saveas(fig, fileName);%, 'Resolution', 300);  % High-quality PNG file

    % Close the figure to avoid cluttering
    clf; close all;
end

%6. Great job!
