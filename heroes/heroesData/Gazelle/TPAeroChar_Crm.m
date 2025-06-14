function TP_Crm = TPAeroChar_Crm
% Horizontal tail plane Crm 
% Digitize data from graphs on page 398 of nasa-tm-88370 
%
%% References
%    [1] Heffernan, Ruth M. and Gaubert, Michel. Structural and aerodynamic
%    loads and performance measurements of an SA349/2 helicopter with an 
%    advanced geometry rotor, 1986. NASA-TM-88370.
% 

  betaCrm = ...
 [-20.7778     0.198329
  -18.9466     0.172162
  -17.2392     0.154579
  -15.1515     0.119791
  -12.533     0.0848522
  -10.1844     0.0457158
  -7.95951     0.015163
  -5.86737     -0.015352
  -3.65141     -0.0544506
  -1.43546     -0.0935491
  0.913194     -0.132685
  2.99644     -0.171746
  6.39339     -0.224004
  9.53383     -0.26764
  12.4044     -0.315473
  15.1423     -0.363269
  18.0218     -0.402556
  21.2993     -0.441957];
  
TP_Crm.betaF = betaCrm(:,1)*pi/180;
TP_Crm.Crm = betaCrm(:,2);