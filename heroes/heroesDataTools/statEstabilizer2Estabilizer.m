function TailSurface = statEstabilizer2Estabilizer (Surface,chord,label,options)
% funcion que dimension las superficies estabilizadores tanto verticales
% como horizontales



options = parseOptions(options,@statTailSurface2TailSurface);


airfoil = options.airfoil;
theta   = options.theta;

TailSurface = struct(...
              'class','stabilizer',...
              'id',label,...
              'active','yes',...
              'airfoil',airfoil,... % @naca0012
              'type',@get2DStabilizerActions,... 
              'c',chord,...
              'S',Surface,... % Input.
              'theta',theta,... % Input.
              'ks',1 ...
            );


% Oscar este es el caso de la vertical. Creo que seria mejor definir otra
% para las horizontales ya que las entradas son distintas.
% En horizontal tenemos S pero no c y en la vertical tenemos c pero no S.
% Si sabes como ponerlo lo vemos en la proxima reunion.




function options = statTailSurface2TailSurface


options = struct(...
          'airfoil',@naca0012,...
          'theta',0 ...
);
