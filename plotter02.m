% [t, eeg_signal ] = generateSignal()
close all , clc , clear;

%% UI CONFIGURATIONS
marginX = 8;
marginY = 8;
cmPanelHeight = 100;
PLOT_COUNT= 21;
PLOT_COLOR = "black";
RANDOM_ARTIFACTS_PER_CHANNEL =0 ;
RECTANGLE_WIDTH= 0.006;
MAIN_WINDOW_HEIGHT= 0;
CHANNEL_CHECKBOX_WIDTH= 40; 

%% GLOBAL VARIABLES
global plots;
plots = [];
global  axes;
axes= [];
global  checkboxes;
checkboxes= [];

global t;
global timeOffsetToSlide
timeOffsetToSlide = 0.5;
global timeToDisplay;
timeToDisplay = 1.0;
global offsetCount;
offsetCount= 0;
global axisSituation;
axisSituation = "on";
global tmax;
tmax = 20;
global fs;
fs = 500;
global timeOffestsLabels;
timeOffestsLabels= {'0.1', '0.2', '0.5', '1.0' , '1.5', '2.0', '3.0','5.0', '10.0'};
global timeOffests;
timeOffests= [0.1, 0.2, 0.5, 1.0 , 1.5, 2.0, 3.0,5.0, 10.0];
global rects;
rects = [];
global scatters;
scatters = [];


%% GENERATE DATA
[t, eeg_signal, artifactsIndices , channelIndices, channelNames] = generateEegSignal(tmax, fs,10,RANDOM_ARTIFACTS_PER_CHANNEL);
% return

%% CREATE UI

%Calculate Window Height
Pix_SS = get(0,'screensize');
MAIN_WINDOW_HEIGHT = Pix_SS(1,4)-200 ;


% Create Figure
fig = uifigure('Name', 'Plotter', 'Position', [300, 100, 1000, MAIN_WINDOW_HEIGHT]);

%Create Plot Panel at Top
axPanel = uipanel(fig);
axPanel.Position = [marginX ,cmPanelHeight, fig.Position(3)-2*marginX ,fig.Position(4)-cmPanelHeight-marginY];
axPanel.Scrollable = "off";

%Create Command Panel at Bottom
cmPannel = uipanel(fig, "BackgroundColor","white");
cmPannel.Position = [marginX, marginY, fig.Position(3)-2*marginX , cmPanelHeight-marginY ];

%Create Buttons
btnLeft= uibutton(cmPannel , 'Position',[0,0,30,30], 'Text', "<<","ButtonPushedFcn", @(src,event) moveLeftButtonPushed());
btnRight = uibutton(cmPannel , 'Position',[32 ,0,30,30], 'Text', ">>","ButtonPushedFcn", @(src,event) moveRightButtonPushed());
btnAxisToggle= uibutton(cmPannel , 'Position',[0,30+ marginY,100,20], 'Text', "axis on/off","ButtonPushedFcn", @(src,event) toggleAxisButtonPushed());

comboBox = uidropdown(cmPannel , ...
                      'Items', timeOffestsLabels, ...
                      'Position', [64, 0, 100, 30], ...
                      'Value','1.0', ...
                      'ValueChangedFcn', @(src, event) dropdownCallback(src));
comboBox.Enable = 'off'


% comboBox.Value = '1.0'
for i= 1:length(channelNames)
    checkbox= uicontrol(cmPannel, 'Style', 'checkbox', ...
                          'String', channelNames{i}, ...
                          'Position', [(i-1)*CHANNEL_CHECKBOX_WIDTH+marginX, cmPannel.Position(4)-30 , CHANNEL_CHECKBOX_WIDTH, 30], ...
                          'Value',1, ...
                          'Callback', @checkboxCallback);
    checkbox.Enable = 'off'
    checkboxes=[checkboxes , checkbox]
end

chkDisplyArtifactRects= uicontrol(cmPannel, 'Style', 'checkbox', ...
                      'String', 'Disply Rects', ...
                      'Position', [168 , 0 , 100, 30], ...
                      'Value',1, ...
                      'Callback', @toggleRects);

chkDisplyArtifactScatter= uicontrol(cmPannel, 'Style', 'checkbox', ...
                      'String', 'Disply Red Dots', ...
                      'Position', [268 , 0 , 100, 30], ...
                      'Value',1, ...
                      'Callback', @toggleScatter);


% % Create a checkbox
% hCheckbox = uicontrol(cmPannel, 'Style', 'checkbox', ...
%                       'String', 'Check me!', ...
%                       'Position', [500, 50, 100, 30], ...
%                       'Callback', @checkboxCallback);




% rectplot = @(ax,x1,x2,y1,y2) rectangle(ax,'Position',[x1 y1 (x2-x1) y2]);
eeg_signal = eeg_signal';
for i= 1:PLOT_COUNT
    ax = uiaxes(axPanel);
    
    axes = [axes , ax];
    ax.Position = [0, (i-1)*axPanel.Position(4)/PLOT_COUNT ,axPanel.Position(3) , axPanel.Position(4)/PLOT_COUNT ];
    hPlot = plot(ax, t, eeg_signal(i,:), "Color",PLOT_COLOR);
    
    % ax.Visible = 'off';
    % set(hPlot, 'Visible', 'off');
    % set(ax, 'Visible', 'off');
    

    
    ylabel(ax , channelNames(i));
    hold(ax,"on")
    if size(artifactsIndices, 1) == 1 
        sct = scatter(ax,t(artifactsIndices), eeg_signal(i, artifactsIndices),"filled");
        scatters =[scatters  , sct]
        % plot(ax,t(indices), eeg_signal(i, indices), "^");
    else
        scatter(ax,t(artifactsIndices(i,:)), eeg_signal(i, artifactsIndices(i,:)),"filled");
        % plot(ax,t(indices(i,:)), eeg_signal(i, indices(i,:)),"^");
    end

    if size(artifactsIndices , 1) ==1
        mn = min(eeg_signal(i, artifactsIndices));
        for index= artifactsIndices
            r = rectangle(ax,'Position',[t(index)-RECTANGLE_WIDTH/2 mn-5 (RECTANGLE_WIDTH) 100]);
            r.FaceColor = [0 0.5 0.5];
            r.EdgeColor = "none";
            r.LineWidth = 0.001;
            alpha(r,.3);
            rects = [rects  , r];
        end

    else

        integratedArtifactsIndices = reshape(artifactsIndices', 1, []);
        % integratedArtifactsIndices = artifactsIndices(:)
        mn = min(eeg_signal(i, integratedArtifactsIndices));
        for index= integratedArtifactsIndices
            r = rectangle(ax,'Position',[t(index)-RECTANGLE_WIDTH/2 mn-5 (RECTANGLE_WIDTH) 100]);
            r.FaceColor = [0 0.5 0.5];
            r.EdgeColor = "none";
            r.LineWidth = 0.001;
            alpha(r,.3);
            rects = [rects  , r];
        end
    end

    

    hold(ax,"off")
    plots= [plots hPlot];
    % xlim(ax ,[min(t) , max(t)/10]); 
    xlim(ax ,[min(t) , t(timeToDisplay*fs)]); 
    ylim(ax , [min(eeg_signal(i,:)), max(eeg_signal(i,:))]); 


    set(gca, 'YLimMode', 'manual'); 
    set(ax, 'YLimMode', 'manual'); 
    % set(hPlot, 'YLimMode', 'manual'); 
    % set(gca, 'HitTest', 'off'); 
    % set(hPlot, 'HitTest', 'off');
    % set(ax, 'HitTest', 'off'); 
    set(gca, 'YColor', 'none');
    % set(hPlot, 'YColor', 'none');
    
    % set(ax, 'YColor', 'none');

    axis (ax , axisSituation);

    % ax.Visible = 'off';
    % set(hPlot, 'Visible', 'off');

end

%% EVENTS
function moveRightButtonPushed()
    global timeToDisplay;
    global axes;
    global t;
    global timeOffsetToSlide;
    global offsetCount;
    global fs;
    global timeToDisplay;
    global tmax;
    % offsetCount=offsetCount+1;
    % min(t)
    % max(t)
    offsetCount=min(int32( tmax/timeToDisplay),offsetCount+1);
    mnInd=int32( timeToDisplay*(offsetCount)*fs)+1;
    mxInd=int32(timeToDisplay*(offsetCount+1)*fs)+1;

    for ax=axes
        % xlim(ax ,[min(t) , t(timeToDisplay*fs)]); 
        xlim(ax ,[t(mnInd), t(mxInd)]); 
        % xlim(ax ,[min(t)+(offsetCount*timeOffsetToSlide), max(t)/10+(offsetCount*timeOffsetToSlide)]); 
    end
    drawnow;
    
end


function moveLeftButtonPushed()
    global timeToDisplay;
    global axes;
    global t;
    global timeOffsetToSlide;
    global offsetCount;
    global fs;
    offsetCount=max(0,offsetCount-1);
    % min(t)
    % max(t)
    mnInd= int32( timeToDisplay*(offsetCount)*fs)+1
    mxInd= int32(timeToDisplay*(offsetCount+1)*fs)+1
    for ax=axes
        xlim(ax ,[t(mnInd), t(mxInd)]); 
        % 
        % xlim(ax ,[min(t)+(offsetCount*timeOffsetToSlide), max(t)/10+(offsetCount*timeOffsetToSlide)]); 
    end
    drawnow;
    
end

function toggleAxisButtonPushed()
    global axes;
    global axisSituation;
    if axisSituation == "on"
        axisSituation ="off";
    else
        axisSituation ="on";
    end
    for ax=axes
        axis (ax , axisSituation );
    end
    drawnow;
end

% Callback function for the checkbox
function checkboxCallback(src, event)
    if get(src, 'Value') == 1
        disp('Checkbox is checked');
    else
        disp('Checkbox is unchecked');
    end
end

% Callback function for the combo box
function dropdownCallback(src)
    selectedOption = src.Value; % Get selected option
    global timeToDisplay;
    global axes;
    global t;
    global fs;
    timeToDisplay =str2double(selectedOption)
    % disp(['Selected: ', selectedOption]);
    for ax = axes
        xlim(ax ,[min(t) , t(timeToDisplay*fs)]); 
    end
    drawnow
end


% Callback function for the checkbox
function toggleRects(src, event)
    global rects
    if get(src, 'Value') == 1
        for rect = rects 
            alpha(rect , 0.3)
        end
    else
        for rect = rects 
            alpha(rect , 0.0)
        end
    end
end

% Callback function for the checkbox
function toggleScatter(src, event)
    global scatters
    if get(src, 'Value') == 1
        for sct = scatters 
            set(sct, 'Visible', 'on');
        end
    else
        for sct =scatters 
            set(sct, 'Visible', 'off');
        end
    end
end
