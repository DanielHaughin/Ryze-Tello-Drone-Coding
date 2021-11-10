clc
clear
close all
format compact

net = darknet53;
inputSize = net.Layers(1).InputSize;

I = imread('dogs.jpg');

I = imresize(I,inputSize(1:2));

[label, score] = classify(net,I);

