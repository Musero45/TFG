function y = AircraftFlyawayCost(desreq,mainRotor,weights,engine)
%
% NDARC, NASA Design and Analysis of Rotorcraft (2009)
% Wayne Johnson
%  
% 19-6 - Aircraft flyaway cost (pages 47-52)
%
% Input and output variables expressed in International System 
%
% Initial version and International System Version 
%      12/11/2013 Cesar Garcia cesar.garcia.lozano@alumnos.upm.es
%

 
W_MTO__   = weights.MTOW;
W_E__     = weights.emptyWeight;
N_blade   = mainRotor.b;
Pto       = engine.PowerTakeOff;
Neng      = engine.numEngines;

W_MEP__   = desreq.mission.missionEquipmentPackage;
W_FCE__   = desreq.mission.flightControlElectronics;
r_MEP     = desreq.mission.costFactorMEP;
r_FCE     = desreq.mission.costFactorFCE;

L_comp    = desreq.costFactors.compositeAdditionalPrice;
X_comp    = desreq.costFactors.compositeFraction; 
X_AF      = desreq.technologyFactors.aircraft;
Y_pur     = desreq.mission.purchaseYear;
K_ET      = desreq.costFactors.engineType;
K_EN      = desreq.costFactors.numEngines;
K_LG      = desreq.costFactors.lgType;
K_R       = desreq.costFactors.numMainRotors;
F_i       = desreq.mission.priceIndex;

%--------------------------------------------------------------------------
% Total Pot adding all engines
%--------------------------------------------------------------------------
P = Pto*Neng;

%--------------------------------------------------------------------------
% Adjusting parameters to SI:
%--------------------------------------------------------------------------
% Parameters in are in W and the model manages kg
kgf2N = 9.81;
W_MTO     = W_MTO__/kgf2N;
W_E       = W_E__/kgf2N;
W_MEP     = W_MEP__/kgf2N;
W_FCE     = W_FCE__/kgf2N;

% Masa de material compuesto
W_comp = W_MTO*X_comp;

%--------------------------------------------------------------------------
% SI to Imperial:
%--------------------------------------------------------------------------
% 1 kg      = 2.20462262 lb   
% 1 W       = 0.00135962 hp
% 1 $/kg    = 0.45359237 $/lb

SI2IS = SI2ImperialSystem;

W_E_ 	 = SI2IS.kg2lb*W_E;
P_       = SI2IS.W2hp*P;
W_MEP_   = SI2IS.kg2lb*W_MEP;
W_FCE_   = SI2IS.kg2lb*W_FCE;
W_comp_  = SI2IS.kg2lb*W_comp;
r_MEP_   = SI2IS.dolarkg2dolarlb*r_MEP;
r_FCE_   = SI2IS.dolarkg2dolarlb*r_FCE;
L_comp_  = SI2IS.dolarkg2dolarlb*L_comp;


%--------------------------------------------------------------------------
% Cost model parameters:
%--------------------------------------------------------------------------
% W_E_      weight empty (lb)
% N_blade   number of blades per rotor (-)
% P_        rated takeoff power (all engines)(hp)
% W_MEP_    fixed useful load weight, mission equipment package (lb)
% W_FCE_    fixed useful load weight, flight control electronics (lb)
% r_MEP_    cost factor, mission equipment package ($/lb)
% r_FCE_    cost factor, flight control electronics ($/lb)
% L_comp_   additional labor rate for composite construction ($/lb)
% W_comp_   composite weight (lb)
% X_AF      aircraft technology factor (-)
% Y_pur     purchase year (yr)
%----------

%--------------------------------------------------------------------------
% Inflation factors: 
%--------------------------------------------------------------------------
% DoD internal inflation factors for DoD
% CPI consumer price index
%
%  inflation factors
% year   DoD     CPI
% --------------------
% -  1994  100.00  100.00
% 1  2010  131.22  147.13
% 2  2011  133.41  151.77
% 3  2012  135.77  154.91
% 4  2013  138.26  157.26
% 5  2014  140.72  160.25
% 6  2015  143.25  163.94
% 7  2016  ......  167.57
% 8  2017  ......  171.89
% 9  2018  ......  176.02
% 10 2019  ......  180.25
% 11 2020  ......  184.58
% 12 2021  ......  189.01
% 13 2022  ......  193.55
% 14 2023  ......  198.19
% 15 2024  ......  202.95
% -----------------------
% Completed based on ftp://ftp.bls.gov/pub/special.requests/cpi/cpiai.tx
% Predictions based on
% http://www.seattle.gov/financedepartment/cpi/documents/US_CPI_Forecast_--_Annual_09-17-13.pdf
%F_i = [ 147.13 151.77 154.91 157.26 160.25 163.94 167.57 171.89 176.02 ...
%180.25 184.58 189.01 193.55 198.19 202.95];


%--------------------------------------------------------------------------
% Main equations:
%--------------------------------------------------------------------------
    %C_AC aircraft flyaway cost ($) = airframe (AF) + mission equipement package 
        %MEP + flight-control-electronics (FCE).
    %C_DOC+I direct operating cost plus interest (cents per available seat
        %mille (ASM)) = maintenance (maint $/hour) + crew + fuel + depreciation
        %+ insurance + finance.
    %CTM rotorcraft cost model

%--------------------------------------------------------------------------
% Equations:
%--------------------------------------------------------------------------

% Airframe weight
W_AF_ = W_E_ - W_MEP_ - W_FCE_;

% Additional cost for composite construction
c_comp = L_comp_*W_comp_;  
% W_comp composite structure = input fraction of component weight with
% separate fractions for body, tail, pylon and wing weight.

% Mission equipement package cost
C_MEP = r_MEP_*W_MEP_;

% Flight control electronics cost
C_FCE = r_FCE_*W_FCE_;

% Airframe purchase price
c_AF    = 739.66*K_ET*K_EN*K_LG*K_R*W_AF_^1.0619*(P_/W_AF_)^0.5887*N_blade^0.1465 + c_comp;

% Aircraft flyaway cost
pos = Y_pur-2009;
C_AF     = F_i(pos)/100*(X_AF*c_AF);
C_MEP    = F_i(pos)/100*(C_MEP);
C_FCE    = F_i(pos)/100*(C_FCE);
C_AC     = C_AF + C_MEP + C_FCE;
% F_i inflation factor, X_AF aircraft technology factor

 
 y = struct (...
     'C_AF', C_AF,...
     'C_MEP', C_MEP,...
     'C_FCE',C_FCE,...
     'C_AC', C_AC...
);
 
