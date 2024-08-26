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

columns = {'inhand_right_child', 'inhand_left_child', 'Position'};
toys = {'bubbles', 'dino', 'klickity', 'spinner'};

%% Calculation and plots in a loop

burstyLabelData = struct();
burstyLabelData(i).bubbles = table;
burstyLabelData(i).dino = table;
burstyLabelData(i).klickity = table;
burstyLabelData(i).spinner = table;

columns = {'inhand_right_child', 'inhand_left_child'};
for i = 1:length(babyCodes)
    current_id = babyCodes(i);
    
    burstyLabelData.bubbles.id(i) = current_id;
    burstyLabelData.dino.id(i) = current_id;
    burstyLabelData.klickity.id(i) = current_id;
    burstyLabelData.spinner.id(i) = current_id;
    
    burstyLabelData.bubbles.MemoryRight(i) = NaN;
    burstyLabelData.bubbles.BurstyRight(i) = NaN;
    burstyLabelData.bubbles.MemoryLeft(i) = NaN;
    burstyLabelData.bubbles.BurstyLeft(i) = NaN;
    burstyLabelData.dino.MemoryRight(i) = NaN;
    burstyLabelData.dino.BurstyRight(i) = NaN;
    burstyLabelData.dino.MemoryLeft(i) = NaN;
    burstyLabelData.dino.BurstyLeft(i) = NaN;
    burstyLabelData.klickity.MemoryRight(i) = NaN;
    burstyLabelData.klickity.BurstyRight(i) = NaN;
    burstyLabelData.klickity.MemoryLeft(i) = NaN;
    burstyLabelData.klickity.BurstyLeft(i) = NaN;
    burstyLabelData.spinner.MemoryRight(i) = NaN;
    burstyLabelData.spinner.BurstyRight(i) = NaN;
    burstyLabelData.spinner.MemoryLeft(i) = NaN;
    burstyLabelData.spinner.BurstyLeft(i) = NaN;
    
    
    % Loop through each column name
    for j = 1:length(columns)
        
        for t =1:length(toys)
            current_toy = toys{t};
            
            % Get the current column name
            col = columns{j};
            columnName = strjoin({col current_toy}, "_");
            % Extract the data as a vector for the current column
            extractedData = binaryDataLabel(1, i).data.(columnName);
            if sum(extractedData) == 0 || sum(extractedData) == 1 || sum(extractedData) == 2
                if strcmp(col, 'inhand_right_child')
                    memory_right_hand = NaN;
                    burstiness_right_hand = NaN;
                    
                elseif strcmp(col, 'inhand_left_child')
                    memory_left_hand = NaN;
                    burstiness_left_hand = NaN;
                    
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
            
            if strcmp(col, 'inhand_right_child')
                if strcmp(current_toy, 'bubbles')
                    burstyLabelData.bubbles.MemoryRight(i) = memory;
                    burstyLabelData.bubbles.BurstyRight(i) = burstiness;
                    
                elseif strcmp(current_toy, 'dino')
                    burstyLabelData.dino.MemoryRight(i) = memory;
                    burstyLabelData.dino.BurstyRight(i) = burstiness;
                    
                elseif strcmp(current_toy, 'klickity')
                    burstyLabelData.klickity.MemoryRight(i) = memory;
                    burstyLabelData.klickity.BurstyRight(i) = burstiness;
                    
                elseif strcmp(current_toy, 'spinner')
                    burstyLabelData.spinner.MemoryRight(i) = memory;
                    burstyLabelData.spinner.BurstyRight(i) = burstiness;
                    
                end
            elseif strcmp(col, 'inhand_left_child')
                if strcmp(current_toy, 'bubbles')                   
                    burstyLabelData.bubbles.MemoryLeft(i) = memory;
                    burstyLabelData.bubbles.BurstyLeft(i) = burstiness;
                    
                elseif strcmp(current_toy, 'dino')
                    burstyLabelData.dino.MemoryLeft(i) = memory;
                    burstyLabelData.dino.BurstyLeft(i) = burstiness;
                    
                elseif strcmp(current_toy, 'klickity')
                    burstyLabelData.klickity.MemoryLeft(i) = memory;
                    burstyLabelData.klickity.BurstyLeft(i) = burstiness;
                    
                elseif strcmp(current_toy, 'spinner')
                    burstyLabelData.spinner.MemoryLeft(i) = memory;
                    burstyLabelData.spinner.BurstyLeft(i) = burstiness;
                    
                end
                
            end
            
        end
    end
    
end
save('burstyLabelData_mani_T3.mat', 'burstyLabelData');