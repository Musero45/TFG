function Fus_Cpm = FusAeroChar_Cpm
%% Fuselage Cpm
% Digitize data from graphs on page 397 of nasa-tm-88370
%
%% References
%    [1] Heffernan, Ruth M. and Gaubert, Michel. Structural and aerodynamic
%    loads and performance measurements of an SA349/2 helicopter with an 
%    advanced geometry rotor, 1986. NASA-TM-88370.
% 

  alphaCpm = ...
 [-21.9318     -0.48125
  -19.4318     -0.4625
  -16.7045     -0.43125
  -14.4318     -0.4
  -11.8182     -0.35625
  -9.31818     -0.30625
  -7.27273     -0.25625
  -4.88636     -0.2
  -2.61364     -0.14375
  -0.227273     -0.08125
  2.15909     -0.01875
  4.31818     0.0375
  6.47727     0.1
  8.63636     0.1625
  11.1364     0.21875
  13.2955     0.26875
  15.4545     0.3125
  17.7273     0.36875
  19.8864     0.39375];
  
Fus_Cpm.alphaF = alphaCpm(:,1)*pi/180;
Fus_Cpm.Cpm = alphaCpm(:,2);