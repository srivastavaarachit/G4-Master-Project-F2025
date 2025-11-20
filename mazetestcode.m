global key;
InitKeyboard();
fprintf("=== REVERSE DRIVING (Front is Back) ===\n");
fprintf("1. Driving Negative (Backwards is the new Forward)\n");
fprintf("2. Wall on RIGHT -> Steer LEFT\n");
fprintf("Press 'q' to quit\n");

brick.SetColorMode(1, 2);
should_quit = false;

% --- CONFIGURATION ---
TARGET_CM = 15;    % Safe buffer
DANGER_CM = 8;     % Panic line

% --- SPEEDS ---
% We keep these positive here, but apply them as NEGATIVE in the loop
DRIVE_SPEED = 40;  
TURN_SUB    = 15;  

while ~should_quit
    pause(0.1); 
    
    if key == 'q'
        brick.StopAllMotors('Brake');
        break;
    end

    % --- SENSORS (PORT 3) ---
    dist = brick.UltrasonicDist(3);
    touch = brick.TouchPressed(4);

    % Safety: Filter bad data
    if isnan(dist) || dist > 200
        dist = TARGET_CM;
    end

    % --- COLLISION RECOVERY ---
    if touch == 1
        fprintf("Bump! Stopping...\n");
        brick.StopAllMotors('Brake');
        pause(0.5);
        
        fprintf("Backing up (Moving Positive)...\n");
        % REVERSED: Positive is now "Backing up"
        brick.MoveMotor('AB', 30);      
        pause(1.5);
        
        brick.StopAllMotors('Brake');
        pause(0.2);
        
        fprintf("Turning LEFT (Away from wall)...\n");
        % Pivot Left while reversed:
        % Motor A (Left) goes Positive (Forward/Slower)
        % Motor B (Right) goes Negative (Backward/Faster)
        brick.MoveMotor('A', 15);       
        brick.MoveMotor('B', -35);
        
        pause(0.5); 
        
        brick.StopAllMotors('Brake');
        pause(0.5);
        continue;
    end

    % --- STEERING LOGIC (RIGHT WALL / REVERSE DRIVE) ---
    
    % CASE 1: DANGER (< 8cm) -> Pivot LEFT
    if dist < DANGER_CM
        fprintf("Danger (%.1f) -> Pivot LEFT!\n", dist);
        % Pivot Left: Pull Left Wheel forward (Pos), Push Right Wheel back (Neg)
        brick.MoveMotor('A', 20); 
        brick.MoveMotor('B', -35); 
        
    % CASE 2: TOO CLOSE (< 15cm) -> Curve LEFT
    elseif dist < TARGET_CM
        fprintf("Close (%.1f)  -> Steer LEFT\n", dist);
        % To steer Left while driving backward:
        % The Right Wheel (B) must go backward FASTER than Left Wheel (A)
        brick.MoveMotor('A', -(DRIVE_SPEED - TURN_SUB)); % Slower Negative (e.g., -25)
        brick.MoveMotor('B', -DRIVE_SPEED);              % Faster Negative (e.g., -40)

    % CASE 3: CLEAR (> 15cm) -> STRAIGHT
    else
        fprintf("Clear (%.1f)  -> Straight (Negative)\n", dist);
        % Both motors Negative to drive "Forward"
        brick.MoveMotor('AB', -DRIVE_SPEED);
    end
end
CloseKeyboard();