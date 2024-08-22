function results = binarizeTimeData(data, babyCodes)
% This function takes the time series with coded events and
% transforms it to 0s and 1s marking the change in event.
% It is then used for burstiness analysis

% Initialize the output struct
results = struct('id', [], 'data', []);

% Process the data for each unique ID
for i = 1:length(babyCodes)
    current_id = babyCodes(i);
    
    % Extract the subset of data corresponding to the current id
    subset = data(data.id == current_id, :);
    
    % Initialize the change columns
    change_inhand_right_child = zeros(height(subset), 1);
    change_inhand_left_child = zeros(height(subset), 1);
    change_mouthing = zeros(height(subset), 1);
    change_Position = zeros(height(subset), 1);
    
    % Calculate changes using shifted differences
    if height(subset) > 1
        change_inhand_right_child(2:end) = ~strcmp(subset.inhand_right_child(2:end), subset.inhand_right_child(1:end-1));
        change_inhand_left_child(2:end) = ~strcmp(subset.inhand_left_child(2:end), subset.inhand_left_child(1:end-1));
        change_mouthing(2:end) = ~strcmp(subset.mouthing(2:end), subset.mouthing(1:end-1));
        change_Position(2:end) = ~strcmp(subset.Position(2:end), subset.Position(1:end-1));
    end
    
    % Store the changes in the change_table for this ID
    change_table_inhand_right_child = array2table(change_inhand_right_child, 'VariableNames', {'inhand_right_child'});
    change_table_inhand_left_child = array2table(change_inhand_left_child, 'VariableNames', {'inhand_left_child'});
    change_table_mouthing = array2table(change_mouthing, 'VariableNames', {'mouthing'});
    change_table_Position = array2table(change_Position, 'VariableNames', {'Position'});
    
    % Combine the original index and id with the change tables
    change_data = [subset(:, {'index', 'id'}), ...
        change_table_inhand_right_child, ...
        change_table_inhand_left_child, ...
        change_table_mouthing, ...
        change_table_Position];
    
    % Store in the results struct
    results(i).id = current_id;
    results(i).data = change_data;
end

end
