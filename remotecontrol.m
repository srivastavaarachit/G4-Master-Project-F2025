% full remote control with arm control 
% for # milestone 01
global key;
InitKeyboard();
while 1                             
    pause(0.1);
    switch key
        case 'w'                                % forward movement
            brick.MoveMotor('AB', 100);         % Left (A) and Right (B) forward
            
        case 's'                                % backward movement
            brick.MoveMotor('AB', -100);        % Left (A) and Right (B) backward
            
        case 'a'                                % left side movement
            brick.MoveMotor('A', 20);           % Left wheel slow
            brick.MoveMotor('B', 100);          % Right wheel fast
            
        case 'd'                                % right side movement
            brick.MoveMotor('A', 100);          % Left wheel fast
            brick.MoveMotor('B', 20);           % Right wheel slow
            
        case 'uparrow'                          % arm move up
            brick.MoveMotor('C', 10);           % Arm motor on port C
            pause(0.5);                   
            brick.MoveMotor('C', 0);    
            
        case 'downarrow'                        % arm move down
            brick.MoveMotor('C', -10);          % Arm motor on port C
            pause(0.5);                   
            brick.MoveMotor('C', 0);    
            
        case 0                                  % handles when no key is pressed
            brick.MoveMotor('AB', 0);           % Stop wheel motors
            
        case 'q'                                % quit and terminate remote control 
            brick.MoveMotor('ABC', 0);          % Stop all motors
            break;
    end
end
CloseKeyboard();
