clc
clear
close all
format compact

% Load pretrained detector
pretrained = load('tinyYOLOv2-coco.mat');
detector = pretrained.yolov2Detector;
% Read test image.
img = imread('people.jpg');

% Detect objects in the test image.
[bboxes, scores, labels] = detect(detector, img)

if labels == "person"
% Visualize detection results.
img = insertObjectAnnotation(img, 'rectangle', bboxes, labels);
figure, imshow(img)
end