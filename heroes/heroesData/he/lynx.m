function he=lynx
% Helicopter defined by Padfield as lynx chapter 4 pg 260

mr = struct(...
      'R',6.4,...% Padfield pg 260 25.63 idle
      'nb',4,...% Padfield pg 260 25.63 idle
      'cldata',[6.0 0],...% Padfield pg 260 25.63 idle
      'cddata',[0.3 0.0 0.0114],...% my own
      'profile',@cl1cd2,...
      'Omega',34,... % Padfield pg 260 25.63 idle
      'chord',0.391, ... % Padfield pg 260
      'kappa',1.1,... % my own 
      'K',4.1,...% my own
      'cd0', 0.01...% my own
);

% data from http://avia.russian.ee/helicopters_eng/lynx.php
eng = struct(...
      'P_sl',2*670*1e3 ...
);

tr = struct(...
      'R',1.106,...% Padfield pg 260
      'nb',4,...% Padfield pg 261
      'Omega',195,...% my own equal tip speed
      'chord',0.208*pi*1.106/4, ...% Padfield pg 260
      'kappa',1.1,...% my own
      'K',3,...% my own
      'cd0', 0.01...% my own
);

he  = struct(...
      'W',42300,...% N pg 260 Padfield
      'f',10*(0.3048)^2, ...% m^2 pg 217 Leishman
      'x_tr',7.6,... % m^2 pg 261 Padfield
      'mr',mr,...
      'tr',tr,...
      'eng',eng,...  % w
      'type','he'...
);
