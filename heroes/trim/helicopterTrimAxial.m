function F = helicopterTrimAxial(x,flightConditionT,muWT,ndHe,options)

n = size(flightConditionT,2);

ndMR = ndHe.mainRotor;
ndTR = ndHe.tailRotor;
GT   = options.GT;
aeromechanicModel = options.aeromechanicModel;


theta      = [x(3,:); x(4,:); x(5,:)];
thetatr    = [x(6,:);zeros(1,n);zeros(1,n)];
beta       = [x(7,:); x(8,:); x(9,:)];
lambda     = [x(10,:); x(11,:); x(12,:)];

Psi      = zeros(1,n);
Theta    = x(1,:);
Phi      = x(2,:);

fCV  = zeros(6,n);
GA   = zeros(3,n);
GAtr = zeros(3,n);

epsx    = ndHe.geometry.epsilonx;
epsy    = ndHe.geometry.epsilony;
epstr   = ndHe.geometry.thetatr;

MAF   = TAF(epsx,epsy);
MAtrF = TAtrF(epstr);

for i = 1:n
    MFT        = TFT(Psi(i),Theta(i),Phi(i));
    fCV(1:3,i) = MFT*flightConditionT(1:3,i);
    fCV(4:6,i) = flightConditionT(4:6,i);
    muWV       = MFT*muWT;
    GA(:,i)    = MAF*MFT*[0;0;GT];
    GAtr(:,i)  = MAtrF*MFT*[0;0;GT];
end

vel = velocities(fCV,muWV,lambda,beta,ndHe,options);

flightConditionA   = vel.A;
muWA               = vel.WA;
flightConditionAtr = vel.Atr;
muWAtr             = vel.WAtr;

[CFW,CFmr,CMmr,CMFmr,CFtr,CMtr,CMFtr,CFf,CMf,CMFf,CFvf,CMvf,CMFvf,...
CFlHTP,CMlHTP,CMFlHTP,CFrHTP,CMrHTP,CMFrHTP] =  getHeForcesAndMoments(x,vel,ndHe,options);

% Complete System

    F(1,:) = CFmr(1,:)+CFtr(1,:)+CFf(1,:)+CFvf(1,:)+CFlHTP(1,:)+CFrHTP(1,:)+CFW(1,:);%-CW*sin(Theta);
    F(2,:) = CFmr(2,:)+CFtr(2,:)+CFf(2,:)+CFvf(2,:)+CFlHTP(2,:)+CFrHTP(2,:)+CFW(2,:);%CW*cos(Theta)*sin(Phi);
    F(3,:) = CFmr(3,:)+CFtr(3,:)+CFf(3,:)+CFvf(3,:)+CFlHTP(3,:)+CFrHTP(3,:)+CFW(3,:);%CW*cos(Theta)*cos(Phi);
    F(4,:) = CMmr(1,:)+CMFmr(1,:)+CMtr(1,:)+CMFtr(1,:)+CMf(1,:)+CMFf(1,:)+CMvf(1,:)+CMFvf(1,:)+CMlHTP(1,:)+CMFlHTP(1,:)+CMrHTP(1,:)+CMFrHTP(1,:);
    F(5,:) = CMmr(2,:)+CMFmr(2,:)+CMtr(2,:)+CMFtr(2,:)+CMf(2,:)+CMFf(2,:)+CMvf(2,:)+CMFvf(2,:)+CMlHTP(2,:)+CMFlHTP(2,:)+CMrHTP(2,:)+CMFrHTP(2,:);
    F(6,:) = CMmr(3,:)+CMFmr(3,:)+CMtr(3,:)+CMFtr(3,:)+CMf(3,:)+CMFf(3,:)+CMvf(3,:)+CMFvf(3,:)+CMlHTP(3,:)+CMFlHTP(3,:)+CMrHTP(3,:)+CMFrHTP(3,:);

for i = 1:n
    F(7:15,i)  = aeromechanicModel(x(7:15,i),theta(:,i),flightConditionA(:,i),GA(:,i),muWA,ndMR,options);
    F(16:24,i) = aeromechanicModel(x(16:24,i),thetatr(:,i),flightConditionAtr(:,i),GAtr(:,i),muWAtr,ndTR,options);
end

