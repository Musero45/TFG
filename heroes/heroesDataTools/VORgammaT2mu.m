function [Mux,MuWx,Muy,MuWy,Muzp]  = VORgammaT2mu(VOR,gammaT)
% Change variables: V/Omega.R and gammaT => mux muzp

Mux  =   VOR.*cos(gammaT);
MuWx =   zeros(size(VOR));
Muy  =   zeros(size(VOR));
MuWy =   zeros(size(VOR));
Muzp = - VOR.*sin(gammaT);

end