function he=ah_64_apache

ft2m  = 0.3048;
lb2N  = 4.448;

mr = struct(...
     'R',24*ft2m,...
     'nb',4,...
     'Omega',726./24.,...
     'chord',[1.75]*ft2m, ...
     'kappa',1.15,...
     'K',4.6,...
     'cd0',0.008 ...
);

tr = struct(...
     'R',4.6*ft2m,...
     'nb',4,...
     'Omega',677./4.6,...
     'chord',[0.83]*ft2m, ...
     'kappa',1.15,...
     'K',4.6,...
     'cd0',0.008 ...
);

he  = struct(...
      'W',17650*lb2N,... %MTOW
      'mr',mr,...
      'tr',tr,...
      'type','he'...
);
