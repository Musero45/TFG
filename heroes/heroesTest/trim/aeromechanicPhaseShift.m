function io = aeromechanicPhaseShift(mode)
%%
% This script is clearly a true candidate to be a demo
%

setPlot;
close all
r2d        = 180/pi;

% Values got from Teoria de los Helicopteros page 220
labels     = {'Puma','Lynx','Bo105'};
zeta       = [0.5712 0.4074 0.2846];
nz         = length(zeta);

lambdaBeta = [1.0257 1.0922 1.1171];




m         = 1.0;
omega_n   = 1.0;
nt        = 1001;
omega     = linspace(0,2*omega_n,nt)';


% Allocation of variables
H         = zeros(nt,nz);
F         = zeros(nt,nz);
H_he      = zeros(1,nz);
F_he      = zeros(1,nz);

leg1      = cell(nz,1);
mark      = {'r-','b-.','m--','k-','r-.','b--','m-','k-.'};
point     = {'r s','b s','m v'};

for i = 1:nz
    % Get complex transfer function
    sdofH    = transferFunction2(m,zeta(i),omega_n);
    Hw       = sdofH(omega);
    H(:,i)   = abs(Hw);
    F(:,i)   = angle(Hw);
    % Define legends
    leg1{i}   = strcat('$$\zeta = $$',num2str(zeta(i)),'[-]');
end

for i = 1:nz
    % Get complex transfer function
    sdofH       = transferFunction2(m,zeta(i),omega_n);
    Hw          = sdofH(1/lambdaBeta(i));
    H_he(:,i)   = abs(Hw);
    F_he(:,i)   = angle(Hw);
    % Define legends
    leg1{i}   = strcat('$$\zeta = $$',num2str(zeta(i)),'[-]');
end

% Plot complex transfer function
figure(1)
for i = 1:nz
    plot(omega,H(:,i),mark{i}); hold on;
end
for i = 1:nz
    plot(1./lambdaBeta(i),H_he(i),point{i}); hold on;
end
xlabel('$$\Omega / \Omega_\beta $$ [-]');
ylabel('$$| H(\omega) |$$ [kg s$$^{-1}$$]')
l=legend({leg1{:},labels{:}});
set(l,'interpreter','LaTex','Location','Best')
v = axis;
axis([v(1) 1.0 0 2])

figure(2)
for i = 1:nz
    plot(omega,r2d.*F(:,i),mark{i}); hold on;
end
for i = 1:nz
    plot(1./lambdaBeta(i),r2d*F_he(i),point{i}); hold on;
end
xlabel('$$\Omega / \Omega_\beta $$ [-]');
ylabel('$$ \phi (H (\omega)) $$ [kg s$$^{-1}$$]');
l = legend({leg1{:},labels{:}},'Location','Best');
set(l,'interpreter','LaTex','Location','Best')
v = axis;
axis([v(1) 1 -90 0])


unsetPlot
io = 1;

function H  = transferFunction2(m,zeta,omega_n)

H          = @(omega) 1./(m*(-omega.^2 + omega_n.^2 + 2*zeta*1i*omega.*omega_n));
