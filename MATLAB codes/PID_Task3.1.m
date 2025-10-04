m = 0.0027;
R = 0.02;
g = -9.8;
L = 0.342;
d = 0.064123;
J = 4.32e-7;
s = tf('s');
P_ball = -m*g*d/L/(J/R^2+m)/s^2;

% Defining Kp, Ki & Kd
Kp = 10;
Ki = 10;
Kd = 5;
C = pid(Kp,Ki,Kd);
sys_cl=feedback(C*P_ball,1);

% Plotting Response
[y,t] = step(0.25*sys_cl);
figure;
plot(t,y,'b','LineWidth',1.5);
grid;
title('PID Controller with Kp = 10, Ki = 10, Kd = 5');
xlabel('Time(seconds)');
ylabel('Amplitude');
t=0:0.01:5;