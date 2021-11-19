function txt = monitor_A(drone,cam,m)

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
        
        pause(m);
        
        moveright(drone,'Distance',2);
        land(drone);
        txt = "Drone Finshed Monitoring Checkpoint A";
        
    else
        
        land(drone);
        txt = "Drone Lost";
        
    end

end