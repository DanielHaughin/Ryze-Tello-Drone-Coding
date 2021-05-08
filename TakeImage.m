clc
clear
close all
format compact

%Connects to Ryze drone
myDrone = ryze();
%Connects to camera
myCam = camera(myDrone);
droneFig = figure();
ax = axes(droneFig);
frame = snapshot(myCam);
im = image(ax, zeros(size(frame),'uint8'));
droneFig = preview(myCam,im);
movegui(droneFig,[800 300]);
%Take-off drone
takeoff(myDrone);
%Land drone
land(myDrone);