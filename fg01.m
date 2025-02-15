% Create a figure
hFig = uifigure('Position', [100, 100, 300, 200]);

% Create a checkbox
hCheckbox = uicontrol('Style', 'checkbox', ...
                      'String', 'Check me!', ...
                      'Position', [100, 100, 100, 30], ...
                      'Callback', @checkboxCallback);

% Callback function for the checkbox
function checkboxCallback(src, event)
    if get(src, 'Value') == 1
        disp('Checkbox is checked');
    else
        disp('Checkbox is unchecked');
    end
end
