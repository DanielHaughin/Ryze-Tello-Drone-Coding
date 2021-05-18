%% set-up
clc
clear
close all
format compact

%Load pretrained detector
pretrained = load('tinyYOLOv2-coco.mat');
detector = pretrained.yolov2Detector;

%number of turns
t = 0;

%Connects to Ryze drone
drone = ryze();

%Connects to drone camera
cam = camera(drone);
subplot(1,2,1); preview(cam); title("Live Stream");

%number of pixels 25% either end of screen
%so drone movement can be determined (x-Axis)
mLeft = 960*0.25;
mRight = 960*0.75;

%% Take-off drone
takeoff(drone);
time = tic;

%% Image processing
while (toc(time) < 60) || t < 4
    
    %takepicture
    I = snapshot(cam);
    %Detect objects in the test image.
    [bboxes, scores, labels] = detect(detector, I);
    %finds matrix position of detected person
    pVec = find(labels == "person");
    
    %produce graphic and track if person detected
    if ~isempty(pVec) 
        while(1)
           
            %Visualize detection results.
            I = insertObjectAnnotation(I, 'rectangle', bboxes, labels);
            subplot(1,2,2); imshow(I); title("Detected Person");
            %determine the middle x-axis of ROI
            mid = bboxes(pVec,1) + (bboxes(pVec,3)/2);

            %determine if movement is required
            if mid < mLeft

                %turn a quarter anti-clockwise
                turn(drone, -pi/4);

            elseif mid > mRight

                %turn a quarter clockwise
                turn(drone, pi/4);

            end
        end
    end  

%turn drone to find person    
turn(drone,pi/2);
t = t + 1;

end

%% Land drone
land(drone);
