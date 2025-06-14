function [F,G,M] = showNdRotorState(beta,theta,lambda,muA,omegaadA,muWA,GA,ndRotor)
%SHOWNDROTORSTATE Summary of this function goes here
%   Detailed explanation goes here

tic

Re       = ndRotor.Re;
M        = ndRotor.M;

zeta     = [0;0;0];

psi2D    = ndRotor.nlRotor.psi2D; 
x2D      = ndRotor.nlRotor.x2D;
psi2Dall = ndRotor.nlRotor.psi2Dall;
x2Dall   = ndRotor.nlRotor.x2Dall;    
cad2Dall = ndRotor.nlRotor.c2adDall;
thetaG2D = ndRotor.nlRotor.thetaG2D;
airfoil  = ndRotor.nlRotor.airfoil;
b        = ndRotor.b;
eada     = ndRotor.ead;
eadb     = ndRotor.ead;

x1D     = x2Dall(1,:);
psi1D   = psi2Dall(:,1); 
    
muxA = muA(1);
muyA = muA(2);
muzA = muA(3);

omxA = omegaadA(1);
omyA = omegaadA(2);
omzA = omegaadA(3);

muWxA = muWA(1);
muWyA = muWA(2);
muWzA = muWA(3);

GxA = GA(1);
GyA = GA(2);
GzA = GA(3);

airmuxA = muxA + muWxA;
airmuyA = muyA + muWyA;
airmuzA = muzA + muWzA;

beta0  = beta(1);
beta1C = beta(2);
beta1S = beta(3);
%beta2C = beta(4);
%beta2S = beta(5);

zeta0  = zeta(1);
zeta1C = zeta(2);
zeta1S = zeta(3);
%zeta2C = zeta(4);
%zeta2S = zeta(5);

theta0  = theta(1);
theta1C = theta(2);
theta1S = theta(3);

lambda0  = lambda(1);
lambda1C = lambda(2);
lambda1S = lambda(3);


%-------------------------------------------------------------------------
% Aerodynamic analysis
%-------------------------------------------------------------------------

Log10Reout   = [];
Mout         = [];
CLout        = [];
CDout        = [];
CMout        = [];
ULadout      = [];
UTadout      = [];
UPadout      = [];
Eout         = [];
ALPHAout     = [];
dTabiout     = [];
dTabpout     = [];
dTabout      = [];
dFTabiout    = [];
dFTabpout    = [];
dFTabout     = [];

CPHIout      = [];
SPHIout      = [];
CBETAout     = [];
SBETAout     = [];
CZETAout     = [];
SZETAout     = [];
  
for nli = 1:length(x2D);
    
    PSI      = psi2D{nli};
    X        = x2D{nli};
    THETAG2D = thetaG2D{nli};
    
    ALPHA3D_CL    = airfoil{nli}.ALPHA3D_CL;
    ALPHA3D_CD    = airfoil{nli}.ALPHA3D_CD;
    ALPHA3D_CM    = airfoil{nli}.ALPHA3D_CM;
    Log10Re3D_CL  = airfoil{nli}.Log10Re3D_CL; 
    Log10Re3D_CD  = airfoil{nli}.Log10Re3D_CD;
    Log10Re3D_CM  = airfoil{nli}.Log10Re3D_CM;
    M3D_CL        = airfoil{nli}.M3D_CL;
    M3D_CD        = airfoil{nli}.M3D_CD;
    M3D_CM        = airfoil{nli}.M3D_CM;
    CL3D          = airfoil{nli}.CL3D;
    CD3D          = airfoil{nli}.CD3D;
    CM3D          = airfoil{nli}.CM3D;
            
    CPSI         = cos(PSI);
    SPSI         = sin(PSI);
    %C2PSI        = cos(2*PSI);
    %S2PSI        = sin(2*PSI);
    
    
    BETA{nli}   = beta0 + beta1C*CPSI + beta1S*SPSI;
    %BETA{nli}   = beta0 + beta1C*CPSI + beta1S*SPSI + beta2C*C2PSI + beta2S*S2PSI;
    ZETA{nli}   = zeta0 + zeta1C*CPSI + zeta1S*SPSI;
    %ZETA{nli}   = zeta(1) + zeta1C*CPSI + zeta1S*SPSI + zeta2C*C2PSI + zeta2S*S2PSI;
    LAMBDA{nli}   = lambda0 + lambda1C*CPSI + lambda1S*SPSI;

    SBETA1C      = sin(beta1C);
    CBETA1C      = cos(beta1C);
    SBETA1S      = sin(beta1S);
    CBETA1S      = cos(beta1S);
    SBETA1C      = sin(beta1C);
    CBETA1C      = cos(beta1C);
    
    CBETA        = cos(BETA{nli});
    SBETA        = sin(BETA{nli});
     
    CZETA        = cos(ZETA{nli});
    SZETA        = sin(ZETA{nli});
     
     
    vP1x = (CZETA.*CBETA.*CPSI-SZETA.*SPSI)*airmuxA+(CZETA.*CBETA.*SPSI+...
        SZETA.*CPSI)*airmuyA+CZETA.*SBETA*airmuzA;
    vP1y = (-CBETA.*SZETA.*CPSI-SPSI.*CZETA)*airmuxA+(-CBETA.*SZETA.*SPSI+...
        CPSI.*CZETA)*airmuyA-SZETA.*SBETA*airmuzA; 
    vP1z = -SBETA.*CPSI*airmuxA-SBETA.*SPSI*airmuyA+CBETA*airmuzA;

    
    vP2x  = -(-SZETA.*(CBETA.*(CPSI*omxA+SPSI*omyA)+SBETA*omzA)+...
        CZETA.*(-SPSI*omxA+CPSI*omyA))*eadb.*SBETA-(-SBETA.*...
        (CPSI*omxA+SPSI*omyA)+CBETA*omzA).*(-eadb*SZETA.*CBETA-(eada-eadb)*SZETA);
    vP2y  = (CZETA.*(CBETA.*(CPSI*omxA+SPSI*omyA)+SBETA*omzA)+...
        SZETA.*(-SPSI*omxA+CPSI*omyA))*eadb.*SBETA+(-SBETA.*...
        (CPSI*omxA+SPSI*omyA)+CBETA*omzA).*(eadb*CZETA.*CBETA+(eada-eadb)*CZETA+X-eada);
    vP2z  = (CZETA.*(CBETA.*(CPSI*omxA+SPSI*omyA)+SBETA*omzA)+...
        SZETA.*(-SPSI*omxA+CPSI*omyA)).*(-eadb*SZETA.*CBETA-(eada-eadb)*SZETA)-...
        (-SZETA.*(CBETA.*(CPSI*omxA+SPSI*omyA)+SBETA*omzA)+CZETA.*...
        (-SPSI*omxA+CPSI*omyA)).*(eadb*CZETA.*CBETA+(eada-eadb)*CZETA+X-eada);
    
    vP3x = SZETA.*(CBETA*eada-CBETA*eadb+eadb);
    vP3y = CBETA.*CZETA*eada-eadb*CZETA.*CBETA+CBETA.*X-CBETA*eada+eadb*CZETA;
    vP3z = SBETA.*(X-eada).*SZETA;
    
    vP4x = 0;
    vP4y = 0;  
    vP4z = -CPSI.*CZETA*beta1S.*X+CPSI.*CZETA*beta1S*eada+SPSI.*CZETA*beta1C.*X...
        -SPSI.*CZETA*beta1C*eada-CPSI*beta1S*eada+CPSI*beta1S*eadb+SPSI*beta1C*eada-SPSI*beta1C*eadb;
    
    vP5x = 0;
    vP5y = (zeta1S*CPSI-zeta1C*SPSI).*(X-eada);
    vP5z = 0;

    vP6x = LAMBDA{nli}.*(CZETA.*(CBETA.*(-SBETA1C*CPSI-SPSI*SBETA1S.*CBETA1C)+...
        CBETA1S*CBETA1C.*SBETA)+SZETA.*(SBETA1C*SPSI-CPSI*SBETA1S.*CBETA1C));
    vP6y = LAMBDA{nli}.*((-SZETA).*(CBETA.*(-SBETA1C*CPSI-SPSI*SBETA1S.*CBETA1C)+...
        CBETA1S*CBETA1C.*SBETA)+CZETA.*(SBETA1C.*SPSI-CPSI*SBETA1S.*CBETA1C));
    vP6z = LAMBDA{nli}.*((-SBETA).*(-SBETA1C*CPSI-SPSI*SBETA1S.*CBETA1C)+CBETA1S*CBETA1C.*CBETA);

    
    Vx = vP1x + -vP2x + -vP3x + vP4x + -vP5x + vP6x;
    Vy = vP1y + -vP2y + -vP3y + vP4y + -vP5y + vP6y;
    Vz = vP1z + -vP2z + -vP3z + vP4z + -vP5z + vP6z;

    ULad{nli} = Vx;
    UTad{nli} = -Vy;
    UPad{nli} = Vz;
    
    PHI{nli}     = atan2(UPad{nli},UTad{nli});
    THETA{nli}   = theta0+theta1C*CPSI+theta1S*SPSI+THETAG2D;
    ALPHA{nli}   = angle2pmpi(PHI{nli}+THETA{nli});
    
    Re2D{nli}      = sqrt((UTad{nli}).^2+(UPad{nli}).^2)*Re;
    Log10Re2D{nli} = log10(Re2D{nli});
    M2D{nli}       = sqrt((UTad{nli}).^2+(UPad{nli}).^2)*M;
    
    CL2D{nli}    = interpn(ALPHA3D_CL,Log10Re3D_CL,M3D_CL,CL3D,ALPHA{nli},Log10Re2D{nli},...
                         M2D{nli});
    CD2D{nli}    = interpn(ALPHA3D_CD,Log10Re3D_CD,M3D_CD,CD3D,ALPHA{nli},Log10Re2D{nli},...
                         M2D{nli});
    CM2D{nli}    = interpn(ALPHA3D_CM,Log10Re3D_CM,M3D_CM,CM3D,ALPHA{nli},Log10Re2D{nli},...
                         M2D{nli});
    E{nli}       = CL2D{nli}./CD2D{nli};
    
    CPHI{nli}   = cos(PHI{nli});
    SPHI{nli}   = sin(PHI{nli});
    
    dTabi{nli}    = CL2D{nli}.*CPHI{nli};
    dTabp{nli}    = CD2D{nli}.*SPHI{nli};
    dFTabi{nli}   = -CL2D{nli}.*SPHI{nli};
    dFTabp{nli}   = CD2D{nli}.*CPHI{nli};
    
    dTab{nli}    = dTabi{nli}+dTabp{nli};
    dFTab{nli}   = dFTabi{nli}+dFTabp{nli};

    Log10Reout   = [Log10Reout Log10Re2D{nli}];
    Mout         = [Mout  M2D{nli}];
    CLout        = [CLout CL2D{nli}];
    CDout        = [CDout CD2D{nli}];
    CMout        = [CMout CM2D{nli}];
    ULadout      = [ULadout ULad{nli}];
    UTadout      = [UTadout UTad{nli}];
    UPadout      = [UPadout UPad{nli}];
    Eout         = [Eout E{nli}];
    ALPHAout     = [ALPHAout ALPHA{nli}];
    dTabiout     = [dTabiout dTabi{nli}];
    dTabpout     = [dTabpout dTabp{nli}];
    dTabout      = [dTabout dTab{nli}];
    dFTabiout    = [dFTabiout dFTabi{nli}];    
    dFTabpout    = [dFTabpout dFTabp{nli}];  
    dFTabout     = [dFTabout dFTab{nli}];    
    
    CPSIout      = cos(psi2Dall);
    SPSIout      = sin(psi2Dall);
    
    CPHIout      = [CPHIout cos(PHI{nli})];
    SPHIout      = [SPHIout sin(PHI{nli})];

    CBETAout     = [CBETAout cos(BETA{nli})];
    SBETAout     = [SBETAout sin(BETA{nli})];
     
    CZETAout     = [CZETAout cos(ZETA{nli})];
    SZETAout     = [SZETAout sin(ZETA{nli})];
    
end

    CPSI        = cos(psi2Dall);
    SPSI        = sin(psi2Dall);
   
    CPHI        = CPHIout;
    SPHI        = SPHIout;

    CBETA       = CBETAout;
    SBETA       = SBETAout;
     
    CZETA       = CZETAout;
    SZETA       = SZETAout;
    

    k    = ((UTadout.^2)+(UPadout.^2)).*cad2Dall/(2*pi);

%------------- Aerodynamic Forces and Moments distribution(A1 axis)--------

    dCFaxA1bi = k.*(CBETA.*SZETA.*dFTabiout-SZETA.*dTabiout);%
    dCFaxA1bp = k.*(CBETA.*SZETA.*dFTabiout-SZETA.*dTabiout);%
    dCFaxA1b  = dCFaxA1bi + dCFaxA1bp;
    
    dCFayA1bi = -k.*(CZETA.*dFTabiout);%
    dCFayA1bp = -k.*(CZETA.*dFTabpout);%
    dCFayA1b  = dCFayA1bi + dCFayA1bp;

    dCFazA1bi = k.*(SBETA.*SZETA.*dFTabiout+CBETA.*dTabiout);%
    dCFazA1bp = k.*(SBETA.*SZETA.*dFTabpout+CBETA.*dTabpout);%
    dCFazA1b  = dCFazA1bi + dCFazA1bp;
    
    dCMaExA1bi = k.*((-CBETA.*SZETA*eada+CBETA.*SZETA.*x2Dall).*dTabiout+...
        (CZETA.*SBETA*eada-CZETA.*SBETA*eadb-SBETA*eada+SBETA.*x2Dall).*dFTabiout);%
    dCMaExA1bp = k.*((-CBETA.*SZETA*eada+CBETA.*SZETA.*x2Dall).*dTabpout+...
        (CZETA.*SBETA*eada-CZETA.*SBETA*eadb-SBETA*eada+SBETA.*x2Dall).*dFTabpout);%
    dCMaExA1b  = dCMaExA1bi + dCMaExA1bp;
 
    dCMaEyA1bi = k.*((CZETA*eada-CZETA.*x2Dall-eada.*CBETA-eada+eadb).*dTabiout+...
        SBETA.*SZETA*eada.*dFTabiout); %  
    dCMaEyA1bp = k.*((CZETA*eada-CZETA.*x2Dall-eada.*CBETA-eada+eadb).*dTabpout+...
        SBETA.*SZETA*eada.*dFTabpout); % 
    dCMaEyA1b  = dCMaEyA1bi + dCMaEyA1bp;
      
    dCMaEzA1bi = k.*((CBETA.^2*eada-CBETA.^2*eadb-SBETA.*SZETA*eada+SBETA.*SZETA.*x2Dall+eada*CBETA).*dTabiout+...
        (CBETA.*SBETA.*SZETA*eada-CBETA.*SBETA.*SZETA*eadb+SBETA.*SZETA*eada+eada*CBETA-CBETA.*x2Dall).*dFTabiout); %  
    dCMaEzA1bp = k.*((CBETA.^2*eada-CBETA.^2*eadb-SBETA.*SZETA*eada+SBETA.*SZETA.*x2Dall+eada*CBETA).*dTabpout+...
        (CBETA.*SBETA.*SZETA*eada-CBETA.*SBETA.*SZETA*eadb+SBETA.*SZETA*eada+eada*CBETA-CBETA.*x2Dall).*dFTabpout); %
    dCMaEzA1b  = dCMaEzA1bi + dCMaEzA1bp;
    
%------------- Aerodynamic Forces and Moments distribution(A axis)--------- 

    dCHbi = CPSI.*dCFaxA1bi-SPSI.*dCFayA1bi;
    dCHbp = CPSI.*dCFaxA1bp-SPSI.*dCFayA1bp;
    dCHb  = dCHbi + dCHbp;
    
    dCYbi = SPSI.*dCFaxA1bi+CPSI.*dCFayA1bi;
    dCYbp = SPSI.*dCFaxA1bp+CPSI.*dCFayA1bp;
    dCYb  = dCYbi + dCYbp;
    
    dCTbi = dCFazA1bi;
    dCTbp = dCFazA1bp;
    dCTb  = dCTbi + dCTbp;
    
    dCMaExAbi = CPSI.*dCMaExA1bi-SPSI.*dCMaEyA1bi;
    dCMaExAbp = CPSI.*dCMaExA1bp-SPSI.*dCMaEyA1bp;
    dCMaExAb  = dCMaExAbi + dCMaExAbp;
    
    dCMaEyAbi = SPSI.*dCMaExA1bi+CPSI.*dCMaEyA1bi;
    dCMaEyAbp = SPSI.*dCMaExA1bp+CPSI.*dCMaEyA1bp;
    dCMaEyAb  = dCMaEyAbi + dCMaEyAbp;
    
    dCMaEzAbi = dCMaEzA1bi;
    dCMaEzAbp = dCMaEzA1bp;
    dCMaEzAb  = dCMaEzAbi + dCMaEzAbp;
    

    
%------------------------x integration (single blade)---------------------- 
%--------------------------------------------------------------------------    

        
    CPSI1D  = CPSI(:,1);
    SPSI1D  = SPSI(:,1);
    
    CBETA1D = CBETA(:,1);
    SBETA1D = SBETA(:,1);

%------------------------------ A1 axis -----------------------------------   
    
    CFaxA1bi = trapz(x1D,dCFaxA1bi,2);
    CFaxA1bp = trapz(x1D,dCFaxA1bp,2);
    CFaxA1b  = CFaxA1bi + CFaxA1bp;

    CFayA1bi = trapz(x1D,dCFayA1bi,2);
    CFayA1bp = trapz(x1D,dCFayA1bp,2);
    CFayA1b  = CFayA1bi + CFayA1bp;
    
    CFazA1bi = trapz(x1D,dCFazA1bi,2);
    CFazA1bp = trapz(x1D,dCFazA1bp,2);
    CFazA1b  = CFazA1bi + CFazA1bp;
    
    CMaExA1bi = trapz(x1D,dCMaExA1bi,2);
    CMaExA1bp = trapz(x1D,dCMaExA1bp,2);    
    CMaExA1b  = CMaExA1bi + CMaExA1bp;
    
    CMaEyA1bi = trapz(x1D,dCMaEyA1bi,2);
    CMaEyA1bp = trapz(x1D,dCMaEyA1bp,2);    
    CMaEyA1b  = CMaEyA1bi + CMaEyA1bp;
    
    CMaEzA1bi = trapz(x1D,dCMaEzA1bi,2);
    CMaEzA1bp = trapz(x1D,dCMaEzA1bp,2);    
    CMaEzA1b  = CMaEzA1bi + CMaEzA1bp;
    
    CMFaxA1bi = -(eada-eadb)*SBETA1D.*CFazA1bi;
    CMFaxA1bp = -(eada-eadb)*SBETA1D.*CFazA1bp;
    CMFaxA1b  = CMFaxA1bi + CMFaxA1bp;
    
    CMFayA1bi = (eada-eadb)*SBETA1D.*CFaxA1bi-(eada-eadb)*CBETA1D.*CFazA1bi-eadb*CFazA1bi;
    CMFayA1bp = (eada-eadb)*SBETA1D.*CFaxA1bp-(eada-eadb)*CBETA1D.*CFazA1bp-eadb*CFazA1bp;
    CMFayA1b  = CMFayA1bi + CMFayA1bp;
    
    CMFazA1bi = (CBETA1D*eada-CBETA1D*eadb+eadb).*CFayA1bi; 
    CMFazA1bp = (CBETA1D*eada-CBETA1D*eadb+eadb).*CFayA1bp;
    CMFazA1b  = CMFazA1bi + CMFazA1bp;
    
    CMaxA1bi = CMaExA1bi + CMFaxA1bi;
    CMaxA1bp = CMaExA1bp + CMFaxA1bp;
    CMaxA1b  = CMaxA1bi + CMaxA1bp;
    
    CMayA1bi = CMaEyA1bi + CMFayA1bi;
    CMayA1bp = CMaEyA1bp + CMFayA1bp;
    CMayA1b  = CMayA1bi + CMayA1bp;    
    
    CMazA1bi = CMaEzA1bi + CMFazA1bi;
    CMazA1bp = CMaEzA1bp + CMFazA1bp;
    CMazA1b  = CMazA1bi + CMazA1bp;   
 
    
%------------------------------ A axis ------------------------------------
    
    
    CHbi = CPSI1D.*CFaxA1bi-SPSI1D.*CFayA1bi;
    CHbp = CPSI1D.*CFaxA1bp-SPSI1D.*CFayA1bp;
    CHb  = CHbi + CHbp;
    
    CYbi = SPSI1D.*CFaxA1bi+CPSI1D.*CFayA1bi;
    CYbp = SPSI1D.*CFaxA1bp+CPSI1D.*CFayA1bp;
    CYb  = CYbi + CYbp;
    
    CTbi = CFazA1bi;
    CTbp = CFazA1bp;
    CTb  = CTbi + CTbp;
    
    CMaExAbi = CPSI1D.*CMaExA1bi-SPSI1D.*CMaEyA1bi;
    CMaExAbp = CPSI1D.*CMaExA1bp-SPSI1D.*CMaEyA1bp;
    CMaExAb  = CMaExAbi + CMaExAbp;
    
    CMaEyAbi = SPSI1D.*CMaExA1bi+CPSI1D.*CMaEyA1bi;
    CMaEyAbp = SPSI1D.*CMaExA1bp+CPSI1D.*CMaEyA1bp;
    CMaEyAb  = CMaEyAbi + CMaEyAbp;
    
    CMaEzAbi = CMaEzA1bi;
    CMaEzAbp = CMaEzA1bp;
    CMaEzAb  = CMaEzA1b;
   
    CMFaxAbi = CPSI1D.*CMFaxA1bi-SPSI1D.*CMFayA1bi;
    CMFaxAbp = CPSI1D.*CMFaxA1bp-SPSI1D.*CMFayA1bp;
    CMFaxAb  = CMFaxAbi + CMFaxAbp;
    
    CMFayAbi = SPSI1D.*CMFaxA1bi+CPSI1D.*CMFayA1bi;
    CMFayAbp = SPSI1D.*CMFaxA1bp+CPSI1D.*CMFayA1bp;
    CMFayAb  = CMFayAbi + CMFayAbp;
    
    CMFazAbi = CMFazA1bi;
    CMFazAbp = CMFazA1bp;
    CMFazAb  = CMFazA1b;    
    
    CMaxAbi = CMaExAbi + CMFaxAbi;
    CMaxAbp = CMaExAbp + CMFaxAbp;
    CMaxAb  = CMaxAbi + CMaxAbp;
    
    CMayAbi = CMaEyAbi + CMFayAbi;
    CMayAbp = CMaEyAbp + CMFayAbp;
    CMayAb  = CMayAbi + CMayAbp;
    
    CMazAbi = CMaEzAbi + CMFazAbi;
    CMazAbp = CMaEzAbp + CMFazAbp;
    CMazAb  = CMazAbi + CMazAbp;
    
    

%-------------------'FSC' function approximation---------------------------
%--------------------------------------------------------------------------

FSCorder = 3;

%------------------------------ A1 axis -----------------------------------

    [a0,CFaxA1bC,CFaxA1bS,CFaxA1bs] = FSC(psi1D,CFaxA1b,FSCorder);
    CFaxA1b0 = a0/2;

    [a0,CFayA1bC,CFayA1bS,CFayA1bs] = FSC(psi1D,CFayA1b,FSCorder);
    CFayA1b0 = a0/2;

    [a0,CFazA1bC,CFazA1bS,CFazA1bs] = FSC(psi1D,CFazA1b,FSCorder);
    CFazA1b0 = a0/2;

    [a0,CMaxA1bC,CMaxA1bS,CMaxA1bs] = FSC(psi1D,CMaxA1b,FSCorder);
    CMaxA1b0 = a0/2;
    
    [a0,CMayA1bC,CMayA1bS,CMayA1bs] = FSC(psi1D,CMayA1b,FSCorder);
    CMayA1b0 = a0/2;
    
    [a0,CMazA1bC,CMazA1bS,CMazA1bs] = FSC(psi1D,CMazA1b,FSCorder);
    CMazA1b0 = a0/2;
 
%------------------------------ A axis ------------------------------------
    
    [a0,CHbC,CHbS,CHbs] = FSC(psi1D,CHb,FSCorder);
    CHb0 = a0/2;

    [a0,CYbC,CYbS,CYbs] = FSC(psi1D,CYb,FSCorder);
    CYb0 = a0/2;

    [a0,CTbC,CTbS,CTbs] = FSC(psi1D,CTb,FSCorder);
    CTb0 = a0/2;

    [a0,CMaxAbC,CMaxAbS,CMaxAbs] = FSC(psi1D,CMaxAb,FSCorder);
    CMaxAb0 = a0/2;
    
    [a0,CMayAbC,CMayAbS,CMayAbs] = FSC(psi1D,CMayAb,FSCorder);
    CMayAb0 = a0/2;
    
    [a0,CMazAbC,CMazAbS,CMazAbs] = FSC(psi1D,CMazAb,FSCorder);
    CMazAb0 = a0/2;
    
    
%-----------------------psi integration (full rotor)-----------------------
%--------------------------------------------------------------------------

%------------------------------ A1 axis -----------------------------------

    CFaxA1i = (b/(2*pi))*trapz(psi1D,CFaxA1bi,1);
    CFaxA1p = (b/(2*pi))*trapz(psi1D,CFaxA1bp,1);
    CFaxA1  = CFaxA1i + CFaxA1p;

    CFayA1i = (b/(2*pi))*trapz(psi1D,CFayA1bi,1);
    CFayA1p = (b/(2*pi))*trapz(psi1D,CFayA1bp,1);
    CFayA1  = CFayA1i + CFayA1p;
    
    CFazA1i = (b/(2*pi))*trapz(psi1D,CFazA1bi,1);
    CFazA1p = (b/(2*pi))*trapz(psi1D,CFazA1bp,1);
    CFazA1  = CFazA1i + CFazA1p;
    
    CMaExA1i = (b/(2*pi))*trapz(psi1D,CMaExA1bi,1);
    CMaExA1p = (b/(2*pi))*trapz(psi1D,CMaExA1bp,1);    
    CMaExA1  = CMaExA1i + CMaExA1p;
    
    CMaEyA1i = (b/(2*pi))*trapz(psi1D,CMaEyA1bi,1);
    CMaEyA1p = (b/(2*pi))*trapz(psi1D,CMaEyA1bp,1);    
    CMaEyA1  = CMaEyA1i + CMaEyA1p;
    
    CMaEzA1i = (b/(2*pi))*trapz(psi1D,CMaEzA1bi,1);
    CMaEzA1p = (b/(2*pi))*trapz(psi1D,CMaEzA1bp,1);    
    CMaEzA1  = CMaEzA1i + CMaEzA1p;

    CMFaxA1i = (b/(2*pi))*trapz(psi1D,CMFaxA1bi,1);
    CMFaxA1p = (b/(2*pi))*trapz(psi1D,CMFaxA1bp,1);
    CMFaxA1  = CMFaxA1i + CMFaxA1p;

    CMFayA1i = (b/(2*pi))*trapz(psi1D,CMFayA1bi,1);
    CMFayA1p = (b/(2*pi))*trapz(psi1D,CMFayA1bp,1);
    CMFayA1  = CMFayA1i + CMFayA1p;

    CMFazA1i = (b/(2*pi))*trapz(psi1D,CMFazA1bi,1);
    CMFazA1p = (b/(2*pi))*trapz(psi1D,CMFazA1bp,1);
    CMFazA1  = CMFazA1i + CMFazA1p;

    CMaxA1i = CMaExA1i + CMFaxA1i;
    CMaxA1p = CMaExA1p + CMFaxA1p;
    CMaxA1  = CMaxA1i + CMaxA1p;

    CMayA1i = CMaEyA1i + CMFayA1i;
    CMayA1p = CMaEyA1p + CMFayA1p;
    CMayA1  = CMayA1i + CMayA1p;
    
    CMazA1i = CMaEzA1i + CMFazA1i;
    CMazA1p = CMaEzA1p + CMFazA1p;
    CMazA1  = CMazA1i + CMazA1p;
    
%------------------------------ A axis ------------------------------------    
    
    CHi = (b/(2*pi))*trapz(psi1D,CHbi,1);
    CHp = (b/(2*pi))*trapz(psi1D,CHbp,1);
    CH  = CHi + CHp;
    
    CYi = (b/(2*pi))*trapz(psi1D,CYbi,1);
    CYp = (b/(2*pi))*trapz(psi1D,CYbp,1);
    CY  = CYi + CYp;
    
    CTi = CFazA1i;
    CTp = CFazA1p;
    CT  = CTi + CTp;

    CMaExAi = (b/(2*pi))*trapz(psi1D,CMaExAbi,1);
    CMaExAp = (b/(2*pi))*trapz(psi1D,CMaExAbp,1);
    CMaExA  = CMaExAi + CMaExAp;
    
    CMaEyAi = (b/(2*pi))*trapz(psi1D,CMaEyAbi,1);
    CMaEyAp = (b/(2*pi))*trapz(psi1D,CMaEyAbp,1);
    CMaEyA  = CMaEyAi + CMaEyAp;
    
    CMaEzAi = CMaEzA1i;
    CMaEzAp = CMaEzA1p;
    CMaEzA  = CMaEzA1;
   
    CMFaxAi = (b/(2*pi))*trapz(psi1D,CMFaxAbi,1);
    CMFaxAp = (b/(2*pi))*trapz(psi1D,CMFaxAbp,1);
    CMFaxA  = CMFaxAi + CMFaxAp;
    
    CMFayAi = (b/(2*pi))*trapz(psi1D,CMFayAbi,1);
    CMFayAp = (b/(2*pi))*trapz(psi1D,CMFayAbp,1);
    CMFayA  = CMFayAi + CMFayAp;
    
    CMFazAi = CMFazA1i;
    CMFazAp = CMFazA1p;
    CMFazA  = CMFazA1;       
    
    CMaxAi = CMaExAi + CMFaxAi;
    CMaxAp = CMaExAp + CMFaxAp;
    CMaxA  = CMaxAi + CMaxAp;
    
    CMayAi = CMaEyAi + CMFayAi;
    CMayAp = CMaEyAp + CMFayAp;
    CMayA  = CMayAi + CMayAp;
    
    CMazAi = CMaEzAi + CMFazAi;
    CMazAp = CMaEzAp + CMFazAp;
    CMazA  = CMazAi + CMazAp;    

%--------------------------------------------------------------------------    
        
    dRemb   = 10.^(Log10Reout);
    Remb     = trapz(x1D,dRemb,2);
    Rem      = (1/(2*pi))*trapz(psi1D,Remb,1);
    Log10Rem = log10(Rem);
    
    Mmb     = trapz(x1D,Mout,2);
    Mm      = (1/(2*pi))*trapz(psi1D,Mmb,1);

    clmb    = trapz(x1D,CLout,2);
    clm     = (1/(2*pi))*trapz(psi1D,clmb,1);
    
    cdmb    = trapz(x1D,CDout,2);
    cdm     = (1/(2*pi))*trapz(psi1D,cdmb,1);
    
    Emb     = trapz(x1D,Eout,2);
    Em      = (1/(2*pi))*trapz(psi1D,Emb,1);
    
    
%--------------------------------------------------------------------------
% Inertial analysis
%--------------------------------------------------------------------------

XGB      = ndRotor.XGB;
muP      = ndRotor.muP;
epsilonR = ndRotor.epsilonR;
RITB     = ndRotor.RITB;
RIZB     = ndRotor.RIZB;
aG       = ndRotor.aG;

Ibetaad  = muP*XGB/epsilonR;

psi1D    = psi2Dall(:,1);

CPSI1D    = cos(psi1D);
SPSI1D    = sin(psi1D);
%C2PSI1D   = cos(2*psi1D);
%S2PSI1D   = sin(2*psi1D);

BETA = beta0 + beta1C*CPSI1D + beta1S*SPSI1D;
%BETA = beta0 + beta1C*CPSI1D + beta1S*SPSI1D + beta2C*C2PSI1D + beta2S*S2PSI1D;

CBETA   = cos(BETA);
SBETA   = sin(BETA);

ZETA = zeta0 + zeta1C*CPSI1D + zeta1S*SPSI1D;
%ZETA = zeta0 + zeta1C*CPSI1D + zeta1S*SPSI1D + zeta2C*C2PSI1D + zeta2S*S2PSI1D;

CZETA   = cos(ZETA);
SZETA   = sin(ZETA);

THETA = theta0 + theta1C*CPSI1D + theta1S*SPSI1D;

CTHETA   = cos(THETA);
STHETA   = sin(THETA);

omxAad = omxA;
omyAad = omyA;
omzAad = omzA;

CMErExA1 = zeros(length(psi1D),1);
CMErEyA1 = zeros(length(psi1D),1); %Kbeta*BETA;
CMErEzA1 = zeros(length(psi1D),1); %Kzeta*ZETA;

CMGxA1 = muP*aG*(XGB*SZETA*GzA-((eada-eadb)*SBETA+XGB*CZETA.*SBETA).*(-SPSI1D*GxA+CPSI1D*GyA));
CMGyA1 = muP*aG*(-(eadb+(eada-eadb)*CBETA+XGB*CZETA.*CBETA)*GzA+((eada-eadb)...
    *SBETA+XGB*CZETA.*SBETA).*(CPSI1D*GxA+SPSI1D*GyA));
CMGzA1 = muP*aG*((eadb+(eada-eadb)*CBETA+XGB*CZETA.*CBETA).*(-SPSI1D*GxA+...
    CPSI1D*GyA)-XGB*SZETA.*(CPSI1D*GxA+SPSI1D*GyA));

dzetadpsi = zeta1C*(-SPSI1D)+zeta1S*CPSI1D;
%dzetadpsi = zeta1C*(-SPSI1D)+zeta1S*CPSI1D+2*zeta2C*(-S2PSI1D)+2*zeta2S*C2PSI1D;
        
dbetadpsi = beta1C*(-SPSI1D)+beta1S*CPSI1D;
%dbetadpsi = beta1C*(-SPSI1D)+beta1S*CPSI1D+2*beta2C*(-S2PSI1D)+2*beta2S*C2PSI1D;
                
dthetadpsi = theta1C*(-SPSI1D)+theta1S*CPSI1D;
        
d2zetadpsi2 = zeta1C*(-CPSI1D)+zeta1S*(-SPSI1D);
%d2zetadpsi2 = zeta1C*(-CPSI1D)+zeta1S*(-SPSI1D)+2*zeta2C*(-C2PSI1D)+2*zeta2S*(-S2PSI1D);

d2betadpsi2 = beta1C*(-CPSI1D)+beta1S*(-SPSI1D);
%d2betadpsi2 = beta1C*(-CPSI1D)+beta1S*(-SPSI1D)+2*beta2C*(-C2PSI1D)+2*beta2S*(-S2PSI1D);
        
d2thetadpsi2 = theta1C*(-CPSI1D)+theta1S*(-SPSI1D);

    function domBad = fdomBad(omxAad,omyAad,omzAad,BETA,THETA,ZETA,CPSI1D,SPSI1D,...
            dbetadpsi,d2betadpsi2,dthetadpsi,d2thetadpsi2,dzetadpsi,d2zetadpsi2)      
        
        t1 = ZETA;
        t2 = sin(t1);
        t3 = dzetadpsi;
        t4 = t2 .* t3;
        t5 = BETA;
        t6 = cos(t5);
        t7 = CPSI1D;
        t11 = cos(t1);
        t12 = sin(t5);
        t13 = t11 .* t12;
        t14 = dbetadpsi;
        t18 = t11 .* t6;
        t19 = SPSI1D;
        t20 = t19 .* omxAad;
        t28 = t7 .* omyAad;
        t30 = t11 .* t3;
        t42 = d2zetadpsi2;
        t46 = d2thetadpsi2;
        domxBad = -t13 .* t14 .* t7 .* omxAad - t4 .* t6 .* t7 .* omxAad - ...
            t13 .* t14 .* t19 .* omyAad - t4 .* t6 .* t19 .* omyAad - t2 .* ...
            t7 .* omxAad - t2 .* t19 .* omyAad - t4 .* t12 .* omzAad + t18 .* ...
            t14 .* omzAad - t4 .* t12 + t18 .* t14 - t30 .* t14 - t18 .* t20...
            + t18 .* t28 - t2 .* t42 - t30 .* t20 + t30 .* t28 + t46;

        
        t1 = ZETA;
        t2 = cos(t1);
        t3 = d2zetadpsi2;
        t4 = t2 .* t3;
        t5 = THETA;
        t6 = cos(t5);
        t7 = t4 .* t6;
        t8 = BETA;
        t9 = cos(t8);
        t10 = CPSI1D;
        t11 = t9 .* t10;
        t12 = t11 .* omxAad;
        t14 = sin(t1);
        t15 = sin(t5);
        t16 = t14 .* t15;
        t17 = dthetadpsi;
        t18 = t16 .* t17;
        t20 = t14 .* t6;
        t21 = sin(t8);
        t22 = t20 .* t21;
        t23 = dbetadpsi;
        t25 = t23 .* t10 .* omxAad;
        t27 = SPSI1D;
        t28 = t9 .* t27;
        t29 = t28 .* omyAad;
        t33 = t23 .* t27 .* omyAad;
        t35 = t14 .* t3;
        t39 = t2 .* t15;
        t49 = t9 .* t23;
        t52 = t6 .* t17;
        t54 = t2 .* t6;
        t55 = d2betadpsi2;
        t57 = t15 .* t21;
        t64 = -t7 .* t12 + t18 .* t12 + t22 .* t25 - t7 .* t29 + t18 .* t29...
            + t22 .* t33 - t35 .* t6 .* t10 .* omyAad - t39 .* t17 .* t10...
            .* omyAad + t35 .* t6 .* t27 .* omxAad + t39 .* t17 .* t27 .* omxAad...
            - t20 .* t49 .* omzAad + t52 .* t9 - t54 .* t55 - t57 .* t23...
            + t52 .* t3 + t39 .* t17 .* t23 + t57 .* t27 .* omxAad;
        t90 = t15 .* t9;
        t102 = d2zetadpsi2;
        t104 = -t57 .* t10 .* omyAad - t54 .* t27 .* omyAad - t54 .* t10 .* omxAad...
            + t52 .* t9 .* omzAad - t57 .* t23 .* omzAad + t15 .* t17 .* t14 .* t21...
            - t54 .* t3 .* t21 - t20 .* t49 + t35 .* t6 .* t23 + t20 .* t28 .* omxAad...
            - t20 .* t11 .* omyAad - t52 .* t21 .* t10 .* omxAad - t90 .* t25...
            - t52 .* t21 .* t27 .* omyAad - t90 .* t33 - t4 .* t6 .* t21 .* omzAad...
            + t16 .* t17 .* t21 .* omzAad + t15 .* t102;
        domyBad = t64 + t104;


        t1 = THETA;
        t2 = sin(t1);
        t3 = ZETA;
        t4 = cos(t3);
        t5 = t2 .* t4;
        t6 = SPSI1D;
        t9 = CPSI1D;
        t12 = cos(t1);
        t13 = BETA;
        t14 = sin(t13);
        t15 = t12 .* t14;
        t20 = dthetadpsi;
        t21 = t12 .* t20;
        t22 = sin(t3);
        t23 = t22 .* t14;
        t25 = dzetadpsi;
        t26 = t25 .* t14;
        t28 = t2 .* t22;
        t29 = cos(t13);
        t30 = dbetadpsi;
        t31 = t29 .* t30;
        t37 = t2 .* t20;
        t43 = d2betadpsi2;
        t47 = t21 .* t22;
        t48 = t29 .* t9;
        t49 = t48 .* omxAad;
        t51 = t5 .* t25;
        t53 = t15 .* t6 .* omxAad + t5 .* t9 .* omxAad - t15 .* t9 .* omyAad...
            + t5 .* t6 .* omyAad - t15 .* t30 .* omzAad - t37 .* t29 .* omzAad...
            + t21 .* t4 .* t30 - t28 .* t25 .* t30 - t15 .* t30 + t21 .* t23...
            - t37 .* t25 + t5 .* t26 + t28 .* t31 - t37 .* t29 + t5 .* t43...
            + t47 .* t49 + t51 .* t49;
        t54 = t28 .* t14;
        t56 = t30 .* t9 .* omxAad;
        t58 = t29 .* t6;
        t59 = t58 .* omyAad;
        t63 = t30 .* t6 .* omyAad;
        t65 = d2zetadpsi2;
        t92 = t12 .* t29;
        t98 = -t54 .* t56 + t47 .* t59 + t51 .* t59 - t54 .* t63 + t12 .* t65...
            - t28 .* t58 .* omxAad + t28 .* t48 .* omyAad + t21 .* t23 .* omzAad...
            + t5 .* t26 .* omzAad + t28 .* t31 .* omzAad - t21 .* t4 .* t9...
            .* omyAad + t28 .* t25 .* t9 .* omyAad + t21 .* t4 .* t6 .* omxAad...
            - t28 .* t25 .* t6 .* omxAad + t37 .* t14 .* t9 .* omxAad - t92...
            .* t56 + t37 .* t14 .* t6 .* omyAad - t92 .* t63;
        domzBad = t53 + t98;

        domBad = struct('domxBad',domxBad,'domyBad',domyBad,'domzBad',domzBad);
        
    end

domBad = fdomBad(omxAad,omyAad,omzAad,BETA,THETA,ZETA,CPSI1D,SPSI1D,...
            dbetadpsi,d2betadpsi2,dthetadpsi,d2thetadpsi2,dzetadpsi,d2zetadpsi2);
        
    function omBad = fomBad(omxAad,omyAad,omzAad,BETA,THETA,ZETA,CPSI1D,SPSI1D,...
            dbetadpsi,dthetadpsi,dzetadpsi)  
        
        t1 = ZETA;
        t2 = cos(t1);
        t3 = BETA;
        t4 = cos(t3);
        t5 = t2 .* t4;
        t6 = CPSI1D;
        t9 = SPSI1D;
        t12 = sin(t1);
        t17 = sin(t3);
        t18 = t2 .* t17;
        t20 = dbetadpsi;
        t22 = dthetadpsi;
        omxBad = -t12 .* t9 * omxAad + t5 .* t6 * omxAad + t12 .* t6 * omyAad...
            + t5 .* t9 * omyAad + t18 * omzAad - t12 .* t20 + t18 + t22;


        t1 = ZETA;
        t2 = sin(t1);
        t3 = THETA;
        t4 = cos(t3);
        t5 = t2 .* t4;
        t6 = BETA;
        t7 = cos(t6);
        t8 = CPSI1D;
        t12 = SPSI1D;
        t16 = sin(t3);
        t17 = sin(t6);
        t18 = t16 .* t17;
        t25 = cos(t1);
        t26 = t25 .* t4;
        t31 = t16 .* t7;
        t34 = dbetadpsi;
        t36 = dzetadpsi;
        omyBad = -t5 .* t7 .* t8 * omxAad - t5 .* t7 .* t12 * omyAad...
            - t26 .* t12 * omxAad - t18 .* t8 * omxAad - t18 .* t12 * omyAad...
            + t26 .* t8 * omyAad - t5 .* t17 * omzAad + t31 * omzAad...
            + t16 .* t36 - t5 .* t17 - t26 .* t34 + t31;


        t1 = THETA;
        t2 = sin(t1);
        t3 = ZETA;
        t4 = sin(t3);
        t5 = t2 .* t4;
        t6 = BETA;
        t7 = cos(t6);
        t8 = CPSI1D;
        t12 = SPSI1D;
        t16 = sin(t6);
        t19 = cos(t3);
        t20 = t2 .* t19;
        t25 = cos(t1);
        t26 = t25 .* t16;
        t32 = dbetadpsi;
        t34 = t25 .* t7;
        t36 = dzetadpsi;
        omzBad = t5 .* t7 .* t8 * omxAad + t5 .* t7 .* t12 * omyAad...
            + t20 .* t12 * omxAad - t26 .* t8 * omxAad - t26 .* t12 * omyAad...
            - t20 .* t8 * omyAad + t5 .* t16 * omzAad + t34 * omzAad...
            + t5 .* t16 + t20 .* t32 + t25 .* t36 + t34;


        omBad = struct('omxBad',omxBad,'omyBad',omyBad,'omzBad',omzBad);
      
    end

omBad = fomBad(omxAad,omyAad,omzAad,BETA,THETA,ZETA,CPSI1D,SPSI1D,...
            dbetadpsi,dthetadpsi,dzetadpsi);

omxBad = omBad.omxBad;
omyBad = omBad.omyBad;
omzBad = omBad.omzBad;

domxBad = domBad.domxBad;
domyBad = domBad.domyBad;
domzBad = domBad.domzBad;

dhdpsixB = Ibetaad*(RITB*domxBad + (RIZB-1)*omyBad.*omzBad);
dhdpsiyB = Ibetaad*(domyBad + (RITB-RIZB)*omxBad.*omzBad);
dhdpsizB = Ibetaad*(RIZB*domzBad + (1-RITB)*omxBad.*omyBad);

dhdpsixA1 = CBETA.*(CZETA.*dhdpsixB-SZETA.*(CTHETA.*dhdpsiyB-...
    STHETA.*dhdpsizB))-SBETA.*(STHETA.*dhdpsiyB+CTHETA.*dhdpsizB);
dhdpsiyA1 = SZETA.*dhdpsixB+CZETA.*(CTHETA.*dhdpsiyB-STHETA.*dhdpsizB);
dhdpsizA1 = SBETA.*(CZETA.*dhdpsixB-SZETA.*(CTHETA.*dhdpsiyB-...
    STHETA.*dhdpsizB))+CBETA.*(STHETA.*dhdpsiyB+CTHETA.*dhdpsizB);


    function dvEad = fdvEad(muxA,muyA,omxAad,omyAad,omzAad,eada,eadb,...
            BETA,CPSI1D,SPSI1D,dbetadpsi,d2betadpsi2)
        
        
        t1 = SPSI1D;
        t2 = BETA;
        t3 = sin(t2);
        t4 = t1 .* t3;
        t7 = CPSI1D;
        t8 = cos(t2);
        t9 = t7 .* t8;
        t10 = dbetadpsi;
        t11 = t10 .* eada;
        t16 = t10 .* eadb;
        t19 = t7 .* t3;
        t22 = t1 .* t8;
        t29 = d2betadpsi2;
        t30 = t3 .* t29;
        t32 = t10 .^ 2;
        t33 = t32 .* t8;
        dvEaddpsix = -t19 .* eada .* omxAad - t4 .* eada .* omyAad + t19...
            .* eadb .* omxAad + t4 .* eadb .* omyAad - t22 .* t11 .* omxAad...
            + t22 .* t16 .* omxAad + t9 .* t11 .* omyAad - t9 .* t16 .* omyAad...
            - t30 .* eada - t33 .* eada + t30 .* eadb + t33 .* eadb...
            + t1 .* muxA - t7 .* muyA;


        
        t1 = SPSI1D;
        t2 = BETA;
        t3 = sin(t2);
        t4 = t1 .* t3;
        t7 = CPSI1D;
        t8 = cos(t2);
        t9 = t7 .* t8;
        t10 = dbetadpsi;
        t11 = t10 .* eada;
        t16 = t10 .* eadb;
        t19 = t7 .* t3;
        t22 = t1 .* t8;
        t29 = t3 .* t10;
        dvEaddpsiy = t4 .* eada .* omxAad - t19 .* eada .* omyAad - t29...
            .* eada .* omzAad - t4 .* eadb .* omxAad + t19 .* eadb .* omyAad...
            + t29 .* eadb .* omzAad - t9 .* t11 .* omxAad + t9 .* t16 .* omxAad...
            - t22 .* t11 .* omyAad + t22 .* t16 .* omyAad - t29 .* eada...
            + t29 .* eadb + t7 .* muxA + t1 .* muyA;



        t1 = SPSI1D;
        t2 = BETA;
        t3 = cos(t2);
        t4 = t1 .* t3;
        t7 = CPSI1D;
        t8 = sin(t2);
        t9 = t7 .* t8;
        t10 = dbetadpsi;
        t11 = t10 .* eada;
        t16 = t10 .* eadb;
        t19 = t7 .* t3;
        t22 = t1 .* t8;
        t29 = d2betadpsi2;
        t30 = t3 .* t29;
        t32 = t10 .^ 2;
        t33 = t32 .* t8;
        dvEaddpsiz = t19 .* eada .* omxAad + t4 .* eada .* omyAad - t19...
            .* eadb .* omxAad + t7 .* eadb .* omxAad + t1 .* eadb .* omyAad...
            - t4 .* eadb .* omyAad - t22 .* t11 .* omxAad + t22 .* t16 .* omxAad...
            + t9 .* t11 .* omyAad - t9 .* t16 .* omyAad + t30 .* eada...
            - t33 .* eada - t30 .* eadb + t33 .* eadb;


        dvEad = struct('dvEaddpsix',dvEaddpsix,'dvEaddpsiy',dvEaddpsiy,'dvEaddpsiz',dvEaddpsiz);
        
    end

dvEad = fdvEad(muxA,muyA,omxAad,omyAad,omzAad,eada,eadb,...
            BETA,CPSI1D,SPSI1D,dbetadpsi,d2betadpsi2);
        
dvEaddpsix = dvEad.dvEaddpsix;
dvEaddpsiy = dvEad.dvEaddpsiy;
dvEaddpsiz = dvEad.dvEaddpsiz;

    function omAadA1xvEadA1 = fomAA1xvEadA1(muxA,muyA,muzA,omxAad,omyAad,...
            omzAad,eada,eadb,BETA,CPSI1D,SPSI1D,dbetadpsi)

        t2 = SPSI1D;
        t4 = CPSI1D;
        t7 = t4;
        t8 = BETA;
        t9 = cos(t8);
        t10 = t7 .* t9;
        t11 = eada * omyAad;
        t13 = eadb * omyAad;
        t15 = t2;
        t16 = t15 .* t9;
        t17 = eada * omxAad;
        t19 = eadb * omxAad;
        t25 = dbetadpsi;
        t26 = t25 .* t9;
        t32 = sin(t8);
        t33 = t32 .* t7;
        t36 = t32 .* t15;
        t39 = t9 * eada;
        t41 = t9 * eadb;
        t46 = eadb * omzAad + t15 * muxA - t7 * muyA + t39 * omzAad...
            - t41 * omzAad - t36 .* t11 + t36 .* t13 - t33 .* t17 + t33 .* t19...
            + eadb + t39 - t41;
        omAadA1xvEadA1x = (-t2 * omxAad + t4 * omyAad) .* (t15 * eadb...
            * omxAad - t7 * eadb * omyAad + t26 * eada - t26 * eadb...
            - t10 .* t11 + t10 .* t13 + t16 .* t17 - t16 .* t19 - muzA)...
            - (omzAad + 1) * t46;




        t2 = SPSI1D;
        t4 = CPSI1D;
        t7 = t4;
        t8 = BETA;
        t9 = cos(t8);
        t10 = t7 .* t9;
        t11 = eada * omyAad;
        t13 = eadb * omyAad;
        t15 = t2;
        t16 = t15 .* t9;
        t17 = eada * omxAad;
        t19 = eadb * omxAad;
        t25 = dbetadpsi;
        t26 = t25 .* t9;
        t32 = sin(t8);
        t33 = t32 .* t7;
        t36 = t32 .* t15;
        t39 = t32 .* t25;
        omAadA1xvEadA1y = -(t4 * omxAad + t2 * omyAad) .* (t15 * eadb...
            * omxAad - t7 * eadb * omyAad + t26 * eada - t26 * eadb...
            - t10 .* t11 + t10 .* t13 + t16 .* t17 - t16 .* t19 - muzA)...
            + (omzAad + 1) * (-t39 * eada + t39 * eadb - t7 * muxA...
            - t15 * muyA + t33 .* t11 - t33 .* t13 - t36 .* t17 + t36 .* t19);




        t2 = SPSI1D;
        t4 = CPSI1D;
        t7 = BETA;
        t8 = sin(t7);
        t9 = t4;
        t10 = t8 .* t9;
        t11 = eada * omxAad;
        t13 = eadb * omxAad;
        t15 = t2;
        t16 = t8 .* t15;
        t17 = eada * omyAad;
        t19 = eadb * omyAad;
        t21 = cos(t7);
        t22 = t21 * eada;
        t24 = t21 * eadb;
        t29 = eadb * omzAad + t15 * muxA - t9 * muyA + t22 * omzAad...
            - t24 * omzAad - t10 .* t11 + t10 .* t13 - t16 .* t17...
            + t16 .* t19 + eadb + t22 - t24;
        t38 = dbetadpsi;
        t39 = t8 .* t38;
        omAadA1xvEadA1z = (t4 * omxAad + t2 * omyAad) .* t29 - (-t2 * omxAad...
            + t4 * omyAad) .* (-t39 * eada + t39 * eadb - t9 * muxA...
            - t15 * muyA + t10 .* t17 - t10 .* t19 - t16 .* t11 + t16 .* t13);


        omAadA1xvEadA1 = struct('omAadA1xvEadA1x',omAadA1xvEadA1x,'omAadA1xvEadA1y',omAadA1xvEadA1y,'omAadA1xvEadA1z',omAadA1xvEadA1z);
        
    end
        
omAadA1xvEadA1 = fomAA1xvEadA1(muxA,muyA,muzA,omxAad,omyAad,...
            omzAad,eada,eadb,BETA,CPSI1D,SPSI1D,dbetadpsi);
        
omAadA1xvEadA1x = omAadA1xvEadA1.omAadA1xvEadA1x;
omAadA1xvEadA1y = omAadA1xvEadA1.omAadA1xvEadA1y; 
omAadA1xvEadA1z = omAadA1xvEadA1.omAadA1xvEadA1z;  
        
dvEaddpsixA1 = dvEaddpsix + omAadA1xvEadA1x;
dvEaddpsiyA1 = dvEaddpsiy + omAadA1xvEadA1y;
dvEaddpsizA1 = dvEaddpsiz + omAadA1xvEadA1z;

EGBxMdVEdpsixA1 = muP*(XGB*SZETA.*dvEaddpsizA1-((eada-eadb)*SBETA+XGB*CBETA.*SBETA).*dvEaddpsiyA1);
EGBxMdVEdpsiyA1 = muP*(-(eadb+(eada-eadb)*CBETA+XGB*CZETA.*CBETA).*dvEaddpsizA1+((eada-eadb)*SBETA+XGB*CZETA.*SBETA).*dvEaddpsixA1);
EGBxMdVEdpsizA1 = muP*((eadb+(eada-eadb)*CBETA+XGB*CZETA.*CBETA).*dvEaddpsiyA1-XGB*SZETA.*dvEaddpsixA1);


irgxA1 = CMErExA1 + CMGxA1 - dhdpsixA1 - EGBxMdVEdpsixA1;
irgyA1 = CMErEyA1 + CMGyA1 - dhdpsiyA1 - EGBxMdVEdpsiyA1;
irgzA1 = CMErEzA1 + CMGzA1 - dhdpsizA1 - EGBxMdVEdpsizA1;


%--------------------------------------------------------------------------
% Output - F,G,M structures
%--------------------------------------------------------------------------

F = struct('psi2D',psi2Dall,...
    'x2D',x2Dall,...
    'Log10Re',Log10Reout,...
    'M',Mout,...
    'cl',CLout,...
    'cd',CDout,...
    'cm',CMout,...
    'ULad',ULadout,...
    'UTad',UTadout,...
    'UPad',UPadout,...
    'E',Eout,...
    'alpha',ALPHAout,...
    'dTabi',dTabiout,...
    'dTabp',dTabpout,...
    'dTab',dTabout,...
    'dFTabi',dFTabiout,...
    'dFTabp',dFTabpout,...
    'dFTab',dFTabout,...
    'dCFaxA1bi',dCFaxA1bi,...
    'dCFaxA1bp',dCFaxA1bp,...
    'dCFaxA1b',dCFaxA1b,...
    'dCFayA1bi',dCFayA1bi,...
    'dCFayA1bp',dCFayA1bp,...
    'dCFayA1b',dCFayA1b,...
    'dCFazA1bi',dCFazA1bi,...
    'dCFazA1bp',dCFazA1bp,...
    'dCFazA1b',dCFazA1b,...
    'dCMaExA1bi',dCMaExA1bi,...
    'dCMaExA1bp',dCMaExA1bp,...
    'dCMaExA1b',dCMaExA1b,...
    'dCMaEyA1bi',dCMaEyA1bi,...
    'dCMaEyA1bp',dCMaEyA1bp,...
    'dCMaEyA1b',dCMaEyA1b,...
    'dCMaEzA1bi',dCMaEzA1bi,...
    'dCMaEzA1bp',dCMaEzA1bp,...
    'dCMaEzA1b',dCMaEzA1b,...
    'dCHbi',dCHbi,...
    'dCHbp',dCHbp,...
    'dCHb',dCHb,...
    'dCYbi',dCYbi,...
    'dCYbp',dCYbp,...
    'dCYb',dCYb,...
    'dCTbi',dCTbi,...
    'dCTbp',dCTbp,...
    'dCTb',dCTb,...
    'dCMaExAbi',dCMaExAbi,...
    'dCMaExAbp',dCMaExAbp,...
    'dCMaExAb',dCMaExAb,...
    'dCMaEyAbi',dCMaEyAbi,...
    'dCMaEyAbp',dCMaEyAbp,...
    'dCMaEyAb',dCMaEyAb,...
    'dCMaEzAbi',dCMaEzAbi,...
    'dCMaEzAbp',dCMaEzAbp,...
    'dCMaEzAb',dCMaEzAb...
    );
 
G = struct('psi1D',psi1D,...
    'CFaxA1bi',CFaxA1bi,...
    'CFaxA1bp',CFaxA1bp,...
    'CFaxA1b',CFaxA1b,...
    'CFayA1bi',CFayA1bi,...
    'CFayA1bp',CFayA1bp,...
    'CFayA1b',CFayA1b,...
    'CFazA1bi',CFazA1bi,...
    'CFazA1bp',CFazA1bp,...
    'CFazA1b',CFazA1b,...
    'CMaExA1bi',CMaExA1bi,...
    'CMaExA1bp',CMaExA1bp,...
    'CMaExA1b',CMaExA1b,...
    'CMaEyA1bi',CMaEyA1bi,...
    'CMaEyA1bp',CMaEyA1bp,...
    'CMaEyA1b',CMaEyA1b,...
    'CMaEzA1bi',CMaEzA1bi,...
    'CMaEzA1bp',CMaEzA1bp,...
    'CMaEzA1b',CMaEzA1b,...
    'CMFaxA1bi',CMFaxA1bi,...
    'CMFaxA1bp',CMFaxA1bp,...
    'CMFaxA1b',CMFaxA1b,...
    'CMFayA1bi',CMFayA1bi,...
    'CMFayA1bp',CMFayA1bp,...
    'CMFayA1b',CMFayA1b,...
    'CMFazA1bi',CMFazA1bi,...
    'CMFazA1bp',CMFazA1bp,...
    'CMFazA1b',CMFazA1b,...
    'CMaxA1bi',CMaxA1bi,...
    'CMaxA1bp',CMaxA1bp,...
    'CMaxA1b',CMaxA1b,...
    'CMayA1bi',CMayA1bi,...
    'CMayA1bp',CMayA1bp,...
    'CMayA1b',CMayA1b,...
    'CMazA1bi',CMazA1bi,...
    'CMazA1bp',CMazA1bp,...
    'CMazA1b',CMazA1b,...
    'CHbi',CHbi,...
    'CHbp',CHbp,...
    'CHb',CHb,...
    'CYbi',CYbi,...
    'CYbp',CYbp,...
    'CYb',CYb,...
    'CTbi',CTbi,...
    'CTbp',CTbp,...
    'CTb',CTb,...
    'CMaxAbi',CMaxAbi,...
    'CMaxAbp',CMaxAbp,...
    'CMaxAb',CMaxAb,...
    'CMayAbi',CMayAbi,...
    'CMayAbp',CMayAbp,...
    'CMayAb',CMayAb,...
    'CMazAbi',CMazAbi,...
    'CMazAbp',CMazAbp,...
    'CMazAb',CMazAb,...
    'CFaxA1bs',CFaxA1bs,...
    'CFayA1bs',CFayA1bs,...
    'CFazA1bs',CFazA1bs,...
    'CMaxA1bs',CMaxA1bs,...
    'CMayA1bs',CMayA1bs,...
    'CMazA1bs',CMazA1bs,... 
    'CHbs',CHbs,...
    'CYbs',CYbs,...
    'CTbs',CTbs,...
    'CMaxAbs',CMaxAbs,...
    'CMayAbs',CMayAbs,...
    'CMazAbs',CMazAbs,...
    'CMErExA1',CMErExA1,...
    'CMGxA1',CMGxA1,...
    'dhdpsixA1',dhdpsixA1,...
    'EGBxMdVEdpsixA1',EGBxMdVEdpsixA1,...
    'irgxA1',irgxA1,...
    'CMErEyA1',CMErEyA1,...
    'CMGyA1',CMGyA1,...
    'dhdpsiyA1',dhdpsiyA1,...
    'EGBxMdVEdpsiyA1',EGBxMdVEdpsiyA1,...
    'irgyA1',irgyA1,...
    'CMErEzA1',CMErEzA1,...
    'CMGzA1',CMGzA1,...
    'dhdpsizA1',dhdpsizA1,...
    'EGBxMdVEdpsizA1',EGBxMdVEdpsizA1,...
    'irgzA1',irgzA1...
    );
    
M = struct('CFaxA1i',CFaxA1i,...
    'CFaxA1p',CFaxA1p,...
    'CFaxA1',CFaxA1,...
    'CFayA1i',CFayA1i,...
    'CFayA1p',CFayA1p,...
    'CFayA1',CFayA1,...
    'CFazA1i',CFazA1i,...
    'CFazA1p',CFazA1p,...
    'CFazA1',CFazA1,...
    'CMaExA1i',CMaExA1i,...
    'CMaExA1p',CMaExA1p,...
    'CMaExA1',CMaExA1,...
    'CMaEyA1i',CMaEyA1i,...
    'CMaEyA1p',CMaEyA1p,...
    'CMaEyA1',CMaEyA1,...
    'CMaEzA1i',CMaEzA1i,...
    'CMaEzA1p',CMaEzA1p,...
    'CMaEzA1',CMaEzA1,...
    'CMFaxA1i',CMFaxA1i,...
    'CMFaxA1p',CMFaxA1p,...
    'CMFaxA1',CMFaxA1,...
    'CMFayA1i',CMFayA1i,...
    'CMFayA1p',CMFayA1p,...
    'CMFayA1',CMFayA1,...
    'CMFazA1i',CMFazA1i,...
    'CMFazA1p',CMFazA1p,...
    'CMFazA1',CMFazA1,...
    'CMaxA1i',CMaxA1i,...
    'CMaxA1p',CMaxA1p,...
    'CMaxA1',CMaxA1,...
    'CMayA1i',CMayA1i,...
    'CMayA1p',CMayA1p,...
    'CMayA1',CMayA1,...
    'CMazA1i',CMazA1i,...
    'CMazA1p',CMazA1p,...
    'CMazA1',CMazA1,...
    'CHi',CHi,...
    'CHp',CHp,...
    'CH',CH,...
    'CYi',CYi,...
    'CYp',CYp,...
    'CY',CY,...
    'CTi',CTi,...
    'CTp',CTp,...
    'CT',CT,...
    'CMaExAi',CMaExAi,...
    'CMaExAp',CMaExAp,...
    'CMaExA',CMaExA,...
    'CMaEyAi',CMaEyAi,...
    'CMaEyAp',CMaEyAp,...
    'CMaEyA',CMaEyA,...
    'CMaEzAi',CMaEzAi,...
    'CMaEzAp',CMaEzAp,...
    'CMaEzA',CMaEzA,...
    'CMFaxAi',CMFaxAi,...
    'CMFaxAp',CMFaxAp,...
    'CMFaxA',CMFaxA,...
    'CMFayAi',CMFayAi,...
    'CMFayAp',CMFayAp,...
    'CMFayA',CMFayA,...
    'CMFazAi',CMFazAi,...
    'CMFazAp',CMFazAp,...
    'CMFazA',CMFazA,...
    'CMaxAi',CMaxAi,...
    'CMaxAp',CMaxAp,...
    'CMaxA',CMaxA,...
    'CMayAi',CMayAi,...
    'CMayAp',CMayAp,...
    'CMayA',CMayA,...
    'CMazAi',CMazAi,...
    'CMazAp',CMazAp,...
    'CMazA',CMazA,...
    'CFaxA1b0',CFaxA1b0,...
    'CFaxA1bC1',CFaxA1bC,...
    'CFaxA1bS1',CFaxA1bS,...
    'CFayA1b0',CFayA1b0,...
    'CFayA1bC1',CFayA1bC,...
    'CFayA1bS1',CFayA1bS,...
    'CFazA1b0',CFazA1b0,...
    'CFazA1bC1',CFazA1bC,...
    'CFazA1bS1',CFazA1bS,...
    'CMaxA1b0',CMaxA1b0,...
    'CMaxA1bC1',CMaxA1bC,...
    'CMaxA1bS1',CMaxA1bS,...
    'CMayA1b0',CMayA1b0,...
    'CMayA1bC1',CMayA1bC,...
    'CMayA1bS1',CMayA1bS,...
    'CMazA1b0',CMazA1b0,...
    'CMazA1bC1',CMazA1bC,...
    'CMazA1bS1',CMazA1bS,...
    'CHb0',CHb0,...
    'CHbC1',CHbC,...
    'CHbS1',CHbS,...
    'CYb0',CYb0,...
    'CYbC1',CYbC,...
    'CYbS1',CYbS,...
    'CTb0',CTb0,...
    'CTbC1',CTbC,...
    'CTbS1',CTbS,...
    'CMaxAb0',CMaxAb0,...
    'CMaxAbC1',CMaxAbC,...
    'CMaxAbS1',CMaxAbS,...
    'CMayAb0',CMayAb0,...
    'CMayAbC1',CMayAbC,...
    'CMayAbS1',CMayAbS,...
    'CMazAb0',CMazAb0,...
    'CMazAbC1',CMazAbC,...
    'CMazAbS1',CMazAbS,...
    'Log10Rem',Log10Rem,...
    'Mm',Mm,...
    'clm',clm,...
    'cdm',cdm,...
    'Em',Em...
    );

toc



end
