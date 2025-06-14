function modos = StabilityModes(he,V,htest)
%This function compute the modes of a rigid helicopter given a velocity and
%height. Its output is an structure which contains the mode with the 
%largest Real part and the mode with the largest Imaginary part. The 
%behaviour of both modes is also presented in the structure.



options            = setHeroesRigidOptions;
options.GT         = 0;
options.inertialFM = 0;

%atmosphere variables needed
atm     = getISA;
% % % % g       = atm.g;
% % % % rho     = atm.density(htest);

%helicopter model selection
ndHe = rigidHe2ndHe(he,atm,htest);
O  = he.mainRotor.Omega;
R  = he.mainRotor.R;

muWT = [0; 0; 0];
ndV = V/(R*O);

fCT      = zeros(6,1);
fCT(1,:) = ndV;

% Compute trim state for the flight condition variable
ts       = getTrimState(fCT,muWT,ndHe,options);

% Compute linear stability state
ss       = getLinearStabilityState(ts,fCT,muWT,ndHe,options);

% Characteristic frequency and meter of helicopter
Omega   = he.mainRotor.Omega;
Radius  = he.mainRotor.R;

% Next, transforms the nondimensional state into an stabiliy map by
% dimensioning the matrix A
sm    = getStabilityMap(ss,Omega,Radius);
%plotStabilityMap(sm,{'PadfieldBo105'},{});

d = sm.si;


[max_real_eigv, realindex] = max(real(d(:)));
[max_img_eigv, imgindex]   = max(imag(d(:)));

t12 = log(2)/abs(max_real_eigv);
modot12 = modetype(d(realindex));
T = 2*pi/max_img_eigv;
modoT = modetype(d(imgindex));


maxrealmode = struct(...
                    'Modetype',modot12,...
                    'thalf',t12);
maximagmode = struct(...
                    'Modetype',modoT,...
                    'T',T);

modos = struct(...
              'MaxRealvalue',maxrealmode,...
              'MaxImagvalue',maximagmode);

end

function modo = modetype(eigenvalue)

realpart = real(eigenvalue);
imgpart  = imag(eigenvalue);

if realpart < 0
    modo1 = 'convergent';
elseif realpart > 0
    modo1 = 'divergent';
else
    modo1 = 'constant amplitude';
end
    
if imgpart > 0
    modo2 = 'oscillatory';
elseif imgpart == 0
    modo2 = 'non oscillatory';
end

modo = strcat(modo1,',',modo2);
    
end
