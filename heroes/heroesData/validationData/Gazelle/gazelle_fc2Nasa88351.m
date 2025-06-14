function [FC,muWT,h,he,mu]=FlightCondition2(he)
% Flight condition #2 defined according to page 17 of [1]
%
%% References
%    [1] Yamauchi, Gloria K., Heffernan, Ruth M. and Gaubert, Michel. 
%    Correlation of SA349/2 Helicopter Flight Test Data with a Comprehnsive
%    Rotorcraft Model, 1987. NASA-TM-88351.

h            = 1521;
he.inertia.W = 1934*9.8 ;
mu  = 0.362;
% CT0 = 0.071.*he.mainRotor.solidityMR;

muWT          = [0; 0; 0];
FC            = {'VOR',mu,...
                 'betaf0',0,...
                 'wTOR',0,...
                 'cs',0,...
                 'vTOR',0};