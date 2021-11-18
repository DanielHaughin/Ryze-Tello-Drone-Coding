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

    %display in command line
    disp("Moving to Checkpoint A");
    %takeoff and move to desired location
    takeoff(drone);
    moveright(drone,'Distance',2,'Speed',1);
    
    %start timer
    tim = tic;
    %while loop to look for text for 10 seconds or until text found
    while toc(tim) <= 10
    
        %takepicture
        I = snapshot(cam);
        %Identifies text using OCR
        txt = ocr(I);
        %comapre located text against expected values
        a = contains(txt.Text,"CHECKPOINT A");
        a2 = contains(txt.Text,"CHECKPOINTA");

        %determine if correct text has been located
        if a == 1 || a2 == 1

            %break out of while loop
            break

        end   
    end
    
    %If function to determine next operation
    if a == 1 || a2 == 1
    
        %display in command line
        disp("Drone at Checkpoint A")
        %move drone home
        moveleft(drone,'Distance',2,'Speed',1);
        %land drone
        land(drone);
    
    else
    
        %display in command line
        disp("Drone lost")
        %land drone
        land(drone);
    
    end

end

%% Drone operation B

%responding to button "B" press
if contains(t,"B")

    %display in command line
    disp("Moving to Checkpoint B");
    %takeoff and move to desired location
    takeoff(drone);
    moveright(drone,'Distance',2,'Speed',1);
    
    %start timer
    tim = tic;
    %while loop to look for text for 10 seconds or until text found
    while toc(tim) <= 10
    
        %takepicture
        I = snapshot(cam);
        %Identifies text using OCR
        txt = ocr(I);
        %comapre located text against expected values
        a = contains(txt.Text,"CHECKPOINT B");
        a2 = contains(txt.Text,"CHECKPOINTB");

        %If function to determine next operation
        if b == 1 || b2 == 1

            %break out of while loop
            break

        end   
    end
    
    %if function to determine next operation
    if b == 1 || b2 == 1
    
        %display in command line
        disp("Drone at Checkpoint A")
        %move drone home
        moveleft(drone,'Distance',2,'Speed',1);
        %land drone
        land(drone);
    
    else
    
        %display in command line
        disp("Drone lost")
        %land drone
        land(drone);
    
    end

end