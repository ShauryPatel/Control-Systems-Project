m = 0.0027;
R = 0.02;
g = -9.8;
L = 0.342;
d = 0.064123;
J = 4.32e-7;
s = tf('s');
P_ball = -m*g*d/L/(J/R^2+m)/s^2;

% Defining Kp and Kd
Kp = 10;
Kd = 20;
C = pid(Kp,0,Kd);
sys_cl=feedback(C*P_ball,1);

% Plotting Response
[y,t] = step(0.25*sys_cl);
figure;
plot(t,y,'b','LineWidth',1.5);
grid;
title('PD Controller with Kp = 10, Kd = 10');
xlabel('Time(seconds)');
ylabel('Amplitude');
t=0:0.01:5;
info = stepinfo(sys_cl);
fprintf('Maximum overshoot time : %.2f %%\n',info.Overshoot);
fprintf('Settling time : %.4f seconds\n',info.SettlingTime);
