function io = gazelle_fusNasa88351(mode)
%% Gazelle Fuselage aerodinamic characteristic Graphics
% Representation of the characteristic forces and moments of the Fuselage. 
% See GazelleTP.m.
%
% [1]: nata-tm-88370

close all
clear all
setPlot;

alphaF = linspace(-20,20,20);
betaF = linspace(-20,20,20);
Re = 100000;

Ki_Fus=zeros(length(alphaF),6);
K_Fus=zeros(length(alphaF),6);
for i= 1:length(alphaF); 
alphaFi = alphaF(i).*pi/180;
betaFi = 0;
Ki_Fus(i,:) = GazelleFus(alphaFi, betaFi, Re);
K_Fus(i,[1,3,5]) = Ki_Fus(i,[1,3,5]);
betaFi = betaF(i).*pi/180;
Ki_Fus(i,:) = GazelleFus(alphaFi, betaFi, Re);
K_Fus(i,[2,4,6]) = Ki_Fus(i,[2,4,6]);
end

TP_i = {FusAeroChar_CD,FusAeroChar_Clf,FusAeroChar_CL,FusAeroChar_Crm,...
        FusAeroChar_Cpm,FusAeroChar_Cym}; % digitize of the graphs in pag. 398 of [1].

vars = {'$$100K_{x}^{f}$$ [-]','$$100K_{y}^{f}$$ [-]','$$100K_{z}^{f}$$ [-]',...
        '$$100K_{Mx}^{f}$$ [-]','$$100K_{My}^{f}$$ [-]','$$100K_{Mz}^{f}$$ [-]'};

for i=1:6;
    if i==1 || i==3|| i==6 || i==4;
        K_Fus(:,i) = + K_Fus(:,i); 
        % with + we have the same sign criteria than in Heroes, as in GazelleFus. 
        % With - we revert the sign change and we have again the same criteria than in [1]
    end
   
figure(i);
box on 
hold on
 if i==1 || i==3|| i==5 ;
 X1 = alphaF;
 Y1 = K_Fus(:,i).*100; 
   h = plot(X1,Y1,'k-o');
% Use this to compare ecuations representation with graphs in pag. 398 of [1]. 
% %  X2 = (TP_i{i}.alphaF).*(180./pi);  
% %  Y2 = TP_i{i}.(vars{i});
% %    p = plot(X2,Y2,'b');
xlabel('$$\alpha_f$$ [$$^o$$]','FontSize',20,'FontAngle','italic');
 end  
 
 if i==2 || i==4 || i==6;
 X3 = betaF;
 Y3 = K_Fus(:,i).*100; 
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


pictures = {'picCDFus','picClfFus',...
            'picCLFus','picCrmFus',...
            'picCpmFus','picCymFus'};
                              
% for i=1:6;    
% s=figure(i);    
% saveas(s,pictures{i},'epsc');
% end

io = 1;
