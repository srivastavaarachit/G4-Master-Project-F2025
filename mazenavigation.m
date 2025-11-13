% # Milestone 03 - Autonomous Maze Navigation (WORKING VERSION)
% Left wall following with collision detection
global key;
InitKeyboard();

fprintf("=== Initializing Autonomous Navigation ===\n");
fprintf("Target wall distance: 25 cm\n");
fprintf("Press 'q' to quit\n\n");

% Test sensors
fprintf("Testing sensors...\n");
test_dist = brick.UltrasonicDist(2);
fprintf("Ultrasonic sensor: %.2f cm\n", test_dist);
test_touch = brick.TouchPressed(4);
fprintf("Touch sensor: %d\n\n", test_touch);

fprintf("Starting in 3 seconds...\n");
pause(1);
fprintf("3...\n");
pause(1);
fprintf("2...\n");
pause(1);
fprintf("1...\n");
pause(1);
fprintf("GO!\n\n");

should_quit = false;
target_distance = 25;  % Target distance from left wall in cm
base_speed = 50;       % Base speed for both motors
turn_gain = 2;         % How aggressively to correct steering

loop_count = 0;

while ~should_quit
    pause(0.1);
    loop_count = loop_count + 1;
    
    % Check for quit
    if key == 'q'
        fprintf("\n=== Quitting program ===\n");
        brick.StopAllMotors('Brake');
        should_quit = true;
        break;
    end
    
    % Read sensors
    touch_pressed = brick.TouchPressed(4);
    distance = brick.UltrasonicDist(2);
    
    % Handle invalid distance readings
    if isnan(distance) || distance <= 0
        distance = 255;  % Treat as "no wall detected"
    end
    
    % COLLISION HANDLING
    if touch_pressed == 1
        fprintf("\n>>> COLLISION DETECTED! <<<\n");
        fprintf("Distance was: %.1f cm\n", distance);
        
        % Stop
        brick.StopAllMotors('Brake');
        pause(0.5);
        
        % Back up
        fprintf("Backing up...\n");
        brick.MoveMotor('A', -45);
        brick.MoveMotor('B', -45);
        pause(1.2);
        
        % Stop
        brick.StopAllMotors('Brake');
        pause(0.3);
        
        % Turn right 90 degrees
        fprintf("Turning right 90 degrees...\n");
        brick.MoveMotor('A', 55);   % Left wheel forward
        brick.MoveMotor('B', -55);  % Right wheel backward
        pause(1.3);  % Adjust this timing for exact 90 degrees
        
        % Stop
        brick.StopAllMotors('Brake');
        pause(0.3);
        
        fprintf("Resuming navigation...\n\n");
        loop_count = 0;  % Reset loop counter
        continue;
    end
    
    % WALL FOLLOWING LOGIC
    if distance > 200
        % No left wall detected - turn left to search for wall
        left_speed = 30;
        right_speed = 60;
        
        if mod(loop_count, 10) == 0
            fprintf("Searching for left wall (dist: %.1f cm)\n", distance);
        end
        
    else
        % Calculate error from target distance
        error = distance - target_distance;
        
        % Proportional control for smooth correction
        adjustment = error * turn_gain;
        
        % Limit adjustment to prevent extreme turns
        if adjustment > 30
            adjustment = 30;
        elseif adjustment < -30
            adjustment = -30;
        end
        
        % Calculate motor speeds
        left_speed = base_speed - adjustment;
        right_speed = base_speed + adjustment;
        
        % Keep speeds within valid range [15, 85]
        if left_speed > 85
            left_speed = 85;
        elseif left_speed < 15
            left_speed = 15;
        end
        
        if right_speed > 85
            right_speed = 85;
        elseif right_speed < 15
            right_speed = 15;
        end
        
        % Print status every 10 loops (reduce console spam)
        if mod(loop_count, 10) == 0
            fprintf("Dist: %.1f cm | L: %d | R: %d | Err: %.1f\n", ...
                    distance, round(left_speed), round(right_speed), error);
        end
    end
    
    % Apply motor commands
    brick.MoveMotor('A', left_speed);
    brick.MoveMotor('B', right_speed);
    
end

CloseKeyboard();
fprintf("\n=== Navigation Complete ===\n");
