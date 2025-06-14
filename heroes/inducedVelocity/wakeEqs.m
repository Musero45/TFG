function F = wakeEqs(lambda,CT,flightCondition,muW,beta,options)

lambda0Model = options.uniformInflowModel;
lambda1Model = options.armonicInflowModel;

CT0  = CT(1);
lambda0  = lambda(1);
lambda1C = lambda(2);
lambda1S = lambda(3);
mux    = flightCondition(1);
muy    = flightCondition(2);
muz    = flightCondition(3);
muWx   = muW(1);
muWy   = muW(2);
muWz   = muW(3);
beta1C = beta(2);
beta1S = beta(3);

muzp   = muz+muWz-beta1C*(mux+muWx)-beta1S*(muy+muWy);

muxy  = sqrt((mux+muWx)^2+(muy+muWy)^2);
lam   = (muz+muWz+lambda0);
xi    = atan2(muxy,-lam);

[kx,ky] = lambda1Model(xi,muxy);

if muxy == 0 %Only to avoid NaN in axial flight
    cpsi0 = 0;
    spsi0 = 0;
else
    cpsi0 = (mux+muWx)/muxy;
    spsi0 = (muy+muWy)/muxy;
end

F(1) = lambda0Model(lambda0,CT0,mux,muWx,muy,muWy,muzp);
F(2) = lambda1C - lambda0*(kx*cpsi0+ky*spsi0);
F(3) = lambda1S - lambda0*(kx*spsi0+ky*cpsi0);

end