clc
clear
close all
format compact

% Load pretrained detector
pretrained = load('tinyYOLOv2-coco.mat');
detector = pretrained.yolov2Detector;
% Read test image.
img = imread('pc.jpg');
% Detect objects in the test image.
[bboxes, scores, labels] = detect(detector, img);
%determines if person is present
person = ismember("person",labels);

%Produces graphic is person present
if person == 1
    % Visualize detection results.
    img = insertObjectAnnotation(img, 'rectangle', bboxes, labels);
    figure, imshow(img);
end

