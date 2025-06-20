function missionOut = getSegmentGlideV(he,atm,missIn,pos,varargin)
% getSegmentGlideV solves the mission glide segment with given altitude 
% increment and flight velocity.
%
% missionOut is a structure with the following fields:
%
%   class: 'missionSegment'
%      id: 'Glide'
%  solver: @MYgetSegmentGlideV
%     pos: [1x1 double] is the segment position
%       V: [1x2 double] is the segment flight velocity [m/s]
%  gammaT: [1x2 double] is the climb angle [rad]
%      VH: [1x2 double] is the segment flight horizontal velocity [m/s]
%      VV: [1x2 double] is the segment flight vertical velocity [m/s]
%   Omega: [1x2 double] is the main rotor angular velocity [rad/s]
%       Z: [1x2 double] is the flight segment height considered by ground
%                       effect [m]
%       H: [1x2 double] is the flight segment altitude [m]
%      DH: [1x1 double] is the altitude increment during the flight 
%                       segment [m]
%       R: [1x2 double] is the flight segment range [m]
%      DR: [1x1 double] is the range increment during the flight segment [m]
%       T: [1x2 double] is the segment flight time [s]
%      DT: [1x1 double] is the time increment during the segment flight [s]
%      GW: [1x2 double] is the flight segment  gross weight [N]
%     DGW: [1x1 double] is the gross weight increment during the flight
%                       segment [N]
%      Mf: [1x2 double] is the flight segment fuel mass [Kg]
%     DMf: [1x1 double] is the fuel mass increment during the flight
%                       segment [Kg]
%      PL: [1x2 double] is the flight segment payload [N]
%     DPL: [1x1 double] is the payload increment during the flight 
%                       segment [N]
%       P: [1x2 double] is the power required in the flight segment [kW]
%
% In fields with two elements, the first element corresponds to its value 
% at the segment start, and the second element corresponds to its value at 
% the end of the segment.
%


 
 options   = parseOptions(varargin,@setHeroesEnergyOptions);
 
% Getting initial segment values from final values of the previous segment
 
missIn.mSeg{pos}.H(1)  = missIn.mSeg{pos-1}.H(2);
missIn.nSeg{pos}.Z(1)  = missIn.mSeg{pos-1}.Z(2);
missIn.mSeg{pos}.R(1)  = missIn.mSeg{pos-1}.R(2);
missIn.mSeg{pos}.T(1)  = missIn.mSeg{pos-1}.T(2);
missIn.mSeg{pos}.GW(1) = missIn.mSeg{pos-1}.GW(2);
missIn.mSeg{pos}.Mf(1) = missIn.mSeg{pos-1}.Mf(2);
missIn.mSeg{pos}.PL(1) = missIn.mSeg{pos-1}.PL(2);

  
% Getting segment flight condition

fC = getFlightCondition(he,'V',missIn.mSeg{pos}.V(1),...
                        'H',missIn.mSeg{pos}.H(1)+0.5*missIn.mSeg{pos}.DH,...
                        'GW',missIn.mSeg{pos}.GW(1),...
                        'Mf',missIn.mSeg{pos}.Mf(1),...
                        'P',missIn.mSeg{pos}.P(1),...
                        'Z',missIn.mSeg{pos}.Z(1));
                         
% Calculating the power state

[gammaTautorrot,Pautorrot] = gammaTgivenPower(he,fC,atm,...
                            'constrainedEnginePower','flightCondition');

fC.gammaT = gammaTautorrot;
fC.Vv     = fC.V * sin(gammaTautorrot);
fC.Vh     = fC.V * cos(gammaTautorrot);
P         = fC.P;

% Calculating the fuel mass consumption 

       missIn.mSeg{pos}.DT = missIn.mSeg{pos}.DH/fC.Vv;
                       DMf = he.engine.PSFC*P*missIn.mSeg{pos}.DT;
      missIn.mSeg{pos}.DMf = -DMf;
     missIn.mSeg{pos}.V(1) = fC.V;
     missIn.mSeg{pos}.V(2) = fC.V;
    missIn.mSeg{pos}.VV(1) = fC.Vv;
    missIn.mSeg{pos}.VV(2) = fC.Vv;
    missIn.mSeg{pos}.VH(1) = fC.Vh;
    missIn.mSeg{pos}.VH(2) = fC.Vh;
missIn.mSeg{pos}.gammaT(1) = fC.gammaT;
missIn.mSeg{pos}.gammaT(2) = fC.gammaT;


% Additional Segment calculations
    
 missIn.mSeg{pos}.Z(2) = missIn.mSeg{pos}.Z(1); 
 missIn.mSeg{pos}.H(2) = missIn.mSeg{pos}.H(1)+missIn.mSeg{pos}.DH;
   missIn.mSeg{pos}.DR = missIn.mSeg{pos}.VH(1)*missIn.mSeg{pos}.DT;
 missIn.mSeg{pos}.R(2) = missIn.mSeg{pos}.R(1)+missIn.mSeg{pos}.DR;
 missIn.mSeg{pos}.T(2) = missIn.mSeg{pos}.T(1)+missIn.mSeg{pos}.DT;
missIn.mSeg{pos}.PL(2) = missIn.mSeg{pos}.PL(1)+missIn.mSeg{pos}.DPL;
  missIn.mSeg{pos}.DGW = missIn.mSeg{pos}.DMf*atm.g+missIn.mSeg{pos}.DPL;
missIn.mSeg{pos}.GW(2) = missIn.mSeg{pos}.GW(1)+missIn.mSeg{pos}.DGW;
missIn.mSeg{pos}.Mf(2) = missIn.mSeg{pos}.Mf(1)+missIn.mSeg{pos}.DMf;
 missIn.mSeg{pos}.P(1) = P;
 missIn.mSeg{pos}.P(2) = P;
  
   
  missionOut = missIn;

end

