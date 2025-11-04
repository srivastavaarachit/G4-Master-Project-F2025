% full remote control with arm control 
% for # milestone 01

global key;
InitKeyboard();

while 1                             
    pause(0.1);
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
            pause(0.5);                   
            brick.MoveMotor('A', 0);    
            
        case 'downarrow'                        % arm move down
            brick.MoveMotor('A', -10);  
            pause(0.5);                   
            brick.MoveMotor('A', 0);    
            
        case 0                                  % handles when no key is pressed
            brick.MoveMotor('BC', 0);   
            
        case 'q'                                % quit and terminate remote control 
            brick.MoveMotor('ABC', 0);  
            break;
    end
end
CloseKeyboard();

