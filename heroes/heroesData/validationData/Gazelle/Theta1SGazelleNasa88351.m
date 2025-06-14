function FCpdfT1S = Theta1SGazelleNasa88351
%% digitize from theta1S graph in pag.26 of nasa-tm-88351
  muTheta1S = ...
 [0.14     1.258
  0.362     -8.056
  0.338     -4.619
  0.2599     -2.146
  0.3441     -7.291
  0.3783     -9.691
  0.3552     -5.421];
  
FCpdfT1S.VOR = muTheta1S(:,1);
FCpdfT1S.theta1S = muTheta1S(:,2)*pi/180;