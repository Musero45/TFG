
function [Atm]=ISA(h)

%Valores definidos como escalares
    
    gama=1.4;
    g=-9.81; %OJO, definida negativa
    R=287;
    
%troposfera
if h<11000
    po=101325;
    To=288;
    roo=1.225;
    alfa=-6.5e-3;
    
    x=g/(R*alfa);
    
    p=po.*(1+(alfa./To).*h).^x;
    T=To+alfa.*h;
    ro=roo.*(1+(alfa./To).*h).^(x-1);

%baja estratosfera(Dudo que llegue ningun helicoptero
else
    po=22552;
    roo=0.3629;
    
    T=216.5;
    p=po.*exp(g.*(h-11000)./(R*T));
    ro=roo.*exp(g.*(h-11000)./(R*T));
end

a_inf=sqrt(gama*R*T);

Atm=struct('P',p,'T',T,'rho',ro,'a_inf',a_inf);

end

    