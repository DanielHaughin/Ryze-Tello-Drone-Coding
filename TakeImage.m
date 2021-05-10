clc
clear
close all
format compact

%Connects to Ryze drone
myDrone = ryze();
%Connects to camera
myCam = camera(myDrone);
%Take-off drone
takeoff(myDrone);
%display live feed
preview(myCam);
%Take and display image
frame = snapshot(myCam);
imshow(frame);
%Land drone
land(myDrone);
