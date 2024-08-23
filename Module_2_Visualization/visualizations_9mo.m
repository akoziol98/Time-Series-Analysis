%% Import and transform data to binary
% Import
timeData=importfile('timeData.csv'); % 40 Hz

% Get the unique IDs
babyCodes = unique(timeData.id);

%Transform to binary spikes
%binaryData = binarizeTimeData(timeData, babyCodes);

% Or import binary data
importmat('binary_mani_t3.mat');
