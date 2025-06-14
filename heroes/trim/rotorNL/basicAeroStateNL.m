function Out = basicAeroStateNL(beta,theta,zeta,lambda,flightCondition,muW,ndRotor)
%basicAeroStateNL Summary of this function goes here
%   Detailed explanation goes here

Re       = ndRotor.Re;
M        = ndRotor.M;

psi2D    = ndRotor.nlRotor.psi2D;
psi2Dall = ndRotor.nlRotor.psi2Dall;
x2D      = ndRotor.nlRotor.x2D;
thetaG2D = ndRotor.nlRotor.thetaG2D;
airfoil  = ndRotor.nlRotor.airfoil;
eada     = ndRotor.ead;
eadb     = ndRotor.ead;

muxA = flightCondition(1);
muyA = flightCondition(2);
muzA = flightCondition(3);

omxA = flightCondition(4);
omyA = flightCondition(5);
omzA = flightCondition(6);

airmuxA = muxA + muW(1);
airmuyA = muyA + muW(2);
airmuzA = muzA + muW(3);

beta0  = beta(1);
beta1C = beta(2);
beta1S = beta(3);

% loop in number of blade regions

%-------------------------------------------------------------------------
%Initialitation of aerostate data
%-------------------------------------------------------------------------

UTadout      = [];
UPadout      = [];
dTabiout     = [];
dTab0out     = [];
dTabout      = [];
dFTabiout    = [];
dFTab0out    = [];
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
    
    %C2PSI         = cos(2*PSI);
    %S2PSI         = sin(2*PSI);
    
    
    BETA{nli}   = beta0 + beta1C*CPSI + beta1S*SPSI;
    %BETA{nli}   = beta0 + beta1C*CPSI + beta1S*SPSI + beta(4)*C2PSI + beta(5)*S2PSI;
    ZETA{nli}   = zeta(1) + zeta(2)*CPSI + zeta(3)*SPSI;
    %ZETA{nli}   = zeta(1) + zeta(2)*CPSI + zeta(3)*SPSI + zeta(4)*C2PSI + zeta(5)*S2PSI;
    LAMBDA{nli}   = lambda(1) + lambda(2)*CPSI + lambda(3)*SPSI;

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
    

    %vP3x = SZETA.*SBETA.^2*eadb-CBETA.*(-eadb*SZETA.*CBETA-(eada-eadb)*SZETA);
    
    %vP3y = CZETA.*SBETA.^2*eadb+CBETA.*(eadb*CZETA.*CBETA+(eada-eadb)*CZETA+X-eada);
    
    %vP3z = CZETA.*SBETA.*(-eadb*SZETA.*CBETA-(eada-eadb)*SZETA)+SZETA.*SBETA..*..
    %    (eadb*CZETA.*CBETA+(eada-eadb)*CZETA+X-eada);
    
    vP3x = SZETA.*(CBETA*eada-CBETA*eadb+eadb);
    vP3y = CBETA.*CZETA*eada-eadb*CZETA.*CBETA+CBETA.*X-CBETA*eada+eadb*CZETA;
    vP3z = SBETA.*(X-eada).*SZETA;
    
    vP4x = 0;
    vP4y = 0;
    %vP4z = (-SZETA.^2).*(beta1S*CPSI-beta1C*SPSI).*(eada-eadb)-...
    %    CZETA.*(beta1S*CPSI-beta1C*SPSI).*((eada-eadb)*CZETA+X-eada);
        
    vP4z = -CPSI.*CZETA*beta1S.*X+CPSI.*CZETA*beta1S*eada+SPSI.*CZETA*beta1C.*X...
        -SPSI.*CZETA*beta1C*eada-CPSI*beta1S*eada+CPSI*beta1S*eadb+SPSI*beta1C*eada-SPSI*beta1C*eadb;

    
    vP5x = 0;
    vP5y = (zeta(3)*CPSI-zeta(2)*SPSI).*(X-eada);
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
    THETA{nli}   = theta(1)+theta(2)*CPSI+theta(3)*SPSI+THETAG2D;
    ALPHA{nli}  = angle2pmpi(PHI{nli}+THETA{nli});
    
    Re2D{nli}      = sqrt((UTad{nli}).^2+(UPad{nli}).^2)*Re;
    Log10Re2D{nli} = log10(Re2D{nli});
    M2D{nli}       = sqrt((UTad{nli}).^2+(UPad{nli}).^2)*M;
    
    CL2D{nli}    = interpn(ALPHA3D_CL,Log10Re3D_CL,M3D_CL,CL3D,ALPHA{nli},Log10Re2D{nli},...
                         M2D{nli});
    CD2D{nli}    = interpn(ALPHA3D_CD,Log10Re3D_CD,M3D_CD,CD3D,ALPHA{nli},Log10Re2D{nli},...
                         M2D{nli});
    CM2D{nli}    = interpn(ALPHA3D_CM,Log10Re3D_CM,M3D_CM,CM3D,ALPHA{nli},Log10Re2D{nli},...
                         M2D{nli});

    
    CPHI{nli}   = cos(PHI{nli});
    SPHI{nli}   = sin(PHI{nli});
    
    dTabi{nli}    = CL2D{nli}.*CPHI{nli};
    dTab0{nli}    = CD2D{nli}.*SPHI{nli};
    dFTabi{nli}   = -CL2D{nli}.*SPHI{nli};
    dFTab0{nli}   = CD2D{nli}.*CPHI{nli};
    
    dTab{nli}    = dTabi{nli}+dTab0{nli};
    dFTab{nli}   = dFTabi{nli}+dFTab0{nli};
    
    UTadout      = [UTadout UTad{nli}];
    UPadout      = [UPadout UPad{nli}];
    dTabiout     = [dTabiout dTabi{nli}];
    dTab0out     = [dTab0out dTab0{nli}];
    dTabout      = [dTabout dTab{nli}];
    dFTabiout    = [dFTabiout dFTabi{nli}];    
    dFTab0out    = [dFTab0out dFTab0{nli}];  
    dFTabout     = [dFTabout dFTab{nli}];    
    
    CPSIout      = cos(psi2Dall);
    SPSIout      = sin(psi2Dall);
    
    CPHIout      = [CPHIout cos(PHI{nli})];
    SPHIout      = [SPHIout sin(PHI{nli})];

    CBETAout     = [CBETAout cos(BETA{nli})];
    SBETAout     = [SBETAout sin(BETA{nli})];
     
    CZETAout     = [CZETAout cos(ZETA{nli})];
    SZETAout     = [SZETAout sin(ZETA{nli})];
    
    vaerad = struct('UTad',UTadout,'UPad',UPadout);
    
    harmFunct = struct ('CPSI',CPSIout,'SPSI',SPSIout,'CPHI',CPHIout,'SPHI',...
        SPHIout,'CBETA',CBETAout,'SBETA',SBETAout,'CZETA',CZETAout,'SZETA',SZETAout);
    
    dFab = struct('dTabi',dTabiout,'dTab0',dTab0out,'dTab',dTabout,'dFTabi',...
        dFTabiout,'dFTab0',dFTab0out,'dFTab',dFTabout);
    
end

    Out = struct('vaerad',vaerad,'dFab',dFab,'harmFunct',harmFunct);
    
end


    

