% Example vector
v = data

% Normalize the vector to [0, 1]
v_norm = (v - min(v)) / (max(v) - min(v));

% Scale to [-1, 1]
v_scaled = v_norm * 2 - 1;

% Display the result
disp(v_scaled);
plot(1:50000, v_scaled)
figure
plot(1:50000 , v_norm)
v_norm2 = normalize(v, 'range', [-1, 1])
figure
plot(1:50000 , v_norm2 )
