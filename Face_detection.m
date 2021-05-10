clc
clear
close all
format compact

% Create a cascade detector object.
faceDetector = vision.CascadeObjectDetector();

% Read an image and run the face detector.
img = imread('face.jfif');
bbox = step(faceDetector, img);

% Draw the returned bounding box around the detected face.
img = insertShape(img, 'Rectangle', bbox);

%detect features to identify face
points = detectMinEigenFeatures(rgb2gray(img), 'ROI', bbox);

% Display the detected points.
figure; imshow(img); hold on; title('Detected features');
plot(points);
