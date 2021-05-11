clc
clear
close all
format compact

%Loads image
I = imread('C.png');
%Identifies text
txt = ocr(I);
%specifying parameters to reference against
A = "CHECKPOINT A";
B = "CHECKPOINT B";
C = "CHECKPOINT C";
%referencing image to pre-determined text
x = contains(txt.Text,A);
y = contains(txt.Text,B);
z = contains(txt.Text,C);

if x == 1
    
    b = 1;
    
elseif y == 1
        
    b = 2;

elseif z == 1
        
    b = 3;
       
end  
    
