% WALL FOLLOWING - VERY SLOW (30-40 SPEED)
global key;
InitKeyboard();
fprintf("=== Navigation Starting NOW! ===\n");
fprintf("Press 'q' to quit\n\n");
brick.SetColorMode(1, 2);
should_quit = false;
target_distance = 7;       % 2-3 inches
DANGER_DISTANCE = 15;      % Safety threshold
color_cooldown = 0;
loop_count = 0;

% MOTOR SPEEDS - MUCH SLOWER!
LEFT_BASE  = 38;           % Reduced from 75
RIGHT_BASE = 36;           % Reduced from 72
WALL_GAIN  = 0.20;         % Reduced gain for slower speeds

fprintf("GO! Slow mode (30-40 speed)\n\n");

while ~should_quit
    pause(0.08);
    loop_count = loop_count + 1;
    
    if key == 'q'
        fprintf("\n=== Quitting ===\n");
        brick.StopAllMotors('Brake');
        break;
    end
    
    % === READ SENSORS ===
    touch_pressed = brick.TouchPressed(4);
    distance = brick.UltrasonicDist(2);
    color = brick.ColorCode(1);
    
    % Handle bad ultrasonic readings
    if isnan(distance) || distance <= 0
        distance = target_distance;
    end
    
    % Show distance every 25 loops
    if mod(loop_count, 25) == 0
        fprintf("Distance: %.1f cm", distance);
        if distance < DANGER_DISTANCE
            fprintf(" [TOO CLOSE - AVOIDING!]");
        end
        fprintf("\n");
    end
    
    if color_cooldown > 0
        color_cooldown = color_cooldown - 1;
    end
    
    % === COLLISION - 90° TURN ===
    if touch_pressed == 1
        fprintf("\n>>> COLLISION! <<<\n");
        brick.StopAllMotors('Brake');
        pause(0.5);
        
        % Back up (slow)
        brick.MoveMotor('A', -30);
        brick.MoveMotor('B', -30);
        pause(1.5);
        brick.StopAllMotors('Brake');
        pause(0.2);
        
        % 90-degree LEFT turn (slow)
        brick.MoveMotor('A', 35);
        brick.MoveMotor('B', -35);
        pause(0.50);
        brick.StopAllMotors('Brake');
        pause(0.3);
        
        color_cooldown = 15;
        continue;
    end
    
    % === COLOR - RED ===
    if color_cooldown == 0 && color == 5
        fprintf("\n>>> RED DETECTED <<<\n");
        brick.StopAllMotors('Brake');
        brick.beep();
        pause(0.5);
        fprintf("Resuming\n\n");
        color_cooldown = 20;
        continue;
    end
    
    % === COLOR - BLUE ===
    if color_cooldown == 0 && color == 2
        fprintf("\n>>> BLUE DETECTED <<<\n");
        brick.StopAllMotors('Brake');
        brick.beep();
        pause(0.3);
        brick.beep();
        pause(0.3);
        brick.beep();
        pause(0.5);
        fprintf("Resuming\n\n");
        color_cooldown = 20;
        continue;
    end
    
    % === WALL FOLLOWING WITH COLLISION AVOIDANCE ===
    
    % DANGER ZONE: Too close to wall (<15cm) - STEER RIGHT!
    if distance < DANGER_DISTANCE && distance > 0
        % AGGRESSIVE right turn (slow speeds)
        left_speed = 45;      % Left motor FASTER
        right_speed = 25;     % Right motor SLOWER → turns RIGHT
        fprintf("⚠️ DANGER: %.1f cm - Steering RIGHT!\n", distance);
    else
        % NORMAL PROPORTIONAL CONTROL
        error = distance - target_distance;
        
        % Clamp error
        if error > 15
            error = 15;
        elseif error < -15
            error = -15;
        end
        
        adjustment = error * WALL_GAIN;
        
        % Too far → turn LEFT, Too close → turn RIGHT
        left_speed  = LEFT_BASE  - adjustment;
        right_speed = RIGHT_BASE + adjustment;
        
        % Speed limits (SLOW RANGE)
        if left_speed > 45
            left_speed = 45;
        elseif left_speed < 28
            left_speed = 28;
        end
        
        if right_speed > 45
            right_speed = 45;
        elseif right_speed < 28
            right_speed = 28;
        end
    end
    
    % DRIVE
    brick.MoveMotor('A', left_speed);
    brick.MoveMotor('B', right_speed);
    
end
CloseKeyboard();
fprintf("\n=== Done ===\n");
