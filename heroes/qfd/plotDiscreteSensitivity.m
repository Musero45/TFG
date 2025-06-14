function plotDiscreteSensitivity(n,Xvar,Yvar,centerX,centerY,nameX,nameY,...
    unitX,unitY,saveX,saveY,prefix,save)
% Plot the reasults for a discrete sensibility

% Legend and filename
Xlegend = strcat(nameX,' ',unitX);
Ylegend = strcat(nameY,' ',unitY);
etiq1 = nameY;
etiq2 = strcat('\partial',nameY,'/\partial',nameX,'=');


filename = strcat(prefix,saveY,'-',saveX,'_sensitivity');

% Differential calculations
fk   = @(x) interp1(Xvar,Yvar,x);
dfk1 = (Yvar(2)-Yvar(1))/(Xvar(2)-Xvar(1));
h0   = fk(centerX);
hh   = h0 + dfk1.*(Xvar-centerX);

if isnumeric(dfk1)== 0
    dfk1 = 0;
    h0   = fk(centerX);
    hh   = h0 + dfk1.*(Xvar-centerX);
end




% Plot
figure(n)

plot(Xvar,Yvar,'ko','LineWidth',3,'MarkerSize',5,...
    'MarkerEdgeColor','k','MarkerFaceColor','k')
hold on;
grid on;
plot(Xvar,hh,'b--','LineWidth',2,'MarkerSize',10)
plot(centerX,centerY,'ko',...
    'MarkerEdgeColor','b','MarkerSize',12)



xlabel(Xlegend, 'FontSize', 18,'FontName','Times New Roman'); 
ylabel(Ylegend, 'FontSize', 18,'FontName','Times New Roman');

leg = legend({etiq1,strcat(etiq2,...
    num2str(dfk1,'%6.2f'))},0);


set(leg,'FontSize',18,'FontName','Times New Roman','Location','SouthEast')
set(gca,'FontSize',18)


if save==1
    saveas(gcf,filename,'fig')
    saveas(gcf,filename,'pdf')
    saveas(gcf,filename,'epsc')
end

end






