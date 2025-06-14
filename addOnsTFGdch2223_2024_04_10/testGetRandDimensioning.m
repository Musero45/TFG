%%%%Test of Rand's statistical sizing


clear all
close all

setPlot
set(0,'DefaultTextFontSize',16);
set(0,'DefaultAxesFontSize',16);
set(0,'defaultlinelinewidth',3);

atm = getISA;

%%%%Definition of Rand's inputs

randDr = struct('MTOW',25506,...
                'b',4,...
                'btr',2,...
                'Crew',2,...
                'Vm',67.50,...
                'Range',515000);

 MTOWv = (atm.g)*linspace(1000,12000,100);

for mi = 1:length(MTOWv)
    
 randDr.MTOW = MTOWv(mi);    
 randHe      = getRandHe(randDr,atm);
         
 R(mi)       = randHe.mainRotor.R;
 Rtr(mi)     = randHe.tailRotor.R;
 OR(mi)      = randHe.mainRotor.OmegaRAD*R(mi);
 ORtr(mi)    = randHe.tailRotor.OmegaRAD*Rtr(mi);
 
 Vmax(mi)    = randHe.performances.VmaxSeaLevel;
 VB(mi)      = randHe.performances.longRangeSpeedSeaLevel;
 
 CWMTOW(mi)  = randHe.ndParameters.CWMTOW;
 MtipMax(mi) = randHe.ndParameters.MtipMax;
 Mtip(mi)    = randHe.ndParameters.MtipHover;
 muMax(mi)   = randHe.ndParameters.muMax;
 Re(mi)      = randHe.ndParameters.ReOR07c;
 Retr(mi)    = randHe.ndParameters.ReORtr07c;
 
end

figure (1)

plot(2*R,OR,'k-');
hold on
plot(2*Rtr,ORtr,'r-');
xlim([0 20]);
ylim([150 250]);
xlabel('$D,\,D_{tr}\,[\mathrm{m}]$');
ylabel('$\Omega R\,[\mathrm{m/s}]$');
legend('$\mathrm{main rotor}$','$\mathrm{tail rotor}$','Location','best');
grid on

figure (2)

plot(OR,Vmax,'k-');
hold on
plot(OR,VB,'r-');
% xlim([0 20]);
% ylim([150 250]);
xlabel('$\Omega R\,[\mathrm{m/s}]$');
ylabel('$[\mathrm{m/s}]$');
legend('$V_{\mathrm{max}}$','$V_{B}$','Location','best');
grid on

figure (3)

plot(MtipMax,muMax,'k-');
hold on
plot(MtipMax(1),muMax(1),'ro');
plot(MtipMax(end),muMax(end),'bo');
xlim([0.75 1]);
ylim([0.25 0.4]);
xlabel('$\mathrm{M}_{\mathrm{tip,max}}\,[-]$');
ylabel('$\mu_{\mathrm{max}}\,[-]$');
legend('$\mathrm{Dependence}$','$\mathrm{1}$','$\mathrm{end}$','Location','best');
grid on    

figure (4)

plot(MTOWv,Re,'k-');
hold on
plot(MTOWv,Retr,'r-');
%xlim([0.75 1]);
ylim([0 10^7]);
xlabel('$\mathrm{MTOW}\,[\mathrm{N}]$');
ylabel('$\mathrm{Re}_{\mathrm{0.7}}\,[-]$');
legend('$\mathrm{main rotor}$','$\mathrm{tail rotor}$','Location','best');
grid on    

figure (5)

plot(MTOWv,CWMTOW,'k-');
%xlim([0.75 1]);
%ylim([0 10^7]);
xlabel('$\mathrm{MTOW}\,[\mathrm{N}]$');
ylabel('$C_{W\mathrm{MTOW}}\,[\mathrm{-}]$');
%legend('$\mathrm{main rotor}$','$\mathrm{tail rotor}$','Location','best');
grid on   




