figure('units', 'normalized', 'outerposition', [0 0 1 1]);
t = tiledlayout(3, 3, "TileSpacing", "none");
for i = 1:9
   nexttile
   plot(rand(1, 20));
end