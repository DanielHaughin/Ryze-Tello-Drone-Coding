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

%% Microbit Connection

%make "t" empty
t = [];
%defines serial port and baud rate
s = serialport("COM5",115200);

while (isempty(t))
    
%red serial line
t = readline(s);

end

%% Drone responce

%responing to button "A" press
if contains(t,"A")

    %takeoff and move to position
    takeoff(drone);
    moveright(drone);
    %pause for 2 seconds
    pause(2);
    %move home and land
    moveleft(drone);
    land(drone);

end

%responding to button "B" press
if contains(t,"B")

    %takeoff and move to position
    takeoff(drone);
    moveleft(drone);
    %pause for 2 seconds
    pause(2);
    %move home and land
    moveright(drone);
    land(drone);

end

