m = 0.0027;
R = 0.02;
g = -9.8;
L = 0.342;
d = 0.064123;
J = 4.32e-7;
s = tf('s');
P_ball = -m*g*d/L/(J/R^2+m)/s^2;

% Plot the step response
figure;

step(P_ball);

grid on;                    
title('Step Response of the Ball System'); 
xlabel('Time ');            
ylabel('Response (Position)');     

