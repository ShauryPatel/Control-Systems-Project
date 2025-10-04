m = 0.0027;
R = 0.02;
g = -9.8;
L = 0.342;
d = 0.064123;
J = 4.32e-7;
s = tf('s');
P_ball = -m * g * d / L / (J / R^2 + m) / s^2;

zo = 0.005;
po = 4.79;
C = tf([1 zo], [1 po]);

rlocus(C * P_ball)
sgrid(0.70, 1.9)

k = 6.433;
sys_cl = feedback(k * C * P_ball, 1);

t = 0:0.01:5;
[y, t_out] = step(0.25 * sys_cl, t); % Get the step response
figure;
plot(t_out, y, 'b', 'LineWidth', 1.5); % Plot step response
hold on;

info = stepinfo(0.25 * sys_cl);

% Maximum overshoot
overshoot_time = info.PeakTime; % Time at maximum peak
[max_value, max_index] = max(y); % Maximum value of the step response
plot(overshoot_time, max_value, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % Red marker at peak

% Settling Time
settling_time = info.SettlingTime;
settling_value = y(find(t_out >= settling_time, 1)); % Value at settling time
plot(settling_time, settling_value, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k'); % Black marker at settling time

% Add annotations
text(overshoot_time, max_value, sprintf('  Max Overshoot: %.2f%%', info.Overshoot), ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', ...
    'FontSize', 10, 'Color', 'r');
text(settling_time, settling_value, sprintf('  Settling Time: %.2f s', settling_time), ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', ...
    'FontSize', 10, 'Color', 'k');

ylim([0 0.3]);
xlabel('Time (s)');
ylabel('Response');
title('Step Response with Markers');
grid on;
hold off;

% Print overshoot and settling time
fprintf('Maximum overshoot time: %.2f %%\n', info.Overshoot);
fprintf('Settling time: %.4f seconds\n', info.SettlingTime);
1