%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TEXTING ACCIONES DEL FUSELAJE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all

% CXF data

alfa_fCxf = [-180 -160 -90 -30 0 20 90 160 180]*pi/180;
C_xf = [.1 .08 .0 -.07 -1.5*.08 -.07 .0 .08 .1];

% CYF data: es una función de beta_F

% CZF

alfa_fCzf = [-180 -160 -120 -60 -20 0 20 60 120 160 180]*pi/180;
C_zf = [.0 .15 1.3 1.3 .15 .0 -.15 -1.3 -1.3 -.15 -0];

% CMX = 0


% CMY

alfa_fCmyf = [-205 -160 -130 -60 -25 25 60 130 155 200]*pi/180;
C_myf = [.02 -.03 .1 .1 -.04 .02 -.1 -.1 .02 -.03];

% CMZ (formulacion de beta_F)

% bucle en alpha_F

alphavect = linspace(-pi,pi,100);
betavect = linspace(-pi/2,pi/2,100);


for alfai = 1:length(alphavect);
    
    alphaF = alphavect(alfai);

    C_xfint(alfai) = interp1(alfa_fCxf,C_xf,alphaF,'cubic');
    C_zfint(alfai) = interp1(alfa_fCzf,C_zf,alphaF,'cubic');
    C_myfint(alfai) = interp1(alfa_fCmyf,C_myf,alphaF,'cubic');




% 
