function F = getStabilityEquations (t,x,control,muWV,y0,ndHe,options)

nlSolver = options.nlSolver;
aeromechanicModel = options.aeromechanicModel;
GT = options.GT;

m(1) = size(x,2);
m(2) = size(control,2);
n = max(m);

F = zeros (9,n);

for i = 1:n
    
    
    %State vector in flight mechanic LO|LA order
    
    muVx     = x(1,i);
    muVz     = x(2,i);
    ndOmegay = x(3,i);
    Theta    = x(4,i);
    muVy     = x(5,i);
    ndOmegax = x(6,i);
    Phi      = x(7,i);
    ndOmegaz = x(8,i);
    Psi      = x(9,i);%ALVARO, uncomment

    %ALVARO: THIS MUST BE MODIFIED TO TAKE THE RIGHT ORDER
    %theta0,theta1S,theta1C,theta0tr...right now the order is
    %the aeromechanic order theta0,thea1C,theta1S,theta0tr
    
    %theta    = control(1:3);Old Nano...aeromechanic order
    
    %Control vector in flight mechanic LO|LA order is control(:)
    
    theta    = [control(1);control(3);control(2)];%New ALVARO: with
    %this definition of the main rotor control angle,
    %control=[t0,t1S,t1C,t0tr] and theta=[t0,t1C,t1S].
    %angle ordOld 
    thetatr  = control(4);

    ndMR = ndHe.mainRotor;
    ndTR = ndHe.tailRotor;

    aG = ndMR.aG;

    inertia = ndHe.inertia;

    omega = y0(19);
    
    CW     = inertia.CW*omega^(-2);%ALVARO
    gammax = inertia.gammax;
    gammay = inertia.gammay;
    gammaz = inertia.gammaz;
    RIxy   = inertia.RIxy;
    RIzy   = inertia.RIzy;
    RIxyy  = inertia.RIxyy;
    RIxzy  = inertia.RIxzy;
    RIyzy  = inertia.RIyzy;
    
    R = [[ RIxy  -RIxyy -RIxzy];
         [-RIxyy    1   -RIyzy];
         [-RIxzy -RIyzy   RIzy]];

    fCV = [muVx; muVy; muVz; ndOmegax; ndOmegay; ndOmegaz];
    
    %MFT  = TFT(0,Theta,Phi);Old version
    MFT  = TFT(Psi,Theta,Phi);%ALVARO new version
    geom = ndHe.geometry;
    epsx = geom.epsilonx;
    epsy = geom.epsilony;
    MAF  = TAF(epsx,epsy);
    MFA  = MAF'; 
    MAT  = MAF*MFT; 
    GA   = MAT*[0;0;GT];

    OfO = [geom.Xcg;geom.Ycg;geom.Zcg];
    OfA = [geom.ndls;geom.ndds;0];
    OfA  = OfA+MFA*[0;0;geom.ndh];
    OA = -OfO+OfA;
    muOmega    = cross(fCV(4:6),OA);
    fCA(1:3,1) = -MAF*(fCV(1:3) + muOmega);
    fCA(4:6,1) = MAF*fCV(4:6);
    muWA       = MAF*muWV;
    
%     vel  = velocities(fCV,muWV,y0(4:6),y0(1:3),ndHe,varargin);
%     fCA  = vel.Atr;
%     muWA = vel.WAtr;
    
    initialCondition = y0(1:9);
    system2solve = @(y) aeromechanicModel(y,theta,fCA,GA,muWA,ndMR,options);
    yMR = nlSolver(system2solve,initialCondition,options);
%     for j=1:9
%         if abs(yMR(j))<1e-12
%             yMR(j)=0;
%         end
%     end

    vel = velocities(fCV,muWV,yMR(4:6),yMR(1:3),ndHe,options);
    
    flightConditionAtr = vel.Atr;
    muWAtr             = vel.WAtr;
    
    epstr = ndHe.geometry.thetatr;
    MAtrF = TAtrF(epstr);
    GAtr  = MAtrF*MFT*[0;0;GT];
    
    initialCondition = y0(10:18);
    system2solve = @(y) aeromechanicModel(y,[thetatr;0;0],flightConditionAtr,GAtr,muWAtr,ndTR,options);
    yTR = nlSolver(system2solve,initialCondition,options);
%     for j=1:9
%         if abs(yTR(j))<1e-12
%             yTR(j)=0;
%         end
%     end
   
    omega = y0(19);%ALVARO
    
    %y = [Theta; Phi; theta; thetatr; yMR; yTR];%Old Nano
    y = [Theta; Phi; theta; thetatr; yMR; yTR; omega; Psi];%ALVARO

    [CFW,CFmr,CMmr,CMFmr,CFtr,CMtr,CMFtr,CFf,CMf,CMFf,CFvf,CMvf,CMFvf,...
    CFlHTP,CMlHTP,CMFlHTP,CFrHTP,CMrHTP,CMFrHTP] =  getHeForcesAndMoments(y,vel,ndHe,options);

    %CFx =
    %CFmr(1,:)+CFtr(1,:)+CFf(1,:)+CFvf(1,:)+CFlHTP(1,:)+CFrHTP(1,:)+CFW(1,:);%-CW*sin(Theta);Old Nano
    CFx = CFmr(1,:)+CFtr(1,:)+CFf(1,:)+CFvf(1,:)+CFlHTP(1,:)+CFrHTP(1,:);%New ALVARO, CFW removed to be explicily included afterwards
    %CFy = CFmr(2,:)+CFtr(2,:)+CFf(2,:)+CFvf(2,:)+CFlHTP(2,:)+CFrHTP(2,:)+CFW(2,:);%CW*cos(Theta)*sin(Phi);Old Nano
    CFy = CFmr(2,:)+CFtr(2,:)+CFf(2,:)+CFvf(2,:)+CFlHTP(2,:)+CFrHTP(2,:);%New ALVARO, CFW removed to be explicily included afterwards
    %CFz = CFmr(3,:)+CFtr(3,:)+CFf(3,:)+CFvf(3,:)+CFlHTP(3,:)+CFrHTP(3,:)+CFW(3,:);%CW*cos(Theta)*cos(Phi);Old Nano
    CFz = CFmr(3,:)+CFtr(3,:)+CFf(3,:)+CFvf(3,:)+CFlHTP(3,:)+CFrHTP(3,:);%New ALVARO, CFW removed to be explicily included afterwards
    CMx = CMmr(1,:)+CMFmr(1,:)+CMtr(1,:)+CMFtr(1,:)+CMf(1,:)+CMFf(1,:)+CMvf(1,:)+CMFvf(1,:)+CMlHTP(1,:)+CMFlHTP(1,:)+CMrHTP(1,:)+CMFrHTP(1,:);
    CMy = CMmr(2,:)+CMFmr(2,:)+CMtr(2,:)+CMFtr(2,:)+CMf(2,:)+CMFf(2,:)+CMvf(2,:)+CMFvf(2,:)+CMlHTP(2,:)+CMFlHTP(2,:)+CMrHTP(2,:)+CMFrHTP(2,:);
    CMz = CMmr(3,:)+CMFmr(3,:)+CMtr(3,:)+CMFtr(3,:)+CMf(3,:)+CMFf(3,:)+CMvf(3,:)+CMFvf(3,:)+CMlHTP(3,:)+CMFlHTP(3,:)+CMrHTP(3,:)+CMFrHTP(3,:);

    %New matrix form
    
    RHSF  = aG/CW*[CFx;CFy;CFz]-cross([ndOmegax;ndOmegay;ndOmegaz],[muVx;muVy;muVz])+MFT*[0;0;aG];
    RHSM  = R\(gammay*[CMx;CMy;CMz]-cross([ndOmegax;ndOmegay;ndOmegaz],R*[ndOmegax;ndOmegay;ndOmegaz]));
    
            
    %----------------------------------------------------------------------
    % Combined moments (acoording to Padfield for derivatives calculations)
    
    CMtmr   = CMmr+CMFmr;
    CMttr   = CMtr+CMFtr;
    CMtf    = CMf+CMFf;
    CMtvf   = CMvf+CMFvf;
    CMtlHTP = CMlHTP+CMFlHTP;
    CMtrHTP = CMrHTP+CMFrHTP;
    
    
    
    CMcom     = R\(gammay*[CMx;CMy;CMz]);
    CMmrcom   = R\(gammay*[CMtmr(1,:);CMtmr(2,:);CMtmr(3,:)]);
    CMtrcom   = R\(gammay*[CMttr(1,:);CMttr(2,:);CMttr(3,:)]);
    CMfcom    = R\(gammay*[CMtf(1,:);CMtf(2,:);CMtf(3,:)]);
    CMvfcom   = R\(gammay*[CMtvf(1,:);CMtvf(2,:);CMtvf(3,:)]);
    CMlHTPcom = R\(gammay*[CMtlHTP(1,:);CMtlHTP(2,:);CMtlHTP(3,:)]);
    CMrHTPcom = R\(gammay*[CMtrHTP(1,:);CMtrHTP(2,:);CMtrHTP(3,:)]);
    
    
    
    %======================================================================
    % F(1:9) function F(x,u)
    %======================================================================
    
    %Longitudinal dynamics
    F(1,i) = RHSF(1);%du/dt%New ALVARO;
    F(2,i) = RHSF(3);%dw/dt%New ALVARO;
    F(3,i) = RHSM(2);%domy/dt%New ALVARO;
    F(4,i) = cos(Phi)*ndOmegay - sin(Phi)*ndOmegaz;%dTheta/dt%New ALVARO;
    
    %Lateral dynamics
    
    F(5,i) = RHSF(2);%dv/dt%New ALVARO;
    F(6,i) = RHSM(1);%domx/dt%New ALVARO;
    F(7,i) = ndOmegax+sin(Phi)*sin(Theta)*ndOmegay/cos(Theta)+cos(Phi)*sin(Theta)*ndOmegaz/cos(Theta);%dPhi/dt%New ALVARO;
    F(8,i) = RHSM(3);%domz/dt%New ALVARO;
    F(9,i) = sin(Phi)*ndOmegay/cos(Theta)+cos(Phi)*ndOmegaz/cos(Theta);%dPsi/dt%New ALVARO;

%Old Nano    
%     A = 2*RIxzy*RIxyy*RIyzy+RIxzy^2+RIxyy^2*RIzy-RIxy*RIzy+RIxy*RIyzy^2;
% 
%     F(1,i) = CFx*aG/CW - ndOmegay*muVz + ndOmegaz*muVy;
%     F(2,i) = CFz*aG/CW - ndOmegax*muVy + ndOmegay*muVx;
%     F(3,i) = -(RIxzy^3-RIxy*RIzy*RIxzy+RIxzy*RIxyy^2+RIxyy*RIyzy*RIxy)/A*ndOmegax^2+(-(-RIxzy*RIxyy+RIxyy*RIzy*RIxzy-RIxy*RIyzy+RIxzy*RIxyy*RIxy-RIxy*RIzy*RIyzy+2*RIxzy^2*RIyzy+RIxy^2*RIyzy)/A*ndOmegay-(RIxy*RIzy^2-RIxyy^2*RIzy-RIxy^2*RIzy-RIxzy^2*RIzy+RIxzy^2*RIxy+RIxy*RIyzy^2)/A*ndOmegaz)*ndOmegax-(RIxyy*RIzy*RIyzy-RIxyy*RIyzy*RIxy-RIxzy*RIxyy^2+RIyzy^2*RIxzy)/A*ndOmegay^2-(RIxzy*RIyzy-RIxzy*RIyzy*RIzy+RIxyy*RIzy*RIxy+RIxyy*RIzy-2*RIxzy^2*RIxyy-RIxyy*RIzy^2-RIxzy*RIyzy*RIxy)/A*ndOmegaz*ndOmegay-(RIxy*RIzy*RIxzy-RIxzy^3-RIyzy^2*RIxzy-RIxyy*RIzy*RIyzy)/A*ndOmegaz^2-(RIxyy*RIzy*CMx*gammax*RIxy+RIxzy*RIxyy*CMz*gammaz*RIzy-RIxzy^2*CMy*gammay+RIxy*RIyzy*CMz*gammaz*RIzy+RIxy*RIzy*CMy*gammay+RIxzy*RIyzy*CMx*gammax*RIxy)/A;
%     F(4,i) = cos(Phi)*ndOmegay - sin(Phi)*ndOmegaz;
%     F(5,i) = CFy*aG/CW - ndOmegaz*muVx + ndOmegax*muVz;
%     F(6,i) = (-RIxzy*RIxyy+RIxzy^2*RIyzy-RIxyy^2*RIyzy+RIxyy*RIzy*RIxzy)/A*ndOmegax^2+((RIxyy*RIyzy+2*RIyzy^2*RIxzy-RIxyy*RIyzy*RIxy-RIxzy*RIxy-RIzy*RIxzy+RIxyy*RIzy*RIyzy+RIxzy)/A*ndOmegay+(RIxzy*RIyzy*RIxy+RIxyy*RIzy-RIxzy*RIyzy*RIzy-2*RIyzy^2*RIxyy-RIxyy*RIzy^2+RIxyy*RIzy*RIxy-RIxzy*RIyzy)/A*ndOmegaz)*ndOmegax+(RIxzy*RIxyy+RIyzy^3-RIzy*RIyzy+RIxyy^2*RIyzy)/A*ndOmegay^2+(RIzy^2-RIzy-RIyzy^2*RIzy+RIxzy^2+RIyzy^2-RIxyy^2*RIzy)/A*ndOmegaz*ndOmegay+(-RIxzy^2*RIyzy-RIyzy^3+RIzy*RIyzy-RIxyy*RIzy*RIxzy)/A*ndOmegaz^2+(-RIzy*CMx*gammax*RIxy-RIxzy*CMz*gammaz*RIzy+RIyzy^2*CMx*gammax*RIxy-RIxyy*RIzy*CMy*gammay-RIxyy*RIyzy*CMz*gammaz*RIzy-RIxzy*RIyzy*CMy*gammay)/A;
%     F(7,i) = ndOmegax+sin(Phi)*sin(Theta)*ndOmegay/cos(Theta)+cos(Phi)*sin(Theta)*ndOmegaz/cos(Theta);
%     F(8,i) = -(-RIxyy^3-RIxzy^2*RIxyy+RIxy*RIxyy-RIxzy*RIyzy*RIxy)/A*ndOmegax^2+(-(-RIxyy^2*RIxy-RIxy+RIxy^2+RIxyy^2+RIxzy^2-RIxy*RIyzy^2)/A*ndOmegay-(RIxy*RIyzy-2*RIxyy^2*RIyzy-RIxzy*RIxyy+RIxy*RIzy*RIyzy-RIxy^2*RIyzy+RIxyy*RIzy*RIxzy-RIxzy*RIxyy*RIxy)/A*ndOmegaz)*ndOmegax-(RIxyy^3+RIxzy*RIyzy+RIyzy^2*RIxyy-RIxy*RIxyy)/A*ndOmegay^2-(RIxyy*RIyzy+2*RIxzy*RIxyy^2+RIxzy+RIxyy*RIyzy*RIxy-RIxzy*RIxy-RIzy*RIxzy-RIxyy*RIzy*RIyzy)/A*ndOmegaz*ndOmegay-(RIxzy*RIyzy*RIxy+RIxzy^2*RIxyy-RIxzy*RIyzy-RIyzy^2*RIxyy)/A*ndOmegaz^2-(RIxzy*RIxyy*CMy*gammay+RIxzy*CMx*gammax*RIxy+RIxy*RIyzy*CMy*gammay+RIxyy*RIyzy*CMx*gammax*RIxy+RIxy*CMz*gammaz*RIzy-RIxyy^2*CMz*gammaz*RIzy)/A;
%     F(9,i) = sin(Phi)*ndOmegay/cos(Theta)+cos(Phi)*ndOmegaz/cos(Theta);

   

%==========================================================================
% F(10:15) Functions for stability derivatives and control derivatives 
%==========================================================================
    
    F(10,i) = aG/CW*CFx;
    F(11,i) = aG/CW*CFz;
    F(12,i) = CMcom(2,:);%CMy;
    F(13,i) = aG/CW*CFy;
    F(14,i) = CMcom(1,:);%CMx;
    F(15,i) = CMcom(3,:);%CMz;
    
%==========================================================================
% Funtions for individual elements stability derivatives and control derivatives
%==========================================================================
%
% F(16:21) main rotor

    F(16,i) = aG/CW*CFmr(1,:);%main rotor CFx;
    F(17,i) = aG/CW*CFmr(3,:);%main rotor CFz;
    F(18,i) = CMmrcom(2,:);%CMmr(2,:)+CMFmr(2,:);%main rotor CMy;CMmrcom(2,:)
    F(19,i) = aG/CW*CFmr(2,:);%main rotor CFy;
    F(20,i) = CMmrcom(1,:);%CMmr(1,:)+CMFmr(1,:);%main rotor CMx;
    F(21,i) = CMmrcom(3,:);%CMmr(3,:)+CMFmr(3,:);%main rotor CMz;
    
% F(22:27) tail rotor

    F(22,i) = aG/CW*CFtr(1,:);%tail rotor CFx;
    F(23,i) = aG/CW*CFtr(3,:);%tail rotor CFz;
    F(24,i) = CMtrcom(2,:);%CMtr(2,:)+CMFtr(2,:);%tail rotor CMy;
    F(25,i) = aG/CW*CFtr(2,:);%tail rotor CFy;
    F(26,i) = CMtrcom(1,:);%CMtr(1,:)+CMFtr(1,:);%tail rotor CMx;
    F(27,i) = CMtrcom(3,:);%CMtr(3,:)+CMFtr(3,:);%tail rotor CMz;
    
% F(28:33) fuselage

    F(28,i) = aG/CW*CFf(1,:);%fuselage CFx;
    F(29,i) = aG/CW*CFf(3,:);%fuselage CFz;
    F(30,i) = CMfcom(2,:);%CMf(2,:)+CMFf(2,:);%fuselage CMy;
    F(31,i) = aG/CW*CFf(2,:);%fuselage CFy;
    F(32,i) = CMfcom(1,:);%CMf(1,:)+CMFf(1,:);%fuselage CMx;
    F(33,i) = CMfcom(3,:);%CMf(3,:)+CMFf(3,:);%fuselage CMz;
    
% F(34:39) vertical fin

    F(34,i) = aG/CW*CFvf(1,:);%vertical fin CFx;
    F(35,i) = aG/CW*CFvf(3,:);%vertical fin CFz;
    F(36,i) = CMvfcom(2,:);%CMvf(2,:)+CMFvf(2,:);%vertical fin CMy;
    F(37,i) = aG/CW*CFvf(2,:);%vertical fin CFy;
    F(38,i) = CMvfcom(1,:);%CMvf(1,:)+CMFvf(1,:);%vertical fin CMx;
    F(39,i) = CMvfcom(3,:);%CMvf(3,:)+CMFvf(3,:);%vertical fin CMz;
    
% F(40:45) left horizontal stabilizer

    F(40,i) = aG/CW*CFlHTP(1,:);%left horizontal stabilizer CFx;
    F(41,i) = aG/CW*CFlHTP(3,:);%left horizontal stabilizer CFz;
    F(42,i) = CMlHTPcom(2,:);%CMlHTP(2,:)+CMFlHTP(2,:);%left horizontal stabilizer CMy;
    F(43,i) = aG/CW*CFlHTP(2,:);%left horizontal stabilizer CFy;
    F(44,i) = CMlHTPcom(1,:);%CMlHTP(1,:)+CMFlHTP(1,:);%left horizontal stabilizer CMx;
    F(45,i) = CMlHTPcom(3,:);%CMlHTP(3,:)+CMFlHTP(3,:);%left horizontal stabilizer CMz;
    
% F(46:51) right horizontal stabilizer

    F(46,i) = aG/CW*CFrHTP(1,:);%right horizontal stabilizer CFx;
    F(47,i) = aG/CW*CFrHTP(3,:);%right horizontal stabilizer CFz;
    F(48,i) = CMrHTPcom(2,:);%CMrHTP(2,:)+CMFrHTP(2,:);%right horizontal stabilizer CMy;
    F(49,i) = aG/CW*CFrHTP(2,:);%right horizontal stabilizer CFy;
    F(50,i) = CMrHTPcom(1,:);%CMrHTP(1,:)+CMFrHTP(1,:);%right horizontal stabilizer CMx;
    F(51,i) = CMrHTPcom(3,:);%CMrHTP(3,:)+CMFrHTP(3,:);%right horizontal stabilizer CMz;

%==========================================================================

end
