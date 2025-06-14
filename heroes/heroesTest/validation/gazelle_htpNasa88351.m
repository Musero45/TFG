function io = gazelle_htpNasa88351(mode)
%% Gazelle tail plane aerodinamic characteristic Graphics
% Representation of the characteristic forces and moments of the Vertical
% and Horizontal Tail Plane. See GazelleTP.m.
%
% [1]: nata-tm-88370

close all
clear all
setPlot;

alphaF = linspace(-20,20,20);
betaF = linspace(-20,20,20);
Re = 100000;

K_TP=zeros(length(alphaF),6);
for i= 1:length(alphaF); 
alphaFi = alphaF(i).*pi./180;
betaFi = betaF(i).*pi./180;
K_TP(i,:) = GazelleTP(alphaFi, betaFi, Re);
end

TP_i = {TPAeroChar_CD,TPAeroChar_Clf,TPAeroChar_CL,TPAeroChar_Crm,...
        TPAeroChar_Cpm,TPAeroChar_Cym}; % digitize of the graphs in pag. 398 of [1].
vars = {'$$100K_{x}^{eh}$$ [-]','$$100K_{y}^{ev}$$ [-]','$$100K_{z}^{eh}$$ [-]',...
        '$$100K_{Mx}^{ev}$$ [-]','$$100K_{My}^{eh}$$ [-]','$$100K_{Mz}^{ev}$$ [-]'};

for i=1:6;
    
figure(i);
box on
hold on
 if i==1 || i==3|| i==5 ;
 X1 = alphaF;
 Y1 = K_TP(:,i).*100; 
   h = plot(X1,Y1,'k-o');
% Use this to compare ecuations representation with graphs in pag. 398 of [1].
% %  X2 = (TP_i{i}.alphaF).*(180./pi);  
% %  Y2 = TP_i{i}.(vars{i});
% %    p = plot(X2,Y2,'b');
xlabel('$$\alpha_f$$ [$$^o$$]','FontSize',20,'FontAngle','italic');

 end  
 
 if i==2 || i==4 || i==6;
 X3 = betaF;
 Y3 = K_TP(:,i); 
   h = plot(X3,Y3,'k-o');
% Use this to compare ecuations representation with graphs in pag. 398 of [1]. 
% %  X4 = (TP_i{i}.betaF).*(180./pi);  
% %  Y4 = TP_i{i}.(vars{i});
% %    p = plot(X4,Y4,'b');
xlabel('$$\beta_f$$ [$$^o$$]','FontSize',20,'FontAngle','italic');
 end  
 
ylabel(vars{i},'FontSize',22,'FontAngle','italic');
% % legend('Ecuaciones','Graficas','Location','Best');

end

% pictures = {'picCDTP','picClfTP',...
%             'picCLTP','picCrmTP',...
%             'picCpmTP','picCymTP'};
%                               
% for i=1:6;    
% s=figure(i);    
% saveas(s,pictures{i},'epsc');
% end


% % x2=TP_i{1}.alphaF.*(180./pi);
% % y2=TP_i{1}.CD;
% % pcd = polyfit(x2,y2,4);

io = 1;
