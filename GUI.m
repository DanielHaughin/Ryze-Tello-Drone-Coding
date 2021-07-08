%% Set-Up

%Initilise
clc
clear
close all
format compact

%global
global drone
global A
global A2
global B
global B2
global detector
global cam

%specifying checkpoint text parameters
A  = "CHECKPOINTA";
A2 = "CHECKPOINT A";
B  = "CHECKPOINTB";
B2 = "CHECKPOINT B";

%Load pretrained detector
pretrained = load('tinyYOLOv2-coco.mat');
detector   = pretrained.yolov2Detector;

%Connects to Ryze drone
drone = ryze();
cam   = camera(drone);
takeoff(drone);

%Creates Figure
fig          = figure('NumberTitle','off','MenuBar','none');
fig.Name     = 'Live Stream';
fig.Position = [300 250 1000 600];
ax           = axes(fig);
frame        = snapshot(cam); 
im           = image(ax,zeros(size(frame),'uint8'));
axis(ax,'image');
preview(cam,im);

%% GUI

%Emergancy Land
ELandGUI        = uicontrol(fig,"style","pushbutton","String","Land","Position",[20 480 100 50],"FontSize",15,...
                  'backgroundcolor','#ff4d4d','Interruptible','off','callback',@Eland);
%Return Home
ReturnGUI       = uicontrol(fig,"style","pushbutton","String","Return","Position",[20 410 100 50],"FontSize",15,...
                  'backgroundcolor','#0099ff','callback',@DroneReturn);
              
%Position One
Pos1GUI       = uicontrol(fig,"style","pushbutton","String","Checkpoint A","Position",[20 360 100 50],"FontSize",15,...
                  'callback',@Pos1);

%Position Two
Pos2GUI       = uicontrol(fig,"style","pushbutton","String","Checkpoint B","Position",[20 290 100 50],"FontSize",15,...
                  'callback',@Pos2);
  
while(1)
    
%BatteryLevel GUI
% battery         =  get.BatteryLevel(drone);
battery         =  20;
BatteryLevelGUI = uicontrol(fig,"style","text","String",battery,"Position",[270 555 150 25],"FontSize",15);
%Flight Speed GUI
[speed, St]     = readSpeed(drone);
FlightSpeedGUI  = uicontrol(fig,"style","text","String",speed,"Position",[440 555 150 25],"FontSize",15);
%Current Height GUI
[height, Ht] = readHeight(drone);
HeightGUI       = uicontrol(fig,"style","text","String",height,"Position",[610 555 150 25],"FontSize",15);
              
end

%% E-Functions

%Emergancy Land
function Eland (src, event)

    global drone
    
    disp = "Emergancy Landing";
    land(drone);   
    clear drone;
    close all

end

%Drone Return
function DroneReturn (src, event)
   
    disp = "Returning Home";

end

%% Position Functions

%Position One
function Pos1
    
    global drone
    global A
    global A2
    global detector
    global cam
    
    %move drone into position
    moveleft(drone, 'Distance', 0.5, 'Speed', 1)
    %takepicture
    I = snapshot(cam);
    %Identifies text
    txt = ocr(I);
    %referencing image to pre-determined text
    x  = contains(txt.Text,A);
    x2 = contains(txt.Text,A2);
    
    %if statements to determine correct position 
    if       x == 1 || x2 == 1

           %move drone into a position to detect person   
           move(drone,[-0.5 0 -1]);
           
           %detect person
           while(1)
               
                   %takepicture
                    I = snapshot(cam);
                    % Detect objects in the test image.
                    [bboxes, scores, labels] = detect(detector, I);
                    %determines if person is present
                    person = ismember("person",labels);

                        if person == 1

                            I = insertObjectAnnotation(I, 'rectangle', bboxes, labels);
                            figure, imshow(I);
                            delete(cam)
                            break

                        end
                    pause(0.1)
               
           end
        
    end
    
end

%Position Two
function Pos2

    global drone
    global B
    global B2
    global detector
    global cam
    
    %move drone into position
    moveright(drone, 'Distance', 0.5, 'Speed', 1)
    %takepicture
    I = snapshot(cam);
    %Identifies text
    txt = ocr(I);
    %referencing image to pre-determined text
    y  = contains(txt.Text,B);
    y2 = contains(txt.Text,B2);
    
    %if statements to determine correct position 
    if       y == 1 || y2 == 1

           %move drone into a position to detect person   
           move(drone,[-0.5 0 -1]);
           
           %detect person
           while(1)
               
                   %takepicture
                    I = snapshot(cam);
                    % Detect objects in the test image.
                    [bboxes, scores, labels] = detect(detector, I);
                    %determines if person is present
                    person = ismember("person",labels);

                        if person == 1

                            I = insertObjectAnnotation(I, 'rectangle', bboxes, labels);
                            figure, imshow(I);
                            delete(cam)
                            break

                        end
                    pause(0.1)
               
           end
        
    end

end