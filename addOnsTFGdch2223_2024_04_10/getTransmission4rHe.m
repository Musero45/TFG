function transmission = getTransmission4rHe(Pmt,Pmtto,Pmtu,etaTmr,etaTtr,transmissionType,name)

%getTransmission4rHe builds a complete transmission structure of a ready
%for flight helicopter to be parsed with the transmission structure of a
%rigid helicoper

%  


transmission = struct(...
            'class','transmission data for a r4f rigid helicopter',...
            'id',name,...
            'Pmt',Pmt,...[W]. Maximum continous transmission power
            'Pmtu',Pmtu,...[W]. Maximum urgency transmission power
            'Pmtto',Pmtto,...[W]. Maximum transmission power at take off
            'etaTmr',etaTmr,...[-]. ratio of power losses in main rotor transmission
            'etaTtr',etaTtr,...[-]. ratio of power losses in tail rotor transmission
            'transmissionType',transmissionType);% Trasmission type model

