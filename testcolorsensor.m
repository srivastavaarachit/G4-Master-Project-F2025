brick.SetColorMode(1, 4); % Set Color Sensor connected to Port 1 to RGB Mode
color_rgb = brick.ColorRGB(1); % Get Color on port 1

% Determine which color stop is detected
red_val = color_rgb(1);
green_val = color_rgb(2);
blue_val = color_rgb(3);

% Identify the color based on RGB values
if (green_val > red_val) && (green_val > blue_val) && (green_val > 100)
    fprintf("Color Detected: YELLOW\n");
elseif (green_val > red_val) && (green_val > blue_val) && (green_val < 100)
    fprintf("Color Detected: GREEN\n");
elseif (blue_val > red_val) && (blue_val > green_val)
    fprintf("Color Detected: BLUE\n");
else
    fprintf("Color Detected: UNKNOWN\n");
end

% Display raw RGB values for reference
fprintf("\tRed: %d\n", red_val);
fprintf("\tGreen: %d\n", green_val);
fprintf("\tBlue: %d\n", blue_val);
