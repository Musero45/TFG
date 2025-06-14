function plotContinuousSensitivity(n,Xvar,Yvar,centerX,centerY,nameX,nameY,...
    unitX,unitY,saveX,saveY,prefix,save)
% Plot the reasults for a continious sensibility

% Legend and filename
Xlegend = strcat(nameX,' ',unitX);
Ylegend = strcat(nameY,' ',unitY);
etiq1 = nameY;
etiq2 = strcat('\partial',nameY,'/\partial',nameX,'=');
etiq3 = strcat(' ',nameX);

filename = strcat(prefix,saveY,'-',saveX,'_sensitivity');

% Differential calculations
fk   = @(x) interp1(Xvar,Yvar,x);
dfk1 = derivest(fk,centerX);
h0   = fk(centerX);
hh   = h0 + dfk1.*(Xvar-centerX);

if isnan(dfk1)
    p = polyfit(Xvar,Yvar,10);
    k = polyder(p);
    dfk1 = polyval(k,centerX);
    h0   = fk(centerX);
    hh   = h0 + dfk1.*(Xvar-centerX);
end


% Plot
figure(n)

plot(Xvar,Yvar,'k-','LineWidth',3,'MarkerSize',10)

hold on;
grid on;
plot(Xvar,hh,'b--','LineWidth',2,'MarkerSize',10)
plot(centerX,centerY,'ko',...
    'MarkerEdgeColor','b','MarkerSize',12)

etiq4 = strcat(etiq2,num2str(dfk1,'%7.2e'),' (en ',[' ' etiq3 '='], num2str(centerX,'%7.2e'),')');

xlabel(Xlegend, 'FontSize', 18,'FontName','Times New Roman'); 
ylabel(Ylegend, 'FontSize', 18,'FontName','Times New Roman');

leg = legend({etiq1,etiq4},0);



set(leg,'FontSize',18,'FontName','Times New Roman','Location','SouthEast')
set(gca,'FontSize',18)


if save==1
    saveas(gcf,filename,'fig')
    saveas(gcf,filename,'pdf')
    saveas(gcf,filename,'epsc')
end

end












