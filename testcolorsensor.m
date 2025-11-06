% # milestone 02
global key;
brick.SetColorMode(1, 4);  % Color sensor on port 1
InitKeyboard();
color_cooldown = 0;
should_quit = false;
brick.MoveMotor('AB', 50);  % Left wheel (A) and right wheel (B) forward
fprintf("Robot started - driving forward autonomously\n");
fprintf("Press 'q' to quit\n\n");
while ~should_quit                             
    pause(0.1);
    
    if key == 'q'
        fprintf("Quitting program...\n");
        brick.StopAllMotors('Brake');
        should_quit = true;
        continue;
    end
    
    if color_cooldown > 0
        color_cooldown = color_cooldown - 1;
    end
    
    if color_cooldown == 0
        color_rgb = brick.ColorRGB(1);  % Read from color sensor on port 1
        red_val = color_rgb(1);
        green_val = color_rgb(2);
        blue_val = color_rgb(3);
        
        total_brightness = red_val + green_val + blue_val;
        
        if total_brightness > 30
            
            if (red_val > green_val) && (red_val > blue_val) && (red_val > 15)
                fprintf("Color Detected: RED\n");
                brick.StopAllMotors('Brake');
                pause(1);
                fprintf("\tRed: %d, Green: %d, Blue: %d\n\n", red_val, green_val, blue_val);
                
                brick.MoveMotor('AB', 50);  % Resume driving
                color_cooldown = 20;
                
            elseif (blue_val > red_val) && (blue_val > green_val) && (blue_val > 15)
                fprintf("Color Detected: BLUE\n");
                brick.StopAllMotors('Brake');
                brick.beep();
                pause(0.2);
                brick.beep();
                fprintf("\tRed: %d, Green: %d, Blue: %d\n\n", red_val, green_val, blue_val);
                
                brick.MoveMotor('AB', 50);  % Resume driving
                color_cooldown = 20;
                
            elseif (green_val > red_val) && (green_val > blue_val) && (green_val > 15)
                fprintf("Color Detected: GREEN\n");
                brick.StopAllMotors('Brake');
                brick.beep();
                pause(0.2);
                brick.beep();
                pause(0.2);
                brick.beep();
                fprintf("\tRed: %d, Green: %d, Blue: %d\n\n", red_val, green_val, blue_val);
                
                brick.MoveMotor('AB', 50);  % Resume driving
                color_cooldown = 20;
            end
        end
    end
    
end
CloseKeyboard();
fprintf("Program ended successfully\n");
