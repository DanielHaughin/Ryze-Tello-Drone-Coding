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
%Take image
frame = snapshot(myCam);
%Process facial recognition
    % Create a cascade detector object.
    faceDetector = vision.CascadeObjectDetector();

    % Run the face detector.
    bbox = step(faceDetector, frame);

    % Draw the returned bounding box around the detected face.
    frame = insertShape(frame, 'Rectangle', bbox);

    %detect features to identify face
    points = detectMinEigenFeatures(rgb2gray(frame), 'ROI', bbox);

    % Display the detected points.
    figure; imshow(frame); hold on; title('Detected features');
    plot(points);
%Land drone
land(myDrone);



