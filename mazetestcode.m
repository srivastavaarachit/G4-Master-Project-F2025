global key;
InitKeyboard();

fprintf("1. Autonomous: Maintains 20-35cm from Right Wall\n");
fprintf("2. Manual: Press 'w','a','s','d' to nudge robot\n");
fprintf("(W=Fwd, S=Back, A=Left, D=Right)\n");
fprintf("3. RED: Stop for 1 second\n");
fprintf("4. BLUE/GREEN: Full keyboard control (Arrow keys for arm)\n");
fprintf("Press 'q' to quit\n");

brick.SetColorMode(1, 2);
should_quit = false;
red_detected = false;

MIN_DIST = 20;
MAX_DIST = 35;
DANGER_CM = 12;

DRIVE_SPEED = 45;  
TURN_SUB    = 6;   

MANUAL_SPEED = 50; 

while ~should_quit
    pause(0.01); 
    
    color = brick.ColorCode(1);
    
    if color == 5 && ~red_detected
        fprintf("RED DETECTED - STOPPING FOR 1 SECOND\n");
        brick.StopAllMotors('Brake');
        pause(1.0);
        fprintf("Resuming movement...\n");
        red_detected = true;
        continue;
    end
    
    if color ~= 5
        red_detected = false;
    end
    
    if color == 2 || color == 3
        fprintf("COLOR DETECTED (Code: %d) - KEYBOARD CONTROL ACTIVE\n", color);
        
        switch key
            case 'w'
                brick.MoveMotor('AB', -MANUAL_SPEED);
                
            case 's'
                brick.MoveMotor('AB', MANUAL_SPEED);
                
            case 'a'
                brick.MoveMotor('A', -MANUAL_SPEED);
                brick.MoveMotor('B', -(MANUAL_SPEED/2));
                
            case 'd'
                brick.MoveMotor('A', -(MANUAL_SPEED/2));
                brick.MoveMotor('B', -MANUAL_SPEED);
                
            case 'uparrow'
                brick.MoveMotor('C', 10);
                pause(0.5);
                brick.MoveMotor('C', 0);
                
            case 'downarrow'
                brick.MoveMotor('C', -10);
                pause(0.5);
                brick.MoveMotor('C', 0);
                
            case 0
                brick.MoveMotor('AB', 0);
                
            case 'q'
                brick.MoveMotor('ABC', 0);
                should_quit = true;
                break;
        end
        
        continue;
    end
    
    switch key
        case 'q'
            brick.StopAllMotors('Brake');
            break;
            
        case 'w'
            fprintf("Manual: Forward\n");
            brick.MoveMotor('AB', -MANUAL_SPEED);
            pause(0.3);
            key = 0;
            continue;
            
        case 's'
            fprintf("Manual: Backward\n");
            brick.MoveMotor('AB', MANUAL_SPEED);
            pause(0.3);
            key = 0;
            continue;
            
        case 'a'
            fprintf("Manual: Left\n");
            brick.MoveMotor('A', 30); 
            brick.MoveMotor('B', -30);
            pause(0.2);
            key = 0;
            continue;
            
        case 'd'
            fprintf("Manual: Right\n");
            brick.MoveMotor('A', -30); 
            brick.MoveMotor('B', 30);
            pause(0.2);
            key = 0;
            continue;
    end
    
    touch_front_1 = brick.TouchPressed(4); 
    touch_front_2 = brick.TouchPressed(2); 
    
    if touch_front_1 == 1 || touch_front_2 == 1
        fprintf("!!! BUMP DETECTED !!!\n");
        brick.StopAllMotors('Brake');
        pause(0.2);
        
        brick.MoveMotor('AB', 30);      
        pause(1.0);
        brick.StopAllMotors('Brake');
        pause(0.3);
        
        check_dist = brick.UltrasonicDist(3);
        if isnan(check_dist) || check_dist > 200
             check_dist = 100; 
        end
        
        if check_dist < 35
            fprintf("Wall on Right -> Turn LEFT\n");
            brick.MoveMotor('A', 25);       
            brick.MoveMotor('B', -45);
            pause(0.6); 
        else
            fprintf("Open Space -> Turn RIGHT\n");
            brick.MoveMotor('A', -45);       
            brick.MoveMotor('B', 25);
            pause(0.6); 
        end
        
        brick.StopAllMotors('Brake');
        pause(0.3);
        continue; 
    end
    
    dist = brick.UltrasonicDist(3);
    if isnan(dist) || dist > 200
        dist = MAX_DIST; 
    end
    
    if dist < 35
        brick.MoveMotor('A', -(DRIVE_SPEED - 2)); 
        brick.MoveMotor('B', -DRIVE_SPEED);
        
    else
        brick.MoveMotor('AB', -DRIVE_SPEED);
    end
end

CloseKeyboard();