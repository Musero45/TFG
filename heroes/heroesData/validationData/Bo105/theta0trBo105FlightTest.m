function t0TTS = theta0trBo105FlightTest()
%
% Data taken from reference [1]
% Ts.theta0tr digitize from figure 4.10(d) page 203 of [1]
%
% [1] G.D. Padfield Helicopter Flight Dynamics 1996
%
%
%
Vt0T = [2.40206;3.78385;12.3656;15.2251;22.5264;31.0155;...
        39.5844;70.52;82.6223;101.012];

R           = 4.91;
Omega       = 44.4;
t0TTS.VOR=Vt0T.*0.5144444./(Omega*R);

t0T = [10.573;9.99931;9.16623;8.87898;5.20743;3.54283;...
       2.59506;3.42105;3.90634;4.59121];
d2r = pi/180;
t0TTS.theta0tr=t0T.*d2r;
