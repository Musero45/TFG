function lambda = linearInflowOld(CT,flightCondition,muW,beta,varargin)

% FIXME To be documented.
% Test completed:
% Glauert VS momentum Theory test OK TolFun needs to be lower than default
% Glauert + Coleman test OK Padfield's figure
% Drees-1C, Payne, White, Pitt & Howlett test OK same tends. See Chen's report
% Drees-1S??
% Lateral flight leads to lambda1S as expected. Backward flight leads to -lambda1C.
% Checked frame rotation See inflowFrameTest

options      = parseOptions(varargin,@setHeroesRigidOptions);
nlSolver     = options.nlSolver;
lambda0Model = options.inducedVelocityModel;
lambda1Model = options.armonicInflowModel;

CT0  = CT(1);
CT1C = CT(2);
CT1S = CT(3);

mux    = flightCondition(1);
muy    = flightCondition(2);
muz    = flightCondition(3);
muWx   = muW(1);
muWy   = muW(2);
muWz   = muW(3);
beta1C = beta(2);
beta1S = beta(3);

muzp   = muz+muWz-beta1C*(mux+muWx)-beta1S*(muy+muWy);

lambdai0 = -sign(CT0)*sqrt(abs(CT0)/2);

if strcmp(lambda0Model,'momentumTheory')
    system2solve = @(lambda) averageInflowEqs(lambda,CT,flightCondition(1:3),muW);
    initialCondition = [lambdai0;.375*CT1C/lambdai0;.375*CT1S/lambdai0];
    lambda = nlSolver(system2solve,initialCondition,options);

elseif strcmp(lambda0Model,'Cuerva')
    system2solve = @(lambda) Cuerva(lambda,CT0,mux,muWx,muy,muWy,muzp);
    lambda0 = nlSolver(system2solve,lambdai0,options);

elseif strcmp(lambda0Model,'Rand') %Rand's Equation: Tip Path Plane + lambda vars
    if (muzp >= sqrt(2*CT0))
        lambda0 = 0.5*(-muzp+sqrt(muzp^2-2*CT0));
    elseif (muzp > 0)
        lambda0 = -sqrt(CT0/2)-0.5*muzp-25/12*muzp^2*sqrt(2/CT0)+7/6*muzp^3*2/CT0; 
    else
        lambda0 = -0.5*(muzp+sqrt(muzp^2+2*CT0));
    end
    lambda0 = lambda0/sqrt(1+((mux+muWx)^2+(muy+muWy)^2)*2/CT0);
    
elseif strcmp(lambda0Model,'Glauert')
    system2solve = @(lambda) Glauert(lambda,CT0,mux,muWx,muy,muWy,muzp);
    lambda0 = nlSolver(system2solve,lambdai0,options);
else
     error('linearInflow:inducedModelChk', 'Wrong induced velocity model. Check heroesRigidOptions')
end

if strcmp(lambda0Model,'momentumTheory') == 0
    
    muxy  = sqrt((mux+muWx)^2+(muy+muWy)^2);
    lam   = (muz+muWz+lambda0);
    xi    = atan2(muxy,-lam);
    
    if muxy == 0 %Only to avoid NaN in hover
        cpsi0 = 0;
        spsi0 = 0;
    else
        cpsi0 = (mux+muWx)/muxy;
        spsi0 = (muy+muWy)/muxy;
    end
    
    if strcmp(lambda1Model,'Coleman')
        if xi > pi/2
            kx = 1/tan(xi/2); %Correction given in Padfield for skew angles greater than pi/2
        else
            kx = tan(xi/2);
        end
        ky = 0;
    elseif strcmp(lambda1Model,'Drees')
        if xi > pi/2
            kx = 4/3*(1-1.8*muxy^2)/tan(xi/2); %Also corrected in the same way than before
        else
            kx = 4/3*(1-1.8*muxy^2)*tan(xi/2);
        end
        ky = -2*muxy;
    elseif strcmp(lambda1Model,'Payne')
        if xi > pi/2
            kx = -4/3*tan(xi)/(1.2-tan(xi)); %Modified tan(xi)=>-tan(xi)
        else
            kx = 4/3*tan(xi)/(1.2+tan(xi));
        end
        ky = 0;
    elseif strcmp(lambda1Model,'White')
        kx = sqrt(2)*sin(xi);
        ky = 0;
    elseif strcmp(lambda1Model,'Pitt')
         if xi > pi/2
            kx = 15*pi/32/tan(xi/2); %Same modification as Coleman's for skew angles greater than pi/2
        else
            kx = 15*pi/32*tan(xi/2);
        end
        ky = 0;
    elseif strcmp(lambda1Model,'Howlett')
        kx = (sin(xi))^2;
        ky = 0;
    elseif strcmp(lambda1Model,'none')
        kx = 0;
        ky = 0;
    else
         error('linearInflow:armonicModelChk', 'Wrong armonic inflow model. Check heroesRigidOptions')
    end

    lambda1C = lambda0*(kx*cpsi0+ky*spsi0);
    lambda1S = lambda0*(-kx*spsi0+ky*cpsi0);
    
    lambda = [lambda0; lambda1C; lambda1S];
end

end

function f = Cuerva(x,CT0,mux,muWx,muy,muWy,muzp)
    f = CT0+2*.745*x.*sqrt((mux+muWx)^2+(muy+muWy)^2+.447^2*muzp^2+(x+muzp)^2);
end

function f = Glauert(x,CT0,mux,muWx,muy,muWy,muzp)
    f = CT0+2*x.*sqrt((mux+muWx)^2+(muy+muWy)^2+(x+muzp)^2);
end