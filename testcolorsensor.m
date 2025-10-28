brick.SetColorMode(1, 4); % Set Color Sensor connected to Port 1 to RGB Mode
color_rgb = brick.ColorRGB(1); % Get Color on port 1

% Get RGB values
red_val = color_rgb(1);
green_val = color_rgb(2);
blue_val = color_rgb(3);

% Identify the color based on RGB values
if (red_val > green_val) && (green_val > 40) && (blue_val < 30) && (red_val > 60)
    % Yellow has red higher than green, both much higher than blue
    fprintf("Color Detected: YELLOW\n");
elseif (green_val > red_val) && (green_val > blue_val) && (green_val > 20)
    % Green has green dominant (lowered threshold from 50 to 20)
    fprintf("Color Detected: GREEN\n");
elseif (blue_val >= green_val) && (blue_val > red_val)
    % Blue has blue dominant
    fprintf("Color Detected: BLUE\n");
else
    fprintf("Color Detected: UNKNOWN\n");
end

% Display raw RGB values for reference
fprintf("\tRed: %d\n", red_val);
fprintf("\tGreen: %d\n", green_val);
fprintf("\tBlue: %d\n", blue_val);
