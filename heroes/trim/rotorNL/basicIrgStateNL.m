function [irgxA1, irgyA1, irgzA1] = basicIrgStateNL(beta,theta,zeta,fc,GA,ndRotor)
%basicIrgStateNL Summary of this function goes here
%   Detailed explanation goes here

XGB      = ndRotor.XGB;
eada     = ndRotor.ead;
eadb     = ndRotor.ead;
Kbeta    = ndRotor.Kbeta;
muP      = ndRotor.muP;
epsilonR = ndRotor.epsilonR;
RITB     = ndRotor.RITB;
RIZB     = ndRotor.RIZB;
aG       = ndRotor.aG;

Ibetaad  = muP*XGB/epsilonR;

psi      = ndRotor.nlRotor.psi2Dall;

psi1D    = psi(:,1);

CPSI1D    = cos(psi1D);
SPSI1D    = sin(psi1D);
%C2PSI1D   = cos(2*psi1D);
%S2PSI1D   = sin(2*psi1D);

BETA = beta(1) + beta(2)*CPSI1D + beta(3)*SPSI1D;
%BETA = beta(1) + beta(2)*CPSI1D + beta(3)*SPSI1D + beta(4)*C2PSI1D + beta(5)*S2PSI1D;

CBETA   = cos(BETA);
SBETA   = sin(BETA);

ZETA = zeta(1) + zeta(2)*CPSI1D + zeta(3)*SPSI1D;
%ZETA = zeta(1) + zeta(2)*CPSI1D + zeta(3)*SPSI1D + zeta(4)*C2PSI1D + zeta(5)*S2PSI1D;

CZETA   = cos(ZETA);
SZETA   = sin(ZETA);

THETA = theta(1) + theta(2)*CPSI1D + theta(3)*SPSI1D;
%THETA = theta(1) + theta(2)*CPSI1D + theta(3)*SPSI1D + theta(4)*C2PSI1D + theta(5)*S2PSI1D;

CTHETA   = cos(THETA);
STHETA   = sin(THETA);

CMErExA1 = 0;
CMErEyA1 = Kbeta*BETA;
CMErEzA1 = 0; %CMErzA_A1 = Kzeta*ZETA;

GxA  = GA(1);
GyA  = GA(2);
GzA  = GA(3);

CMGxA1 = muP*aG*(XGB*SZETA*GzA-((eada-eadb)*SBETA+XGB*CZETA.*SBETA).*(-SPSI1D*GxA+CPSI1D*GyA));
CMGyA1 = muP*aG*(-(eadb+(eada-eadb)*CBETA+XGB*CZETA.*CBETA)*GzA+((eada-eadb)*SBETA+XGB*CZETA.*SBETA).*(CPSI1D*GxA+SPSI1D*GyA));
CMGzA1 = muP*aG*((eadb+(eada-eadb)*CBETA+XGB*CZETA.*CBETA).*(-SPSI1D*GxA+CPSI1D*GyA)-XGB*SZETA.*(CPSI1D*GxA+SPSI1D*GyA));

muxA   = fc(1);
muyA   = fc(2);
muzA   = fc(3);

omxAad = fc(4);
omyAad = fc(5);
omzAad = fc(6);


dzetadpsi = zeta(2)*(-SPSI1D)+zeta(3)*CPSI1D;
%dzetadpsi = zeta(2)*(-SPSI1D)+zeta(3)*CPSI1D+2*zeta(4)*(-S2PSI1D)+2*zeta(5)*C2PSI1D;
        
dbetadpsi = beta(2)*(-SPSI1D)+beta(3)*CPSI1D;
%dbetadpsi = beta(2)*(-SPSI1D)+beta(3)*CPSI1D+2*beta(4)*(-S2PSI1D)+2*beta(5)*C2PSI1D;
                
dthetadpsi = theta(2)*(-SPSI1D)+theta(3)*CPSI1D;
%dthetadpsi = theta(2)*(-SPSI1D)+theta(3)*CPSI1D+2*theta(4)*(-S2PSI1D)+2*theta(5)*C2PSI1D;
        
d2zetadpsi2 = zeta(2)*(-CPSI1D)+zeta(3)*(-SPSI1D);
%d2zetadpsi2 = zeta(2)*(-CPSI1D)+zeta(3)*(-SPSI1D)+2*zeta(4)*(-C2PSI1D)+2*zeta(5)*(-S2PSI1D);

d2betadpsi2 = beta(2)*(-CPSI1D)+beta(3)*(-SPSI1D);
%d2betadpsi2 = beta(2)*(-CPSI1D)+beta(3)*(-SPSI1D)+2*beta(4)*(-C2PSI1D)+2*beta(5)*(-S2PSI1D);
        
d2thetadpsi2 = theta(2)*(-CPSI1D)+theta(3)*(-SPSI1D);
%d2thetadpsi2 = theta(2)*(-CPSI1D)+theta(3)*(-SPSI1D)+2*theta(4)*(-C2PSI1D)+2*theta(5)*(-S2PSI1D);


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

end