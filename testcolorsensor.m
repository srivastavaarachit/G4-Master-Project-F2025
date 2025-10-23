brick.SetColorMode(1, 4); % Set Color Sensor connected to Port 1 to Color Code Mode

color_rgb = brick.ColorRGB(1); % Get Color on port 1.

%print color of object

fprintf("\tRed: %d\n", color_rgb(1));

fprintf("\tGreen: %d\n", color_rgb(2));

fprintf("\tBlue: %d\n", color_rgb(3));