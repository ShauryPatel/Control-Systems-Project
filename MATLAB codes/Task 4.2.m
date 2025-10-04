m = 0.0027;
R = 0.02;
g = -9.8;
L = 0.342;
d = 0.064123;
J = 4.32e-7;
s = tf('s');
P_ball = -m*g*d/L/(J/R^2+m)/s^2;

% Plot pole-zero map and step response of the open-loop system
%pzmap(P_ball);
%step(P_ball);

% Lead compensator design (adjust zero and pole based on new dominant poles)
z0 = 0.001;  % Zero of the lead compensator
p0 = 4;  % Pole of the lead compensator
C = tf([1 z0], [1 p0]);  % Lead compensator transfer function

% Plot the root locus of the compensated system
figure;
rlocus(C*P_ball);
sgrid(0.7, 1.0);  % Damping ratio and natural frequency
axis([-5 5 -2 2]); % Set axis limits for better visualization


k=5;
% Closed-loop system with compensator and gain
sys_cl = feedback(k*C*P_ball, 1);  % Closed-loop system

% Time vector for step response
t = 0:0.01:5;

% Plot the step response of the closed-loop system
figure;
step(0.25*sys_cl, t);
grid on;
title("Closed Loop Response");

% Get step response performance metrics
info = stepinfo(sys_cl);
fprintf('Maximum overshoot time : %.2f %%\n', info.Overshoot);
fprintf('Settling time : %.4f seconds\n', info.SettlingTime);
