function [dVGBdpsi_Ax, dVGBdpsi_Ay, dVGBdpsi_Az] = getInertialForces(beta,zeta,flightCondition,ndRotor)



psi  = ndRotor.nlRotor.psi2Dall;
xGB  = ndRotor.XGB;
eada = ndRotor.ead;
eadb = ndRotor.ead;

muxA = flightCondition(1);
muyA = flightCondition(2);
muzA = flightCondition(3);

omxAad = flightCondition(4);
omyAad = flightCondition(5);
omzAad = flightCondition(6);


psi1D    = psi(:,1);

CPSI1D    = cos(psi1D);
SPSI1D    = sin(psi1D);
%C2PSI1D   = cos(2*psi1D);
%S2PSI1D   = sin(2*psi1D);


BETA = beta(1) + beta(2)*CPSI1D + beta(3)*SPSI1D;
%BETA = beta(1) + beta(2)*CPSI1D + beta(3)*SPSI1D + beta(4)*C2PSI1D + beta(5)*S2PSI1D;

ZETA = zeta(1) + zeta(2)*CPSI1D + zeta(3)*SPSI1D;
%ZETA = zeta(1) + zeta(2)*CPSI1D + zeta(3)*SPSI1D + zeta(4)*C2PSI1D + zeta(5)*S2PSI1D;

dzetadpsi = zeta(2)*(-SPSI1D)+zeta(3)*CPSI1D;
%dzetadpsi = zeta(2)*(-SPSI1D)+zeta(3)*CPSI1D+2*zeta(4)*(-S2PSI1D)+2*zeta(5)*C2PSI1D;
        
dbetadpsi = beta(2)*(-SPSI1D)+beta(3)*CPSI1D;
%dbetadpsi = beta(2)*(-SPSI1D)+beta(3)*CPSI1D+2*beta(4)*(-S2PSI1D)+2*beta(5)*C2PSI1D;
        
d2zetadpsi2 = zeta(2)*(-CPSI1D)+zeta(3)*(-SPSI1D);
%d2zetadpsi2 = zeta(2)*(-CPSI1D)+zeta(3)*(-SPSI1D)+2*zeta(4)*(-C2PSI1D)+2*zeta(5)*(-S2PSI1D);

d2betadpsi2 = beta(2)*(-CPSI1D)+beta(3)*(-SPSI1D);
%d2betadpsi2 = beta(2)*(-CPSI1D)+beta(3)*(-SPSI1D)+2*beta(4)*(-C2PSI1D)+2*beta(5)*(-S2PSI1D);


function dVGBdpsi_Ax = InForxA(muyA,muzA,omxAad,omyAad,omzAad,BETA,ZETA,...
        CPSI1D,SPSI1D,dbetadpsi,dzetadpsi,d2betadpsi2,d2zetadpsi2,xGB,eada,eadb)
    
t1 = ZETA;
t2 = sin(t1);
t3 = SPSI1D;
t4 = t2 .* t3;
t6 = t4 .* xGB .* omzAad;
t7 = BETA;
t8 = cos(t7);
t9 = CPSI1D;
t10 = t8 .* t9;
t11 = cos(t1);
t12 = t11 .* xGB;
t13 = t10 .* t12;
t15 = t10 .* eada .* omzAad;
t17 = t10 .* eadb .* omzAad;
t18 = sin(t7);
t19 = dbetadpsi;
t20 = t18 .* t19;
t21 = t3 .* eada;
t22 = t20 .* t21;
t24 = t3 .* eadb;
t25 = t20 .* t24;
t27 = dzetadpsi;
t28 = t27 .* t9;
t29 = t28 .* t12;
t30 = t19 .^ 2;
t31 = t8 .* t30;
t32 = t9 .* eada;
t34 = t9 .* eadb;
t36 = d2betadpsi2;
t37 = t18 .* t36;
t39 = d2zetadpsi2;
t41 = t3 .* xGB;
t43 = t8 .* t19;
t44 = eada .* omyAad;
t46 = eadb .* omyAad;
t49 = t4 .* xGB;
t50 = t10 .* eada;
t51 = -t39 .* t11 .* t41 - t31 .* t32 + t31 .* t34 - t37 .* t32 + t37 .* t34 + t43 .* t44 - t43 .* t46 - t13 - t15 + t17 + 0.2e1 .* t22 - 0.2e1 .* t25 - t29 + t49 - t50 + t6;
t52 = t10 .* eadb;
t53 = t34 .* omzAad;
t54 = t2 .* t8;
t57 = t54 .* t27 .* t3 .* xGB;
t59 = t10 .* t12 .* omzAad;
t62 = t20 .* t11 .* t3 .* xGB;
t65 = t9 .* t11 .* xGB;
t71 = t12 .* omyAad;
t77 = t2 .* t18;
t91 = xGB .* omxAad;
t98 = t8 .* t3;
t107 = -t10 .* t71 + t8 .* t11 .* t41 .* omxAad - t77 .* t27 .* xGB + t2 .* t9 .* t91 + t4 .* xGB .* omyAad + t43 .* t12 - t10 .* t44 + t10 .* t46 + t98 .* eada .* omxAad - t98 .* eadb .* omxAad + t43 .* eada - t43 .* eadb - t34 .* omyAad + t24 .* omxAad - muzA;
t115 = -t18 .* eada .* omxAad + t18 .* eadb .* omxAad - t18 .* t11 .* t91 - muyA + t13 + t15 - t17 - t22 + t25 + t29 + t34 - t49 + t50 - t52 + t53 - t57 + t59 - t6 - t62;
t117 = t52 - t53 + t57 - t59 + 0.2e1 .* t62 - t37 .* t65 + t20 .* t21 .* omzAad - t20 .* t24 .* omzAad + t43 .* t71 - t54 .* t39 .* t9 .* xGB - t31 .* t65 + t77 .* t19 .* t28 .* xGB + t20 .* t11 .* t41 .* omzAad - t34 + omyAad .* t107 - omzAad .* t115;
dVGBdpsi_Ax = t51 + t117;

end

dVGBdpsi_Ax = InForxA(muyA,muzA,omxAad,omyAad,omzAad,BETA,ZETA,...
        CPSI1D,SPSI1D,dbetadpsi,dzetadpsi,d2betadpsi2,d2zetadpsi2,xGB,eada,eadb);

function dVGBdpsi_Ay = InForyA(muxA,muzA,omxAad,omyAad,omzAad,BETA,ZETA,...
        CPSI1D,SPSI1D,dbetadpsi,dzetadpsi,d2betadpsi2,d2zetadpsi2,xGB,eada,eadb)
    
t1 = BETA;
t2 = sin(t1);
t3 = d2betadpsi2;
t4 = t2 .* t3;
t5 = SPSI1D;
t6 = t5 .* eada;
t8 = t5 .* eadb;
t10 = d2zetadpsi2;
t11 = CPSI1D;
t13 = ZETA;
t14 = cos(t13);
t15 = t14 .* xGB;
t17 = cos(t1);
t18 = dbetadpsi;
t19 = t17 .* t18;
t20 = eada .* omxAad;
t22 = eadb .* omxAad;
t24 = t18 .^ 2;
t25 = t17 .* t24;
t28 = sin(t13);
t29 = t28 .* t11;
t31 = t29 .* xGB .* omzAad;
t32 = t17 .* t14;
t33 = t5 .* xGB;
t34 = t32 .* t33;
t35 = t17 .* t5;
t37 = t35 .* eada .* omzAad;
t39 = t35 .* eadb .* omzAad;
t40 = t2 .* t18;
t41 = t11 .* eada;
t42 = t40 .* t41;
t44 = t11 .* eadb;
t45 = t40 .* t44;
t47 = dzetadpsi;
t49 = t47 .* t14 .* t33;
t50 = t29 .* xGB;
t51 = t35 .* eada;
t52 = t10 .* t11 .* t15 - t19 .* t20 + t19 .* t22 - t25 .* t6 + t25 .* t8 - t4 .* t6 + t4 .* t8 - t31 - t34 - t37 + t39 - 0.2e1 .* t42 + 0.2e1 .* t45 - t49 - t50 - t51;
t53 = t35 .* eadb;
t54 = t8 .* omzAad;
t55 = t17 .* t11;
t60 = t28 .* t2;
t66 = xGB .* omyAad;
t79 = -t55 .* eada .* omyAad + t55 .* eadb .* omyAad - t55 .* t15 .* omyAad + t28 .* t5 .* t66 + t29 .* xGB .* omxAad + t32 .* t33 .* omxAad - t60 .* t47 .* xGB + t19 .* eada - t19 .* eadb + t19 .* t15 + t35 .* t20 - t35 .* t22 - t44 .* omyAad + t8 .* omxAad - muzA;
t81 = t28 .* t17;
t84 = t81 .* t47 .* t11 .* xGB;
t86 = t32 .* t33 .* omzAad;
t89 = t40 .* t11 .* t14 .* xGB;
t96 = t2 .* eada .* omyAad - t2 .* eadb .* omyAad + t2 .* t14 .* t66 - muxA - t31 - t34 - t37 + t39 - t42 + t45 - t49 - t50 - t51 + t53 - t54 - t8 - t84 - t86 - t89;
t106 = t14 .* t5 .* xGB;
t119 = t53 - t54 - t8 - omxAad .* t79 + omzAad .* t96 + t60 .* t18 .* t47 .* t5 .* xGB - t40 .* t11 .* t15 .* omzAad - t25 .* t106 - t81 .* t10 .* t5 .* xGB - t4 .* t106 - t40 .* t41 .* omzAad + t40 .* t44 .* omzAad - t19 .* t15 .* omxAad - t84 - t86 - 0.2e1 .* t89;
dVGBdpsi_Ay = t52 + t119;

end

dVGBdpsi_Ay = InForyA(muxA,muzA,omxAad,omyAad,omzAad,BETA,ZETA,...
        CPSI1D,SPSI1D,dbetadpsi,dzetadpsi,d2betadpsi2,d2zetadpsi2,xGB,eada,eadb);

function dVGBdpsi_Az = InForzA(muxA,muyA,omxAad,omyAad,omzAad,BETA,ZETA,...
        CPSI1D,SPSI1D,dbetadpsi,dzetadpsi,d2betadpsi2,d2zetadpsi2,xGB,eada,eadb)
        
t1 = BETA;
t2 = cos(t1);
t3 = SPSI1D;
t4 = t2 .* t3;
t5 = ZETA;
t6 = cos(t5);
t7 = t6 .* xGB;
t8 = t7 .* omyAad;
t10 = t2 .* t6;
t11 = CPSI1D;
t15 = sin(t5);
t16 = t15 .* t2;
t17 = dbetadpsi;
t18 = dzetadpsi;
t22 = sin(t1);
t23 = t22 .* t17;
t24 = t11 .* eada;
t27 = t11 .* eadb;
t30 = t3 .* eada;
t33 = t3 .* eadb;
t39 = t3 .* xGB;
t42 = d2betadpsi2;
t43 = t2 .* t42;
t45 = t17 .^ 2;
t46 = t22 .* t45;
t50 = t4 .* t8 + t10 .* t11 .* xGB .* omxAad - t16 .* t17 .* t18 .* xGB + t23 .* t24 .* omyAad - t23 .* t27 .* omyAad - t23 .* t30 .* omxAad + t23 .* t33 .* omxAad + t23 .* t11 .* t8 - t23 .* t6 .* t39 .* omxAad + t43 .* eada - t46 .* eada - t43 .* eadb + t46 .* eadb;
t54 = d2zetadpsi2;
t57 = t15 .* t3;
t58 = xGB .* omxAad;
t60 = t15 .* t11;
t61 = xGB .* omyAad;
t69 = t2 .* t11;
t82 = xGB .* omzAad;
t85 = eada .* omzAad;
t87 = eadb .* omzAad;
t91 = t22 .* t6;
t93 = t18 .* t11;
t98 = t22 .* eada;
t100 = t22 .* eadb;
t103 = -t16 .* t18 .* t3 .* xGB + t69 .* t7 .* omzAad - t23 .* t6 .* t3 .* xGB - t57 .* t82 + t69 .* t7 + t69 .* t85 - t69 .* t87 - t23 .* t30 + t23 .* t33 - t91 .* t58 + t93 .* t7 - t57 .* xGB + t69 .* eada - t69 .* eadb - t98 .* omxAad + t100 .* omxAad + t27 .* omzAad + t27 - muyA;
t127 = -t16 .* t93 .* xGB - t10 .* t39 .* omzAad - t23 .* t11 .* t6 .* xGB - t60 .* t82 - t10 .* t39 - t4 .* t85 + t4 .* t87 - t23 .* t24 + t23 .* t27 + t91 .* t61 - t18 .* t6 .* t39 - t60 .* xGB - t4 .* eada + t4 .* eadb + t98 .* omyAad - t100 .* omyAad - t33 .* omzAad - t33 - muxA;
t129 = t33 .* omyAad + t27 .* omxAad - t15 .* t22 .* t54 .* xGB - t57 .* t58 + t60 .* t61 + t43 .* t7 - t46 .* t7 + t4 .* eada .* omyAad - t4 .* eadb .* omyAad + t69 .* eada .* omxAad - t69 .* eadb .* omxAad + omxAad .* t103 - omyAad .* t127;
dVGBdpsi_Az = t50 + t129;

    end

dVGBdpsi_Az = InForzA(muxA,muyA,omxAad,omyAad,omzAad,BETA,ZETA,...
        CPSI1D,SPSI1D,dbetadpsi,dzetadpsi,d2betadpsi2,d2zetadpsi2,xGB,eada,eadb);

end