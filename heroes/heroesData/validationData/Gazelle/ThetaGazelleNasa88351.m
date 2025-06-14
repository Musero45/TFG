function FCpdfTheta = ThetaGazelleNasa88351
%% digitize from Theta graph in pag.27 of nasa-tm-88351
  muTheta = ...
 [0.14     -4.205
  0.362     -6.566
  0.338     -7.178
  0.2599     -5.181
  0.3441     -6.2883
  0.3783     -6.7305
  0.3552     -5.882];
  
FCpdfTheta.VOR = muTheta(:,1);
FCpdfTheta.Theta = muTheta(:,2)*pi/180;