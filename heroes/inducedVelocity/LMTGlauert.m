function [eqs] = LMTGlauert(lambda,CT,flightCondition,muW,beta,options)

CT0  = CT(1);
CT1C = CT(2);
CT1S = CT(3);

mux       = flightCondition(1);
muy       = flightCondition(2);
muz       = flightCondition(3);
omegaAdxA = flightCondition(4);
omegaAdyA = flightCondition(5);
% omegaAdzA = flightCondition(6);

muWx  = muW(1);
muWy  = muW(2);
muWz  = muW(3);

% beta0  = beta(1);
beta1C = beta(2);
beta1S = beta(3);

lambda0  = lambda(1);
lambda1C = lambda(2);
lambda1S = lambda(3);

Lambda0  = -lambda0*((mux+muWx)^2+lambda0^2+2*lambda0*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))+(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2+(muy+muWy)^2)^(1/2)+1/8*(-6*lambda1S^2*lambda0*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2-6*lambda1C^2*lambda0*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2-2*lambda1C^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*(muy+muWy)^2-2*lambda1C^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^3-2*lambda1S^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^3-6*lambda1S^2*lambda0^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))+2*lambda1S*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^3*omegaAdxA-2*lambda1S^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*(muy+muWy)^2+2*lambda1S*lambda0^3*omegaAdxA-6*lambda1C^2*lambda0^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))-lambda0*omegaAdyA^2*(muy+muWy)^2-2*lambda1C*lambda0^3*omegaAdyA-2*(mux+muWx)^2*lambda1S^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))-2*(mux+muWx)^2*lambda1C^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))-2*lambda1C*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^3*omegaAdyA-lambda0*omegaAdxA^2*(muy+muWy)^2-lambda0*(mux+muWx)^2*omegaAdxA^2-lambda0*(mux+muWx)^2*omegaAdyA^2-3*lambda1C^2*lambda0*(muy+muWy)^2-3*lambda1S^2*lambda0*(muy+muWy)^2-3*lambda0*(mux+muWx)^2*lambda1S^2-3*lambda0*(mux+muWx)^2*lambda1C^2-4*lambda0*(mux+muWx)^2*lambda1C*omegaAdyA+6*lambda1S*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2*omegaAdxA*lambda0+4*lambda1S*lambda0*omegaAdxA*(muy+muWy)^2-2*lambda1C^2*lambda0^3-2*lambda1S^2*lambda0^3-6*lambda1C*lambda0^2*omegaAdyA*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))-4*lambda1C*lambda0*omegaAdyA*(muy+muWy)^2-6*lambda1C*lambda0*omegaAdyA*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2-2*(mux+muWx)^2*lambda1C*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*omegaAdyA+4*lambda0*(mux+muWx)^2*lambda1S*omegaAdxA-2*lambda1C*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*omegaAdyA*(muy+muWy)^2+6*lambda1S*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*omegaAdxA*lambda0^2+2*lambda1S*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*omegaAdxA*(muy+muWy)^2+2*(mux+muWx)^2*lambda1S*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*omegaAdxA)/((mux+muWx)^2+lambda0^2+2*lambda0*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))+(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2+(muy+muWy)^2)^(3/2);
Lambda1C = 1/3*(-4*lambda0^2*lambda1C-2*lambda0^2*omegaAdyA-6*lambda0*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1C-2*lambda0*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*omegaAdyA-2*lambda1C*(mux+muWx)^2-2*lambda1C*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2-2*lambda1C*(muy+muWy)^2)/((mux+muWx)^2+lambda0^2-2*lambda0*beta1C*(mux+muWx)-2*lambda0*beta1S*(muy+muWy)+2*lambda0*(muz+muWz)+beta1C^2*(mux+muWx)^2+2*beta1C*(mux+muWx)*beta1S*(muy+muWy)-2*beta1C*(mux+muWx)*(muz+muWz)+beta1S^2*(muy+muWy)^2-2*beta1S*(muy+muWy)*(muz+muWz)+(muz+muWz)^2+(muy+muWy)^2)^(1/2);
Lambda1S = 1/3*(-4*lambda0^2*lambda1S+2*lambda0^2*omegaAdxA-6*lambda0*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1S+2*lambda0*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*omegaAdxA-2*lambda1S*(mux+muWx)^2-2*lambda1S*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2-2*lambda1S*(muy+muWy)^2)/((mux+muWx)^2+lambda0^2-2*lambda0*beta1C*(mux+muWx)-2*lambda0*beta1S*(muy+muWy)+2*lambda0*(muz+muWz)+beta1C^2*(mux+muWx)^2+2*beta1C*(mux+muWx)*beta1S*(muy+muWy)-2*beta1C*(mux+muWx)*(muz+muWz)+beta1S^2*(muy+muWy)^2-2*beta1S*(muy+muWy)*(muz+muWz)+(muz+muWz)^2+(muy+muWy)^2)^(1/2);

[eqs] = [CT0/2 - Lambda0;...
        CT1C/2 - Lambda1C;...
        CT1S/2 - Lambda1S];
end
