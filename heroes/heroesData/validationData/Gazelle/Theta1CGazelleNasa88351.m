function FCpdfT1C = Theta1CGazelleNasa88351
%% digitize from theta1C graph in pag.26 of nasa-tm-88351
  muTheta1C = ...
 [0.14     1.1364
  0.362     2.014
  0.338     1.273
  0.2599     1.221
  0.3441     1.963
  0.3783     2.272
  0.3552     1.7794];
  
FCpdfT1C.VOR = muTheta1C(:,1);
FCpdfT1C.theta1C = muTheta1C(:,2)*pi/180;