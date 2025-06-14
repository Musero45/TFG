function ndRlState = getNdRotorLinearState(ndRlSol,ndRotor,cv,nx,npsi,options,varargin)

% 
% getNdRotorLinearState calculates the non-dimensional rotor state from a
% a non-dimensional rotor solution (ndRlSol) obtained from a linear aeromechanics model
% (aeromechanicsLin) by the function getNdRotorAeromechSolution.
%
% The non-dimensional rotor state is obtained for a non-dimensional Rotor,
% ndRotor.
%
% The non-dimensional rotor state (ndRlState) is formed by non-dimensional
% radial-azimutal distributions in a nx x npsi grid, being nx the number of
% radial positions and npsi the number of azimutal positions specified by the user.
%
% The user must specify as input the structure cv with fields:
%
%            'alphaLin' [rad]. Maximun angle of attack of linear region of cl
%            'alphaMax' [rad]. Angle of attack for máximum cl
%            'Minc'       [-]. Maximum incompressibe flow Mach number 
%            'Mcrit'      [-]. Critical Mach number
%            'Mdd'        [-]. Drag divergence Mach number
%            'kRedLim'    [-]. Maximum reduced frequency for stationarity
%
% The previous values can be used to visualise the radial-azimutal regions 
% of validity of the linear solution considering different aerodynamic criteria  
%
% The output structure  ndRlState is formed by the fields containing the
% [nx x npsi] matrices of non-dimensional values of the radial-azimutal
% distributions of
%                
%     'xM':        Radial positions
%     'psiM':      Azimuthal positions
%     'xAM':       xA positions
%     'yAM':       yA positions
%     'lambdai':   Induced velocity parameter
%     'ndUT':      Tangential velocity (-yA2)
%     'ndUP':      Normal velocity (zA2)      
%     'ndUL':      Longitudinal velocity (xA2)       
%     'phiang':    Flow incidence angle.
%     'phiangSim': Linearized flow incidence angle.
%     'theta':     Pitch angle.
%     'alpha':     Angle of attack.
%     'alphaSim':  Angle of attack from linearized phiang.
%     'betaM':     Flap angle.
%     'Mloc':      Local Mach number.
%     'Reloc':     Local Reynolds number.
%     'kRedLoc':   Local reduced frequency.
%     'MkRedLoc':  Product of Mloc and kRedLoc.
%     'cl',cl:     Lift coefficient.
%     'clSim':     Lift coefficient from linearized phiang. 
%     'cd':        Drag coefficient.
%     'cdSim':     Drag coefficient from linearized phiang. 
%     'k':         Aerodynamic efficiency.
%     'kSim':      Aerodynamic efficiency from linearized phiang.
%     'dCTb_dx':   Thrust coefficient.   
%     'dCTb_dxSim':  Thrust (aerodynamic) coefficient from linearized phiang.
%     'dCFTb_dx':    Tangential force (aerodynamic) coefficient.
%     'dCFTb_dxSim': Tangential force (aerodynamic) coefficient from linearized phiang.
%     'dCHb_dx':     Longitudinal force (xA, aerodynamic) coefficient.
%     'dCHb_dxSim':  Longitudinal force (xA, aerodynamic) coefficient from linearized phiang.
%     'dCYb_dx':     Lateral force (yA, aerodynamic) coefficient. 
%     'dCYb_dxSim':  Lateral force (yA, aerodynamic) coefficient from linearized phiang.
%     'dCPb_dx':     Power (aerodynamic) coefficient.
%     'dCPb_dxSim':  Power (aerodynamic) coefficient from linearized phiang.
%
%%    

Pin    = 1;
b      = ndRotor.b;
ead    = ndRotor.ead;
sigma0 = ndRotor.sigma0;
sigma1 = ndRotor.sigma1;
theta1 = ndRotor.theta1;
Mtip   = ndRotor.M;
Retip  = ndRotor.Re;
a      = ndRotor.cldata(1);
alpha0 = ndRotor.cldata(2);
delta0 = ndRotor.cddata(1);
delta1 = ndRotor.cddata(2);
delta2 = ndRotor.cddata(3);
   
xv   = linspace(ead,1,nx);
psiv = linspace(0,2*pi,npsi);

[xM,psiM] = ndgrid(xv,psiv);

xAM = xM.*cos(psiM);
yAM = xM.*sin(psiM);

c_R    = (sigma0+sigma1.*xM)*pi/b; 

%% Assignment of values

% Critical values that will determine if certain solutions 
% meet the criteria that is evaluated in each case.

alphaLin = cv.alphaLin; % [rad]. Maximun angle of attack of linear region of cl
alphaMax = cv.alphaMax; % [rad]. Angle of attack for máximum cl
Minc     = cv.Minc;     % [-]. Maximum incompressibe flow Mach number 
Mcrit    = cv.Mcrit;    % [-]. Critical Mach number
Mdd      = cv.Mdd;      % [-]. Drag divergence Mach number
kRedLim  = cv.kRedLim;  % [-]. Maximum reduced frequency for stationarity
 

muxA     = ndRlSol.fC(1); 
muyA     = ndRlSol.fC(2);
muzA     = ndRlSol.fC(3);
   
muWxA    = ndRlSol.muWA(1); 
muWyA    = ndRlSol.muWA(2);
muWzA    = ndRlSol.muWA(3);
   
lambda0  = ndRlSol.lambda0;
lambdaC1 = ndRlSol.lambda1C; 
lambdaS1 = ndRlSol.lambda1S; 

beta0    = ndRlSol.beta0;
beta1C   = ndRlSol.beta1C;
beta1S   = ndRlSol.beta1S;

theta0   = ndRlSol.theta(1);
theta1C  = ndRlSol.theta(2);
theta1S  = ndRlSol.theta(3);

omxAad   = ndRlSol.fC(4);
omyAad   = ndRlSol.fC(5);
omzAad   = ndRlSol.fC(6);

betaM    = beta0 + beta1C.*cos(psiM) + beta1S.*sin(psiM);
lambdai  = lambda0 + xM.*(lambdaC1*cos(psiM) + lambdaS1*sin(psiM));
  
ndUT         = Pin.*(-sin(psiM).^2.*Pin.*beta1C.*xM.*lambdaS1 - sin(psiM).*cos(psiM).*Pin.*beta1C.*xM.*lambdaC1 + sin(psiM).*cos(psiM).*beta1S.*xM.*lambdaS1 - sin(psiM).*Pin.*beta1C.*lambda0 + cos(psiM).^2.*beta1S.*xM.*lambdaC1 + muWxA.*sin(psiM).*Pin + sin(psiM).*Pin.*muxA + cos(psiM).*beta1S.*lambda0 - muWyA.*cos(psiM) - cos(psiM).*muyA + xM.*Pin + xM.*omzAad) - Pin.*xM.*(sin(psiM).*Pin.*omyAad + cos(psiM).*omxAad).*(beta0 + cos(psiM).*beta1C + beta1S.*sin(psiM)) + Pin.*(sin(psiM).*Pin.*omyAad + cos(psiM).*omxAad).*(beta0 + cos(psiM).*beta1C + beta1S.*sin(psiM)).*ead;
ndUP         = -xM.*(sin(psiM).*Pin.*omxAad - beta1C.*sin(psiM) + cos(psiM).*beta1S - cos(psiM).*omyAad) + muzA + (sin(psiM).*xM.*lambdaS1 + cos(psiM).*xM.*lambdaC1 + lambda0) + muWzA - (-sin(psiM).^2.*Pin.*beta1S.*xM.*lambdaS1 - sin(psiM).*cos(psiM).*Pin.*beta1S.*xM.*lambdaC1 - sin(psiM).*cos(psiM).*beta1C.*xM.*lambdaS1 - sin(psiM).*Pin.*beta1S.*lambda0 - cos(psiM).^2.*beta1C.*xM.*lambdaC1 + muWyA.*sin(psiM).*Pin + sin(psiM).*Pin.*muyA - cos(psiM).*beta1C.*lambda0 + muWxA.*cos(psiM) + cos(psiM).*muxA).*(beta0 + cos(psiM).*beta1C + beta1S.*sin(psiM)) - (beta1C.*sin(psiM) - cos(psiM).*beta1S).*ead; 
ndUL         = (sin(psiM).*Pin.*muyA + cos(psiM).*muxA) - cos(psiM).*beta1C.*(sin(psiM).*xM.*lambdaS1 + cos(psiM).*xM.*lambdaC1 + lambda0) - Pin.*sin(psiM).*beta1S.*(sin(psiM).*xM.*lambdaS1 + cos(psiM).*xM.*lambdaC1 + lambda0) + cos(psiM).*muWxA + Pin.*sin(psiM).*muWyA + (sin(psiM).*xM.*lambdaS1 + cos(psiM).*xM.*lambdaC1 + muWzA + lambda0 + muzA).*(beta0 + cos(psiM).*beta1C + beta1S.*sin(psiM)) - (sin(psiM).*Pin.*omxAad - cos(psiM).*omyAad).*(beta0 + cos(psiM).*beta1C + beta1S.*sin(psiM)).*ead; 
phiangSim    = ndUP./ndUT;
phiang       = atan2(ndUP,ndUT);
theta        = theta0 + theta1C.*cos(psiM) + theta1S.*sin(psiM) + theta1.*xM;
alpha        = phiang+theta;
alphaSim     = phiangSim+theta;
Mloc         = Mtip.*(ndUT.^2+ndUP.^2).^0.5;
Reloc        = Retip.*c_R.*(ndUT.^2+ndUP.^2).^0.5;
kRedLoc      = 0.5*c_R./((ndUT.^2+ndUP.^2).^0.5);
MkRedLoc     = Mloc.*kRedLoc;
cl           = a.*alpha-alpha0;
clSim        = a.*alphaSim-alpha0;
cd           = delta0+delta1.*alpha+delta2.*alpha.^2;
cdSim        = delta0+delta1.*alphaSim+delta2.*alphaSim.^2;
k            = cl./cd;
kSim         = clSim./cdSim;
dCTb_dx      = 0.5*ndUT.^2.*c_R/pi.*cl;
dCTb_dxSim   = 0.5*ndUT.^2.*c_R/pi.*clSim;
dCFTb_dx     = 0.5*ndUT.^2.*(c_R/pi).*(-phiang.*cl+cd);
dCFTb_dxSim  = 0.5*ndUT.^2.*(c_R/pi).*(-phiangSim.*clSim+cdSim);
dCHb_dx      = -cos(psiM).*sin(betaM).*dCTb_dx + sin(psiM).*dCFTb_dx;
dCHb_dxSim   = -cos(psiM).*sin(betaM).*dCTb_dxSim + sin(psiM).*dCFTb_dxSim;
dCYb_dx      = -sin(psiM).*sin(betaM).*dCTb_dx - cos(psiM).*dCFTb_dx;
dCYb_dxSim   = -sin(psiM).*sin(betaM).*dCTb_dxSim - cos(psiM).*dCFTb_dxSim;
dCPb_dx      = xM.*dCFTb_dx;
dCPb_dxSim   = xM.*dCFTb_dxSim;

ndRlState = struct('xM',xM,...,
                   'psiM',psiM,...,
                   'xAM',xAM,...,
                   'yAM',yAM,...,
                   'lambdai',lambdai,...,
                   'ndUT',ndUT,...,
                   'ndUP',ndUP,...,      
                   'ndUL',ndUL,...,       
                   'phiang',phiang,...,
                   'phiangSim',phiangSim,...,
                   'theta',theta,...,
                   'alpha',alpha,...,
                   'alphaSim',alphaSim,...,
                   'betaM',betaM,...,
                   'Mloc',Mloc,...,
                   'Reloc',Reloc,...,
                   'kRedLoc',kRedLoc,...,
                   'MkRedLoc',MkRedLoc,...,
                   'cl',cl,...,
                   'clSim',clSim,...,
                   'cd',cd,...,
                   'cdSim',cdSim,...,
                   'k',k,...,
                   'kSim',kSim,...,
                   'dCTb_dx',dCTb_dx,...,  
                   'dCTb_dxSim',dCTb_dxSim,...,
                   'dCFTb_dx',dCFTb_dx,...,
                   'dCFTb_dxSim',dCFTb_dxSim,...,
                   'dCHb_dx',dCHb_dx,...,
                   'dCHb_dxSim',dCHb_dxSim,...,
                   'dCYb_dx',dCYb_dx,...,
                   'dCYb_dxSim',dCYb_dxSim,...,
                   'dCPb_dx',dCPb_dx,...,
                   'dCPb_dxSim',dCPb_dxSim);


