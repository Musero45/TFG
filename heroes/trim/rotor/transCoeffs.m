function [CFi, CFg, CMFi, CMiE, CMgE, CMel] = transCoeffs(beta,theta,flightCondition,muW,GA,ndRotor,varargin)

% FIXME To be documented and tested.

if length(varargin)==1 
   while iscell(varargin) && length(varargin)==1
      varargin = varargin{1};
   end
end

options   = parseOptions(varargin,@setHeroesRigidOptions);

beta0  = beta(1);
beta1C = beta(2);
beta1S = beta(3);

theta1C = theta(2);
theta1S = theta(3);

muxA = flightCondition(1);
muyA = flightCondition(2);
muzA = flightCondition(3);

omegaAdxA = flightCondition(4);
omegaAdyA = flightCondition(5);
omegaAdzA = flightCondition(6);

muWxA = muW(1);
muWyA = muW(2);
muWzA = muW(3);

GxA = GA(1);
GyA = GA(2);
GzA = GA(3);

rotor = ndRotor;

b        = rotor.b;
sigma0   = rotor.sigma0;
a        = rotor.cldata(1);
ead      = rotor.ead;
epsilonR = rotor.epsilonR;
aG       = rotor.aG;
SBeta    = rotor.SBeta; %WARNING!! SBeta based on non-tapered blades!!
RITB     = rotor.RITB;
RIZB     = rotor.RIZB;
XGB      = rotor.XGB;
muP      = rotor.muP;

mBeta = sigma0*a*SBeta/16;

%Inertial forces
CFixA = b*muP*((muzA+muWzA)*omegaAdyA-(muyA+muWyA)*omegaAdzA);
CFiyA = b*muP*(-(muzA+muWzA)*omegaAdxA+omegaAdzA*(muxA+muWxA));
CFizA = b*muP*((muyA+muWyA)*omegaAdxA-omegaAdyA*(muxA+muWxA));

%Gravitational forces
CFgxA = b*muP*aG*GxA;
CFgyA = b*muP*aG*GyA;
CFgzA = b*muP*aG*GzA;

%Inertial forces moments
CMFixA = b*ead*muP*(beta1S*XGB/2-(ead+XGB)*omegaAdyA);
CMFiyA = b*ead*muP*(-beta1C*XGB/2+(ead+XGB)*omegaAdxA);
CMFizA = b*ead*muP*XGB*(beta1S*omegaAdxA-beta1C*omegaAdyA);

%Gravitational moments in E
CMgExA = -b*beta0*muP*XGB*aG*GyA;
CMgEyA = b*beta0*muP*XGB*aG*GxA;
CMgEzA = 0;

%Inertial and elastic moments in E
if strcmp(options.momentumComputation,'elastic') % CMiE*
    
    CMiExA = muP*XGB*b/2*(beta0*(muzA+muWzA)*omegaAdxA-beta0*(muxA+muWxA)*omegaAdzA+1/epsilonR*...
            ((beta1S-theta1C)*(RIZB-RITB-1)+omegaAdzA*(2*theta1C*(1-RIZB)+beta1S*(RIZB-RITB-1))+...
            omegaAdyA*(1-RIZB-RITB)));
    CMiEyA = muP*XGB*b/2*(beta0*(muzA+muWzA)*omegaAdyA-beta0*(muyA+muWyA)*omegaAdzA+1/epsilonR*...
            ((-beta1C-theta1S)*(RIZB-RITB-1)+omegaAdzA*(2*theta1S*(1-RIZB)-beta1C*(RIZB-RITB-1))-...
             omegaAdxA*(1-RIZB-RITB)));           
    CMelxA = beta1S*(mBeta-b*muP*XGB*ead/2);
    CMelyA = -beta1C*(mBeta-b*muP*XGB*ead/2);
    
elseif strcmp(options.momentumComputation,'aerodynamic') % CMiE
    
    CMiExA = muP*XGB*b*(beta0*(muzA+muWzA)*omegaAdxA-ead*omegaAdyA-1/2*beta1S*ead+...
            (-beta1S*ead-beta0*(muxA+muWxA))*omegaAdzA+1/(2*epsilonR)*...
            ((theta1C*(1-RIZB-RITB)+beta1S*(RITB-1-RIZB))*omegaAdzA-2*RIZB*omegaAdyA));
    CMiEyA = muP*XGB*b*(ead*omegaAdxA+beta0*(muzA+muWzA)*omegaAdyA+1/2*beta1C*ead+...
            (beta1C*ead-beta0*(muyA+muWyA))*omegaAdzA+1/(2*epsilonR)*...
            ((theta1S*(1-RIZB-RITB)-beta1C*(RITB-1-RIZB))*omegaAdzA+2*RIZB*omegaAdxA));
    CMelxA = 0;
    CMelyA = 0;
else
    
    disp('ERROR. Wrong moment computation model. Press Ctrl+C and check heroesRigidOptions')
    pause
    
end

CMiEzA = 0;
CMelzA = 0;

CFi  = [CFixA; CFiyA; CFizA];
CFg  = [CFgxA; CFgyA; CFgzA];
CMFi = [CMFixA; CMFiyA; CMFizA];
CMgE = [CMgExA; CMgEyA; CMgEzA];
CMiE = [CMiExA; CMiEyA; CMiEzA];
CMel = [CMelxA; CMelyA; CMelzA];