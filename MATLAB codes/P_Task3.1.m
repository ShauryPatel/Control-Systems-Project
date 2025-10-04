m = 0.0027;
R = 0.02;
g = -9.8;
L = 0.342;
d = 0.064123;
J = 4.32e-7;
s = tf('s');
P_ball = -m*g*d/L/(J/R^2+m)/s^2;

% Defining Kp ; 
Kp = 0.5;
C = pid(Kp);
sys_cl=feedback(C*P_ball,1);

% Plotting response
[y,t] = step(0.25*sys_cl);
figure;
plot(t,y,'b','LineWidth',1.5);
grid;
title('Proportional Controller with Kp = 0.5');
xlabel('Time(seconds)');
ylabel('Amplitude');
axis([0 70 0 0.5])