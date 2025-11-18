% QUICK ULTRASONIC TEST - Port 2
fprintf("=== Testing Ultrasonic Sensor on Port 2 ===\n");
fprintf("Move your hand closer/farther from the sensor\n");
fprintf("Press Ctrl+C to stop\n\n");

for i = 1:50
    distance = brick.UltrasonicDist(2);
    fprintf("Reading %d: %.1f cm\n", i, distance);
    pause(0.2);
end

fprintf("\nTest complete!\n");
