clc
clear
close all
format compact

addpath 'C:\Users\dejha\Desktop\BEng Honours Degree\Dissertation\Code'

%Load pretrained detector
pretrained = load('tinyYOLOv2-coco.mat');
detector   = pretrained.yolov2Detector;

% Read an image and run the face detector.
oimg = imread('2.jpg');

% Detect objects in the test image.
[bboxes, scores, labels] = detect(detector, oimg);

%Visualize detection results.
img = imcrop(oimg, bboxes);
imgray = rgb2gray(img);

im = edge(imgray, 'prewitt');

imgray = imtophat(imgray,strel('disk',100));

bw = imbinarize(imgray);
bw2 = bwareaopen(bw,5);

imshow(bw2);
imshow(imgray);

results = evaluateOCRTraining(imgray);

imshow(results)


%%

% s = regionprops(bw2,'centroid');
% %Store the x- and y-coordinates of the centroids into a two-column matrix.
% 
% centroids = cat(1,s.Centroid);
% %Display the binary image with the centroid locations superimposed.
% 
% imshow(bw2)
% hold on
% plot(centroids(:,1),centroids(:,2),'b*')
% hold off



%%

% %Below steps are to find location of number plate
% Iprops=regionprops(im,'BoundingBox','Area', 'Image');
% area = Iprops.Area;
% count = numel(Iprops);
% maxa= area;
% boundingBox = Iprops.BoundingBox;
% for i=1:count
%    if maxa<Iprops(i).Area
%        maxa=Iprops(i).Area;
%        boundingBox=Iprops(i).BoundingBox;
%    end
% end   
% 
% im = imcrop(bw, boundingBox);
% im = bwareaopen(~im, 500);
%  [h, w] = size(im);
% 
% imshow(im);
% 
% Iprops=regionprops(im,'BoundingBox','Area', 'Image');
% count = numel(Iprops);
% noPlate=[];
% for i=1:count
%    ow = length(Iprops(i).Image(1,:));
%    oh = length(Iprops(i).Image(:,1));
%    if ow<(h/2) & oh>(h/3)
%        letter=Letter_detection(Iprops(i).Image);
%        noPlate=[noPlate letter]
%    end
% end

