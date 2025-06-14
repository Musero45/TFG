function FCpdfPow = PowerGazelleNasa88351
%% digitize from PM graph in pag.27 of nasa-tm-88351
  muPower = ...
 [0.14     231.3
  0.362     592.56
  0.338     500
  0.2599     296.9
  0.3441     593.6
  0.3783     735.8
  0.3552     687.94];
  
FCpdfPow.VOR = muPower(:,1);
FCpdfPow.PMpower = muPower(:,2)*1/0.00134102;