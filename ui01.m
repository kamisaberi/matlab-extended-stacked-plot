function myApp
    % Create a figure
    fig = uifigure('Position', [100, 100, 300, 200]);

    % Create a push button
    btn = uibutton(fig, ...
                   'Text', 'Click Me', ...
                   'Position', [100, 80, 100, 40]);

    % Set the ButtonDownFcn for mouse down events
    btn.ButtonPushedFcn = @(src, event) mouseDownCallback(src);
end

function mouseDownCallback(btn)
    % Change the button's background color on mouse down
    btn.BackgroundColor = [0.7, 0.7, 0.7]; % Change to darker color
    disp('Mouse button pressed down on the button!');
    
    % Optional: Reset color on mouse release
    btn.ButtonDownFcn = @(src, event) resetButtonColor(src);
end

function resetButtonColor(btn)
    % Reset the button's background color
    btn.BackgroundColor = [0.94, 0.94, 0.94]; % Default color
    disp('Mouse button released from the button!');
end
