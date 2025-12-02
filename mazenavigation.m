global key;
InitKeyboard();
fprintf("=== REVERSE WALL + MANUAL OVERRIDE ===\n");
fprintf("1. Autonomous: Maintains 20-35cm from Right Wall\n");
fprintf("2. Manual: Press 'w','a','s','d' to nudge robot\n");
fprintf("   (W=Fwd, S=Back, A=Left, D=Right)\n");
fprintf("3. RED: Stop for 1 second\n");
fprintf("4. BLUE/GREEN: Full keyboard control (Arrow keys for arm)\n");
fprintf("Press 'q' to quit\n");

brick.SetColorMode(1, 2);
should_quit = false;
red_detected = false;  % Flag to track if red was already detected

% --- CONFIGURATION ---
MIN_DIST = 20;     % Min distance
MAX_DIST = 35;     % Max distance
DANGER_CM = 12;    % Panic distance

% --- SPEEDS (Applied as NEGATIVE) ---
DRIVE_SPEED = 45;  
TURN_SUB    = 6;   

% --- MANUAL SPEED ---
MANUAL_SPEED = 50; 

while ~should_quit
    pause(0.01); 
    
    % === 1. CHECK COLOR SENSOR ===
    color = brick.ColorCode(1);
    
    % === RED DETECTED: STOP FOR 1 SECOND (ONLY ONCE) ===
    if color == 5 && ~red_detected  % Red color code and not already detected
        fprintf("RED DETECTED - STOPPING FOR 1 SECOND\n");
        brick.StopAllMotors('Brake');
        pause(1.0);  % Stop for exactly 1 second
        fprintf("Resuming movement...\n");
        red_detected = true;  % Mark red as detected
        continue;  % Resume autonomous mode
    end
    
    % Reset red flag when no longer seeing red
    if color ~= 5
        red_detected = false;
    end
    
    % === BLUE OR GREEN DETECTED: FULL KEYBOARD CONTROL ===
    if color == 2 || color == 3  % Blue=2, Green=3
        fprintf("COLOR DETECTED (Code: %d) - KEYBOARD CONTROL ACTIVE\n", color);
        
        % Full remote control loop
        switch key
            case 'w'  % forward movement (swapped)
                brick.MoveMotor('AB', -MANUAL_SPEED);
                
            case 's'  % backward movement (swapped)
                brick.MoveMotor('AB', MANUAL_SPEED);
                
            case 'a'  % right turn (reversed)
                brick.MoveMotor('A', -MANUAL_SPEED);
                brick.MoveMotor('B', -(MANUAL_SPEED/2));
                
            case 'd'  % left turn (reversed)
                brick.MoveMotor('A', -(MANUAL_SPEED/2));
                brick.MoveMotor('B', -MANUAL_SPEED);
                
            case 'uparrow'  % arm move up
                brick.MoveMotor('C', 10);
                pause(0.5);
                brick.MoveMotor('C', 0);
                
            case 'downarrow'  % arm move down
                brick.MoveMotor('C', -10);
                pause(0.5);
                brick.MoveMotor('C', 0);
                
            case 0  % no key pressed
                brick.MoveMotor('AB', 0);  % Stop wheel motors
                
            case 'q'  % quit
                brick.MoveMotor('ABC', 0);
                should_quit = true;
                break;
        end
        
        continue;  % Stay in manual mode while color detected
    end
    
    % === 2. CHECK KEYBOARD (MANUAL OVERRIDE IN AUTO MODE) ===
    switch key
        case 'q'
            brick.StopAllMotors('Brake');
            break;
            
        case 'w' % Forward (Negative)
            fprintf("Manual: Forward\n");
            brick.MoveMotor('AB', -MANUAL_SPEED);
            pause(0.3);      % Run for short time
            key = 0;         % Reset key to resume auto
            continue;        % Skip sensors this loop
            
        case 's' % Backward (Positive)
            fprintf("Manual: Backward\n");
            brick.MoveMotor('AB', MANUAL_SPEED);
            pause(0.3);
            key = 0;
            continue;
            
        case 'a' % Turn Left (Pivot)
            fprintf("Manual: Left\n");
            % Pivot Left: A Positive, B Negative
            brick.MoveMotor('A', 30); 
            brick.MoveMotor('B', -30);
            pause(0.2);
            key = 0;
            continue;
            
        case 'd' % Turn Right (Pivot)
            fprintf("Manual: Right\n");
            % Pivot Right: A Negative, B Positive
            brick.MoveMotor('A', -30); 
            brick.MoveMotor('B', 30);
            pause(0.2);
            key = 0;
            continue;
    end
    
    % === 3. READ TOUCH SENSORS ===
    touch_front_1 = brick.TouchPressed(4); 
    touch_front_2 = brick.TouchPressed(2); 
    
    % --- COLLISION RECOVERY ---
    if touch_front_1 == 1 || touch_front_2 == 1
        fprintf("!!! BUMP DETECTED !!!\n");
        brick.StopAllMotors('Brake');
        pause(0.2);
        
        % Back Up
        brick.MoveMotor('AB', 30);      
        pause(1.0);
        brick.StopAllMotors('Brake');
        pause(0.2);
        
        % CHECK SITUATION
        check_dist = brick.UltrasonicDist(3);
        if isnan(check_dist) || check_dist > 200
             check_dist = 100; 
        end
        
        % DECIDE TURN
        if check_dist < 35
            fprintf("Wall on Right -> Turn Shallow LEFT\n");
            brick.MoveMotor('A', 25);       
            brick.MoveMotor('B', -45);
            pause(0.6); 
        else
            fprintf("Open Space -> Turn Shallow RIGHT\n");
            brick.MoveMotor('A', -45);       
            brick.MoveMotor('B', 25);
            pause(0.6); 
        end
        
        brick.StopAllMotors('Brake');
        pause(0.5);
        continue; 
    end
    
    % === 4. AUTONOMOUS WALL FOLLOWING ===
    dist = brick.UltrasonicDist(3);
    if isnan(dist) || dist > 200
        dist = MAX_DIST; 
    end
    
    % CASE 1: PANIC (< 12cm) - AGGRESSIVE TURN
    if dist < DANGER_CM
        brick.MoveMotor('A', 20); 
        brick.MoveMotor('B', -40); 
        
    % CASE 2: TOO CLOSE (< 20cm) -> GENTLE STEER LEFT
    elseif dist < MIN_DIST
        % Gentle correction - smaller difference between wheels
        brick.MoveMotor('A', -(DRIVE_SPEED - 3)); 
        brick.MoveMotor('B', -DRIVE_SPEED);              
        
    % CASE 3: SLIGHTLY TOO FAR (35-50cm) -> GENTLE STEER RIGHT
    elseif dist > MAX_DIST && dist <= 50
        % Gentle correction - smaller difference between wheels
        brick.MoveMotor('A', -DRIVE_SPEED);              
        brick.MoveMotor('B', -(DRIVE_SPEED - 3)); 
        
    % CASE 4: WAY TOO FAR (> 50cm) -> MODERATE TURN RIGHT
    elseif dist > 50
        % Moderate turn for big gaps
        brick.MoveMotor('A', -DRIVE_SPEED);              
        brick.MoveMotor('B', -(DRIVE_SPEED - TURN_SUB)); 
        
    % CASE 5: PERFECT ZONE (20-35cm) -> STRAIGHT
    else
        brick.MoveMotor('AB', -DRIVE_SPEED);
    end
end

CloseKeyboard();