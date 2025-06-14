function [HM]=polarlineal(HM,rango)

%FUNCION [HM]=POLAR(HM,elemento)
%elemento puede tomar el valor:
%   'RP'    Rotor Principal
%   'RA'    Rotor Antipar
%   'EHD'   Estabilizador Horizontal Derecho
%   'EHI'   Estabilizador Horizontal Izquierdo
%   'EV'    Estabilizador Vertical

%PERFIL QUE SE USARA EN LAS SUPERFICIES ESTABILIZADORAS
    [alphaop,clop,cdop,kmax,alpha,Cl] = NACA0012dat('cl');
        p = polyfit(alpha(rango(1)<alpha&alpha<rango(2)),Cl(rango(1)<alpha&alpha<rango(2)),1);

%         figure(1)
%         subplot(2,3,1)
%             hold on
%             plot(alpha,Cl,'.')
%             plot(alphaop,clop,'ok')
%             plot(alpha(rango(1)<alpha&alpha<rango(2)),p(1)*alpha(rango(1)<alpha&alpha<rango(2))+p(2),'r')
%             hold off
%             xlim=.5;
%         axis([-xlim xlim min(Cl(-xlim<alpha&alpha<xlim)) max(Cl(-xlim<alpha&alpha<xlim))])            

%PERFIL QUE SE USARA EN LOS ROTORES        
    [alphaSN,clop,cdop,kmax,alpha,Cl] = NACA63618CORRdat('cl');
    
    alpha = alpha-alphaSN;
    
        p2=polyfit(alpha(rango(1)<alpha&alpha<rango(2)),Cl(rango(1)<alpha&alpha<rango(2)),1);
    
%         subplot(2,3,4)
%             hold on
%             plot(alpha,Cl,'.')
%             plot(alphaop,clop,'ok')
%             plot(alpha(rango(1)<alpha&alpha<rango(2)),p2(1)*alpha(rango(1)<alpha&alpha<rango(2))+p2(2),'r')
%             hold off
%             xlim=.5;
%        axis([-xlim xlim min(Cl(-xlim<alpha&alpha<xlim)) max(Cl(-xlim<alpha&alpha<xlim))])            

    %La curva de Cl se aproxima ahora por p(1)*alpha+p(2).
        HM.RP.Perfil.cla=p2(1);
        HM.RA.Perfil.cla=p2(1);
        HM.E.EHD.Perfil.cla=p(1);
        HM.E.EHI.Perfil.cla=p(1);
        HM.E.EV.Perfil.cla=p(1);
        
        
    [alphaop,clop,cdop,kmax,alpha,Cd] = NACA0012dat('cd');
        p=polyfit(alpha(rango(1)<alpha&alpha<rango(2)),Cd(rango(1)<alpha&alpha<rango(2)),2);

%         subplot(2,3,2)
%             hold on
%             plot(alpha,Cd,'.')
%             plot(alphaop,cdop,'ok')
%             plot(alpha(rango(1)<alpha&alpha<rango(2)),p(1)*(alpha(rango(1)<alpha&alpha<rango(2))).^2+p(2)*alpha(rango(1)<alpha&alpha<rango(2))+p(3),'r')
%             hold off
%             xlim=max(abs(rango))+.2;
%         axis([-xlim xlim min(Cd(-xlim<alpha&alpha<xlim)) max(Cd(-xlim<alpha&alpha<xlim))])            
        
    [alphaop,clop,cdop,kmax,alpha,Cd] = NACA63618CORRdat('cd');
        p2=polyfit(alpha(rango(1)<alpha&alpha<rango(2)),Cd(rango(1)<alpha&alpha<rango(2)),2);

%         subplot(2,3,5)
%             hold on
%             plot(alpha,Cd,'.')
%             plot(alphaop,cdop,'ok')
%             plot(alpha(rango(1)<alpha&alpha<rango(2)),p2(1)*(alpha(rango(1)<alpha&alpha<rango(2))).^2+p2(2)*alpha(rango(1)<alpha&alpha<rango(2))+p2(3),'r')
%             hold off
%             xlim=max(abs(rango))+.2;
%         axis([-xlim xlim min(Cd(-xlim<alpha&alpha<xlim)) max(Cd(-xlim<alpha&alpha<xlim))])            
        
    %La curva de Cl se aproxima ahora por p(2)*alpha^2+p(2)*alpha+p(3).
        HM.RP.Perfil.delta0 = p2(3);
        HM.RA.Perfil.delta0 = p2(3);
        HM.E.EHD.Perfil.delta0 = p(3);
        HM.E.EHI.Perfil.delta0 = p(3);
        HM.E.EV.Perfil.delta0 = p(3);
        
        HM.RP.Perfil.delta1 = p2(2);
        HM.RA.Perfil.delta1 = p2(2);
        HM.E.EHD.Perfil.delta1 = p(2);
        HM.E.EHI.Perfil.delta1 = p(2);
        HM.E.EV.Perfil.delta1 = p(2);
        
        HM.RP.Perfil.delta2 = p2(1);
        HM.RA.Perfil.delta2 = p2(1);
        HM.E.EHD.Perfil.delta2 = p(1);
        HM.E.EHI.Perfil.delta2 = p(1);
        HM.E.EV.Perfil.delta2= p(1);
    
    [alphaop,clop,cdop,kmax,alpha,Cmo] = NACA0012dat('cm');
        p=polyfit(alpha(rango(1)<alpha&alpha<rango(2)),Cmo(rango(1)<alpha&alpha<rango(2)),0);

%         subplot(2,3,3)
%             hold on
%             plot(alpha,Cmo,'.')
%             plot(alpha(rango(1)<alpha&alpha<rango(2)),p(1),'r')
%             hold off
%             xlim=.5;
%         axis([-xlim xlim min(Cmo(-xlim<alpha&alpha<xlim))-.01 max(Cmo(-xlim<alpha&alpha<xlim))+.01])            

            [alphaop,clop,cdop,kmax,alpha,Cmo] = NACA63618CORRdat('cm');
        p2=polyfit(alpha(rango(1)<alpha&alpha<rango(2)),Cmo(rango(1)<alpha&alpha<rango(2)),0);

%         subplot(2,3,6)
%             hold on
%             plot(alpha,Cmo,'.')
%             plot(alpha(rango(1)<alpha&alpha<rango(2)),p2(1),'r')
%             hold off
%             xlim=.5;
%         axis([-xlim xlim min(Cmo(-xlim<alpha&alpha<xlim)) max(Cmo(-xlim<alpha&alpha<xlim))])            

    %La curva de Cm en ppio sera constante(no cierto dependiendo del perfil)
        HM.RP.Perfil.cmo=p2(1);
        HM.RA.Perfil.cmo=p2(1);
        HM.E.EHD.Perfil.cmo=p(1);
        HM.E.EHI.Perfil.cmo=p(1);
        HM.E.EV.Perfil.cmo=p(1);
        
    
end