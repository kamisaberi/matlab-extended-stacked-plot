% [t, eeg_signal ] = generateSignal()
close all , clc , clear;
addpath('E:\LIBRARIES\Matlab\fieldtrip-20240916');

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
% global timeOffsetToSlide;
% timeOffsetToSlide = 0.5;


global timeInterval;
timeInterval = 1.0;
global startTimeIndex;
startTimeIndex= 1;


global axisSituation;
axisSituation = "on";
global tmax;
tmax = 100;
global fs;
fs = 500;
global timeOffestsLabels;
timeOffestsLabels= {'0.1', '0.2', '0.5', '1.0' , '1.5', '2.0', '3.0','5.0', '10.0', '20.0'};
global timeOffests;
timeOffests= [0.1, 0.2, 0.5, 1.0 , 1.5, 2.0, 3.0,5.0, 10.0,20.0];
global rects;
rects = [];
global scatters;
scatters = []; 


%% GENERATE DATA
[hdr, EEG_field, EEG_lab] = readEEG("E:\DATASETS\EEG\Sample_EEG_data\FJ002193.EEG",1,tmax );
[t, eeg_signal, artifactsIndices , channelIndices, channelNames] = generateEegSignal(tmax, fs,10,RANDOM_ARTIFACTS_PER_CHANNEL);
t = EEG_lab.times
eeg_signal = EEG_lab.data';
channelNames = EEG_field.label;
artifactsLabels= hdr.orig.logs.label;
artifactsTimes= hdr.orig.logs.time
% channelIndices = hdr.orig.logs.time 
% channelIndices = channelIndices  *500
art =hdr.orig.logs.time 
artifactsIndices  =int32( art(art <= tmax)  *500) +1
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
% comboBox.Enable = 'off';


% comboBox.Value = '1.0'
for i= 1:length(channelNames)
    checkbox= uicontrol(cmPannel, 'Style', 'checkbox', ...
                          'String', channelNames{i}, ...
                          'Position', [(i-1)*CHANNEL_CHECKBOX_WIDTH+marginX, cmPannel.Position(4)-30 , CHANNEL_CHECKBOX_WIDTH, 30], ...
                          'Value',1, ...
                          'Callback', @checkboxCallback);
    % checkbox.Enable = 'off';
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
ax = uiaxes(axPanel);
axes = [axes , ax];
ax.Position = [0, 0 ,axPanel.Position(3) , axPanel.Position(4) ];
for i= 1:PLOT_COUNT
    data= eeg_signal(i,:);
    % mnd = min(data)
    % mxd = max(data);
    data2 = normalize(data, "range", [i ,i+1])
    % plot(t(1:1000), data2(1:1000))
    % data2 = rescale(data,-1 , 1);

    hPlot = plot(ax, t, data2 , "Color",PLOT_COLOR);
    
    % hPlot.ButtonDownFcn = @(h,e) disp(e.IntersectionPoint);
    % f= @(h,e) disp(e.IntersectionPoint);
    % set(hPlot, "ButtonDownFcn",f )




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

    

    % hold(ax,"off")
    plots= [plots hPlot];
    % xlim(ax ,[min(t) , max(t)/10]); 


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

    ax.Visible = 'on';
    % set(hPlot, 'Visible', 'off');

end
xlim(ax ,[t(startTimeIndex) , t(startTimeIndex + int32(timeInterval*fs))]); 

% ylim(ax , [min(eeg_signal(i,:)), max(eeg_signal(i,:))]); 
ylim(ax , [0, PLOT_COUNT]); 

hold(ax,"off")



%% EVENTS
function moveRightButtonPushed()
    global timeInterval;
    global axes;
    global t;
    % global timeOffsetToSlide;
    global startTimeIndex;
    global fs;
    global timeInterval;
    global tmax;
    startTimeIndex = min(startTimeIndex+  int32(fs* timeInterval), (size(t,2)-int32(fs* timeInterval)) )
    for ax=axes
        xlim(ax ,[t(startTimeIndex), t(startTimeIndex + int32(timeInterval* fs))]); 
    end
    drawnow;
    
end


function moveLeftButtonPushed()
    global timeInterval;
    global axes;
    global t;
    % global timeOffsetToSlide;
    global startTimeIndex;
    global fs;
    global tmax;
    startTimeIndex = max(startTimeIndex-  int32(fs* timeInterval), 1 )
    for ax=axes
        xlim(ax ,[t(startTimeIndex), t(startTimeIndex + int32(timeInterval* fs))]); 
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
    global  checkboxes;
    global  plots;
    global  axes;
    for ind=1:length(checkboxes)
        ind
        % disp(sprintf("%s=%d", checkboxes(ind).String , checkboxes(ind).Value));
        if checkboxes(ind).Value==1
            % set(plots(ind), "Visible", "on");
            plots(ind).Visible = "on";
            axes(ind).Visible = "on";
        else 
            % set(plots(ind), "Visible", "off");
            plots(ind).Visible = "off";
            axes(ind).Visible = "off";
        end
    end
    % if get(src, 'Value') == 1
    %     disp('Checkbox is checked');
    % else
    %     disp('Checkbox is unchecked');
    % end
end

% Callback function for the combo box
function dropdownCallback(src)
    selectedOption = src.Value; % Get selected option
    global timeInterval;
    global startTimeIndex;
    global axes;
    global t;
    global fs;
    oldTimeInterval = timeInterval 
    timeInterval =str2double(selectedOption);
    offsetTimeIndex =min((oldTimeInterval-timeInterval)*int32(timeInterval*fs), 0)
    startTimeIndex= max(startTimeIndex + offsetTimeIndex , 1)
    for ax = axes
        xlim(ax ,[t(startTimeIndex ), t(startTimeIndex + int32(timeInterval*fs))]); 
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
