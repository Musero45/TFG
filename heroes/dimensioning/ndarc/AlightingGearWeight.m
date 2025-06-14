function y = AlightingGearWeight (desreq,weights)
%
% NDARC, NASA Design and Analysis of Rotorcraft (2009)
% Wayne Johnson
% ALIGHTING GEAR GROUP (parametric method AFDD82) 19-5 (page 156)
%
% Input and output variables expressed in International System 
%
% Initial version: Emory et al
% International System Version 
%      11/03/2014 Rocio Martin rocio.martin.macarro@alumnos.upm.es
%


MTOW = desreq.rand.MTOW;
Dl   = weights.discLoading;
chilg    = desreq.technologyFactors.lg;
chilgret = desreq.technologyFactors.lgret;
chilgcw  = desreq.technologyFactors.lgcrashworthiness;
flgret = desreq.options.flgret;
flgcw  = desreq.options.flgcrashworthiness;
Nlg = desreq.estimations.Nlg;


%factor de conversion de Kg fuerza a Newtons
KgfaN = 9.81;

%conversi?n de los pesos en masas
MTOW = MTOW/KgfaN;

Dl = Dl/KgfaN;


%PASO DE SISTEMA INTERNACIONAL A SISTEMA IMPERIAL
MTOW_ = MTOW*2.205;%kg=>lb
Dl_ = Dl*(2.205/(3.2808)^2);%Kg/m^2=>lb/ft^2


%BASIC ESTRCTURE ALIGHTING GEAR GROUP(parametric method AFDD82)(Johnson19-5)(pag. 156)
%MTOW= maximuntakeoff weight
%W/S=Dl=wing load
%Nlg=number of lading gear assembies
wlg_ = 0.4013*(MTOW_^0.6662)*(Nlg^0.5360)*((Dl_)^0.1525);%41 (parametric method AFDD82)(Johnson19-5)(pag. 156)
Wlg_ = chilg*wlg_;%42(Johnson19-5)(pag. 156)

%RETRACTION ALIGHTING GEAR GROUP(parametric method AFDD82)(Johnson19-5)(pag. 156)
 
flgret = 0;
wlgret_ = flgret*Wlg_;%43(Johnson19-5)(pag. 156)
Wlgret_ = chilgret*wlgret_;%44(Johnson19-5)(pag. 156)

% ALIGHTING GEAR GROUP(parametric method AFDD82)(Johnson19-5)(pag. 156)
 
wlgcw_ = flgcw*(Wlg_+Wlgret_);%45(Johnson19-5)(pag. 156)
Wlgcw_ = chilgcw*wlgcw_;%46 (Johnson19-5)(pag. 156)

%PASO DE SISTEMA Imperia al Sistema Internacional 

Wlg = Wlg_*0.4536;
Wlgret = Wlgret_*0.4536;
Wlgcw = Wlgcw_*0.4536;

%conversi?n de las masas a pesos
Wlg = Wlg*KgfaN;
Wlgret = Wlgret*KgfaN;
Wlgcw = Wlgcw*KgfaN;

y = struct (...
    'WlandingGear',Wlg,...
    'WretractionSystem',Wlgret,...
    'Wcrashworthiness',Wlgcw ...
);

