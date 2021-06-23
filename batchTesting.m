clc
clear
close all
format compact

z = 0;

tic
j = batch('batchTest');
wait(j,'running');
toc

tic
while( ~ismember(j.State,'f') )
    
    disp("turning");
    pause(2)
    
end
toc

disp("detected");

load(j);

disp(z)