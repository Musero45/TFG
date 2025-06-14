function MissionParameters = missionDR(varargin)
%MISSIONDR Summary of this function goes here

% Set options
options   = parseOptions(varargin,@setHeroesMissionOptions);


if strcmp(options.missionType,'civilTimeSurvey')
    
    %Mission segments
    %01hover1 
    %12taxi  
    %23climb  
    %34cruise 
    %45hover2 
    %56glide
    %67taxi2
    
    Nsegments = 7;
    
    T = struct(...
        'thover01',36.0,...
        'ttaxi12',72.0,...
        'tcruise34',2160.0,... %variable
        'thover45',180.0,...
        'ttaxi67',72.0...
        );
    
    H = struct(...
        'hstart',600.0,...
        'deltah',300.0...
        );
        
    V = struct(...
        'vtaxi12',4.0...
        );

    Z = struct(...
        'zflour',2.0,... 
        'zhight',10000.0... 
        );
    
    R = struct();
    
    gammaT = 'none';
    n = struct();
    
elseif strcmp(options.missionType,'civilRangeSurvey')
 
    %Mission segments
    %01hover1 
    %12taxi  
    %23climb  
    %34cruise 
    %45hover2 
    %56glide
    %67taxi2
    
    Nsegments = 7;
    
    T = struct(...
        'thover01',36.0,...
        'ttaxi12',72.0,...
        'thover45',180.0,...
        'ttaxi67',72.0...
        );
    
    H = struct(...
        'hstart',600.0,...
        'deltah',300.0...
        );
        
    V = struct(...
        'vtaxi12',4.0...
        );

    Z = struct(...
        'zflour',2.0,... 
        'zhight',10000.0... 
        );
    
   R = struct(...
        'Rcruise',100000.0...%var
    );
    
    gammaT = 'none';
    n = struct();
    
    
elseif strcmp(options.missionType,'civilRangeTransport')

    %Mission segments
    %01hover 
    %12taxi  
    %23climb  
    %34cruise 
    %45glide
    %56taxi2
    
    Nsegments= 6;
    T = struct(...
        'thover',100,...
        'ttaxi',100 ...        
        );
    
    H = struct(...
        'hstart',600.0,...
        'deltahcruise',700,...
        'hlanding',200 ...
        );
        
    V = struct(...
        'vtaxi',4.0...
        );

    Z = struct(...
        'zflour',2.0,... 
        'zhight',10000.0... 
        );
    
    R = struct(...
        'Rcruise',200000.0...%variable
    );

    gammaT = 'none';
    n = struct();
    
elseif strcmp(options.missionType,'civilMedical')
    
    %Mission segments
    %01hover1
    %12climb1
    %23cruisemaxv 
    %34glide1
    %45hover2
    %56climb2 
    %67cruisemaxv
    %78glide2
    %89hover3
    %910climb3
    %1011cruise
    %1112glide3
    %1213taxi
        
    Nsegments = 13;
    
    
    
    T = struct(...
        'thover01',36,...
        'thover45',180,... %hover rescue
        'thover89',180,... %hover hospital
        'ttaxi',72 ...
         );
    
    H = struct(...
        'hstart',600,...
        'deltahcruise',200, ...
        'deltahrescue',0, ...
        'hhospital',650, ...
        'deltahcruise2',300 ...
         );
    
    V = struct(...
        'vtaxi',4.0 ...
        );
    
    Z = struct(...
        'zflour',2.0,... %use this Z to take ground effect into account
        'zhight',10000.0... %use this Z if no ground effect
        );
    
    R = struct(...
        'Rcruiserescue',10000,... 
        'Rcruisehospital',10000,...
        'Rcruisereturn',10000 ...
         );
    
    gammaT = 'none';
    n = struct();
    
elseif strcmp(options.missionType,'civilSurveillance')
    
    %Mission segments
    %01hover1 
    %12taxi  
    %23climb  
    %34cruise 
    %45hover2 
    %56glide
    %67taxi2
    
    Nsegments = 7;
    
    T = struct(...
        'thover01',36.0,...
        'ttaxi12',72.0,...
        'tcruise34',3600.0,... %VAriar esta
        'thover45',180.0,...
        'ttaxi67',72.0...
        );
    
    H = struct(...
        'hstart',600.0,...
        'deltah',300.0...
        );
        
    V = struct(...
        'vtaxi12',4.0...
        );

    Z = struct(...
        'zflour',2.0,... 
        'zhight',10000.0... 
        );
    
    R = struct();
    
    gammaT = 'none';
    n = struct();
    
elseif strcmp(options.missionType,'civilFirefighting')
    
   
    n = 0; %Calculated by getCivilFireFightingMission
    Nsegments = @(n) 12+8*n; %Calculated by getCivilFireFightingMission
    
    %Variable mission parameters are marked with VAR, and typical
    %values are indicated
    
    T = struct(...
        'thover01',36,...
        'thoverwater',50,... %VAR water refill time
        'Tmax',7200 ... %Standard maximum time of mission.
        );
    
    H = struct(...
        'hstart',600,...
        'deltahcruise',75.0,... %VAR; typical cruise1 height (inventada)
        'deltahwater', 10,...
        'deltahfire',20.0... %VAR;  
        );
    
    V = struct();
    
    Z = struct(...
        'zflour',2.0,... %use this Z to take ground effect into account
        'zhight',10000.0... %use this Z if no ground effect
        );
    
    R = struct(...
        'Rcruisemaxv',60000.0,...%cruise between start point and  first water refill point
        'RcruiseWaterToFire',2000.0,... %cruise between water refill point and first dropping water point 
        'Rfire',150.0... %distance dropping water
        );
    
    gammaT = 'none';

elseif strcmp(options.missionType,'milRecon')
    
    %Mission segments
    %01hover1
    %12taxi1
    %23climb1
    %34cruisemaxr1
    %45cruisemaxe2
    %56cruisemaxr3
    %67glide2
    %78taxi2
    
    Nsegments = 8;
    
    %Variable mission parameters are marked with VAR, and typical
    %values are indicated
    
    T = struct(...
        'thover01',36,...
        'ttaxi12',72.0,...
        'tcruise45',9000.0,... %VAR esta
        'ttaxi78',72.0...
        );
    
    H = struct(...
        'hstart',600.0,...
        'deltah',2400.0... 
        );
    
    V = struct(...
        'vtaxi',4.0...
        );
    
    Z = struct(...
        'zflour',2.0,... %use this Z to take ground effect into account
        'zhight',10000.0... %use this Z if no ground effect
        );
    
    R = struct(...
        'Rcruisemaxr134',150000.0,...%VAR; typically 200NM max
        'Rcruisemaxr356',150000.0...%VAR; typically 200NM max
        );
    
    gammaT = 'none';
    n = struct();
    
elseif strcmp(options.missionType,'milASWDippingSonar')
    
    %Mission segments
    %01hover1
    %12climb1
    %23cruisemaxv1 
    %34glide1
    %45allhover 
    %56alltransit 
    %67climb2
    %78cruisemaxr3
    %89glide2
    
    Nsegments = 9;
    
    %Variable mission parameters are marked with VAR, and typical
    %values are indicated
    
    n = 15; %VAR esta! 12-30 ; N of dipping sonar searches
    tperhover = 120.0; %VAR 120-300; hover time on each search point
    Rpertransit = 8000.0; %VAR 3.7-9.3; distance between search points
    
    T = struct(...
        'thover01',36,...
        'tallhover45',@(N) tperhover*N...
        );
    
    H = struct(...
        'hstart',0.0,...
        'deltahcruise1',914.4,... %VAR; 3000ft de primer crucero
        'deltahcruise3',61.0,... %VAR; 200ft de crucero de vuelta
        'deltahsearch',20.0... %VAR; hover & transit height 50-300ft 
        );
    
    V = struct(...
        'vtransit56',51.44... %Transit max velocity 100knots
        );
    
    Z = struct(...
        'zflour',2.0,... %use this Z to take ground effect into account
        'zhight',10000.0... %use this Z if no ground effect
        );
    
    R = struct(...
        'Rcruisemaxv123',150000.0,...%VAR
        'Rcruisemaxr378',150000.0,...%VAR
        'Ralltransit56',@(N) Rpertransit*N...
        );
    
    gammaT = 'none';
    
elseif strcmp(options.missionType,'milASWSonobuoy')
    
    %Mission segments
    %01hover1
    %12climb1
    %23travelcruise1
    %34deploycruise1 
    %45transitcruise
    %56deploycruise2
    %67travelcruise2
    %78glide1
    %89hover2
    
    Nsegments = 9;
    
    %Variable mission parameters are marked with VAR, and typical
    %values are indicated

    T = struct(...
        'thover01',36.0,...
        'thover02',36.0...
        );
    
    H = struct(...
        'hstart',0.0,...
        'deltah',31.0...
        );
    
    V = struct(...
        'vmaxdeploy',62.0... %Max deploy speed of sonobuoy @h=31m
        );
    
    Z = struct(...
        'zflour',2.0,... %use this Z to take ground effect into account
        'zhight',10000.0... %use this Z if no ground effect
        );
    
    R = struct(...
        'Rtravelcruise1',56000.0,...
        'Rdeploycruise1',50000.0,...
        'Rtransitcruise',100000.0,...
        'Rdeploycruise2',50000.0,...
        'Rtravelcruise2',56000.0...
        );
    
    gammaT = 'none';
    n = struct();
    
elseif strcmp(options.missionType,'milASWMAD')
    
    %Mission segments
    %01hover1
    %12climb1
    %23travelcruise1
    %34MADsearchcruise 
    %45travelcruise2
    %56glide1
    %67hover2
    
    Nsegments = 7;
    
    %Variable mission parameters are marked with VAR, and typical
    %values are indicated

    T = struct(...
        'thover01',36.0,...
        'thover02',36.0,...
        'tMADsearch',7200.0...
        );
    
    H = struct(...
        'hstart',0.0,...
        'deltah',100.0...
        );
    
    V = struct();
    
    Z = struct(...
        'zflour',2.0,... %use this Z to take ground effect into account
        'zhight',10000.0... %use this Z if no ground effect
        );
    
    R = struct(...
        'Rtravelcruise1',56000.0,...
        'Rtravelcruise2',56000.0...
        );
    
    gammaT = 'none';
    n = struct();
    
elseif strcmp(options.missionType,'milMEDEVAC')
    
    %Mission segments
    %01hover1
    %12climb1
    %23cruisemaxv1 
    %34glide1
    %45hover2
    %56climb2 
    %67cruisemaxv2
    %78glide2
    %89taxi
    
    Nsegments = 9;
    
    %Variable mission parameters are marked with VAR, and typical
    %values are indicated
    
    T = struct(...
        'thover01',36,...
        'thover45',900.0,... %VAR 0-25min; Rescue hover time
        'ttaxi89',72.0...
        );
    
    H = struct(...
        'hstart',600.0,...
        'deltahcruise1',1000.0,... %VAR; typical cruise1 height (inventada)
        'deltahcruise2',1000.0,... %VAR; typical cruise2 height (inventada)
        'deltahrescue',20.0... %VAR; hover & transit height 50-300ft 
        );
    
    V = struct(...
        'vtaxi89',4.0...
        );
    
    Z = struct(...
        'zflour',2.0,... %use this Z to take ground effect into account
        'zhight',10000.0... %use this Z if no ground effect
        );
    
    R = struct(...
        'Rcruisemaxv123',150000.0,...%VAR; typically 200NM max esta
        'Rcruisemaxv267',150000.0...%VAR; typically 200NM max
        );
    
    gammaT = 'none';
    n = struct();


elseif strcmp(options.missionType,'milScort')
    
    %Mission segments
    %01hover1
    %12taxi1
    %23climb1
    %34cruisemaxr1
    %45cruisemaxv2
    %56cruisemaxe3
    %67cruisemaxr4
    %78glide2
    %89taxi2
    
    Nsegments = 9;
    Nencounters = 1; %VAR Number of En-route encounters
    
    %Variable mission parameters are marked with VAR, and typical
    %values are indicated
    
    T = struct(...
        'thover01',36,...
        'ttaxi12',72.0,...
        'tcruise56',1800.0,...
        'ttaxi89',72.0...
        );
    
    H = struct(...
        'hstart',600.0,...
        'deltah',600.0... 
        );
    
    V = struct(...
        'vtaxi',4.0...
        );
    
    Z = struct(...
        'zflour',2.0,... %use this Z to take ground effect into account
        'zhight',10000.0... %use this Z if no ground effect
        );
    
    R = struct(...
        'Rcruisemaxr134',150000.0,...%VAR; typically 200NM max esta
        'Rcruisemaxv245',15000.0*Nencounters,...
        'Rcruisemaxr467',150000.0...%VAR; typically 200NM max
        );
    
    gammaT = 'none';
    n = struct();
    
elseif strcmp(options.missionType,'milTroopTransport')
    
    %Mission segments
    %01hover1
    %12taxi1
    %23climb1
    %34cruisemaxr1 
    %45cruisemaxv2
    %56glide1
    %67taxi2
    %78climb2 
    %89cruisemaxr3
    %910cruisemaxv4
    %1011glide2
    %1112taxi3
    
    Nsegments = 12;
    Nencounters1 = 1;%VAR
    Nencounters2 = 1;%VAR
    
    %Variable mission parameters are marked with VAR, and typical
    %values are indicated
    
    T = struct(...
        'thover01',36,...
        'ttaxi12',72,...
        'ttaxi67',144,...
        'ttaxi1112',72.0...
        );
    
    H = struct(...
        'hstart',600.0,...
        'deltahcruise1',400.0,... %VAR; typical cruise1 height (inventada)
        'deltahcruise2',400.0,... %VAR; typical cruise2 height (inventada)
        'deltahstop',0.0...
        );
    
    V = struct(...
        'vtaxi',4.0...
        );
    
    Z = struct(...
        'zflour',2.0,... %use this Z to take ground effect into account
        'zhight',10000.0... %use this Z if no ground effect
        );
    
    R = struct(...
        'Rcruisemaxr134',150000.0,...%VAR; typically 200NM max
        'Rcruisemaxv245',15000.0*Nencounters1,...
        'Rcruisemaxr389',150000.0,...%VAR; esta
        'Rcruisemaxv4910',15000.0*Nencounters2...
        );
    
    gammaT = 'none';
    n = struct();
    
elseif strcmp(options.missionType,'milCommand')
    
    %Mission segments
    %01hover1
    %12taxi1
    %23climb1
    %34cruisemaxr1
    %45cruisemaxe2
    %56cruisemaxr3
    %67glide2
    %78taxi2
    
    Nsegments = 8;
    
    %Variable mission parameters are marked with VAR, and typical
    %values are indicated
    
    T = struct(...
        'thover01',36,...
        'ttaxi12',72.0,...
        'tcruise45',10800.0,... %VAR esta
        'ttaxi78',72.0...
        );
    
    H = struct(...
        'hstart',600.0,...
        'deltah',1400.0... 
        );
    
    V = struct(...
        'vtaxi',4.0...
        );
    
    Z = struct(...
        'zflour',2.0,... %use this Z to take ground effect into account
        'zhight',10000.0... %use this Z if no ground effect
        );
    
    R = struct(...
        'Rcruisemaxr134',50000.0,...%VAR; 
        'Rcruisemaxr356',50000.0...%VAR;
        );
    
    gammaT = 'none';
    n = struct();
    
elseif strcmp(options.missionType,'onlyCruise')
    
    Nsegments = 1;

    
    H = struct(...
        'hstart',600.0,...
        'deltah',300.0...
        );
        

    Z = struct(... 
        'zhight',10000.0... 
        );
    
    R = struct('Rcruise',500000);%variable
    
    gammaT = 'none';
    n = struct();
    
    
else
    
    %Mission segments
    %01hover1 
    %12taxi  
    %23climb  
    %34cruise 
    %45glide
    %56taxi2
    
%    Nsegments = 6;
%     
%    T = struct(...
%         'thover01',36.0,...
%         'ttaxi12',72.0,...
%         'tcruise34',2160.0,... %variable
%         'ttaxi56',72.0...
%         );
%     
%     H = struct(...
%         'hstart',600.0,...
%         'deltah',300.0...
%         );
%         
%     V = struct(...
%         'vtaxi12',4.0,...
%         'vclimb23',20.0,...
%         'vcruise34',40.0,...
%         'vglide45',20.0...
%         );
% 
%     Z = struct(...
%         'zflour',2.0,... 
%         'zhight',10000.0... 
%         );
%     
%     R = struct();
%     
%     gammaT = struct(...
%         'gammaTclimb',deg2rad(+10),... 
%         'gammaTglide',deg2rad(-10)... 
%         );
%     
%     n = struct();

Nsegments = 1;
    
    T = struct(...
        'tcruise34',3600.0...
        );
    
    H = struct(...
        'hstart',900.0...
        );
        
    V = struct(...
        'vcruise34',40.0...
        );

    Z = struct(...
        'zhight',10000.0... 
        );
    
    R = struct();
    
    gammaT = struct();
    
    n = struct();
    
end

MissionParameters = struct(...
    'Nsegments',Nsegments,...
    'T',T,...
    'gammaT',gammaT,...
    'H',H,...
    'Z',Z,...
    'V',V,...
    'R',R,...
    'n',n...
    );


end
