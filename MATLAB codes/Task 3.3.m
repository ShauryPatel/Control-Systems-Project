m = 0.0027;
R = 0.02;
g = -9.8;
L = 0.342;
d = 0.064123;
J = 4.32e-7;
s = tf('s');
P_ball = -m*g*d/L/(J/R^2+m)/s^2;

Kp = 10;
Ki = 20;
Kd = 15 ;
C = pid(Kp,Ki,Kd);
sys_cl = feedback(C*P_ball, 1);

% Plotting Response
[y, t] = step(0.25*sys_cl);
figure;
plot(t, y, 'b-', 'LineWidth', 2.5); % Thicker blue line
hold on;
grid on;
info = stepinfo(sys_cl);
fprintf('Maximum overshoot time : %.2f %%\n',info.Overshoot);
fprintf('Settling time : %.4f seconds\n',info.SettlingTime);
% Maximum Overshoot
overshoot_time = info.PeakTime; % Time at maximum peak
max_value = max(y);  % Maximum value of the step response
plot(overshoot_time, max_value, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % Red marker at peak
ylim([0 0.3])
% Settling Time
settling_value = y(find(t >= info.SettlingTime, 1));
plot(info.SettlingTime, settling_value, 'blacko', 'MarkerSize', 8, 'MarkerFaceColor', 'black'); % Green marker at settling time


text(overshoot_time, max_value, sprintf('  Max Overshoot: %.2f%%', info.Overshoot), ...
    'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', ...
    'FontSize', 10,'Color', 'r');
text(info.SettlingTime, settling_value, sprintf('  Settling Time: %.2f s', info.SettlingTime), ...
    'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', ...
    'FontSize', 10, 'Color', 'black');

xlabel('Time (seconds)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Amplitude', 'FontSize', 12, 'FontWeight', 'bold');
title('PID Controller with Kp = 10, Ki = 20, Kd = 15', 'FontSize', 14, 'FontWeight', 'bold');
legend('Step Response', 'Max Overshoot', 'Settling Time', 'Location', 'Best');
axis([0 max(t) 0 0.5]);
hold off;
ylim([0 0.3])