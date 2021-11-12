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

%Connects to drone
drone = ryze();
%connects to camera
cam   = camera(drone);

%% Microbit Connection

%make "t" empty
t = [];
%defines serial port and baud rate
s = serialport("COM5",115200);

while (isempty(t))
    
%red serial line
t = readline(s);

end

%% Drone operation A

%responing to button "A" press
if contains(t,"A")

    %takeoff and move to desired location
    takeoff(drone);
    moveright(drone,'Distance',2,'Speed',1);
    
    %start timer
    tim = tic
    %while loop to look for text for 10 seconds or until text found
    while isempty(txt) || toc<10
    
        %takepicture
        I = snapshot(cam);
        %Identifies text using OCR
        txt = ocr(I);
    
    end
    
    %If function to compare located text
    %if true
    if contains(txt.Text,"CHECKPOINT A") || contains(txt.Text,"CHECKPOINTA")
    
        %display in command line
        disp("Drone at Checkpoint A")
        %move drone home
        moveleft(drone,'Distance',2,'Speed',1);
        land(drone);
    
    else
    
        %display in command line
        disp("Drone lost")
        land(drone);
    
    end

end

%% Drone operation B

%responding to button "B" press
if contains(t,"B")

    %takeoff and move to desired location
    takeoff(drone);
    moveright(drone,'Distance',2,'Speed',1);
    
    %start timer
    tim = tic
    %while loop to look for text for 10 seconds or until text found
    while isempty(txt) || toc<10
    
        %takepicture
        I = snapshot(cam);
        %Identifies text using OCR
        txt = ocr(I);
    
    end
    
    %if function to compare located text
    %if true
    if contains(txt.Text,"CHECKPOINT A") || contains(txt.Text,"CHECKPOINTA")
    
        %display in command line
        disp("Drone at Checkpoint A")
        %move drone home
        moveleft(drone,'Distance',2,'Speed',1);
        land(drone);
    
    else
    
        %display in command line
        disp("Drone lost")
        land(drone);
    
    end

end