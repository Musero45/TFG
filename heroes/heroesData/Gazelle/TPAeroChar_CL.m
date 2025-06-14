function TP_CL = TPAeroChar_CL
% Horizontal tail plane CL 
% Digitize data from graphs on page 398 of nasa-tm-88370 
%
%% References
%    [1] Heffernan, Ruth M. and Gaubert, Michel. Structural and aerodynamic
%    loads and performance measurements of an SA349/2 helicopter with an 
%    advanced geometry rotor, 1986. NASA-TM-88370.
% 

  alphaCl = ...
 [-22.5688     0.7625
  -20.5046     0.7875
  -18.4404     0.7875
  -16.3761     0.7625
  -13.8991     0.7125
  -11.1468     0.6375
  -8.80734     0.55
  -6.74312     0.4625
  -4.26606     0.3625
  -2.06422     0.225
  -0.412844     0.1375
  1.92661     0.0125
  3.99083     -0.1125
  6.05505     -0.225
  8.3945     -0.375
  10.5963     -0.475
  12.7982     -0.575
  15     -0.6625
  16.789     -0.7
  18.7156     -0.725
  20.367     -0.7125];
  
TP_CL.alphaF = alphaCl(:,1)*pi/180;
TP_CL.CL = alphaCl(:,2);