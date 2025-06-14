function y = RotorGroupWeight(desreq,mainRotor)
%
%  NDARC, NASA Design and Analysis of Rotorcraft (2009)
%  Wayne Johnson
%  
%  19-2 - Rotor Group (AFDD00 model) (pages 152-)
%
% Input and output variables expressed in International System 
%
% Initial version: Emory et al
% International System Version 
%      21/01/2014 Marina Hierro Tobar marina.hierro.tobar@alumnos.upm.es
%


b = desreq.rand.b;
chiblade = desreq.technologyFactors.blade;
chihub   = desreq.technologyFactors.hub;
chispin  = desreq.technologyFactors.spin;
chifold  = desreq.technologyFactors.fold;
ftilt = desreq.options.ftilt;
wb    = desreq.estimations.wb;
wh    = desreq.estimations.wh;
Dspin = desreq.estimations.Dspin;
c  = mainRotor.c;
R  = mainRotor.R;
Vt = mainRotor.Vt;

%PASO DE SISTEMA INTERNACIONAL A SISTEMA IMPERIAL
c_ = c*3.2808;
R_ = R*3.2808;
Dspin_ = Dspin*3.2808;
Vt_ = Vt*3.2808;%m/s=>ft/s


%WEIGHT OF THE BLADE(AFDD00 model)(Johnson 19-2 pag.152)
N = 1;%N=number of rotors=1
%b=number of blades;
%c=chord of blade;
%Vt=rotor hovertip velocity;
%wb=flap natural frecuency of blade;
wblade_ = 0.0024419*ftilt*N*(b^0.53479)*(R_^1.74231)*(c_^0.77291)*(Vt_^0.87562)*(wb^2.51048);%1 weight of blades(AFDD00 model)(Johnson 19-2 pag.152)
Wblade_ = chiblade*wblade_;%2 total weight of blades(AFDD00 model)(Johnson 19-2 pag.152)

%WEIGHT OF HUB;(AFDD00 model)(Johnson 19-2 pag.152)
%wh=flap natural frecuency of hub;

whub_ = 0.1837*N*(b^0.16383)*(R_^0.19937)*(Vt_^0.06171)*(wh^0.46203)*((Wblade_/N)^1.02958);%3 weight of hub(AFDD00 model)(Johnson 19-2 pag.152)
Whub_ = chihub*whub_;%4 total weight of hub(AFDD00 model)(Johnson 19-2 pag.152)

%WEIGHT OF SPIN(AFDD00 model)(Johnson 19-2 pag.152)
%Dspin= spinner diameter

wspin_ = 7.386*N*Dspin_^2;%5 total weight of spin(AFDD00 model)(Johnson 19-2 pag.152)
Wspin_ = chispin*wspin_;

%WEIGTH OF FOLD??????no se si lo poniamos

if desreq.options.ffoldManual==true
    ffold=0.04;
else
    ffold=0.28;
end
% The next line is commented because otherwise the value of 
% Wfold is not taken into account. Previously to Marina's 
% modification this line was commented, we do not know why!
%ffold = 0;
wfold_ = ffold*Wblade_;%6 (AFDD00 model)(Johnson 19-2 pag.152)
Wfold_ = chifold*wfold_;

%PASO DE SISTEMA IMPERIAL A SISTEMA INTERNACIONAL
Wblade = Wblade_*0.4536;
Whub = Whub_*0.4536;
Wspin = Wspin_*0.4536;
Wfold = Wfold_*0.4536; 

%masas a pesos para tenerlo en el sistema internacinal en N
g=9.81;
Wblade = Wblade*g;
Whub = Whub*g;
Wspin = Wspin*g;
Wfold = Wfold*g;



y = struct (...
    'WbladeMainRotor', Wblade,...
    'WhubMainRotor', Whub,...
    'WspinMainRotor', Wspin,...
    'WfoldBladeMainRotor', Wfold ...
);








