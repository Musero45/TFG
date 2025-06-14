close all
clear all

d2r = pi/180;
alpha = linspace(-180,180,37)*d2r;
beta  = linspace(-180,180,37)*d2r;

n = length(alpha);
m = length(beta);
K = zeros(n,m,6);

tic;
for i = 1:n
    for j = 1:m
        K(i,j,:) = generalFus(alpha(i), beta(j), 0);
    end
end
toc

vars = {'K_{x} [-]' 'K_{y} [-]' 'K_{z} [-]' ...
        'K_{Mx} [-]' 'K_{My} [-]' 'K_{Mz} [-]'};

names = {'Kx' 'Ky' 'Kz' ...
        'KMx' 'KMy' 'KMz'};
    
setPlot
for i = 1:3
    figure(2*i-1)
    plot(alpha/d2r,K(:,19,2*i-1),'k')
    xlabel('\alpha [º]')
    ylabel(vars{2*i-1})
    grid on
    savePlot(gcf,names{2*i-1},{'pdf'});
    
    figure(2*i)
    plot(alpha/d2r,K(19,:,2*i),'k')
    xlabel('\beta [º]')
    ylabel(vars{2*i})
    grid on
    savePlot(gcf,names{2*i},{'pdf'});
end