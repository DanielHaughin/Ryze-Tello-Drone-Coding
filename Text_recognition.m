clc
clear
close all
format compact

%set-up camera connection
cam = webcam('Microsoft Camera Rear');
preview(cam)

% % Create a cascade detector object.
% faceDetector = vision.CascadeObjectDetector();

pause(5);

%takepicture
I = snapshot(cam);
%Identifies text
txt = ocr(I);
%specifying parameters to reference against
A = "CHECKPOINTA";
A2 = "CHECKPOINT A";
B = "CHECKPOINTB";
B2 = "CHECKPOINT B";
C = "CHECKPOINTC";
C2 = "CHECKPOINT C";
%referencing image to pre-determined text
x = contains(txt.Text,A);
x2 = contains(txt.Text,A2);
y = contains(txt.Text,B);
y2 = contains(txt.Text,B2);
z = contains(txt.Text,C);
z2 = contains(txt.Text,C2);

%if statements to determine correct checkpoint
if x == 1 |  x2 == 1
    
    t = 1;
    
elseif y == 1 | y2==1
        
    t = 2;

elseif z == 1 | z2==1
        
    t = 3;
       
end
    
