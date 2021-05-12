%% set-up
clc
clear
close all
format compact

%Connects to Ryze drone
drone = ryze();
%Connects to drone camera
cam = camera(drone);
preview(cam)
%pause to allow camera set-up
pause(5);

%variables
t = 0;

%specifying checkpoint text parameters
A  = "CHECKPOINTA";
A2 = "CHECKPOINT A";

%% Take-off drone
%take off drone
takeoff(drone);

%% Image processing for checkpoint
while t == 0

%takepicture
I = snapshot(cam);
%Identifies text
txt = ocr(I);
%referencing image to pre-determined text
x  = contains(txt.Text,A);
x2 = contains(txt.Text,A2);

%if statements to determine correct checkpoint
%move drone left if checkpoint not detected  
if       x == 1 || x2 == 1

            %Show which checkpoint & exit while loop
            t = 1;
            %Finds desired text in image
            bboxes = locateText(txt, 'CHECKPOINT', 'IgnoreCase', true);
            %Creates animation to highlight text
            Iocr = insertShape(I, 'FilledRectangle', bboxes);
            %Creates figure of image and where text is located
            figure; imshow(Iocr);

end

end
%% Land drone

%land drone
land(drone);