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
importmat('babyCodes.mat');
importmat('binaryDataLabel_T3.mat');

%% Calculation and plots in a loop
binaryDataLabel.data
burstyLabelData = table;
ieiLabelData = struct('id', [], 'iei_right', [], 'iei_left', [], 'iei_position', []);

for i = 1:length(babyCodes)  
    current_id = babyCodes(i);
    ieiLabelData(i).id = current_id;

    % List of column names to extract
    columnsToExtract = {'inhand_right_child', 'inhand_left_child', 'Position'};
    
    % Loop through each column name
    for j = 1:length(columnsToExtract)
        
        % Get the current column name
        columnName = columnsToExtract{j};
        
        % Extract the data as a vector for the current column
        extractedData = binaryData(1, i).data.(columnName);
        if sum(extractedData) == 0 || sum(extractedData) == 1
            if strcmp(columnName, 'inhand_right_child')
            memory_right_hand = NaN;
            burstiness_right_hand = NaN;
            
        elseif strcmp(columnName, 'inhand_left_child')
            memory_left_hand = NaN;
            burstiness_left_hand = NaN;
            
        elseif strcmp(columnName, 'Position')
            memory_position = NaN;
            burstiness_position = NaN;
           
        end
            continue
        end
        
        %Index onsets in spike train
        ix=find(extractedData');
        
        %Compute IEI distribution of onsets
        iei=diff(ix);
        
        %Adjust IEI as per sample rate (40 Hz)
        iei=iei/40;
        
        %Estimate Burstiness (as per Goh & Barabasi)
        burstiness=(std(iei)-mean(iei))/(std(iei)+mean(iei));
        
        %Estimate Memory (lag-1 ACF)
        memory=acf(iei',1);
        
        if strcmp(columnName, 'inhand_right_child')
            memory_right_hand = memory;
            burstiness_right_hand = burstiness;
            ieiLabelData(i).iei_right = iei;
            
        elseif strcmp(columnName, 'inhand_left_child')
            memory_left_hand = memory;
            burstiness_left_hand = burstiness;
            ieiLabelData(i).iei_left = iei;

        elseif strcmp(columnName, 'Position')
            memory_position = memory;
            burstiness_position = burstiness;
            ieiLabelData(i).iei_position = iei;

        end
    end
    % Combine the original index and id with the bursty tables
    burstyLabelData.id(i) = current_id;
    burstyLabelData.MemoryRight(i) = memory_right_hand;
    burstyLabelData.BurstyRight(i) = burstiness_right_hand;
    burstyLabelData.MemoryLeft(i) = memory_left_hand;
    burstyLabelData.BurstyLeft(i) = burstiness_left_hand;
    burstyLabelData.MemoryPosition(i) = memory_position;
    burstyLabelData.BurstyPosition(i) = burstiness_position;
end
save('burstyData_mani_T3.mat', 'burstyData');
save('ieiData_mani_T3.mat', 'ieiData');