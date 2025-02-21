% Example vector
v = [2, 3, 5, 7, 1];

% Normalize the vector to [0, 1]
v_norm = (v - min(v)) / (max(v) - min(v));

% Scale to [-1, 1]
v_scaled = v_norm * 2 - 1;

% Display the result
disp(v_scaled);