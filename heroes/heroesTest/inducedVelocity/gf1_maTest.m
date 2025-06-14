% setHeroesPath
alphaDM    = 180/pi*asin(sqrt(8/9));
nv  = 501;
v = linspace(0,3,nv);
% alphaD = [-90,-30,0,30,60];
% alphaD = [-90,-30,0,30,60,alphaDM,80];
alphaD = [80];
% alphaD = [60,62,64,66,68,70];
% alphaD = [0,10,20,30,40,50];

na    = length(alphaD);
nu    = zeros(na,nv);
vu    = zeros(na,nv);
leg   = cell(1,na);

for i=1:na
    [nu(i,:),vu(i,:)] = glauertForward1_ma(v,pi/180*alphaD(i));
    leg{i} = strcat('\alpha = ',num2str(alphaD(i)));
end

mark   = {'r-','b-.','k--','m--.','g:.',...
          'r-*','b-+','k-s','m-d',...
          'r-^','b-v','k->','m-<'...
};
figure(1)

for i=1:na
    plot(vu(i,:),nu(i,:),mark{i}); hold on;
end
legend(leg)


alphaPositives = alphaD > 0;
[Vmax,nuMax] = getHtg_gf1ma(pi/180*alphaD(alphaPositives));
[VtgV,nutgV] = getVtg_gf1ma(pi/180*alphaD(alphaPositives));
plot(Vmax,nuMax,'r-p'); hold on;
plot(VtgV(1,:),nutgV(1,:),'b-s'); hold on;
plot(VtgV(2,:),nutgV(2,:),'r-s')
