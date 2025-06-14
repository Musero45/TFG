function t1CTS = theta1CBo105FlightTest()
%
% Data taken from reference [1]
% Ts.theta1c digitize from figure 4.10(b) page 203 of [1]
%
% [1] G.D. Padfield Helicopter Flight Dynamics 1996
%
%
%
Vt1C = [2.65586;4.14959;11.4295;14.0182;20.8418;25.2175;31.9388;...
        40.5269;51.0652;60.6236;70.6959;79.3256;99.5342];

R           = 4.91;
Omega       = 44.4;
t1CTS.VOR   = Vt1C.*0.5144444./(Omega*R);

t1C = [1.09977;1.31393;1.54185;2.34163;2.68388;2.85492;2.74003;...
       2.35355;2.06689;1.70889;1.4937;1.29293;1.14827];
d2r = pi/180;
t1CTS.theta1C=t1C.*d2r;
