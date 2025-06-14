function t0TS = theta0Bo105FlightTest()
%
% Data taken from reference [1]
% Ts.theta0 digitize from figure 4.10(c) page 203 of [1]
%
% [1] G.D. Padfield Helicopter Flight Dynamics 1996
%
%
%
Vt0         = [0.1;7.78116;12.6444;19.9392;25.7751;34.0426;50.0912;...
               60.304;70.5167;80.7295;100.182];
R           = 4.91;
Omega       = 44.4;
t0TS.VOR    = Vt0.*0.5144444./(R*Omega);

theta0      = [14.2571;13.8286;13.4857;13.0571;12.6;12.2857;12.0857;...
               12.1429;12.5714;13.0571;14.5143];

d2r         = pi/180;
t0TS.theta0 = theta0.*d2r;
