function txt = AI_monitor_A(drone,cam,m,detector)

    takeoff(drone)
    moveup(drone,'Distance',1);
    moveleft(drone,'Distance',2);
    
    tim = tic;
    while toc(tim) <= 10
        
        I = snapshot(cam);
        result = ocr(I);
        a = contains(result.Text,"CHECKPOINT A");
        a2 = contains(result.Text,"CHECKPOINTA");
        
        if a == 1 || a2 == 1
            
            break
            
        end
        
        pause(0.1)
        
    end
    
    if a == 1 || a2 == 1
        
        moveback(drone,'Distance',1);
        
        tim = tic;
        while toc(tim) <= m

            %takes image from camera
            I = snapshot(cam);
            %logs detected objects, their positions & confidence
            %scores
            [bboxes, scores, labels] = detect(detector, I);
            %determines if vehicle or car is present
            person = ismember("person",labels);

            %if present detected function
            if person == 1
                
                break
                
            end

            pause(0.1);

        end

        %if present detected function
        if person == 1

            %insert annotation to show position of detection
            I = insertObjectAnnotation(I,'rectangle',bboxes,labels);
            %display annotated image
            dI = figure('WindowState','normal');
            dI, imshow(I);

            uialert(figurealert,"PRESENSE DETECTED! Drone returning home","ALERT!","Modal",true);

        end

        %move drone home
        moveforward(drone,'Distance',1,'Speed',1);
        moveright(drone,'Distance',2,'Speed',1);
        land(drone);
        txt = "Drone Finished Responding to Checkpoint A";
        
    else
        
        land(drone)
        txt = "Drone Lost";
        
    end
end