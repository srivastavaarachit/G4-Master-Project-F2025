%  full remote control with arm control 
% for # milestone 01

global key;
InitKeyboard();

while 1                             
    pause(0.1);
    switch key
        case 'uparrow'                      %forward movement
            brick.MoveMotor('BC', 50);  
            
        case 'downarrow'                    % backward movement
            brick.MoveMotor('BC', -50);  
            
        case 'leftarrow'                    % left side movement
            brick.MoveMotor('B', 20);   
            brick.MoveMotor('C', 50);
            
        case 'rightarrow'                   % right side movement
            brick.MoveMotor('B', 50);   
            brick.MoveMotor('C', 20);
            
        case 'w'                            % arm move up
            brick.MoveMotor('A', 20);   
            pause(0.3);                   
            brick.MoveMotor('A', 0);    
            
        case 's'                            % arm move down
            brick.MoveMotor('A', -20);  
            pause(0.3);                   
            brick.MoveMotor('A', 0);    
            
        case 0                              % handles when no key is pressed
            brick.MoveMotor('BC', 0);   
            
        case 'q'                            % quit and terminate remote control 
            brick.MoveMotor('ABC', 0);  
            break;
    end
end
CloseKeyboard();



