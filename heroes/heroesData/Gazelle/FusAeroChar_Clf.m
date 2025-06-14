function Fus_Clf = FusAeroChar_Clf
%% Fuselage Clf
% Digitize data from graphs on page 397 of nasa-tm-88370
%
%% References
%    [1] Heffernan, Ruth M. and Gaubert, Michel. Structural and aerodynamic
%    loads and performance measurements of an SA349/2 helicopter with an 
%    advanced geometry rotor, 1986. NASA-TM-88370.
% 

  betaClf = ...
 [-21.6969     2.15634
  -20.1175     2.00229
  -18.5404     1.81775
  -16.8451     1.69407
  -15.268     1.50954
  -13.4591     1.38575
  -11.9957     1.20133
  -10.0822     0.955471
  -8.16427     0.77059
  -5.90541     0.585362
  -3.76246     0.369763
  -1.6195     0.154164
  0.180284     -0.0915747
  2.55049     -0.307404
  4.57982     -0.522888
  6.60914     -0.738371
  8.868     -0.923599
  10.895     -1.16957
  13.0403     -1.35468
  15.0696     -1.57016
  17.5534     -1.78611
  19.4691     -2.00148
  21.6144     -2.18659];
  
Fus_Clf.betaF = betaClf(:,1)*pi/180;
Fus_Clf.Clf = betaClf(:,2);