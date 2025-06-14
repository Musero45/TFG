function t1STS = theta1SBo105FlightTest()
% getPadfieldFlightTest returns a Bo105 partial heroes trim state
%
% Data taken from reference [1]
% Ts.theta1s digitize from figure 4.10(a) page 203 of [1]
%
% [1] G.D. Padfield Helicopter Flight Dynamics 1996
%
%
%
Vt1S = [1.44441;8.63416;14.3662;16.9059;24.2143;35.8069;44.993;...
        55.627;64.8823;77.4731;84.6629;104.854];

R           = 4.91;
Omega       = 44.4;
t1STS.VOR=Vt1S.*0.5144444./(Omega*R);

t1S = [2.00007;1.56759;1.16447;0.0201166;-0.0695236;-0.504358;...
       -0.823603;-1.20077;-1.32003;-1.69825;-2.13073;-3.17024];

d2r = pi/180;
t1STS.theta1S=t1S.*d2r;
