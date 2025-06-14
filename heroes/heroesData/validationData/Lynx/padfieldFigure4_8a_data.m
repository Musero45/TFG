function VPhi=padfieldFigure4_8a_data()
% Phi angle in degrees for different speeds in kn
%
% Data taken from reference [1]
% Theta digitize from figure 4.8(a) page 202 of [1]
%
% [1] G.D. Padfield Helicopter Flight Dynamics 2007
%
% IMPORTANT: This trim analysis is only for - Lynx -


PhiV = [
1.1643     -3.14443
8.37467     -3.08935
13.2582     -2.98033
18.4224     -2.84115
23.8708     -2.68387
28.7345     -2.50256
34.4702     -2.33922
39.6328     -2.19402
46.5327     -2.06066
54.3063     -1.95129
63.2474     -1.88394
70.4677     -1.865
78.5681     -1.89415
85.2334     -1.95961
92.7691     -2.03701
99.4508     -2.16271
105.555     -2.28848
110.796     -2.43243
116.329     -2.58237
121.867     -2.7564
125.955     -2.90651
129.756     -3.0687
133.556     -3.22487
137.648     -3.39305
];

Phi      = PhiV(:,2);
V        = PhiV(:,1);

VPhi.Phi = Phi.*(pi/180);
VPhi.VOR = V.*0.5144444./(6.4*35.63);

