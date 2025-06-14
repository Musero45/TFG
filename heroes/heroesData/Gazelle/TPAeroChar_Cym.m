function TP_Cym = TPAeroChar_Cym
% Horizontal tail plane Cym
% Digitize data from graphs on page 398 of nasa-tm-88370 
%
%% References
%    [1] Heffernan, Ruth M. and Gaubert, Michel. Structural and aerodynamic
%    loads and performance measurements of an SA349/2 helicopter with an 
%    advanced geometry rotor, 1986. NASA-TM-88370.
% 

  betaCym = ...
 [-21.8873     -1.8742
  -19.4541     -1.51641
  -17.1626     -1.23102
  -14.4685     -0.910232
  -11.2436     -0.590734
  -7.88597     -0.271557
  -4.93091     0.0122265
  -2.11745     0.223616
  0.696011     0.435006
  3.51837     0.719112
  5.93816     0.967825
  8.62781     1.25225
  11.3308     1.64575
  13.4941     1.96782
  15.392     2.29054
  17.7057     2.75772
  19.6036     3.08044
  21.3777     3.47619];
  
TP_Cym.betaF = betaCym(:,1)*pi/180;
TP_Cym.Cym = betaCym(:,2);