% only to test the ultrasonic sensor
global key;
InitKeyboard();

while true
    dist = brick.UltrasonicDist(3);
    fprintf('Distance: %.2f\n', dist);
    
    pause(0.1);
    
    switch key
        case 'q'
            break;
    end
end
CloseKeyboard();


