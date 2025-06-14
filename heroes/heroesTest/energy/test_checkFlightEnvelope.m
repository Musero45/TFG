function io = test_checkFlightEnvelope(mode)
close all


% Get ISA atmosphere
atm        = getISA;


% Define longitudinal flight path angle
gammaT = 0;




% % % % % % One problem of stathe2ehe is that the maximum transmission power is
% % % % % % limitating most of the altitude envelope, for this example up to 10000
% % % % % % and 11000 meters
% % % % % % Therefore to obtain a nice flight envelope we set a maximum transmission
% % % % % % power of 1e6 W and we override ehe data
% % % % % Pmt                    = 1e6;
% % % % % fPmt                   = @(h) Pmt*ones(size(h));
% % % % % he.transmission.fPmt   = fPmt;
% % % % % he.transmission.Pmt    = Pmt;
% % % % % 
% % % % % % Next we recompute available power
% % % % % % Get available power taken into account transmission power limitation
% % % % % availablePower = engine_transmission2availablePower(he.engine,he.transmission);
% % % % % he.availablePower = availablePower;





% % The following snippet of code is for debugging pourposes
% % and before plotting flight envelope just check excess power to understand
% % what it is going on
% hi     = linspace(0,10000,53);
% vi     = linspace(0,100,51);
% Pi     = getExcessPower(he,vi,gammaT,hi,NaN,atm);
% [Vi,Hi] = meshgrid(vi,hi);
% [D,g] = contour(Vi,Hi,Pi);
% set(g,'ShowText','on');


% Just test the case with problems which is one engine and no power
% constraint. Flight envelope plot is drawn using the branch fields of the 
% structure

energytestcase  = {'cesar1','cesar2','4500kg','6000kg','9000kg','ehe'};
ne              = length(energytestcase);


for i = 1:ne
    he = selectTestingEhe(energytestcase{i},atm);
    fc = getFlightCondition(he);
    fe1 = getFlightEnvelope(he,fc,atm);

    figure(i)
    set(gcf,  'Name',energytestcase{i});

    plot(fe1.hover2hmax(:,1),fe1.hover2hmax(:,2),'r-'); hold on;
    plot(fe1.vmaxSL2hmax(:,1),fe1.vmaxSL2hmax(:,2),'b-x'); hold on;
    plot(fe1.branch2(:,1),fe1.branch2(:,2),'g-'); hold on;
    plot(fe1.vh_hMax(:,1),fe1.vh_hMax(:,2),'k s'); hold on;
    plot(fe1.vh_vmaxSL(:,1),fe1.vh_vmaxSL(:,2),'k o'); hold on;

end







io = 1;
