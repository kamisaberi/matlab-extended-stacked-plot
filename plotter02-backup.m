% [t, eeg_signal ] = generateSignal()
close all , clc , clear;
global t
[t, eeg_signal ] = generateEegSignal();


marginX = 8;
marginY = 8;
cmPanelHeight = 100;
plot_counts= 10;

plots = []
global  axes;
axes= [];

% Create Figure
fig = uifigure('Name', 'Plotter', 'Position', [300, 300, 1600, 1000]);

%Create Plot Panel at Top
axPanel = uipanel(fig);
axPanel.Position = [marginX ,cmPanelHeight, fig.Position(3)-2*marginX ,fig.Position(4)-cmPanelHeight-marginY];
axPanel.Scrollable = "off";

%Create Command Panel at Bottom
cmPannel = uipanel(fig, "BackgroundColor","white");
cmPannel.Position = [marginX, marginY, fig.Position(3)-2*marginX , cmPanelHeight-marginY ];

btnRight = uibutton(cmPannel , 'Position',[cmPannel.Position(3)-100 ,0,100,20], 'Text', ">>","ButtonPushedFcn", @(src,event) moveRightButtonPushed());

eeg_signal = eeg_signal';
% figure('units', 'normalized', 'outerposition', [0 0 1 1]);
% t = tiledlayout(3, 3, "TileSpacing", "none");

for i= 1:plot_counts
    ax = uiaxes(axPanel);
    axes = [axes , ax]
    ax.Position = [0, (i-1)*axPanel.Position(4)/plot_counts ,axPanel.Position(3) , axPanel.Position(4)/plot_counts];
    hPlot = plot(ax, t, eeg_signal(i,:), "Color","black");
    plots= [plots hPlot]  ;
    xlim(ax ,[min(t) , max(t)/3]); % Display data from t = 2 to t = 4 seconds
    ylim(ax , [-1.5, 1.5]); % Set limits to prevent dragging
    % Disable drag events on the y-axis by locking the limits
    set(gca, 'YLimMode', 'manual'); % Prevent automatic adjustment of Y limits
    set(ax, 'YLimMode', 'manual'); % Prevent automatic adjustment of Y limits
    % set(hPlot, 'YLimMode', 'manual'); % Prevent automatic adjustment of Y limits
    % ylim(ax ,[-1, 1]); % Optional: Set y-axis limits if needed
    set(gca, 'HitTest', 'off'); % Disable interaction with the axes
    set(hPlot, 'HitTest', 'off'); % Disable interaction with the plot object
    set(ax, 'HitTest', 'off'); % Disable interaction with the plot object
    set(gca, 'YColor', 'none');
    % set(hPlot, 'YColor', 'none');
    set(ax, 'YColor', 'none');
    % axis (ax , "off");

end
% plots
% axes
% plot(ax, t, eeg_signal(1,:));
% subplot( 10,1,2);
% plot(ax, t, eeg_signal(2,:));
% subplot( 10,1,3);
% plot(ax, t, eeg_signal(3,:));
% subplot( 10,1,4);
% plot(ax, t, eeg_signal(4,:));


% tg = uitabgroup(axPanel);
% tg.Position = [0 0 ax.Position(3:4)];
% t1 = uitab(tg,'Title','Tab1');
% h = stackedplot(t1,data,'k','DisplayLabels',"EEG"+(1:nch));
% set(h.AxesProperties,'YLimits',[-3 3])


% % figure;
% plot(ax, t, eeg_signal);
% title(ax,'Synthetic EEG-like Signal');
% xlabel(ax,'Time (s)');
% ylabel(ax,'Amplitude');
% grid(ax, 'on');
% % ax.Position = [fig.Position(1:2) [fig.Position(3:4) - 2*fig.Position(1:2)]]
% % fig.Position
% ax.Position = [0 0 fig.Position(3) fig.Position(4) ]
% 


function moveRightButtonPushed()
    global axes
    global t
    for ax=axes
        xlim(ax ,[min(t)+0.5 , max(t)/3+0.5]); 
        % xlim(plots(0) ,[min(t)+10 , max(t)/3 + 10]); 
    end
    drawnow;
end



