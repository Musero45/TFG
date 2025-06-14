function Fus_Crm = FusAeroChar_Crm
%% Fuselage Crm
% Digitize data from graphs on page 397 of nasa-tm-88370
%
%% References
%    [1] Heffernan, Ruth M. and Gaubert, Michel. Structural and aerodynamic
%    loads and performance measurements of an SA349/2 helicopter with an 
%    advanced geometry rotor, 1986. NASA-TM-88370.
% 

  betaCrm = ...
 [-22.1474     0.01
  -20.3271     0.01
  -18.5068     0.01
  -16.1137     0.01
  -13.9411     0.01
  -11.7662     0.01
  -9.59132     0.01
  -7.64139     0.01
  -5.68918     0.01
  -3.73469     0.01
  -2.12337     0.01
  -0.0529637     0.01
  1.90153     0.01
  3.51285     0.01
  5.23325     0.01
  6.84457     0.01
  8.90813     0.01
  10.7421     0.01
  12.6898     0.01
  14.5192     0.01
  16.6896     0.01
  18.9667     0.01
  21.1279     0.01];
  
Fus_Crm.betaF = betaCrm(:,1)*pi/180;
Fus_Crm.Crm = betaCrm(:,2);