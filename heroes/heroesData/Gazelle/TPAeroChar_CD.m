function TP_CD = TPAeroChar_CD
% Horizontal tail plane CD 
% Digitize data from graphs on page 398 of nasa-tm-88370 
%
%% References
%    [1] Heffernan, Ruth M. and Gaubert, Michel. Structural and aerodynamic
%    loads and performance measurements of an SA349/2 helicopter with an 
%    advanced geometry rotor, 1986. NASA-TM-88370.
% 

  alphaCd = ...
 [-22.2936     0.293421
  -20.6422     0.273684
  -18.9908     0.251754
  -17.3394     0.229825
  -15.2752     0.203509
  -12.7982     0.177193
  -10.0459     0.150877
  -7.15596     0.13114
  -4.54128     0.113596
  -1.37615     0.100439
  1.37615     0.0938596
  4.26606     0.0982456
  7.01835     0.109211
  9.3578     0.128947
  11.5596     0.157456
  13.8991     0.201316
  15     0.232018
  16.1009     0.264912
  17.0642     0.295614
  18.1651     0.330702
  18.8532     0.365789
  19.5413     0.396491];
  
TP_CD.alphaF = alphaCd(:,1)*pi/180;
TP_CD.CD = alphaCd(:,2);
