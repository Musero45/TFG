function Fus_Cym = FusAeroChar_Cym
%% Fuselage Cym
% Digitize data from graphs on page 397 of nasa-tm-88370
%
%% References
%    [1] Heffernan, Ruth M. and Gaubert, Michel. Structural and aerodynamic
%    loads and performance measurements of an SA349/2 helicopter with an 
%    advanced geometry rotor, 1986. NASA-TM-88370.
% 

  betaCym = ...
 [-22.1474     0.412804
  -20.3271     0.407512
  -18.5068     0.402219
  -16.1137     0.385766
  -13.9411     0.352369
  -11.7662     0.313338
  -9.59132     0.274306
  -7.64139     0.229599
  -5.68918     0.179257
  -3.73469     0.123282
  -2.12337     0.0728767
  -0.0529637     0.0112889
  1.90153     -0.0446863
  3.51285     -0.0950918
  5.23325     -0.134208
  6.84457     -0.184614
  8.90813     -0.2293
  10.7421     -0.268395
  12.6898     -0.307469
  14.5192     -0.335297
  16.6896     -0.36306
  18.9667     -0.373901
  21.1279     -0.379129];
  
Fus_Cym.betaF = betaCym(:,1)*pi/180;
Fus_Cym.Cym = betaCym(:,2);