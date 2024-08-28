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
importmat('burstyLabelData_mani_T3.mat');
%importmat('ieiData_mani_T3.mat');
importmat('babyCodes.mat');
toys = {'bubbles', 'dino', 'klickity', 'spinner'};
icis_colors = ["#2bc3db","#2bc3db", "#fdb718", "#fdb718"]; % Colors for each toy
aff_colors = ["#2bc3db", "#fdb718"];
outputFolder = 'burstiness_plots/toys';

% Define marker shapes for right and left hands
marker_shapes = {'o', '^'}; % 'o' for right hand, '^' for left hand

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
hold on
% Initialize handles for legend entries
toy_handles = gobjects(1, length(toys));
hand_handles = gobjects(1, 2);

% Loop through each toy
for t = 1:length(toys)
    toy_name = toys{t};
    toy_color = icis_colors(t); % Get color for the toy
    data = burstyLabelData.(toy_name); % Extract data for the current toy
    
    % Plot Right Hand data
    h_right = scatter(data.MemoryRight, data.BurstyRight, 60, 'filled', ...
        'MarkerFaceColor', toy_color, 'Marker', marker_shapes{1}, 'MarkerEdgeColor', 'black',...
        'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);
    
    % Plot Left Hand data
    h_left = scatter(data.MemoryLeft, data.BurstyLeft, 60, 'filled', ...
        'MarkerFaceColor', toy_color, 'Marker', marker_shapes{2}, 'MarkerEdgeColor', ...
        'black', 'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);
    
    % Store handles for the first toy to use in the legend
    if t == 1
    hand_handles(1) = h_right;
    hand_handles(2) = h_left;
    end

    if strcmp(toy_name, 'bubbles')
        bubbles_handles(1) = h_right;
        bubbles_handles(2) = h_left;
      
    elseif strcmp(toy_name, 'dino')
        dino_handles(1) = h_right;
        dino_handles(2) = h_left;
    
    elseif strcmp(toy_name, 'klickity')
        klickity_handles(1) = h_right;
        klickity_handles(2) = h_left;
    
        elseif strcmp(toy_name, 'spinner')
        spinner_handles(1) = h_right;
        spinner_handles(2) = h_left;
        
    end
    % Store handles for each toy color
    toy_handles(t) = h_right; % Use h_right or h_left, doesn't matter, just to get the color
end

yline(burstiness_random, '--', 'random','LineWidth', 2);
yline(burstiness_periodic, '--', 'periodic','LineWidth', 2);

title('Burstiness/Memory Space')
xlabel('Memory')
ylabel('Burstiness')
xlim([-1 1])
ylim([-1 1])

% Create legend for toys with colors
%toy_lgd = legend(toy_handles, {'Bubbles', 'Dino', 'Klickity', 'Spinner'}, 'Location', 'northeast');
%title(toy_lgd, 'Toy');
% Create a separate legend for hand markers with black color
%set(hand_handles, 'MarkerFaceColor','black');


hand_lgd = legend(hand_handles, {'Right Hand', 'Left Hand'}, 'Location', 'best');

affordances = ["graspable", "stationary"];
for a = 1:length(affordances)
    aff_name = affordances(a);
    aff_color = aff_colors(a);
    set(hand_handles, 'MarkerFaceColor',aff_color,'MarkerEdgeColor','black','MarkerFaceAlpha',1,'MarkerEdgeAlpha',1);
    title(hand_lgd, aff_name);
    if strcmp(aff_name, 'graspable')
        set(bubbles_handles, 'MarkerFaceAlpha',1,'MarkerEdgeAlpha',1);
        set(dino_handles, 'MarkerFaceAlpha',1,'MarkerEdgeAlpha',1);
        elseif strcmp(aff_name, 'stationary')         
        set(klickity_handles, 'MarkerFaceAlpha',1,'MarkerEdgeAlpha',1);
        set(spinner_handles, 'MarkerFaceAlpha',1,'MarkerEdgeAlpha',1);
    end
% Save the figure in high quality
fileName = fullfile(outputFolder, sprintf('burstiness_%s.png', aff_name));
    
    % Save the figure in high quality
    saveas(fig, fileName);
    set(bubbles_handles, 'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);
    set(dino_handles, 'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);
    set(klickity_handles, 'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);
    set(spinner_handles, 'MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);
end
% Close the figure to avoid cluttering
% Hold off to finish the plot
hold off;
clf; close all;

