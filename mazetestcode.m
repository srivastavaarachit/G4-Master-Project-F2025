global key;
InitKeyboard();

fprintf("=== ULTRASONIC SENSOR TEST (PORT 3) ===\n");
fprintf("Press 'q' to quit.\n");
fprintf("Move your hand in front of Port 3 sensor.\n\n");

while 1
    pause(0.1); % Don't freeze Matlab
    
    if key == 'q'
        break;
    end
    
    % CHANGED: Now reading from Port 3
    distance = brick.UltrasonicDist(3);
    
    % Print the value
    fprintf("Distance: %.1f cm\n", distance);
end

CloseKeyboard();
fprintf("Done.\n");