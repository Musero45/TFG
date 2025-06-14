function y = FuselajeGroupWeightHello(desreq,Dimensions)
%
% NDARC, NASA Design and Analysis of Rotorcraft (2009)
% Wayne Johnson
% Structure Fusalage Group
% AFDD82 Hello model 19-4 page 154
%
% Input and output variables expressed in International System 
%
% Initial version: Emory et al
% International System Version 
%      26/01/2014 Sergio Fernandez sergio.fernandezr@alumnos.upm.es
%

MTOW     = desreq.rand.MTOW;
Fl       = Dimensions.fuselageLength;
chibasic = desreq.technologyFactors.basic;
chitfold = desreq.technologyFactors.tfold;
chiwfold = desreq.technologyFactors.wfold;
chimar   = desreq.technologyFactors.mar;
chipress = desreq.technologyFactors.press;
chicw    = desreq.technologyFactors.crashworthiness;
fwfold   = desreq.options.fwfold;
fmar     = desreq.options.fmar;
fpress   = desreq.options.fpress;
ftfold   = desreq.options.ftfold;
fcw      = desreq.options.fcrashworthiness;
Sbody    = desreq.estimations.Sbody;


%PASO DE SISTEMA INTERNACIONAL A SISTEMA IMPERIAL

MTOW_ = MTOW*2.205/9.81;%N=>lb
Fl_ = Fl*3.2808;
Sbody_ = Sbody*(3.2808^2);


%BASIC STRCTURE FUSELAJE GROUP(AFDD82 Hello model)(Johnson19-4)(pag. 155)
if desreq.options.framp ==true
    framp=1;
else
    framp=1.3939;
end
nz = 3.5;% desing ultimate load factor
%Sbody= wetted area of body(pag.155)
%Fl=lenght of fuselaje(pag.155)
%We=structuraldesing gross weight(pag.155)
%MTOW=maximun takeoff weight(pag.155)
wbasic_ = 5.896*framp*((MTOW_/1000)^0.4908)*(nz^0.1323)*(Sbody_^0.2544)*(Fl_^0.61);% 29 AFDD84 pag.154
Wbasic_ = chibasic*wbasic_;% 30 AFDD82 pag. 155

%TAIL FOLD FUSELAGE GROUP WEIGHT

wtfold_ = ftfold*Wbasic_;% 31 AFDD82 pag. 155
Wtfold_ = chitfold*wtfold_;% 32 AFDD82 pag. 155

% WING AND ROTOR FOLD FUSELAGE GROUP WEIGHT(creo que este grupo es prescindible)
%fwfold =wing and rotor fold weight(fraction basic structure and tail fold weight)(pag.155)
wwfold_ = fwfold*(Wbasic_+Wtfold_);%33 AFDD82 pag. 155
Wwfold_ = chiwfold*wwfold_;%34 AFDD82 pag. 155

%MARINIZATION FUSELAGE GROUP WEIGHT
%fmar=marinization weight(fraction basic body weight)(pag.155)

wmar_ = fmar*Wbasic_;%35 AFDD82 pag. 155
Wmar_ = chimar*wmar_;%36 AFDD82 pag. 155

%PRESSURIZATION FUSELAGE GROUP WEIGHT(creo que este grupo es prescindible)
%fpress =pressurization weight(fraction basic body weight)(pag.155)
wpress_ = fpress*Wbasic_;%37 AFDD82 pag. 155
Wpress_ = chipress*wpress_;%38 AFDD82 pag. 155

%CRASHWORTHINESS FUSELAGE GROUP WEIGHT

wcw_ = fcw*(Wbasic_+Wtfold_+Wwfold_+Wmar_+Wpress_);%39AFDD84 pag. 155
Wcw_ = chicw*wcw_;%40 AFDD82 pag. 155

%PASO DE SISTEMA  IMPERIAL  A SISTEMA INTERNACIONAL( Weight=>N)

Wbasic = Wbasic_*0.4536*9.81;
Wtfold = Wtfold_*0.4536*9.81; 
Wwfold = Wwfold_*0.4536*9.81;
Wpress = Wpress_*0.4536*9.81;
Wcw = Wcw_*0.4536*9.81;
Wmar=Wmar_*0.4536*9.81;

y = struct (...
    'WbasicStructureFuselageGroup',Wbasic,...
    'WtailFoldFuselageGroup',Wtfold,...
    'WwingandRotorFoldFuselageGroup',Wwfold,...
    'Wmarinization',Wmar,...
    'Wpressurization',Wpress,...
    'Wcrashworthiness',Wcw ...
);

