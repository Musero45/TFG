function ClimbPlan = MinFuelClimb4VSegmentBuilder(pos,DH,V,DPL,Omega)
% MinFuelClimb4VhSegmentBuilder builds the mission segment corresponding
% to a climb for given altitude increment, DH, flight velocity, V, and the minimum 
% fuel consumption.
%
% pos   [1x1 double] is the segment position
% DH    [1x1 double] is the altitude increment during the flight segment [m]
% V     [1x1 double] is the segment flight velocity [m/s]
% DPL   [1x1 double] is the segment payload variation [N]
% Omega [1x1 double] is the main rotor angular velocity [rad/s]
%
%
% The ClimbPlan is a structure with the following fields:
%
%     class: 'missionSegment'
%        id: 'Climb'
%    solver: @getSegmentMinFuelClimb4V
%       pos: [1x1 double]
%         V: [1x2 double]
%    gammaT: [1x2 double]
%        VH: [1x2 double]
%        VV: [1x2 double]
%     Omega: [1x2 double]
%         Z: [1x2 double]
%         H: [1x2 double]
%        DH: [1x1 double]
%         R: [1x2 double]
%        DR: [1x1 double]
%         T: [1x2 double]
%        DT: [1x1 double]
%        GW: [1x2 double]
%       DGW: [1x1 double]
%        Mf: [1x2 double]
%       DMf: [1x1 double]
%        PL: [1x2 double]
%       DPL: [1x1 double]
%         P: [1x2 double]
%


ClimbPlan = struct(...
    'class','missionSegment',...
       'id','Climb',...
   'solver',@getSegmentMinFuelClimb4V,...  
      'pos',pos,...
        'V',[V V],...
   'gammaT',[NaN NaN],...
       'VH',[NaN NaN],...
       'VV',[NaN NaN],...
    'Omega',[Omega Omega],...
        'Z',[NaN NaN],...
        'H',[NaN NaN],...
       'DH',DH,...
        'R',[NaN NaN],...
       'DR',NaN,...
        'T',[NaN NaN],...
       'DT',NaN,...
       'GW',[NaN NaN],...
      'DGW',NaN,...
       'Mf',[NaN NaN],...
      'DMf',NaN,...
       'PL',[NaN NaN],...
      'DPL',DPL,...
        'P',[NaN NaN]...
          ); 
      
end


