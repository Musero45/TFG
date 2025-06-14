close all
clear all

load CuervaModes.mat

plotOpt = setHeroesPlotOptions;
mark = plotOpt.mark;

setPlot

for k = 2:9
    figure(k)
    hold on
    for i = 1:9
        b(1,:) = eigV(i,k,:);
        if imag(d(k,:))== 0
            plot(ndV,-sign(b(1,1)).*abs(b),mark{i})
            ylabel('X_i [1/s]')
        else
            plot(ndV,abs(b),mark{i})
            ylabel('|X_i| [1/s]')
        end
    end
    grid on
    xlabel('V/(\Omega R) [-]')    
    legend('u','w','\omega_y','\Theta','v','\omega_x','\Phi','\omega_z','\Psi')
    name = strcat('modeAx',num2str(k));
    savePlot(gcf,name,{'pdf'});
    
    figure(k+9)
    hold on
    plot(ndV,real(d(k,:)),mark{1})
    plot(ndV,imag(d(k,:)),mark{2})    
    grid on
    xlabel('V/(\Omega R) [-]')
    ylabel('s [1/s]')
    legend('Re(s)','Im(s)')
    name = strcat('autovAx',num2str(k));
    savePlot(gcf,name,{'pdf'});
    
    figure(k+18)
    for j = 1:length(ndV)
        long(1,j) = norm(eigV(1:4,k,j),2);
        lat (1,j) = norm(eigV(5:9,k,j),2);
    end
    hold on
    legend('long','lat')
    plot(ndV,long,mark{1})
    plot(ndV,lat,mark{2}) 
    grid on
    xlabel('V/(\Omega R) [-]')
    ylabel('|w_i| [1/s]')
    legend('long','lat')
    name = strcat('longlatAx',num2str(k));
    savePlot(gcf,name,{'pdf'});
    
end