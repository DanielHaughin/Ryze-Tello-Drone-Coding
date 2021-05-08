clc
clear
close all
format compact

%Connects to Ryze drone
myDrone = ryze();
%Take-off drone
takeoff(myDrone);
%Rotates drone
turn(myDrone,2*pi);
%Land drone
land(myDrone);