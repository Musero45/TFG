function io = dimensioning07(mode)
% nI = getNewInertia(he,atm,Mpl,Ipl,OfGPL,eulerPl) generates a helicopter newhe with
% updated inertia and geometry field after adding a payload to the helicopter he. 
% The payload has mass Mpl and Inertia tensor Ipl defined with respect to payload body axes 
% with origin in the payload center of mass GPL. The payload is located by the
% vector OfGPL which positions the payload center of mass with respect to
% the helicopter fuselage reference point Of. OfGPL = [oxPl,oyPl,ozPl] is expressed by its
% components in the helicopter body axis. The orientation of the payload
% inside the helicopter is defined by the three Euler angles eulerPl =
% [PsiPl,ThetaPl,PhiPl] that position the body Pl reference system [Opl;xPl,yPl,zPl] 
% with respect to the helicopter body reference system [Of;x,y,z].
%
% This function implements part of the developments in: 
% [1]. Irene Velasco Suárez. Diseño y Análisis Preliminar de un Helicóptero no Tripulado.
% PFC. ETSI Aeronáuticos. UPM. Noviembre 2017.
%
%
%%% How to modify a rigid helicopter data by adding an internal payload with known inertia
%%% This demo shows how to modify a rigid helicopter with modified inertia data  
%%%
%%% First we setup heroes environment by defining an ISA+0 atmosphere and 
%%% a Bo105 rigid helicopter which are stored at the variables atm and he
%%% respectively.
%
   atm           = getISA;
   he            = PadfieldBo105(atm);
%
%%% getUpdatedInertiaHe is the main function and inputs to this function 
%%% are a clean configuration rigid helicopter an atmophere and the inertia
%%% characteristics of the payload to be shipped:
%
%%% Mpl: [kg]. Mass of the payload
%%% Ipl: [kg*m^2]. Inertia tensor of the payload defined in the payload reference
%%%      system [GPl;xPl,yPl,zPl].
%%% OfGPL: [m]. Center of mass of payload in the helicopter fuselage reference system [Of;x,y,z]
%%% eulerPl: [rad]. Euler angles of [xPl,yPl,zPl] with respect to [x,y,z]

   Mpl           = 10;                         
   Ipl           = 0*[[1 0 0];[0 2 0];[0 0 1];]; 
   OfGPL         = [0.5;0;0];               
   eulerPl       = pi/180*[0 10 0];            
                                            
   newHe         = getUpdatedInertiaHe(he,atm,Mpl,Ipl,OfGPL,eulerPl);%

io = 1;

