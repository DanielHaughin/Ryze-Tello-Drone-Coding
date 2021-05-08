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
%Take image
myImage = snapshot(myCam);
display(myImage);
%Land drone
land(myDrone);