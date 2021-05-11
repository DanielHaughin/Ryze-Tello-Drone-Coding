clc
clear
close all
format compact

I = imread('A.png');
txt = ocr(I);
A = "CHECKPOINT A"
x = contains(txt.Text,A) 

if x == 1
    
    b = 1;
    
end