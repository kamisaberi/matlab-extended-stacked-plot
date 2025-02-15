% [t, eeg_signal ] = generateSignal()
close all , clc , clear;
[t, eeg_signal ] = generateEegSignal();

marginX = 8;
marginY = 8;
cmPanelHeight = 100;
plot_counts= 10;

% Create Figure
fig = uifigure('Name', 'Plotter', 'Position', [300, 300, 1600, 1000]);

%Create Plot Panel at Top
axPanel = uipanel(fig);
axPanel.Position = [marginX ,cmPanelHeight, fig.Position(3)-2*marginX ,fig.Position(4)-cmPanelHeight-marginY];
axPanel.Scrollable = "on";

%Create Command Panel at Bottom
cmPannel = uipanel(fig, "BackgroundColor","white");
cmPannel.Position = [marginX, marginY, fig.Position(3)-2*marginX , cmPanelHeight-marginY ];

eeg_signal = eeg_signal'

infig = figure(axPanel);
t = tiledlayout(infig,plot_counts, 1, "TileSpacing", "none");
for i= 1:plot_counts
    ax = uiaxes(axPanel);
    ax.Position = [0, (i-1)*axPanel.Position(4)/plot_counts ,axPanel.Position(3) , axPanel.Position(4)/plot_counts];
    hPlot = plot(ax, t, eeg_signal(i,:), "Color","black");
    xlim(ax ,[min(t) , max(t)/3]); % Display data from t = 2 to t = 4 seconds
    ylim(ax , [-1.5, 1.5]); % Set limits to prevent dragging
end
