m = 0.0027;
R = 0.02;
g = -9.8;
L = 0.342;
d = 0.064123;
J = 4.32 e -7;
s = tf ( 's ') ;
P_ball = -m * g * d / L /( J / R ^2+ m ) / s ^2;
rlocus(P_ball)
sgrid(0.70,1.9)
axis([-5 5 -2 2])