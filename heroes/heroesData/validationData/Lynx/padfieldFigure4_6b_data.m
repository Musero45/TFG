function TheTurnRateTS = ThetaOmegaHelisim()
% getPadfieldFlightTest returns a Lynx partial heroes trim state
%
% Data taken from reference [1]
% Ts.Theta digitize from figure 4.6(b) page 200 of [1]
%
% [1] G.D. Padfield Helicopter Flight Dynamics 2007
%
% TODO
% - Function name should include Lynx to indicate the helicopter data
%

% Dato del Lynx -> Omega_idle    = 35.63 rpm
% Los datos de Omega sacados de la grafica estan en rad/s
% Estos datos estan obtenidos en una condicion de vuelo de 80 kn
% VOR = 80.*0.5144444./(6.4*35.63); 

TheTurnRateTS.gammaT =[0;0.1;0.15];
TurnRate(:,:,1) = [0.0105717;0.0476257;0.0880502;0.126789;0.167231;...
    0.202043;0.240238;0.278432;0.316638;0.355984;0.387466;0.399842];
TurnRate(:,:,2) = [0.0113313;0.0441531;0.07866;0.1098080;0.143776;...
    0.180484;0.214991;0.251733;0.287948;0.325297;0.360479;0.397424];  
TurnRate(:,:,3) = [0.0102158;0.0364033;0.0625569;0.0881714;0.123998;...
    0.162127;0.193427;0.229849;0.270236;0.306647;0.346921;0.400069];      
TheTurnRateTS.omegaAdzT = TurnRate./35.63;
      

Theta(:,:,1) = [0.024527;0.0256198;0.026721;0.027818;0.0281691;...
    0.0290063;0.0293518;0.0296973;0.0295428;0.0286411;0.0277196;0.0270005];
Theta(:,:,2) = [0.0307106;0.0381556;0.0456092;0.0527856;0.0597169;...
    0.0682212;0.0756749;0.0834;0.0903429;0.097032;0.101891;0.104941];
Theta(:,:,3) = [0.0347002;0.0423199;0.0491897;0.0565623;0.066134;...
    0.0769442;0.0857885;0.0961073;0.107156;0.117225;0.125774;0.133259];     
TheTurnRateTS.Theta = Theta;     



     