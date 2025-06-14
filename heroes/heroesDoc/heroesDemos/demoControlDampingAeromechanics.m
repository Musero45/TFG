%% Control and damping derivatives of the aeromechanics of rotor
% The goals of this demo are the following ones:
% Show how the control and damping derivatives change with the 
% helicopter forward speed. From this point of view this demo is completely
% different from demoHoverAeromechanics. The flight condition of this demo
% is a forward speed flight condition. 
%
% 

clear all
close all
setPlot
r2d               = 180/pi;
%%
%
atm               = getISA;
heRef             = rigidBo105(atm);
ndHeRef           = rigidHe2ndHe(heRef,atm,0);
ndRotorRef        = ndHeRef.mainRotor;


GA                = [0; 0; -1];
muW               = [0; 0; 0];

%% Control and damping derivatives at hover
%
n_i               = 11;
SBeta_i           = linspace(0,0.5,n_i);

beta1C_1Ci        = zeros(1,n_i);
beta1S_1Ci        = zeros(1,n_i);
beta1C_1Si        = zeros(1,n_i);
beta1S_1Si        = zeros(1,n_i);
beta1C_wxi        = zeros(1,n_i);
beta1C_wyi        = zeros(1,n_i);
beta1S_wxi        = zeros(1,n_i);
beta1S_wyi        = zeros(1,n_i);

leg_i             = cell(1,n_i);
lambda            = [NaN; NaN; NaN];
mu_i              = [0;0;0];
for i = 1:n_i
ndRotor_i           = ndRotorRef;
ndRotor_i.SBeta     = SBeta_i(i);

[dBdT,dBdw]         = flappingDer(lambda,mu_i,GA,muW,ndRotor_i);
beta1C_1Ci(i)       = dBdT(1);
beta1C_1Si(i)       = dBdT(2);
beta1S_1Ci(i)       = dBdT(3);
beta1S_1Si(i)       = dBdT(4);


beta1C_wxi(i)       = dBdw(1); 
beta1C_wyi(i)       = dBdw(2);
beta1S_wxi(i)       = dBdw(4);
beta1S_wyi(i)       = dBdw(5);
end

figure(100) 
plot(SBeta_i,-beta1C_1Si,'r-o'); hold on;
plot(SBeta_i,+beta1S_1Ci,'b-o'); hold on;
plot(SBeta_i,+beta1C_1Ci,'r-.s'); hold on;
plot(SBeta_i,+beta1S_1Si,'b-.s'); hold on;
xlabel('$$S_\beta$$ [-]');
l=legend(...
'$$\frac{\partial \beta_{1C}}{\partial \theta_{1S}}$$',...
'$$\frac{\partial \beta_{1S}}{\partial \theta_{1C}}$$',...
'$$\frac{\partial \beta_{1C}}{\partial \theta_{1C}}$$',...
'$$\frac{\partial \beta_{1S}}{\partial \theta_{1S}}$$',...
'Location','Best');
set(l,'interpreter','latex');
grid on;




%% Control and damping derivatives of the rotor


SBeta_a           = [0.0,0.5,1.0];
n_s               = length(SBeta_a);

Lock0             = 7.0;
ndRotorRef.gamma  = Lock0;
n_mu              = 11;
mu_xA             = linspace(0,0.3,n_mu);

beta1C_1C         = zeros(n_mu,n_s);
beta1S_1C         = zeros(n_mu,n_s);
beta1C_1S         = zeros(n_mu,n_s);
beta1S_1S         = zeros(n_mu,n_s);
beta1C_wx         = zeros(n_mu,n_s);
beta1C_wy         = zeros(n_mu,n_s);
beta1S_wx         = zeros(n_mu,n_s);
beta1S_wy         = zeros(n_mu,n_s);

leg_s             = cell(1,n_s);
lambda            = [NaN; NaN; NaN];
for i = 1:n_s
ndRotor_s            = ndRotorRef;
ndRotor_s.SBeta      = SBeta_a(i);
leg_s{i}             = strcat('$$S_\beta$$ =',num2str(SBeta_a(i)));

for j = 1:n_mu

    mu                   = [mu_xA(j);0;0];
    [dBdT,dBdw]          = flappingDer(lambda,mu,GA,muW,ndRotor_s);
    beta1C_1C(j,i)       = dBdT(1);
    beta1C_1S(j,i)       = dBdT(2);
    beta1S_1C(j,i)       = dBdT(3);
    beta1S_1S(j,i)       = dBdT(4);


    beta1C_wx(j,i)       = dBdw(1); 
    beta1C_wy(j,i)       = dBdw(2);
    beta1S_wx(j,i)       = dBdw(4);
    beta1S_wy(j,i)       = dBdw(5);
end
end

mark           = {'o','s','<','^'};
leg_ms         = cell(1,2*n_s);

figure(1) 
title(strcat('$$\gamma$$ =',num2str(Lock0)))
for i = 1:n_s
i1           = 1 + 2*(i-1);
leg_ms{i1}   = strcat(leg_s{i},...
             ', $$\frac{\partial \beta_{1C}}{\partial \theta_{1S}}$$');
leg_ms{i1+1} = strcat(leg_s{i},...
             ', $$ \frac{\partial \beta_{1S}}{\partial \theta_{1C}}$$');

plot(mu_xA,beta1C_1S(:,i),strcat('b--',mark{i})); hold on;
plot(mu_xA,beta1S_1C(:,i),strcat('r-',mark{i})); hold on;
end
xlabel('$$\mu_{xA}$$ [-]');
l=legend(leg_ms,'Location','Best');
set(l,'interpreter','latex');
grid on;


figure(2)
title(strcat('$$\gamma$$ =',num2str(Lock0)))
for i = 1:n_s
i1           = 1 + 2*(i-1);
leg_ms{i1}   = strcat(leg_s{i},...
             ', $$\Omega \frac{\partial \beta_{1C}}{\partial \theta_{1C}}$$');
leg_ms{i1+1} = strcat(leg_s{i},...
             ', $$\Omega \frac{\partial \beta_{1S}}{\partial \theta_{1S}}$$');

plot(mu_xA,beta1C_1C(:,i),strcat('b-',mark{i})); hold on;
plot(mu_xA,beta1S_1S(:,i),strcat('r--',mark{i})); hold on;
end
xlabel('$$\mu_{xA}$$ [-]');
l=legend(leg_ms,'Location','Best');
set(l,'interpreter','latex');
grid on;




figure(3) 
title(strcat('$$\gamma$$ =',num2str(Lock0)))
for i = 1:n_s
i1           = 1 + 2*(i-1);
leg_ms{i1}   = strcat(leg_s{i},...
             ', $$\Omega \frac{\partial \beta_{1C}}{\partial \omega_{yA}}$$');
leg_ms{i1+1} = strcat(leg_s{i},...
             ', $$\Omega \frac{\partial \beta_{1S}}{\partial \omega_{xA}}$$');

plot(mu_xA,beta1C_wy(:,i),strcat('b--',mark{i})); hold on;
plot(mu_xA,beta1S_wx(:,i),strcat('r-',mark{i})); hold on;
end
xlabel('$$\mu_{xA}$$ [-]');
l=legend(leg_ms,'Location','Best');
set(l,'interpreter','latex');
grid on;

figure(4) 
title(strcat('$$\gamma$$ =',num2str(Lock0)))
for i = 1:n_s
i1           = 1 + 2*(i-1);
leg_ms{i1}   = strcat(leg_s{i},...
             ', $$\Omega \frac{\partial \beta_{1S}}{\partial \omega_{yA}}$$');
leg_ms{i1+1} = strcat(leg_s{i},...
             ', $$\Omega \frac{\partial \beta_{1C}}{\partial \omega_{xA}}$$');

plot(mu_xA,beta1S_wy(:,i),strcat('b--',mark{i})); hold on;
plot(mu_xA,beta1C_wx(:,i),strcat('r-',mark{i})); hold on;
end
xlabel('$$\mu_{xA}$$ [-]');
l=legend(leg_ms,'Location','Best');
set(l,'interpreter','latex');
grid on;

io = 1;
%% References
%
% [1] Alvaro Cuerva Tejero, Jose Luis Espino Granado, Oscar Lopez Garcia,
% Jose Meseguer Ruiz, and Angel Sanz Andres. Teoria de los Helicopteros.
% Serie de Ingenieria y Tecnologia Aeroespacial. Universidad Politecnica
% de Madrid, 2008.
%
% [2] G.D. Padfield. Helicopter Flight Dynamics. Blackwell Science, 1996.
%








% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % %%
% % % % % % % % % % % % % % % % % Reference condition
% % % % % % % % % % % % % % % % atm               = getISA;
% % % % % % % % % % % % % % % % heRef             = rigidBo105(atm);
% % % % % % % % % % % % % % % % ndHeRef           = rigidHe2ndHe(heRef,atm.rho0,atm.g);
% % % % % % % % % % % % % % % % ndRotorRef        = ndHeRef.mainRotor;
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % sigma             = ndRotorRef.sigma0;
% % % % % % % % % % % % % % % % cla               = ndRotorRef.cldata(1);
% % % % % % % % % % % % % % % % theta1            = ndRotorRef.theta1;
% % % % % % % % % % % % % % % % f_theta0          = @(CT) 6*CT/sigma/cla - 3*theta1/4 + 3/2*sqrt(CT/2);
% % % % % % % % % % % % % % % % CTRef             = ndRotorRef.CW;
% % % % % % % % % % % % % % % % % theta0Ref         = f_theta0(CTRef);
% % % % % % % % % % % % % % % % theta0Ref=0.0;
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % thetaRef          = [theta0Ref; 0; 0];
% % % % % % % % % % % % % % % % fC0               = zeros(6,1);
% % % % % % % % % % % % % % % % GA                = [0; 0; -1];
% % % % % % % % % % % % % % % % muW               = [0; 0; 0];
% % % % % % % % % % % % % % % % system2solve      = @(x) aeromechanicsLin(x,thetaRef,fC0,GA,muW,ndRotorRef);
% % % % % % % % % % % % % % % % x0Ref             = [2/r2d;  0; 0; ...
% % % % % % % % % % % % % % % %                      -sqrt(CTRef/2); 0; 0; ...
% % % % % % % % % % % % % % % %                      CTRef; 0; 0];
% % % % % % % % % % % % % % % % opt               = optimset('Display','off');
% % % % % % % % % % % % % % % % xRef              = fsolve(system2solve,x0Ref,opt);
% % % % % % % % % % % % % % % % beta0Ref          = xRef(1);
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % %% Control derivatives of the rotor
% % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % theta1C           = 1/r2d;
% % % % % % % % % % % % % % % % theta1S           = 1/r2d;
% % % % % % % % % % % % % % % % SBeta_a           = [0.0,0.5,1.0];
% % % % % % % % % % % % % % % % n_s               = length(SBeta_a);
% % % % % % % % % % % % % % % % theta_1C          = [theta0Ref;theta1C;0];
% % % % % % % % % % % % % % % % theta_1S          = [theta0Ref;0;theta1S];
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % Lock0             = 7.0;
% % % % % % % % % % % % % % % % ndRotorRef.gamma  = Lock0;
% % % % % % % % % % % % % % % % n_mu              = 11;
% % % % % % % % % % % % % % % % mu_xA             = linspace(0,0.3,n_mu);
% % % % % % % % % % % % % % % % beta1C_1C         = zeros(n_mu,n_s);
% % % % % % % % % % % % % % % % beta1S_1C         = zeros(n_mu,n_s);
% % % % % % % % % % % % % % % % beta1C_1S         = zeros(n_mu,n_s);
% % % % % % % % % % % % % % % % beta1S_1S         = zeros(n_mu,n_s);
% % % % % % % % % % % % % % % % b0                = beta0Ref;
% % % % % % % % % % % % % % % % leg_s             = cell(1,n_s);
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % for i = 1:n_s
% % % % % % % % % % % % % % % % ndRotor_s            = ndRotorRef;
% % % % % % % % % % % % % % % % ndRotor_s.SBeta      = SBeta_a(i);
% % % % % % % % % % % % % % % % leg_s{i}             = strcat('$$S_\beta$$ =',num2str(SBeta_a(i)));
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % for j = 1:n_mu
% % % % % % % % % % % % % % % %     x0_a                 = [b0;  0; 0; ...
% % % % % % % % % % % % % % % %                             -sqrt(CTRef/2); 0; 0; ...
% % % % % % % % % % % % % % % %                             CTRef; 0; 0];
% % % % % % % % % % % % % % % %     fC_mu                = fC0;
% % % % % % % % % % % % % % % %     fC_mu(1)             = mu_xA(j);
% % % % % % % % % % % % % % % %     s2s_1C               = @(x) aeromechanicsLin(x,theta_1C,fC_mu,GA,muW,ndRotor_s);
% % % % % % % % % % % % % % % %     x_1C                 = fsolve(s2s_1C,x0_a,opt);
% % % % % % % % % % % % % % % %     beta1C_1C(j,i)       = x_1C(2);
% % % % % % % % % % % % % % % %     beta1S_1C(j,i)       = x_1C(3);
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % %     [dBdT,dumpDer]       = flappingDer(x_1C(4:6),fC_mu(1:3),GA,muW,ndRotor_s);
% % % % % % % % % % % % % % % %     beta1C_1C(j,i)       = dBdT(1);
% % % % % % % % % % % % % % % %     beta1S_1C(j,i)       = dBdT(3);
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % %     s2s_1S               = @(x) aeromechanicsLin(x,theta_1S,fC_mu,GA,muW,ndRotor_s);
% % % % % % % % % % % % % % % %     x_1S                 = fsolve(s2s_1S,x0_a,opt);
% % % % % % % % % % % % % % % %     beta1C_1S(j,i)       = x_1S(2);
% % % % % % % % % % % % % % % %     beta1S_1S(j,i)       = x_1S(3);
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % %     [dBdT,dumpDer]       = flappingDer(x_1S(4:6)*0,fC_mu(1:3),GA,muW,ndRotor_s);
% % % % % % % % % % % % % % % %     beta1C_1S(j,i)       = dBdT(2);
% % % % % % % % % % % % % % % %     beta1S_1S(j,i)       = dBdT(4);
% % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % mark           = {'o','s','<','^'};
% % % % % % % % % % % % % % % % leg_ms         = cell(1,2*n_s);
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % figure(1)
% % % % % % % % % % % % % % % % title(strcat('$$\gamma$$ =',num2str(Lock0)))
% % % % % % % % % % % % % % % % for i = 1:n_s
% % % % % % % % % % % % % % % % i1           = 1 + 2*(i-1);
% % % % % % % % % % % % % % % % leg_ms{i1}   = strcat(leg_s{i},...
% % % % % % % % % % % % % % % %              ', $$\frac{\partial \beta_{1C}}{\partial \theta_{1S}}$$');
% % % % % % % % % % % % % % % % leg_ms{i1+1} = strcat(leg_s{i},...
% % % % % % % % % % % % % % % %              ', $$ \frac{\partial \beta_{1S}}{\partial \theta_{1C}}$$');
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % plot(mu_xA,beta1C_1S(:,i),strcat('b-',mark{i})); hold on;
% % % % % % % % % % % % % % % % plot(mu_xA,beta1S_1C(:,i),strcat('r--',mark{i})); hold on;
% % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % xlabel('$$S_\mu_{xA}$$ [-]');
% % % % % % % % % % % % % % % % l=legend(leg_ms,'Location','Best');
% % % % % % % % % % % % % % % % set(l,'interpreter','latex');
% % % % % % % % % % % % % % % % grid on;
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % figure(2)
% % % % % % % % % % % % % % % % title(strcat('$$\gamma$$ =',num2str(Lock0)))
% % % % % % % % % % % % % % % % for i = 1:n_s
% % % % % % % % % % % % % % % % i1           = 1 + 2*(i-1);
% % % % % % % % % % % % % % % % leg_ms{i1}   = strcat(leg_s{i},...
% % % % % % % % % % % % % % % %              ', $$\Omega \frac{\partial \beta_{1C}}{\partial \theta_{1C}}$$');
% % % % % % % % % % % % % % % % leg_ms{i1+1} = strcat(leg_s{i},...
% % % % % % % % % % % % % % % %              ', $$\Omega \frac{\partial \beta_{1S}}{\partial \theta_{1S}}$$');
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % plot(mu_xA,beta1C_1C./theta1C,strcat('b-',mark{i})); hold on;
% % % % % % % % % % % % % % % % plot(mu_xA,beta1S_1S./theta1S,strcat('r--',mark{i})); hold on;
% % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % xlabel('$$S_\mu_{xA}$$ [-]');
% % % % % % % % % % % % % % % % l=legend(leg_ms,'Location','Best');
% % % % % % % % % % % % % % % % set(l,'interpreter','latex');
% % % % % % % % % % % % % % % % grid on;
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % %% Damping derivatives of the rotor
% % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % omegaxA           = 1.0;
% % % % % % % % % % % % % % % % omegayA           = 1.0;
% % % % % % % % % % % % % % % % theta_b           = [theta0Ref;0;0];
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % this is a common part and we can skip it
% % % % % % % % % % % % % % % % SBeta_a           = [0.0,0.3,0.5,1.0];
% % % % % % % % % % % % % % % % n_s               = length(SBeta_a);
% % % % % % % % % % % % % % % % Lock0             = 7.0;
% % % % % % % % % % % % % % % % ndRotorRef.gamma  = Lock0;
% % % % % % % % % % % % % % % % n_mu              = 11;
% % % % % % % % % % % % % % % % mu_xA             = linspace(0,0.3,n_mu);
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % beta1C_xA         = zeros(n_mu,n_s);
% % % % % % % % % % % % % % % % beta1S_xA         = zeros(n_mu,n_s);
% % % % % % % % % % % % % % % % beta1C_yA         = zeros(n_mu,n_s);
% % % % % % % % % % % % % % % % beta1S_yA         = zeros(n_mu,n_s);
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % b0                = beta0Ref;
% % % % % % % % % % % % % % % % leg_s             = cell(1,n_s);
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % fC_xA             = [0;0;0;omegaxA;0;0];
% % % % % % % % % % % % % % % % fC_yA             = [0;0;0;0;omegayA;0];
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % for i = 1:n_s
% % % % % % % % % % % % % % % % ndRotor_s            = ndRotorRef;
% % % % % % % % % % % % % % % % ndRotor_s.SBeta      = SBeta_a(i);
% % % % % % % % % % % % % % % % leg_s{i}             = strcat('$$S_\beta$$ =',num2str(SBeta_a(i)));
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % %     for j = 1:n_mu
% % % % % % % % % % % % % % % %         x0_b               = [b0;  0; 0; ...
% % % % % % % % % % % % % % % %                               -sqrt(CTRef/2); 0; 0; ...
% % % % % % % % % % % % % % % %                               CTRef; 0; 0];
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % %         fC_muxxA           = fC_xA;
% % % % % % % % % % % % % % % %         fC_muxxA(1)        = mu_xA(j);
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % %         s2s_xA             = @(x) aeromechanicsLin(x,theta_b,fC_muxxA,GA,...
% % % % % % % % % % % % % % % %                                                    muW,ndRotor_s);
% % % % % % % % % % % % % % % %         x_xA               = fsolve(s2s_xA,x0_b,opt);
% % % % % % % % % % % % % % % %         beta1C_xA(j,i)     = x_xA(2);
% % % % % % % % % % % % % % % %         beta1S_xA(j,i)     = x_xA(3);
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % %         fC_muxyA           = fC_yA;
% % % % % % % % % % % % % % % %         fC_muxyA(1)        = mu_xA(j);
% % % % % % % % % % % % % % % %         s2s_yA             = @(x) aeromechanicsLin(x,theta_b,fC_muxyA,GA,...
% % % % % % % % % % % % % % % %                                                    muW,ndRotor_s);
% % % % % % % % % % % % % % % %         x_yA               = fsolve(s2s_yA,x0_b,opt);
% % % % % % % % % % % % % % % %         beta1C_yA(j,i)     = x_yA(2);
% % % % % % % % % % % % % % % %         beta1S_yA(j,i)     = x_yA(3);
% % % % % % % % % % % % % % % %     end
% % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % mark  = {'b-.o','r-.s','m-.<','k-.*','b-o','r-s','m-<','k-.*'};
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % leg_ts = cell(2*n_s,1);
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % figure(13)
% % % % % % % % % % % % % % % % for i = 1:n_s
% % % % % % % % % % % % % % % % i1           = 1 + 2*(i-1);
% % % % % % % % % % % % % % % % leg_ts{i1}   = strcat(leg_s{i},...
% % % % % % % % % % % % % % % %              ', $$\Omega \frac{\partial \beta_{1C}}{\partial \omega_{yA}}$$');
% % % % % % % % % % % % % % % % leg_ts{i1+1} = strcat(leg_s{i},...
% % % % % % % % % % % % % % % %              ', $$\Omega \frac{\partial \beta_{1S}}{\partial \omega_{xA}}$$');
% % % % % % % % % % % % % % % % plot(mu_xA,beta1C_yA(:,i)./omegayA,mark{i}); hold on;
% % % % % % % % % % % % % % % % plot(mu_xA,beta1S_xA(:,i)./omegaxA,mark{i+n_s}); hold on;
% % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % xlabel('$$S_\mu_{xA}$$ [-]');
% % % % % % % % % % % % % % % % grid on;
% % % % % % % % % % % % % % % % legend(leg_ts,'Location','Best')
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % figure(14)
% % % % % % % % % % % % % % % % for i = 1:n_s
% % % % % % % % % % % % % % % % i1           = 1 + 2*(i-1);
% % % % % % % % % % % % % % % % leg_ts{i1}   = strcat(leg_s{i},...
% % % % % % % % % % % % % % % %              ', $$\Omega \frac{\partial \beta_{1C}}{\partial \omega_{xA}}$$');
% % % % % % % % % % % % % % % % leg_ts{i1+1} = strcat(leg_s{i},...
% % % % % % % % % % % % % % % %              ', $$\Omega \frac{\partial \beta_{1S}}{\partial \omega_{yA}}$$');
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % plot(mu_xA,beta1C_xA(:,i)./omegaxA,mark{i}); hold on;
% % % % % % % % % % % % % % % % plot(mu_xA,beta1S_yA(:,i)./omegayA,mark{i+n_s}); hold on;
% % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % xlabel('$$S_\mu_{xA}$$ [-]');
% % % % % % % % % % % % % % % % grid on;
% % % % % % % % % % % % % % % % legend(leg_ts,'Location','Best')


