function F = energyEquations (CW,VOR,gammaT,lambdaI,kappa,fS,sigma,...
                                    Cd0,K,CP,kG,options)
%   energyEquations gives the 2 equations system for solve the energy main
%     rotor problem incluthing the ground effect and selecting the desired 
%     induced velocity model


% Get induced velocity model
indVelModel = options.inducedVelocity;

% Pass Vor and gammaT to mu terms
[mux,muWx,muy,muWy,muzp]  = VORgammaT2mu(VOR,gammaT);

% First equation: induced velocity
F(1,1) = indVelModel(lambdaI,CW,mux,muWx,muy,muWy,muzp);

% second equation: power terms for main rotor
CPi   = - lambdaI.*CW.*kappa*kG;
CPf   =   fS/2*(VOR).^3;
CPcd0 =   sigma*Cd0/8*(1+K*(VOR*cos(gammaT)).^2);
CPg   =   VOR*sin(gammaT)*CW;

F(2,1)     = CPi + CPf + CPcd0 + CPg - CP;
