function rigidheOut = addMissionWeightsRigid(rigidheIn,PL,Mf,Rf,atm)
% ADDMISSIONWEIGHTSRIGID       Adds mission weights to rigid helicopter
%
%   HE = ADDMISSIONWEIGHTS(HE,PL,MF,RF,atm) computes the actual helicopter 
%   weight, W, for a given mission in an atmosphere, ATM, defined by the 
%   payload weight, PL, the fuel weight as the sum of the fuel mass, MF and 
%   reserve fuel mass, RF. The helicopter weight, W, the fuel mass, MF, and
%   the reserve fuel mass, RF, are added to the rigid helicopter data.
%   
%   Example of usage
%
%     % PL and fuel for missions
%     PL = 75*atm.g; %N
%     Mf = 400; % kg
%     Rf = 50;  % kg
% 
%     % Add in weights into the helicopter data 
%     he = addMissionWeightsRigid(he,PL,Mf,Rf,atm);

% Set the rigid helicopter output
rigidheOut     = rigidheIn;

% Define the Operating Empty Weight, MTOW and max Fuel value
OEW  = rigidheIn.inertia.OEW;
MFW  = rigidheIn.inertia.MFW;
MTOW = rigidheIn.inertia.MTOW;

% Set the fuel weight
FW   = (Mf+Rf)*atm.g-0.00001;

if FW>MFW
    FW = MFW;
    disp('addMissionWeightsRigid: FW exceeds MFW. FW = MFW.');
end


% Define the Gross Empty Weight
GTOW = OEW + PL + FW;

if GTOW>MTOW
    GTOW = MTOW;
    %This is done to use the real fuel weight the helicopter can carry
    %in the selected configuration to compute Range, Endurance...This was
    %done previously using MFW to compute maximum performances but the helo
    %may not be able to carry MFW in some configurations.
    FW = MTOW - (OEW+PL);
    disp('addMissionWeightsRigid: GTOW exceeds MTOW. GTOW = MTOW. Limiting FW');
end

% Add mass and weights to helicopter
rigidheOut.inertia.OEW = OEW;
rigidheOut.inertia.PL  = PL;

rigidheOut.inertia.W   = GTOW;
rigidheOut.inertia.FW  = FW;

