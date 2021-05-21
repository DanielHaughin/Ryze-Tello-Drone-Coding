clc
clear
close all
format compact

%Load pretrained detector
pretrained = load('tinyYOLOv2-coco.mat');
detector = pretrained.yolov2Detector;

%Connects to camera
cam = webcam('Microsoft Camera Front');
%Creates Figure
fig = figure('NumberTitle','off','MenuBar','none');
fig.Name = 'Live Stream';
fig.Position = [50 50 1000 500]
ax = axes(fig)
frame = snapshot(cam); 
im = image(ax,zeros(size(frame),'uint8')); 
axis(ax,'image');
preview(cam,im)

%BatteryLevel GUI
BatteryLevel = "Battery 80%"
BatteryLevelGUI = uicontrol(fig,"style","text","String",BatteryLevel,"Position",[30 400 100 50],"FontSize",15); 
%Flight Speed GUI
FlightSpeed = "Speed 20m/s"
FlightSpeedGUI = uicontrol(fig,"style","text","String",FlightSpeed,"Position",[30 300 100 50],"FontSize",15);
%Current Height GUI
Height = "Height 4m"
HeightGUI = uicontrol(fig,"style","text","String",Height,"Position",[30 200 100 50],"FontSize",15); 

