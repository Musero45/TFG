
function [theta0, theta1c, theta1s, theta0_RA,angulo_cabeceo,angulo_balance,fval] =...
    solucion_trimado (MHAdim, mu_xT, mu_yT, mu_zT, mu_WxT, mu_WyT, mu_WzT, theta00, theta1c0,...
    theta1s0, theta0_RA0, angulo_guinada0, angulo_cabeceo0, angulo_balance0)

%Solución del sistema del rotor principal

%si se usan menos incognitas, hay que reflejarlo en las condiciones iniciales
%x = fsolve(@(incog) trimado(incog,MHAdim,Veloc,theta0,theta1c,theta1s,theta0_RA,angulo_guinada,angulo_cabeceo,angulo_balance), [theta0;theta1c;theta1s]);

TolFun = MHAdim.Analisis.Precision;
MaxIter = MHAdim.Analisis.NumeroMaxIter;

%options = optimset('fsolve');
options = optimset('Display','iter','TolFun',TolFun,'MaxIter',MaxIter);

 [x,fval] = fsolve(@(incog) trimado(incog,MHAdim, mu_xT, mu_yT, mu_zT, mu_WxT, mu_WyT, mu_WzT, angulo_guinada0),...
    [theta00;theta1c0;theta1s0;theta0_RA0;angulo_cabeceo0;angulo_balance0],options);

% x = fsolve(@(incog) DemostradorTrimado(incog,MHAdim,Veloc,angulo_guinada0),...
%     [theta00;theta1c0;theta1s0;theta0_RA0;angulo_cabeceo0;angulo_balance0]);

theta0 = x(1);
theta1c = x(2);
theta1s = x(3);
theta0_RA = x(4);
angulo_cabeceo = npi2pi(x(5),'rad');
angulo_balance = npi2pi(x(6),'rad');

end