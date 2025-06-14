function y = DirectOperatingCost(desreq,weights,engine,aircraftFlyawayCost)
%
% NDARC, NASA Design and Analysis of Rotorcraft (2009)
% Wayne Johnson
%  
% 19-6 - Direct operating costs (pages 47-52)
%
% Input and output variables expressed in International System 
%
% Initial version and International System Version 
%      12/11/2013 Cesar Garcia cesar.garcia.lozano@alumnos.upm.es
%

C_AC      = aircraftFlyawayCost.C_AC;

W_MTO__   = weights.MTOW;
W_E__     = weights.emptyWeight;
Pto       = engine.PowerTakeOff;
Neng      = engine.numEngines;

X_maint   = desreq.technologyFactors.maintenance;
W_fuel__  = desreq.mission.fuelWeight;
T_miss__  = desreq.mission.time;
R_miss    = desreq.rand.Range;
B__       = desreq.mission.avaibleBlockHours;
S         = desreq.mission.sparesPerAircraft;
D         = desreq.mission.depreciacionPeriod;
V         = desreq.mission.residualValue;
L         = desreq.mission.loanPeriod;
I         = desreq.mission.interestRate;
T_NF__    = desreq.mission.nonFlightTimeTrip;
N_pas     = desreq.mission.numPassengers;
ro_fuel__ = desreq.mission.fuelDensity;
K_crew    = desreq.mission.crewFactor;
T_op      = desreq.mission.operationPeriod;
Y_ini     = desreq.mission.initialOperationYear;
F_i       = desreq.mission.priceIndex;
G_i__     = desreq.mission.fuelCost;

%--------------------------------------------------------------------------
% Total Pot adding all engines
%--------------------------------------------------------------------------
P = Pto*Neng;

%--------------------------------------------------------------------------
% Adjusting parameters to SI:
%--------------------------------------------------------------------------
% Parameters in are in W and the model manages kg

kgf2N = 9.81;
l2m3  = 1000;
h2s   = 3600;

W_MTO    = W_MTO__/kgf2N;
W_E      = W_E__/kgf2N;
W_fuel   = W_fuel__/kgf2N;
ro_fuel  = ro_fuel__/l2m3;
G_i      = G_i__/l2m3;
T_miss   = T_miss__/h2s;
T_NF     = T_NF__/h2s;
B        = B__/h2s;


%--------------------------------------------------------------------------
% SI to Imperial:
%--------------------------------------------------------------------------
% 1 kg      = 2.20462262 lb
% 1 m       = 0.00053995 nm
% 1 W       = 0.00135962 hp
% 1 l       = 0.26417205 gal
% 1 $/kg    = 0.45359237 $/lb
% 1 kg/l    = 8.34540447 lb/gal
% 1 $/l     = 3.78541180 $/gal

SI2IS = SI2ImperialSystem;

W_MTO_   = SI2IS.kg2lb*W_MTO;
W_E_ 	 = SI2IS.kg2lb*W_E;
W_fuel_  = SI2IS.kg2lb*W_fuel;
R_miss_  = SI2IS.m2nm*R_miss;
P_       = SI2IS.W2hp*P;
ro_fuel_ = SI2IS.kgl2lbgal*ro_fuel;
G_i_     = SI2IS.dolarl2dolargal*G_i;


%--------------------------------------------------------------------------
% Cost model parameters:
%--------------------------------------------------------------------------
% W_MTO     maximum takeoff weight (lb)
% W_E       weight empty (lb)
% X_maint   maintenance technology factor (-)
% W_fuel    mission fuel burned (kg)
% T_miss    mission time (hr)
% R_miss    mission range (nm)
% G         fuel cost ($/liter)
% B         available block hours (hr)
% S         spares per aircraft (fraction purchase price) (-)
% D         depreciacion period (yr)
% V         residual value (fraction) (-)
% L         loan period (yr)
% I         interest rate (%)
% T_NF      non-flight time per trip (hr)
% N_pass    number of passengers (-)
% ro_fuel   fuel density (weight/volume) (kg/liter)
% K_crew    crew factor (-)
% T_op      operation period (yr)
% Y_ini     initial operation year (yr)
%-----------



%--------------------------------------------------------------------------
% Inflation factors: 
%--------------------------------------------------------------------------
% DoD internal inflation factors for DoD
% CPI consumer price index
%
%   inflation factors
% -----------------------
% n  year   DoD     CPI
% -----------------------
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
% Fuel price forecast: 
%--------------------------------------------------------------------------
%  fuel  factors
% year   JetA1[$/gal]
% --------------------
% 1  2010  2.1919
% 2  2011  2.7441
% 3  2012  2.9972
% 4  2013  2.8089
% 5  2014  2.5726
% 6  2015  2.4207
% 7  2016  2.4417
% 8  2017  2.5622
% 9  2018  2.6616
% 10 2019  2.7667
% 11 2020  2.8569
% 12 2021  2.9420
% 13 2022  3.0197
% 14 2023  3.1038
% 15 2024  3.1876
% Predictions based on
% http://www.faa.gov/about/office_org/headquarters_offices/apl/aviation_forecasts/aerospace_forecasts/2013-2033/media/2013_Forecast.pdf
%G_i_ = [ 2.1919 2.7441 2.9972 2.8089 2.5726 2.4207 2.4417 2.5622 2.6616 ...
%2.7667 2.8569 2.9420 3.0197 3.1038 3.1876];  % $/gal
%G_i = [ 0.5790 0.7249 0.7918 0.7420 0.6796 0.6395 0.6450 0.6769 ...
%0.7031 0.7309 0.7547 0.7772 0.7977 0.8199 0.8421]...  % $/l


%----------------------------------    ----------------------------------------
% Main equation model:
%--------------------------------------------------------------------------
    %C_DOC+I direct operating cost plus interest (cents per available seat
        %mille (ASM)) = maintenance (maint $/hour) + crew + fuel + depreciation
        %+ insurance + finance.


%--------------------------------------------------------------------------
% Equations:
%--------------------------------------------------------------------------

% Maintenance cost per hour
c_maint = 0.49885*W_E_^0.3746*P_^0.4635;

% Maintenance cost per flight hour
posF = Y_ini-2009;
C_maint=zeros(T_op);
for i = 1:T_op
  C_maint(i)  = F_i(posF-1+i)/100*X_maint*c_maint;
end
% F_i inflation factor, X_maint maintenance technology factor

% Number of departures per year
N_dep = B/T_miss;

% Flight time per trip
T_trip = T_miss - T_NF;

% Flight hours per year
T_F = T_trip*N_dep;

% Crew cost
C_crew  = 3.19*K_crew*(W_MTO_^0.4)*B;

% Insurance cost
C_ins   = 0.0056*C_AC;

% Depreciation cost
C_dep   = C_AC*(1+S)/D*(1-V);

% Finantial cost
C_fin   = C_AC*(1+S)/D*(2*L+1)/4*I/100;

% Available seat miles per year
ASM = 1.1508*N_pas*R_miss_*N_dep;

% Fuel cost
% Operating cost per year
% Direct operating cost + interest
posG = Y_ini-2009;
C_fuel=zeros(T_op);
C_OPV=zeros(T_op);
DOCIV=zeros(T_op);
for i = 1:T_op
    C_fuel(i)   = G_i_(posG-1+i)*(W_fuel_/ro_fuel_)*N_dep;
    C_OPV(i)    = T_F*C_maint(i) + C_fuel(i) + C_crew + C_dep + C_ins + C_fin;
    DOCIV(i)    = C_OPV(i)/ASM; % In the model (*100): the value is in cents but we want in $
end

C_Maint = T_F*sum(C_maint);
C_Fuel  = sum(C_fuel);
C_OP    = sum(C_OPV);
DOCI    = sum(DOCIV);

% Convert exit values in SI
DOCI = DOCI*SI2IS.m2nm;

y = struct (...
  'C_maint', C_Maint,...
   'C_fuel', C_Fuel,...
   'C_crew', C_crew,...
    'C_ins', C_ins,...
    'C_dep', C_dep,...
    'C_fin', C_fin,...
     'C_OP', C_OP,...
     'DOCI', DOCI...
);


