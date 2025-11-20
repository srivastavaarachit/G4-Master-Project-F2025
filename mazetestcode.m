global key;
InitKeyboard();
fprintf("=== REVERSE WALL + MANUAL OVERRIDE ===\n");
fprintf("1. Autonomous: Maintains 20-35cm from Right Wall\n");
fprintf("2. Manual: Press 'w','a','s','d' to nudge robot\n");
fprintf("   (W=Fwd, S=Back, A=Left, D=Right)\n");
fprintf("Press 'q' to quit\n");

brick.SetColorMode(1, 2);
should_quit = false;

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
    
    % === 1. CHECK KEYBOARD (MANUAL OVERRIDE) ===
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

    % === 2. READ TOUCH SENSORS ===
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

    % === 3. AUTONOMOUS WALL FOLLOWING ===
    dist = brick.UltrasonicDist(3);

    if isnan(dist) || dist > 200
        dist = MAX_DIST; 
    end
    
    % CASE 1: PANIC (< 12cm)
    if dist < DANGER_CM
        brick.MoveMotor('A', 20); 
        brick.MoveMotor('B', -40); 
        
    % CASE 2: TOO CLOSE (< 20cm) -> STEER LEFT
    elseif dist < MIN_DIST
        brick.MoveMotor('A', -(DRIVE_SPEED - TURN_SUB)); 
        brick.MoveMotor('B', -DRIVE_SPEED);              

    % CASE 3: TOO FAR (> 35cm) -> STEER RIGHT
    elseif dist > MAX_DIST
        brick.MoveMotor('A', -DRIVE_SPEED);              
        brick.MoveMotor('B', -(DRIVE_SPEED - TURN_SUB)); 

    % CASE 4: PERFECT ZONE (20-35cm) -> STRAIGHT
    else
        brick.MoveMotor('AB', -DRIVE_SPEED);
    end
end
CloseKeyboard();





