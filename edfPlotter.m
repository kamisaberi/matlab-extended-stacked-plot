% [t, eeg_signal ] = generateSignal()
close all , clc , clear;
eeg_data = edfread("aaaaaanr_s001_t001.edf")

%% UI CONFIGURATIONS
marginX = 8;
marginY = 8;
cmPanelHeight = 100;
% PLOT_COUNT= 29;

global PLOT_COLOR ;
PLOT_COLOR = "black";
global RANDOM_ARTIFACTS_PER_CHANNEL;
RANDOM_ARTIFACTS_PER_CHANNEL =0; 
global RECTANGLE_WIDTH;
RECTANGLE_WIDTH= 0.006;
global MAIN_WINDOW_HEIGHT;
MAIN_WINDOW_HEIGHT= 0;
global MAIN_WINDOW_WIDTH;
MAIN_WINDOW_WIDTH = 0;
global CHANNEL_CHECKBOX_WIDTH;
CHANNEL_CHECKBOX_WIDTH= 40;

global PLOTS_GAP_BETWEEN;
PLOTS_GAP_BETWEEN= 0.2;
global PLOTS_HEIGHT;
PLOTS_HEIGHT= 1.0;
global PLOTS_TOP_PADDING;
PLOTS_TOP_PADDING = 0.5;
global PLOTS_BOTTOM_PADDING ;
PLOTS_BOTTOM_PADDING = 0.5;


%% GLOBAL VARIABLES
global plots;
plots = [];
global  axes;
axes= [];
global  ax;
ax = 0;
global  checkboxes;
checkboxes= [];
global t;
% global timeOffsetToSlide;
% timeOffsetToSlide = 0.5;


global timeInterval;
timeInterval = 10.0;

global timeOffset;
timeOffset= 0.5;



global startTimeIndex;
startTimeIndex= 1;



global axisSituation;
axisSituation = "on";
global tmax;
tmax = size(eeg_data, 2)/500;
global fs;
fs = 500;
global timeOffestsLabels;
timeOffestsLabels= {'0.1', '0.2', '0.5', '1.0' , '1.5', '2.0', '3.0','5.0', '10.0', '20.0', '50.0', '100.0', '200.0'};
global timeOffests;
timeOffests= [0.1, 0.2, 0.5, 1.0 , 1.5, 2.0, 3.0,5.0, 10.0,20.0 , 50.0 , 100.0, 200.0];
global rects;
rects = [];
global scatters;
scatters = [];
global channelsToDisply;
channelsToDisply= 1:29;
% channelsToDisply= [1,3,5,7,9];
global t
t = [];
global eeg_signal
eeg_signal = [];
global channelNames;
channelNames = [];


%% GENERATE DATA
% [hdr, EEG_field, EEG_lab] = readEEG("E:\DATASETS\EEG\Sample_EEG_data\FJ002193.EEG",1,tmax );
% [t, eeg_signal, artifactsIndices , channelIndices, channelNames] = generateEegSignal(tmax, fs,10,RANDOM_ARTIFACTS_PER_CHANNEL);
nch = 29;
channelIndices = 1:nch;
channelNames = {'Fp1','Fp2','F7','F3','Fz','F4','F8','T3','C3','Cz','C4','T4','T5','P3','Pz','P4','T6','O1','Oz','O2','A1','P3','Pz','P4','T6','O1','Oz','O2','A1' };
nt = fs*tmax;
t = (0:nt-1)/fs;

%% CREATE UI

%Calculate Window Height
Pix_SS = get(0,'screensize');
MAIN_WINDOW_HEIGHT = Pix_SS(1,4)-200 ;
MAIN_WINDOW_WIDTH= Pix_SS(1,3)-400;


% Create Figure
fig = uifigure('Name', 'Plotter', 'Position', [300, 100, MAIN_WINDOW_WIDTH, MAIN_WINDOW_HEIGHT]);

%Create Plot Panel at Top
axPanel = uipanel(fig);
axPanel.Position = [marginX ,cmPanelHeight, fig.Position(3)-2*marginX ,fig.Position(4)-cmPanelHeight-marginY];
axPanel.Scrollable = "off";


%Create Command Panel at Bottom
cmPannel = uipanel(fig, "BackgroundColor","white");
cmPannel.Position = [marginX, marginY, fig.Position(3)-2*marginX , cmPanelHeight-marginY ];

%Create Buttons
btnLeft= uibutton(cmPannel , 'Position',[0,0,30,30], 'Text', "<<","ButtonPushedFcn", @(src,event) moveLeftButtonPushed(src));
btnRight = uibutton(cmPannel , 'Position',[32 ,0,30,30], 'Text', ">>","ButtonPushedFcn", @(src,event) moveRightButtonPushed(src));
btnAxisToggle= uibutton(cmPannel , 'Position',[0,30+ marginY,100,20], 'Text', "axis on/off","ButtonPushedFcn", @(src,event) toggleAxisButtonPushed());
% btnTestRedraw= uibutton(cmPannel , 'Position',[120,30+ marginY,100,20], 'Text', "add channel","ButtonPushedFcn", @(src,event) TestRedraw());

drpTimeInterval = uidropdown(cmPannel , ...
    'Items', timeOffestsLabels, ...
    'Position', [64, 0, 100, 30], ...
    'Value','10.0', ...
    'ValueChangedFcn', @(src, event) changetimeInterval(src));

drpSlideTime= uidropdown(cmPannel , ...
    'Items', timeOffestsLabels, ...
    'Position', [400, 0, 100, 30], ...
    'Value','0.5', ...
    'ValueChangedFcn', @(src, event) changetimeOffset(src));

drpChangeType= uidropdown(cmPannel , ...
    'Items', {'time','index'}, ...
    'Position', [530, 0, 70, 30], ...
    'Value','time', ...
    'ValueChangedFcn', @(src, event) changetimeOffset(src));

txtTimeIndex= uieditfield(cmPannel, 'text', 'Position', [600 0 50 30]);
btnChangeTimeIndex= uibutton(cmPannel , 'Position',[650,0,30,30], 'Text', "GO","ButtonPushedFcn", @(src,event) changeTimeIndex(drpChangeType, txtTimeIndex));


% drpTimeInterval.Enable = 'off';


% drpTimeInterval.Value = '1.0'
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
    'String', 'Bars', ...
    'Position', [168 , 0 , 100, 30], ...
    'Value',1, ...
    'Callback', @toggleRects);

chkDisplyArtifactScatter= uicontrol(cmPannel, 'Style', 'checkbox', ...
    'String', 'Dots', ...
    'Position', [268 , 0 , 100, 30], ...
    'Value',0, ...
    'Callback', @toggleScatter);


% % Create a checkbox
% hCheckbox = uicontrol(cmPannel, 'Style', 'checkbox', ...
%                       'String', 'Check me!', ...
%                       'Position', [500, 50, 100, 30], ...
%                       'Callback', @checkboxCallback);




% rectplot = @(ax,x1,x2,y1,y2) rectangle(ax,'Position',[x1 y1 (x2-x1) y2]);
% eeg_signal = eeg_signal';
eeg_signal  = eeg_data;
ax = uiaxes(axPanel);
axes = [axes , ax];
ax.Position = [0, 0 ,axPanel.Position(3) , axPanel.Position(4) ];

plotData(t,eeg_signal, channelsToDisply, channelNames);


%% EVENTS
function moveRightButtonPushed(src)
global timeInterval;
global axes;
global t;
% global timeOffsetToSlide;
global startTimeIndex;
global fs;
global timeInterval;
global timeOffset;
global tmax;

src.UserData
startTimeIndex = min(startTimeIndex+  int32(fs* timeOffset), (size(t,2)-int32(fs* timeOffset)) )
for ax=axes
    xlim(ax ,[t(startTimeIndex), t(startTimeIndex + int32(timeInterval* fs))]);
end
drawnow;

end


function moveLeftButtonPushed(src)
global timeInterval;
global axes;
global t;
% global timeOffsetToSlide;
global startTimeIndex;
global timeOffset;

global fs;
global tmax;

startTimeIndex = max(startTimeIndex-  int32(fs* timeOffset), 1 )
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

function TestRedraw()
    global PLOT_COLOR ;
    global RANDOM_ARTIFACTS_PER_CHANNEL;
    global RECTANGLE_WIDTH;
    global MAIN_WINDOW_HEIGHT;
    global MAIN_WINDOW_WIDTH;
    global CHANNEL_CHECKBOX_WIDTH;
    global PLOTS_GAP_BETWEEN;
    global PLOTS_HEIGHT;
    global PLOTS_TOP_PADDING;
    global PLOTS_BOTTOM_PADDING ;
    global ax;
    global plots;
    global axisSituation;
    global tmax;
    global fs;
    global timeOffestsLabels;
    global timeOffests;
    global rects;
    global scatters;
    global channelsToDisply;
    global startTimeIndex;
    global timeInterval;
    global timeOffset;
    global t
    global eeg_signal
    global channelNames;

    channelsToDisply = [channelsToDisply  , 11]
    plotData(t,eeg_signal, channelsToDisply, channelNames);
    drawnow;
end

function changeTimeIndex(drpChangeType, txtTimeIndex)

    global PLOT_COLOR ;
    global RANDOM_ARTIFACTS_PER_CHANNEL;
    global RECTANGLE_WIDTH;
    global MAIN_WINDOW_HEIGHT;
    global MAIN_WINDOW_WIDTH;
    global CHANNEL_CHECKBOX_WIDTH;
    global PLOTS_GAP_BETWEEN;
    global PLOTS_HEIGHT;
    global PLOTS_TOP_PADDING;
    global PLOTS_BOTTOM_PADDING ;
    global ax;
    global plots;
    global axisSituation;
    global tmax;
    global fs;
    global timeOffestsLabels;
    global timeOffests;
    global rects;
    global scatters;
    global channelsToDisply;
    global startTimeIndex;
    global timeInterval;
    global timeOffset;
    global t
    global eeg_signal
    global channelNames;

    disp(txtTimeIndex.Value)
    disp(drpChangeType.Value)
    if strcmp(drpChangeType.Value ,'index' ) == 1 
    startTimeIndex = int32(str2double(txtTimeIndex.Value))
    else 
        startTimeIndex = int32(str2double(txtTimeIndex.Value)*fs);
    end
    plotData(t,eeg_signal, channelsToDisply, channelNames);
    drawnow

end


% Callback function for the checkbox
function checkboxCallback(src, event)
    global  checkboxes;
    global  plots;
    global  axes;

    global channelsToDisply;
    global startTimeIndex;
    global timeInterval;
    global timeOffset;
    global t
    global eeg_signal
    global channelNames;

    channelsToDisply= []
    for ind=1:length(checkboxes)
        ind
        % disp(sprintf("%s=%d", checkboxes(ind).String , checkboxes(ind).Value));
        if checkboxes(ind).Value==1
            % set(plots(ind), "Visible", "on");
            % plots(ind).Visible = "on";
            % axes(ind).Visible = "on";
            channelsToDisply = [channelsToDisply  , ind]
        % else
        %     % set(plots(ind), "Visible", "off");
        %     plots(ind).Visible = "off";
        %     axes(ind).Visible = "off";
        end
    end

    channelsToDisply = [channelsToDisply  , 11]
    plotData(t,eeg_signal, channelsToDisply, channelNames);
    % if get(src, 'Value') == 1
    %     disp('Checkbox is checked');
    % else
    %     disp('Checkbox is unchecked');
    % end
end

% Callback function for the combo box
function changetimeInterval(src)
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

function changetimeOffset(src)
selectedOption = src.Value; % Get selected option
global timeOffset;
timeOffset = str2double(selectedOption);
end


% Callback function for the checkbox
function toggleRects(src, event)
global rects
if get(src, 'Value') == 1
    for rect = rects
        alpha(rect , 0.01)
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


function [] = plotData(t, eeg_signal, channelsToDisply,channelNames)

    global PLOT_COLOR ;
    global RANDOM_ARTIFACTS_PER_CHANNEL;
    global RECTANGLE_WIDTH;
    global MAIN_WINDOW_HEIGHT;
    global MAIN_WINDOW_WIDTH;
    global CHANNEL_CHECKBOX_WIDTH;
    global PLOTS_GAP_BETWEEN;
    global PLOTS_HEIGHT;
    global PLOTS_TOP_PADDING;
    global PLOTS_BOTTOM_PADDING ;
    global ax;
    global plots;
    global axisSituation;
    global tmax;
    global fs;
    global timeOffestsLabels;
    global timeOffests;
    global rects;
    global scatters;
    global startTimeIndex;
    global timeInterval;
    global timeOffset;


    channelsCount = size(channelsToDisply,2)
    for i=1:length(channelsToDisply)
        data= eeg_signal(channelsToDisply(i),:);
        data2 = normalize(data, "range", [PLOTS_BOTTOM_PADDING+(i-1)+PLOTS_GAP_BETWEEN*(i-1) ,PLOTS_BOTTOM_PADDING+(i-1)+PLOTS_HEIGHT+PLOTS_GAP_BETWEEN*(i-1)]);
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
        % if size(artifactsIndices, 1) == 1
        %     sct = scatter(ax,t(artifactsIndices), data2(artifactsIndices),"filled");
        %     set(sct, 'Visible', 'off');
        %     scatters =[scatters  , sct]
        %     % plot(ax,t(indices), eeg_signal(i, indices), "^");
        % else
        %     sct = scatter(ax,t(artifactsIndices(i,:)), data2(artifactsIndices(i,:)),"filled");
        %     set(sct, 'Visible', 'off');
        %     % plot(ax,t(indices(i,:)), eeg_signal(i, indices(i,:)),"^");
        % end
        %
        % if size(artifactsIndices , 1) ==1
        %     mn = min(eeg_signal(i, artifactsIndices));
        %     for index= 1:length(artifactsIndices)
        %         rw = ((RECTANGLE_WIDTH)*timeInterval);
        %         r = rectangle(ax,'Position',[t(artifactsIndices(index))-rw/2 mn-5 rw 100]);
        %         r.FaceColor = "RED";
        %         r.EdgeColor = "none";
        %         r.LineWidth = 0.001;
        %         alpha(r,.01);
        %         y = PLOTS_BOTTOM_PADDING+PLOT_COUNT*PLOTS_HEIGHT+(PLOT_COUNT*PLOTS_GAP_BETWEEN)+PLOTS_TOP_PADDING - 1;
        %         t1 = text(ax , t(artifactsIndices(index))-rw/2 ,y , artifactsLabels{index});
        %         t1.FontSize = 14;
        %         rects = [rects  , r];
        %     end
        %
        % else
        %
        %     integratedArtifactsIndices = reshape(artifactsIndices', 1, []);
        %     % integratedArtifactsIndices = artifactsIndices(:)
        %     mn = min(eeg_signal(i, integratedArtifactsIndices));
        %     for index= integratedArtifactsIndices
        %         rw = ((RECTANGLE_WIDTH)*timeInterval);
        %         r = rectangle(ax,'Position',[t(index)-rw/2 mn-5 rw 100]);
        %         r.FaceColor = [0 0.5 0.5];
        %         r.EdgeColor = "none";
        %         r.LineWidth = 0.001;
        %         alpha(r,.01);
        %         rects = [rects  , r];
        %     end
        % end
    
    
    
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
    
    ylim(ax , [0, PLOTS_BOTTOM_PADDING+channelsCount*PLOTS_HEIGHT+(channelsCount *PLOTS_GAP_BETWEEN)+PLOTS_TOP_PADDING]);
    
    hold(ax,"off")


end
