function Fus_CD = FusAeroChar_CD
%% Fuselage CD
% Digitize data from graphs on page 397 of nasa-tm-88370
%
%% References
%    [1] Heffernan, Ruth M. and Gaubert, Michel. Structural and aerodynamic
%    loads and performance measurements of an SA349/2 helicopter with an 
%    advanced geometry rotor, 1986. NASA-TM-88370.
% 

  alphaCd = ...
 [-21.6525     1.6695
  -20.7676     1.61081
  -19.5429     1.54719
  -18.3181     1.48357
  -17.2097     1.41508
  -16.0921     1.36611
  -14.8673     1.30249
  -13.0723     1.23877
  -11.7288     1.18488
  -10.2714     1.13098
  -8.69752     1.08193
  -6.89326     1.03773
  -4.29748     0.978761
  -2.37226     0.949175
  -0.672861     0.924504
  1.25926     0.909553
  3.42639     0.909201
  3.42409     0.904322
  5.24905     0.904025
  7.42768     0.928065
  9.48995     0.947245
  11.9082     0.995641
  14.4428     1.0489
  16.6375     1.10709
  18.1456     1.16051
  20.2286     1.22359
  21.5154     1.29169];
  
Fus_CD.alphaF = alphaCd(:,1)*pi/180;
Fus_CD.CD = alphaCd(:,2);