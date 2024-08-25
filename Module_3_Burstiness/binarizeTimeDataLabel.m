function binaryDataLabel = binarizeTimeDataLabel(data, babyCodes)
% This function takes the time series with coded events and
% transforms it to 0s and 1s marking the change in event.
% It is then used for burstiness analysis

% Initialize a struct to hold the results
binaryDataLabel = struct();
toys = ["bubbles", "dino", "klickity", "spinner"];

% Process the data for each unique ID
for i = 1:length(babyCodes)
    current_id = babyCodes(i);
    
    % Extract the subset of data corresponding to the current id
    subset = data(data.id == current_id, :);
    
    % Initialize the change columns for each toy
    change_inhand_right_child = zeros(height(subset), length(toys));
    change_inhand_left_child = zeros(height(subset), length(toys));
    %change_Position = zeros(height(subset), length(toys));
    
    % Calculate changes using vectorized operations
    if height(subset) > 0
        % Loop through each toy
        for t = 1:length(toys)
            toyName = toys(t);
            
            % Check for transitions from "" to the current toy for each column
            
            % Right Hand
            if height(subset) > 1
                change_inhand_right_child(1, t) = strcmp(subset.inhand_right_child(1), toyName); % Check first row
                change_inhand_right_child(2:end, t) = strcmp(subset.inhand_right_child(2:end), toyName) & strcmp(subset.inhand_right_child(1:end-1), "");
            end
            
            % Left Hand
            if height(subset) > 1
                change_inhand_left_child(1, t) = strcmp(subset.inhand_left_child(1), toyName); % Check first row
                change_inhand_left_child(2:end, t) = strcmp(subset.inhand_left_child(2:end), toyName) & strcmp(subset.inhand_left_child(1:end-1), "");
            end
            
            % Position
            %if height(subset) > 1
            %    change_Position(1, t) = strcmp(subset.Position(1), toyName); % Check first row
            %    change_Position(2:end, t) = strcmp(subset.Position(2:end), toyName) & strcmp(subset.Position(1:end-1), "");
            %end
        end
    end
    
    % Store the changes in the change_table for this ID
    change_table_inhand_right_child = array2table(change_inhand_right_child, 'VariableNames', strcat('inhand_right_child_', toys));
    change_table_inhand_left_child = array2table(change_inhand_left_child, 'VariableNames', strcat('inhand_left_child_', toys));
    %change_table_Position = array2table(change_Position, 'VariableNames', strcat('Position_', toys));
    
    % Combine the original index and id with the change tables
    change_data = [subset(:, {'index', 'id'}), ...
        change_table_inhand_right_child, ...
        change_table_inhand_left_child, ...
        %change_table_Position];
        ];
    
    % Store in the results struct
    binaryDataLabel(i).id = current_id;
    binaryDataLabel(i).data = change_data;
end
save('binaryDataLabel_T3.mat', 'binaryDataLabel');
end



