function txt = respond_B(drone,cam)

    takeoff(drone)
    moveup(drone,'Distance',1);
    moveright(drone,'Distance',2);
    
    tim = tic;
    while toc(tim) <= 10
        
        I = snapshot(cam);
        result = ocr(I);
        b = contains(result.Text,"CHECKPOINT B");
        b2 = contains(result.Text,"CHECKPOINTB");
        
        if b == 1 || b2 == 1
            
            break
            
        end
        
        pause(0.1)
        
    end
    
    if b == 1 || b2 == 1
        
        moveleft(drone,'Distance',2);
        land(drone);
        txt = "Drone Responded and Returned Home";
        
    else
        
        land(drone);
        txt = "Drone Lost";
        
    end
    
end
