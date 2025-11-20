% --- SETUP: PRE-CALCULATE THE IMAGES ---
% We draw the images first so the animation loop is fast and smooth.

% 1. Create blank canvases (128 pixels high x 178 pixels wide)
% false = white pixel, true = black pixel
openEyes = false(128, 178);
closedEyes = false(128, 178);

% 2. Define Eye Dimensions and Position
eyeWidth = 50; 
eyeHeight = 80; 
eyeY = 24;              % Distance from top
leftEyeX = 30;          % Distance from left
rightEyeX = 98; 
borderThick = 5;        % Thickness of the eye box
pupilSize = 16;         % Size of the square pupil
cornerSize = 8;         % How much to "cut" from corners to round them

% ---------------------------------------------------------
% DRAWING THE 'OPEN EYES'
% ---------------------------------------------------------

% 1. Draw the Outer Boxes (Solid Black)
openEyes(eyeY : eyeY+eyeHeight, leftEyeX : leftEyeX+eyeWidth) = true;
openEyes(eyeY : eyeY+eyeHeight, rightEyeX : rightEyeX+eyeWidth) = true;

% 2. Hollow out the boxes (White centers)
openEyes(eyeY+borderThick : eyeY+eyeHeight-borderThick, ...
         leftEyeX+borderThick : leftEyeX+eyeWidth-borderThick) = false;
openEyes(eyeY+borderThick : eyeY+eyeHeight-borderThick, ...
         rightEyeX+borderThick : rightEyeX+eyeWidth-borderThick) = false;

% 3. Draw the Pupils (Solid Black squares in center)
pupilY = eyeY + (eyeHeight/2) - (pupilSize/2);
leftPupilX = leftEyeX + (eyeWidth/2) - (pupilSize/2);
rightPupilX = rightEyeX + (eyeWidth/2) - (pupilSize/2);

openEyes(pupilY : pupilY+pupilSize, leftPupilX : leftPupilX+pupilSize) = true;
openEyes(pupilY : pupilY+pupilSize, rightPupilX : rightPupilX+pupilSize) = true;

% 4. Round the Corners (Manually clear the corner pixels)
% Left Eye Corners
openEyes(eyeY:eyeY+cornerSize, leftEyeX:leftEyeX+cornerSize) = false;
openEyes(eyeY:eyeY+cornerSize, leftEyeX+eyeWidth-cornerSize:leftEyeX+eyeWidth) = false;
openEyes(eyeY+eyeHeight-cornerSize:eyeY+eyeHeight, leftEyeX:leftEyeX+cornerSize) = false;
openEyes(eyeY+eyeHeight-cornerSize:eyeY+eyeHeight, leftEyeX+eyeWidth-cornerSize:leftEyeX+eyeWidth) = false;

% Right Eye Corners
openEyes(eyeY:eyeY+cornerSize, rightEyeX:rightEyeX+cornerSize) = false;
openEyes(eyeY:eyeY+cornerSize, rightEyeX+eyeWidth-cornerSize:rightEyeX+eyeWidth) = false;
openEyes(eyeY+eyeHeight-cornerSize:eyeY+eyeHeight, rightEyeX:rightEyeX+cornerSize) = false;
openEyes(eyeY+eyeHeight-cornerSize:eyeY+eyeHeight, rightEyeX+eyeWidth-cornerSize:rightEyeX+eyeWidth) = false;

% ---------------------------------------------------------
% DRAWING THE 'CLOSED EYES'
% ---------------------------------------------------------
blinkHeight = 6; % Thickness of the closed eyelid line
centerY = eyeY + (eyeHeight / 2) - (blinkHeight / 2);

% Draw a horizontal line for Left and Right eyes
closedEyes(centerY : centerY+blinkHeight, leftEyeX : leftEyeX+eyeWidth) = true;
closedEyes(centerY : centerY+blinkHeight, rightEyeX : rightEyeX+eyeWidth) = true;

% ---------------------------------------------------------
% THE ANIMATION LOOP (Using writeLCD)
% ---------------------------------------------------------
disp('Blinking animation started.');
disp('Press Ctrl+C in the Command Window to stop.');

while true
    % 1. Show Open Eyes
    writeLCD(brick, openEyes);
    
    % 2. Wait for a random time (between 1.5 and 3.5 seconds)
    % This makes the blinking look natural rather than robotic
    pause(1.5 + (rand() * 2)); 
    
    % 3. Show Closed Eyes (The Blink)
    writeLCD(brick, closedEyes);
    
    % 4. Keep eyes closed for a fraction of a second
    pause(0.15);
