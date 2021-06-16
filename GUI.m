%% Set-Up

%Initilise
clc
clear
close all
format compact

%global
global drone

%Load pretrained detector
pretrained = load('tinyYOLOv2-coco.mat');
detector = pretrained.yolov2Detector;

%Connects to Ryze drone
drone = ryze();
cam = camera(drone);
takeoff(drone);

%Creates Figure
fig = figure('NumberTitle','off','MenuBar','none');
fig.Name = 'Live Stream';
fig.Position = [300 250 1000 600];
ax = axes(fig);
frame = snapshot(cam); 
im = image(ax,zeros(size(frame),'uint8'));
axis(ax,'image');
preview(cam,im);

%% GUI

%BatteryLevel GUI
% BatLev          = ryze.BatteryLevel()
BatteryLevel    = "Battery 80%";
BatteryLevelGUI = uicontrol(fig,"style","text","String",BatteryLevel,"Position",[270 535 150 25],"FontSize",15);
%Flight Speed GUI
FlightSpeed     = "Speed 20m/s";
FlightSpeedGUI  = uicontrol(fig,"style","text","String",FlightSpeed,"Position",[440 535 150 25],"FontSize",15);
%Current Height GUI
Height          = "Height 1m";
HeightGUI       = uicontrol(fig,"style","text","String",Height,"Position",[610 535 150 25],"FontSize",15);
%Emergancy Land
ELandGUI        = uicontrol(fig,"style","pushbutton","String","Land","Position",[20 480 100 50],"FontSize",15,...
                  'backgroundcolor','#ff4d4d','Interruptible','off','callback',@Eland);
%Return Home
ReturnGUI       = uicontrol(fig,"style","pushbutton","String","Return","Position",[20 410 100 50],"FontSize",15,...
                  'backgroundcolor','#0099ff','callback',@DroneReturn);

%% Functions

%Emergancy Land
function Eland (src, event)

    global drone
    
    land(drone);
    display = "Emergancy Landing"

end

%Drone Return
function DroneReturn (src, event)
   
    display = "Returning Home"

end
