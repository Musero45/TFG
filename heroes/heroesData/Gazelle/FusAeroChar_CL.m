function Fus_CL = FusAeroChar_CL
%% Fuselage CL
% Digitize data from graphs on page 397 of nasa-tm-88370
%
%% References
%    [1] Heffernan, Ruth M. and Gaubert, Michel. Structural and aerodynamic
%    loads and performance measurements of an SA349/2 helicopter with an 
%    advanced geometry rotor, 1986. NASA-TM-88370.
% 

  alphaCl = ...
 [-21.9318     -0.190909
  -19.8864     -0.136364
  -18.0682     -0.0818182
  -15.5682     -0.00909091
  -13.5227     0.0636364
  -11.1364     0.145455
  -8.18182     0.245455
  -5.56818     0.345455
  -2.27273     0.445455
  1.02273     0.563636
  3.86364     0.663636
  7.5     0.8
  10.6818     0.909091
  14.0909     1.02727
  17.2727     1.13636
  19.8864     1.2
  21.3636     1.25455];
  
Fus_CL.alphaF = alphaCl(:,1)*pi/180;
Fus_CL.CL = alphaCl(:,2);