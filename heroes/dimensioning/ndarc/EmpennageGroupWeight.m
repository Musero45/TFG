function y = EmpennageGroupWeight(desreq, mainRotor, tailRotor, dimensions, performances)
%
% NDARC, NASA Design and Analysis of Rotorcraft (2009)
% Wayne Johnson
% EMPENNAGE GROUP 19-7.4 (page 153)
%
% Input and output variables expressed in International System 
%
% Initial version: Emory et al
% International System Version 
%      11/03/2014 Raquel Martin San Roman raquel.martin.sanroman@alumnos.upm.es
%


k_gf2N=9.81;
R  = mainRotor.R;
Vt = mainRotor.Vt;
Dtr = tailRotor.D;
Sht = dimensions.Sht;
Tto = performances.TakeOffTransmissionRating;
chiht=desreq.technologyFactors.ht;
chivt=desreq.technologyFactors.vt;
chitr=desreq.technologyFactors.tr;
chiat=desreq.technologyFactors.at;
Aht = desreq.estimations.Aht;
Svt = desreq.estimations.Svt;
Avt = desreq.estimations.Avt;
Nat = desreq.estimations.Nat;
Tat = desreq.estimations.Tat;
Aat = desreq.estimations.Aat;


%PASO DE SISTEMA INTERNACIONAL A SISTEMA IMPERIAL
Sht_ = Sht*3.2808^2;         % m^2=> ft^2
Svt_ = Svt*3.2808^2;         % m^2=> ft^2
Dtr_ = Dtr*3.2808;           % m=> ft
Tto_ = Tto*(1/754.699872);   % W=> hp      
R_ = R*3.2808;               % m=> ft
Vt_ = Vt*3.2808;             % m/s=> ft/s
Tat_ = Tat*2.205/k_gf2N;     % N=> lb            
Aat_ = Aat*3.2808^2;         % m^2=> ft^2


%HORIZONTAL TAIL WEIGHT(Johnson 19-3)(pag. 153)
%Sht=horizontal tail platform area
%Aht=horizontal tail aspect ratio

wht_ = 0.7176*(Sht_^1.1881)*(Aht^0.3173);%13(Johnson 19-3)(pag. 153)
Wht_ = chiht*wht_;

%VERTICAL TAIL WEIGHT(Johnson 19-3)(pag. 153)

if desreq.options.ftr==true
    ftr=1.6311;
else
    ftr=1;
end
%ftr=1.6311 if itis located on the vertical tail
%ftr=1 otherwise
%Svt=vertical tail platform area
%Avt=vertical tail aspect ratio

wvt_ = 1.0460*ftr*(Svt_^0.9441)*(Avt^0.5332);%14(Johnson 19-3)(pag. 153)
Wvt_ = chivt*wvt_;

%TAIL ROTOR WEIGHT(Johnson 19-3)(pag. 153)
%Dtr=tail rotor diameter
%Tto=drive system rated power
%R=main rotor radius in hover
%Vt=main rotor hover tip velocity 

wtr_ = 1.3778*(Dtr_/2)^(0.0897)*(Tto_*R_/Vt_)^0.8951;%15(Johnson 19-3)(pag. 153)
Wtr_ = chitr*wtr_;

%AUXILIARY PROPULSION WEIGHT(Johnson 19-3)(pag. 153)
%Nat=n? of auxiliary thrusters
%Tat=thrust per propeller
%Aat=Auxiliary thruster disk area

wat_ = 0.0809484*Nat*(Tat_^1.04771*(Tat_/Aat_)^(-0.07821));%16(Johnson 19-3)(pag. 153) 
Wat_ = chiat*wat_;

%PASO DE SISTEMA INTERNACIONAL A SISTEMA IMPERIAL
% lb=> N
Wht = Wht_*0.4536*k_gf2N;
Wvt = Wvt_*0.4536*k_gf2N;
Wtr = Wtr_*0.4536*k_gf2N;
Wat = Wat_*0.4536*k_gf2N;


y = struct (...
    'WhorizontalTail',Wht,...
    'WverticalTail',Wvt,...
    'WtailrRotor',Wtr,...
    'WauxiliaryPropulsion',Wat ...
);

