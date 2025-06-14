function TP_Cpm = TPAeroChar_Cpm
% Horizontal tail plane Cpm 
% Digitize data from graphs on page 398 of nasa-tm-88370 
%
%% References
%    [1] Heffernan, Ruth M. and Gaubert, Michel. Structural and aerodynamic
%    loads and performance measurements of an SA349/2 helicopter with an 
%    advanced geometry rotor, 1986. NASA-TM-88370.
% 

  alphaCpm = ...
 [-21.8711     -0.753382
  -20.2321     -0.779065
  -18.0452     -0.804977
  -16.1252     -0.793277
  -13.7895     -0.756749
  -11.1704     -0.670338
  -8.27026     -0.546544
  -5.78102     -0.422579
  -3.01072     -0.261229
  -0.651354     -0.0997089
  1.84499     0.0617545
  4.20672     0.235774
  6.56372     0.384795
  9.19231     0.521203
  11.1313     0.632898
  13.6181     0.744364
  15.6799     0.781006
  17.7416     0.817647
  19.7939     0.804292];
  
TP_Cpm.alphaF = alphaCpm(:,1)*pi/180;
TP_Cpm.Cpm = alphaCpm(:,2);
