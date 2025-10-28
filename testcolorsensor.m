brick.SetColorMode(1, 4); 
color_rgb = brick.ColorRGB(1); 

% Get RGB values
red_val = color_rgb(1);
green_val = color_rgb(2);
blue_val = color_rgb(3);

% Identify the color based on RGB values
if (red_val > 100) && (green_val > 80) && (blue_val < 50)
    % Yellow has both red and green high, blue low
    fprintf("Color Detected: YELLOW\n");
elseif (green_val > red_val) && (green_val > blue_val) && (blue_val < 50)
    % Green has green dominant, blue low
    fprintf("Color Detected: GREEN\n");
elseif (blue_val >= green_val) && (blue_val > red_val)
    % Blue has blue dominant
    fprintf("Color Detected: BLUE\n");
else
    fprintf("Color Detected: UNKNOWN\n");
end

% Display raw RGB values for reference testing
fprintf("\tRed: %d\n", red_val);
fprintf("\tGreen: %d\n", green_val);
fprintf("\tBlue: %d\n", blue_val);
