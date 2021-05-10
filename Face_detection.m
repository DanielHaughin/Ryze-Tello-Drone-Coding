clc
clear
close all
format compact

% Create a cascade detector object.
faceDetector = vision.CascadeObjectDetector();

% Read a video frame and run the face detector.
img = imread('face.jfif');
bbox = step(faceDetector, img);

% Draw the returned bounding box around the detected face.
img = insertShape(img, 'Rectangle', bbox);
figure; imshow(img); title('Detected face');