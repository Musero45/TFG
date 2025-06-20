function hoverPlan = HoverSegmentBuilder(pos,DT,DPL,Omega)
% HoverSegmentBuilder builds the mission segment corresponding to a hover 
% for given flight time, DT. 
%
% pos   [1x1 double]  is the segment position
% DT    [1x1 double]  is the segment flight time [s]
% DPL   [1x1 double]  is the segment payload variation [N]
% Omega [1x1 double]  is the main rotor angular velocity [rad/s]
%
%
% The hoverPlan is a structure with the following fields:
%
%     class: 'missionSegment'
%        id: 'Hover'
%    solver: @getSegmentHover
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

    hoverPlan = struct(...
    'class','missionSegment',...
       'id','Hover',...
   'solver',@getSegmentHover,...
      'pos',pos,...
        'V',[0 0],...
   'gammaT',[0 0],...
       'VH',[NaN NaN],...
       'VV',[NaN NaN],...
    'Omega',[Omega Omega],...
        'Z',[NaN NaN],...
        'H',[NaN NaN],...
       'DH',0,...
        'R',[NaN NaN],...
       'DR',0,...
        'T',[NaN NaN],...
       'DT',DT,...
       'GW',[NaN NaN],...
      'DGW',NaN,...
       'Mf',[NaN NaN],...
      'DMf',NaN,...
       'PL',[NaN NaN],...
      'DPL',DPL,...
        'P',[NaN NaN]...
          );
      
end


