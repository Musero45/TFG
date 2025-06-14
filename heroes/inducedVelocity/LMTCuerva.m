function [eqs] = LMTCuerva(lambda,CT,flightCondition,muW,beta,options)

CT0  = CT(1);
CT1C = CT(2);
CT1S = CT(3);

mux       = flightCondition(1);
muy       = flightCondition(2);
muz       = flightCondition(3);
omegaAdxA = flightCondition(4);
omegaAdyA = flightCondition(5);
% omegaAdzA = flightCondition(6); unused

muWx  = muW(1);
muWy  = muW(2);
muWz  = muW(3);

% beta0  = beta(1); unused
beta1C = beta(2);
beta1S = beta(3);

lambda0  = lambda(1);
lambda1C = lambda(2);
lambda1S = lambda(3);

A = 0.745;
B = 0.447;

Lambda0  = -A*lambda0*((mux+muWx)^2+lambda0^2+2*lambda0*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))+(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2+B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2+(muy+muWy)^2)^(1/2)+1/4*(-1/2*A*lambda0^3*B^2*omegaAdyA^2-A*lambda1C^2*lambda0^3-A*lambda1S^2*lambda0^3-3*A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2*lambda1S^2*lambda0-3*A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2*lambda1C^2*lambda0-A*lambda1C*omegaAdyA*lambda0^3+A*B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1S*omegaAdxA*(mux+muWx)^2+A*B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1S*omegaAdxA*(muy+muWy)^2-1/2*A*lambda0*B^2*omegaAdxA^2*(muy+muWy)^2-1/2*A*lambda0*B^2*omegaAdxA^2*(mux+muWx)^2-1/2*A*lambda0*omegaAdxA^2*(mux+muWx)^2-1/2*A*lambda0^3*B^2*omegaAdxA^2-1/2*A*lambda0*omegaAdxA^2*(muy+muWy)^2+3*A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2*lambda1S*lambda0*omegaAdxA+A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1S*omegaAdxA*(mux+muWx)^2+A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1S*omegaAdxA*(muy+muWy)^2+2*A*lambda0*lambda1S*omegaAdxA*(mux+muWx)^2+2*A*lambda0*lambda1S*omegaAdxA*(muy+muWy)^2+3*A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1S*omegaAdxA*lambda0^2+2*A*B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^3*lambda1S*omegaAdxA+A*B^4*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^3*lambda1S*omegaAdxA+3*A*B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2*lambda1S*lambda0*omegaAdxA-3*A*B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2*lambda1C*lambda0*omegaAdyA-A*B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1C*omegaAdyA*(mux+muWx)^2-A*B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1C*omegaAdyA*(muy+muWy)^2-1/2*A*lambda0*B^2*omegaAdyA^2*(muy+muWy)^2-3*A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2*lambda1C*lambda0*omegaAdyA-A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1C*omegaAdyA*(mux+muWx)^2-A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1C*omegaAdyA*(muy+muWy)^2-2*A*lambda0*lambda1C*omegaAdyA*(mux+muWx)^2-3*A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1C*omegaAdyA*lambda0^2-2*A*B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^3*lambda1C*omegaAdyA-A*B^4*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^3*lambda1C*omegaAdyA+A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^3*lambda1S*omegaAdxA+A*lambda1S*omegaAdxA*lambda0^3-3*A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1S^2*lambda0^2-A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1S^2*(muy+muWy)^2-A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1C^2*(mux+muWx)^2-A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1C^2*(muy+muWy)^2-A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1S^2*(mux+muWx)^2-A*B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^3*lambda1C^2-A*B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^3*lambda1S^2-3/2*A*lambda0*lambda1S^2*(muy+muWy)^2-3/2*A*lambda0*lambda1C^2*(mux+muWx)^2-3/2*A*lambda0*lambda1C^2*(muy+muWy)^2-1/2*A*lambda0*B^2*omegaAdyA^2*(mux+muWx)^2-3/2*A*lambda0*B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2*lambda1C^2-3/2*A*lambda0*B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2*lambda1S^2-2*A*lambda0*lambda1C*omegaAdyA*(muy+muWy)^2-3*A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1C^2*lambda0^2-3/2*A*lambda0*lambda1S^2*(mux+muWx)^2-A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^3*lambda1C*omegaAdyA-A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^3*lambda1S^2-A*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^3*lambda1C^2-1/2*A*lambda0*omegaAdyA^2*(mux+muWx)^2-1/2*A*lambda0*omegaAdyA^2*(muy+muWy)^2)/((mux+muWx)^2+lambda0^2+2*lambda0*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))+(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2+B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2+(muy+muWy)^2)^(3/2);
Lambda1C = 1/3*(-2*A*lambda0*B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*omegaAdyA-2*A*lambda1C*B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2-6*A*lambda0*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1C-2*A*lambda0*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*omegaAdyA-4*A*lambda0^2*lambda1C-2*A*lambda0^2*omegaAdyA-2*A*lambda1C*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2-2*A*lambda1C*(mux+muWx)^2-2*A*lambda1C*(muy+muWy)^2)/((mux+muWx)^2+lambda0^2+2*lambda0*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))+(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2+B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2+(muy+muWy)^2)^(1/2);
Lambda1S = 1/3*(-2*A*lambda1S*(muy+muWy)^2+2*A*lambda0*B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*omegaAdxA-2*A*lambda1S*B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2-6*A*lambda0*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*lambda1S+2*A*lambda0*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))*omegaAdxA-4*A*lambda0^2*lambda1S+2*A*lambda0^2*omegaAdxA-2*A*lambda1S*(mux+muWx)^2-2*A*lambda1S*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2)/((mux+muWx)^2+lambda0^2+2*lambda0*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))+(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2+B^2*(-beta1C*(mux+muWx)-beta1S*(muy+muWy)+(muz+muWz))^2+(muy+muWy)^2)^(1/2);

eqs = [CT0/2 - Lambda0;...
       CT1C/2 - Lambda1C;...
       CT1S/2 - Lambda1S...
      ];
end