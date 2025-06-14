function stathe = desreq2stathe(desreq,engine)
%
% This function transforms a design requirement (desreq) together with an 
% engine into a helicopter dimensioning

mr    = getRandMainRotor(desreq);
tr    = getRandTailRotor(desreq);
dim   = getRandDimension(desreq,mr,tr);
pfs   = getRandPerformance(desreq);
wgt   = getRandWeight(desreq);


% Fuel flow
wgt.fuelFlow = engine.PSFC*pfs.TakeOffTotalPower;


afdd = AFDD(desreq,mr,tr,dim,pfs,wgt,engine);

% get equivalent flat plate area
f = getEquivalentFlatPlateArea(desreq);
desreq.energyEstimations.f                = f;


% Adds standard transmission as default for the transmission type
desreq.energyEstimations.transmissionType = @standardTransmission;

% Get inertia moments of aircraft
MTOW           = desreq.rand.MTOW;
radius         = mr.R;
inertiaMoments = getStatInertiaMoments(MTOW,radius);

stathe = struct(...
        'class','stathe',...
        'id',desreq.id,...
        'MainRotor', mr,...
        'TailRotor', tr,...
        'Dimensions', dim,...
        'Performances', pfs,...
        'Weights', wgt,...
        'inertiaMoments',inertiaMoments,...
        'energyEstimations',desreq.energyEstimations,...
        'Engine',engine,...
        'AFDD', afdd ...
);


