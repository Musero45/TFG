function TP_Clf = TPAeroChar_Clf
% Horizontal tail plane Clf 
% Digitize data from graphs on page 398 of nasa-tm-88370 
%
%% References
%    [1] Heffernan, Ruth M. and Gaubert, Michel. Structural and aerodynamic
%    loads and performance measurements of an SA349/2 helicopter with an 
%    advanced geometry rotor, 1986. NASA-TM-88370.
% 

  betaClf = ...
 [-21.8705     1.74282
  -19.9155     1.44439
  -17.0361     1.107
  -14.4175     0.806949
  -11.6619     0.54327
  -8.77351     0.279266
  -6.01341     0.0522812
  -3.1206     -0.175028
  0.0376214     -0.402987
  3.19584     -0.630947
  5.9515     -0.894626
  8.83542     -1.19532
  12.2279     -1.68079
  15.4833     -2.20263
  18.0884     -2.61276
  19.7736     -2.94723
  21.4632     -3.24501];
  
TP_Clf.betaF = betaClf(:,1)*pi/180;
TP_Clf.Clf = betaClf(:,2);