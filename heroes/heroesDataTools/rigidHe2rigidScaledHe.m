function rigidScaledHe    = rigidHe2rigidScaledHe(rigidHe,b,R,Omega,W,btr,...
                                                            atm,H,label)

%   This function implements part of the developments in: 
%%% [1]. Irene Velasco Suárez. Diseño y Análisis Preliminar de un Helicóptero no Tripulado.
%%% PFC. ETSI Aeronáuticos. UPM. Noviembre 2017.
                                           
%%% Example of usage
%%%
%%% How to get a scaled rigid helicopter from a seed rigid helicopter
%%% This demo shows how to get a scaled rigid helicopter from a seed rigid helicopter 
%%%
%%%
%%% First we setup heroes environment by defining an ISA+0 atmosphere and 
%%% a Bo105 rigid helicopter which are stored at the variables atm and he
%%% respectively.
%
%   atm           = getISA;
%   he            = PadfieldBo105(atm);
% 
%%%  rigidHe2rigidScaledHe is the main function and inputs to this function 
%%%  are a seed rigid helicopter, global characteristics of the goal scaled
%%%  helicopter: number of blades of the main rotor, b, main rotor radius, R, 
%%%  main rotor speed, Omega, scaled helicopter weight, W and number of blades
%%%  of the tail rotor. An atmosphere, atm and flight altitude are also required.
%
%   b     = 2;         
%   R     = 1.1;       
%   W     = 120*atm.g; 
%   btr   = 2;         
%   Omega = 72;        
%
%   hsl            = 0;
%
%   label           = 'ScaledHelicopterfromBo105';
%
%   DroneHe       = rigidHe2rigidScaledHe(he,b,R,Omega,W,btr,atm,hsl,label);
%
%%% References
%%%
%%% [1] Alvaro Cuerva Tejero, Jose Luis Espino Granado, Oscar Lopez Garcia,
%%% Jose Meseguer Ruiz, and Angel Sanz Andres. Teoria de los Helicopteros.
%%% Serie de Ingenieria y Tecnologia Aeroespacial. Universidad Politecnica
%%% de Madrid, 2008.
%%%
%%% [2] Irene Velasco Suárez. Diseño y Análisis Preliminar de un Helicóptero
%%% no Tripulado. PFC. ETSI Aeronáuticos. UPM. Noviembre 2017.



% Non-dimensionalisation of seed helicopter

ndHe            = rigidHe2ndHe(rigidHe,atm,H);

% Definición del helicóptero no tripulado

rigidScaledHe   = ndSeedHe2rigidScaledHe(ndHe,b,R,Omega,W,btr,label);

end


