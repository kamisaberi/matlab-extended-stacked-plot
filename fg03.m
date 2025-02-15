% Create a uifigure
fig = uifigure('Position', [100, 100, 300, 200]);

% Create a combo box
comboBox = uidropdown(fig, ...
                      'Items', {'Option 1', 'Option 2', 'Option 3'}, ...
                      'Position', [50, 100, 200, 30], ...
                      'ValueChangedFcn', @(src, event) dropdownCallback(src));

% Callback function for the combo box
function dropdownCallback(src)
    selectedOption = src.Value; % Get selected option
    disp(['Selected: ', selectedOption]);
end
