%% set-up
clc
clear
close all
format compact

%Load pretrained detector
pretrained = load('tinyYOLOv2-coco.mat');
detector = pretrained.yolov2Detector;

%Connects to Ryze drone
drone = ryze();
%Connects to drone camera
cam = camera(drone);
preview(cam)
%pause to allow camera set-up
pause(1);

%% Take-off drone
%take off drone
takeoff(drone);

%% Image processing for checkpoint
while (1)    
    %takepicture
    I = snapshot(cam);
    % Detect objects in the test image.
    [bboxes, scores, labels] = detect(detector, I);
    %determines if person is present
    person = ismember("person",labels);
    
    if person == 1
       
        %Visualize detection results.
        I = insertObjectAnnotation(I, 'rectangle', bboxes, labels);
        figure, imshow(I);
        break
        
    end

turn(drone,pi/2);

end
%% Land drone
%land drone
land(drone);