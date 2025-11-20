global key;
InitKeyboard();
fprintf("=== WALL AVOIDER (No Left Turns) ===\n");
fprintf("1. If < 15cm: Turn Right\n");
fprintf("2. If > 15cm: Drive Straight\n");
fprintf("Press 'q' to quit\n");

brick.SetColorMode(1, 2);
should_quit = false;


TARGET_CM = 15;    
DANGER_CM = 8;     


DRIVE_SPEED = 35;  
TURN_SUB    = 10;  

while ~should_quit
    pause(0.1); 
    
    if key == 'q'
        brick.StopAllMotors('Brake');
        break;
    end

    % SENSORS (PORT 3) 
    dist = brick.UltrasonicDist(3);
    touch = brick.TouchPressed(4);

    % Safety: Filter bad data
    if isnan(dist) || dist > 200
        dist = TARGET_CM;
    end

    % COLLISION RECOVERY (Touch Sensor) 
    if touch == 1
        fprintf("Bump! Stopping...\n");
        brick.StopAllMotors('Brake');
        pause(0.5);
        
        fprintf("Backing up...\n");
        brick.MoveMotor('AB', -30);      
        pause(1.5);
        
        brick.StopAllMotors('Brake');
        pause(0.2);
        
        fprintf("Turning Right (90 deg)...\n");
        brick.MoveMotor('A', 35);       
        brick.MoveMotor('B', -35);
        pause(0.8);                      
        brick.StopAllMotors('Brake');
        pause(0.5);
        continue;
    end

    % STEERING LOGIC
    
    % CASE 1: DANGER (< 8cm) -> Pivot Right
    % 
    if dist < DANGER_CM
        fprintf("Danger (%.1f) -> Pivot Right\n", dist);
        brick.MoveMotor('A', 35);  
        brick.MoveMotor('B', -10); % Reverse inner wheel to pivot out
        
    % CASE 2: CLOSE (< 15cm) -> Gentle Right Turn
    elseif dist < TARGET_CM
        fprintf("Too Close (%.1f) -> Curve Right\n", dist);
        brick.MoveMotor('A', DRIVE_SPEED);
        brick.MoveMotor('B', DRIVE_SPEED - TURN_SUB); 

    % CASE 3: FAR or PERFECT (> 15cm) -> GO STRAIGHT
    else
        fprintf("Clear (%.1f) -> Straight\n", dist);
        brick.MoveMotor('AB', DRIVE_SPEED);
    end
end
CloseKeyboard();