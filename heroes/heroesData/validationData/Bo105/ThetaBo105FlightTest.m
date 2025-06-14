function TheTS = ThetaBo105FlightTest()
%
% Data taken from reference [1]
% Ts.Theta digitize from figure 4.6(a) page 198 of [1]
%
% [1] G.D. Padfield Helicopter Flight Dynamics 1996
%
%
%
VThe = [0.1;4.93535;7.99823;15.7215;17.0566;26.6451;38.586;...
        48.112;59.3925;67.0854;77.8983;95.7812];

R           = 4.91;
Omega       = 44.4;
TheTS.VOR   = VThe.*0.5144444./(Omega*R);

The = [2.71375;2.86011;2.43131;2.57816;3.15231;3.2283;-0.207649;...
       0.119242;-0.664335;-1.87968;-2.26915;-4.34026];
d2r = pi/180;
TheTS.Theta=The.*d2r;
