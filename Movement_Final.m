%% Initialisation
%clear command line
clc
%clear variables
clear
%close all figures
close all
%format command line
format compact

%% Drone Connection

%Connect to drone as obj "drone"
drone = ryze();

%% Drone Operations
%takeoff
takeoff(drone);
%moveup 2m at 1m/s
moveup(drone,'speed',1,'Distance',2);
%moveleft 2m at 1m/s
moveleft(drone,'speed',1,'Distance',2);
%moveback 2m at 1m/s
moveback(drone,'speed',1,'Distance',2);
%moveright 2m at 1m/s
moveright(drone,'speed',1,'Distance',2);
%moveforward 2m at 1m/s
moveforward(drone,'speed',1,'Distance',2);
%movedown 2m at 1m/s
movedown(drone,'speed',1,'Distance',2);
%land
land(drone);
