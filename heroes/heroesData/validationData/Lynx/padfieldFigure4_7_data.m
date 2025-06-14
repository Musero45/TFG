function VBeta1C=padfieldFigure4_7_data()
% Beta 1C angle in rad for different speeds in kn
%
% Data taken from reference [1]
% Theta digitize from figure 4.7 page 201 of [1]
%
% [1] G.D. Padfield Helicopter Flight Dynamics 2007
%
% Author: Francisco J. Ruiz Fernandez
%


LynxVbeta1C =[
5.21982     0.00677999
14.5481     0.00669218
26.0242     0.00634885
37.7444     0.00623853
48.7569     0.0066055
61.4485     0.00719199
73.1785     0.0075522
86.8367     0.00860021
99.5529     0.010363
111.791     0.0121304
125.962     0.0148207
138.717     0.0184657
151.009     0.022821
162.607     0.0283593
];

Lynxbeta1C        = LynxVbeta1C(:,2);
V                 = LynxVbeta1C(:,1);

VBeta1C{1}.beta1C = Lynxbeta1C;
VBeta1C{1}.V      = V.*0.5144444;

PumaVbeta1C =[
2.63747     -0.0576254
12.4262     -0.0569344
21.2591     -0.0564792
30.5669     -0.0565014
40.5894     -0.0567634
51.088     -0.0572645
62.3063     -0.0570532
74.4816     -0.0563679
86.422     -0.0549678
99.0783     -0.0535693
111.502     -0.0509799
123.211     -0.0481507
134.211     -0.0438912
144.734     -0.0396307
152.872     -0.0351263
160.776     -0.029669
];

Pumabeta1C        = PumaVbeta1C(:,2);
V                 = PumaVbeta1C(:,1);

VBeta1C{2}.beta1C = Pumabeta1C;
VBeta1C{2}.V      = V.*0.5144444;