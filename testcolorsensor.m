% Full remote control with arm control + Color Detection
% Milestone 02 - Color Sensor Integration with Debouncing
global key;

% Initialize color sensor on Port 1 to RGB Mode
brick.SetColorMode(1, 4);

InitKeyboard();

% Debouncing variables to prevent continuous triggering
last_color_detected = 'none';
color_cooldown = 0;

% Flag to control loop exit
should_quit = false;

while ~should_quit                             
    pause(0.1);
    
    % Remote control switch statement
    switch key
        case 'w'                                % forward movement
            brick.MoveMotor('BC', 100);  
            
        case 's'                                % backward movement
            brick.MoveMotor('BC', -100);  
            
        case 'a'                                % left side movement
            brick.MoveMotor('B', 20);   
            brick.MoveMotor('C', 100);
            
        case 'd'                                % right side movement
            brick.MoveMotor('B', 100);   
            brick.MoveMotor('C', 20);
            
        case 'uparrow'                          % arm move up
            brick.MoveMotor('A', 10);   
            pause(0.2);                   
            brick.MoveMotor('A', 0);    
            
        case 'downarrow'                        % arm move down
            brick.MoveMotor('A', -10);  
            pause(0.2);                   
            brick.MoveMotor('A', 0);    
            
        case 0                                  % handles when no key is pressed
            brick.MoveMotor('BC', 0);   
            
        case 'q'                                % quit and terminate remote control 
            brick.MoveMotor('ABC', 0);  
            should_quit = true;                 % Set flag to exit loop
    end
    
    % Decrease cooldown timer
    if color_cooldown > 0
        color_cooldown = color_cooldown - 1;
    end
    
    % COLOR DETECTION - Only check if cooldown expired
    if color_cooldown == 0
        color_rgb = brick.ColorRGB(1);
        red_val = color_rgb(1);
        green_val = color_rgb(2);
        blue_val = color_rgb(3);
        
        % Calculate total brightness to filter out black/dark colors
        total_brightness = red_val + green_val + blue_val;
        
        % Only detect colors if brightness is above threshold (not black)
        if total_brightness > 30
            
            % Detect RED - Stop for 1 second
            if (red_val > green_val) && (red_val > blue_val) && (red_val > 15)
                fprintf("Color Detected: RED\n");
                brick.StopAllMotors('Brake');
                pause(1);
                fprintf("\tRed: %d, Green: %d, Blue: %d\n", red_val, green_val, blue_val);
                last_color_detected = 'red';
                color_cooldown = 20; % Wait 2 seconds before detecting again
                
            % Detect BLUE - Stop and beep 2 times
            elseif (blue_val > red_val) && (blue_val > green_val) && (blue_val > 15)
                fprintf("Color Detected: BLUE\n");
                brick.StopAllMotors('Brake');
                brick.beep();
                pause(0.2);
                brick.beep();
                fprintf("\tRed: %d, Green: %d, Blue: %d\n", red_val, green_val, blue_val);
                last_color_detected = 'blue';
                color_cooldown = 20; % Wait 2 seconds before detecting again
                
            % Detect GREEN - Stop and beep 3 times
            elseif (green_val > red_val) && (green_val > blue_val) && (green_val > 15)
                fprintf("Color Detected: GREEN\n");
                brick.StopAllMotors('Brake');
                brick.beep();
                pause(0.2);
                brick.beep();
                pause(0.2);
                brick.beep();
                fprintf("\tRed: %d, Green: %d, Blue: %d\n", red_val, green_val, blue_val);
                last_color_detected = 'green';
                color_cooldown = 20; % Wait 2 seconds before detecting again
            end
        end
    end
    
end

CloseKeyboard();
% Full remote control with arm control + Color Detection
% Milestone 02 - Color Sensor Integration with Debouncing
global key;

% Initialize color sensor on Port 1 to RGB Mode
brick.SetColorMode(1, 4);

InitKeyboard();

% Debouncing variables to prevent continuous triggering
last_color_detected = 'none';
color_cooldown = 0;

% Flag to control loop exit
should_quit = false;

while ~should_quit                             
    pause(0.1);
    
    % Remote control switch statement
    switch key
        case 'w'                                % forward movement
            brick.MoveMotor('BC', 100);  
            
        case 's'                                % backward movement
            brick.MoveMotor('BC', -100);  
            
        case 'a'                                % left side movement
            brick.MoveMotor('B', 20);   
            brick.MoveMotor('C', 100);
            
        case 'd'                                % right side movement
            brick.MoveMotor('B', 100);   
            brick.MoveMotor('C', 20);
            
        case 'uparrow'                          % arm move up
            brick.MoveMotor('A', 10);   
            pause(0.2);                   
            brick.MoveMotor('A', 0);    
            
        case 'downarrow'                        % arm move down
            brick.MoveMotor('A', -10);  
            pause(0.2);                   
            brick.MoveMotor('A', 0);    
            
        case 0                                  % handles when no key is pressed
            brick.MoveMotor('BC', 0);   
            
        case 'q'                                % quit and terminate remote control 
            brick.MoveMotor('ABC', 0);  
            should_quit = true;                 % Set flag to exit loop
    end
    
    % Decrease cooldown timer
    if color_cooldown > 0
        color_cooldown = color_cooldown - 1;
    end
    
    % COLOR DETECTION - Only check if cooldown expired
    if color_cooldown == 0
        color_rgb = brick.ColorRGB(1);
        red_val = color_rgb(1);
        green_val = color_rgb(2);
        blue_val = color_rgb(3);
        
        % Calculate total brightness to filter out black/dark colors
        total_brightness = red_val + green_val + blue_val;
        
        % Only detect colors if brightness is above threshold (not black)
        if total_brightness > 30
            
            % Detect RED - Stop for 1 second
            if (red_val > green_val) && (red_val > blue_val) && (red_val > 15)
                fprintf("Color Detected: RED\n");
                brick.StopAllMotors('Brake');
                pause(1);
                fprintf("\tRed: %d, Green: %d, Blue: %d\n", red_val, green_val, blue_val);
                last_color_detected = 'red';
                color_cooldown = 20; % Wait 2 seconds before detecting again
                
            % Detect BLUE - Stop and beep 2 times
            elseif (blue_val > red_val) && (blue_val > green_val) && (blue_val > 15)
                fprintf("Color Detected: BLUE\n");
                brick.StopAllMotors('Brake');
                brick.beep();
                pause(0.2);
                brick.beep();
                fprintf("\tRed: %d, Green: %d, Blue: %d\n", red_val, green_val, blue_val);
                last_color_detected = 'blue';
                color_cooldown = 20; % Wait 2 seconds before detecting again
                
            % Detect GREEN - Stop and beep 3 times
            elseif (green_val > red_val) && (green_val > blue_val) && (green_val > 15)
                fprintf("Color Detected: GREEN\n");
                brick.StopAllMotors('Brake');
                brick.beep();
                pause(0.2);
                brick.beep();
                pause(0.2);
                brick.beep();
                fprintf("\tRed: %d, Green: %d, Blue: %d\n", red_val, green_val, blue_val);
                last_color_detected = 'green';
                color_cooldown = 20; % Wait 2 seconds before detecting again
            end
        end
    end
    
end

CloseKeyboard();


