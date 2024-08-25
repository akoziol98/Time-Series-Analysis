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
binaryData = binarizeTimeData(timeData, babyCodes);
binaryDataLabel = binarizeTimeDataLabel(timeData, babyCodes);

% Or import binary data
importmat('binary_mani_t3.mat');

%% Calculation and plots in a loop
%Import data for plotting
importmat('burstyData_mani_T3.mat');
importmat('ieiData_mani_T3.mat');
importmat('label_table_T3.mat');
importmat('binaryDataLabel_T3.mat');

% Define the folder to save plots
outputFolder = 'burstiness_plots';

% Create the folder if it doesn't exist
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

for i = 1:length(babyCodes)
    current_id = babyCodes(i);
    
    % List of column names to extract
    columnsToExtract = {'inhand_right_child', 'inhand_left_child', 'Position'};
    
    %fig = figure('Position', [300, 300, 1100, 800]);
    fig = figure('Visible', 'off', 'Position', [300, 300, 1500, 800]);
    sgtitle(sprintf('ID: %d\n', current_id))
    
    % Loop through each column name
    for j = 1:length(columnsToExtract)
        
        % Get the current column name
        columnName = columnsToExtract{j};
        
        
        if strcmp(columnName, 'inhand_right_child')
            if isnan(burstyData.MemoryRight(i))
                memory_right_hand = NaN;
                burstiness_right_hand = NaN;
                iei = NaN;
                continue
            end
            % Extract the data as a vector for the current column
            memory_right_hand = burstyData.MemoryRight(i);
            burstiness_right_hand = burstyData.BurstyRight(i);
            iei = ieiData(1, i).iei_right;
            
            subplot(1,4,1)
            hist(iei,10)
            title('IEI Distribution for Right Hand Events')
            xlabel('IEI (seconds)')
            ylabel('Count')
            xlim([0 100])
            ylim([0 100])
            
        elseif strcmp(columnName, 'inhand_left_child')
            if isnan(burstyData.MemoryLeft(i))
                memory_left_hand = NaN;
                burstiness_left_hand = NaN;
                iei = NaN;
                continue
            end
            memory_left_hand = burstyData.MemoryLeft(i);
            burstiness_left_hand = burstyData.BurstyLeft(i);
            iei = ieiData(1, i).iei_left;
            
            subplot(1,4,2)
            hist(iei,10)
            title('IEI Distribution for Left Hand Events')
            xlabel('IEI (seconds)')
            ylabel('Count')
            xlim([0 100])
            ylim([0 100])
            
        elseif strcmp(columnName, 'Position')
            if isnan(burstyData.MemoryPosition(i))
                memory_position = NaN;
                burstiness_position = NaN;
                iei = NaN;
                continue
            end
            memory_position = burstyData.MemoryPosition(i);
            burstiness_position = burstyData.BurstyPosition(i);
            iei = ieiData(1, i).iei_position;
            
            subplot(1,4,3)
            hist(iei,10)
            title('IEI Distribution for Body Position Events')
            xlabel('IEI (seconds)')
            ylabel('Count')
            xlim([0 100])
            ylim([0 100])
        end
    end
    
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
