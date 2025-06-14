function FCpdfT0 = Theta0GazelleNasa88351
%% digitize from theta0 graph in pag.26 of nasa-tm-88351
  muTheta0 = ...
  [0.14     6.916
  0.362     13.332
  0.338     12.974
  0.2599     8.342
  0.3441     12.457
  0.3783     14.3125
  0.3552     13.564];
  
FCpdfT0.VOR = muTheta0(:,1);
FCpdfT0.theta0 = muTheta0(:,2)*pi/180;