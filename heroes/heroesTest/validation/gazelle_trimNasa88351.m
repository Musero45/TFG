function io = gazelle_trimNasa88351(mode)
%% Helicopter Trim and Performance. 
% Comparison between Heroes solution for trim and flight test.
% Flight test data from nasa-tm-88351 for 7 flight conditions (pag. 17), digitize
% from pag. 26-27.

close all
clear all
setPlot;

atm           = getISA;
he            = rigidGazelle(atm);

options       = setHeroesRigidOptions;


% % Various operating conditions were included in the orignal flight
% % test envelope: ( 1 ) hover out-of-ground-effect; (2) level flights at
% % 305 m, 1524 m, and 3048 m ( 1000 ft, 5000 ft, and 10000 ft) with speeds
% % from 100 km/hr to 300 km/hr; (3) steady turns at 305 m, 1524 m, and
% % 3048 m (1000 ft, 5000 ft, and 10000 ft) corresponding to a range of load
% % factor from 1.4 to 2.0; (4) autorotation at 200 km/hr; and (5) high
% % speed dive at 350 km/hr.

zvars     ={'Theta','theta0','theta1C','theta1S'};       

%% Condition 1: 

[FC,muWT,h,he,mu]=gazelle_fc1Nasa88351(he);
ndHe           = rigidHe2ndHe(he,atm,h);

% To compute the nondimensional trim state just use the function 
% getNdHeTrimState.
ndts          = getNdHeTrimState(ndHe,muWT,FC,options);
% % save ndtsCOND1
% % load ('ndtsCOND1')

for i= 1:4;
TrimState.(zvars{i})(1,1) = ndts.solution.(zvars{i});
end

% This function is used to get the power of the helicopter in order to
% comare it with the test fligt data from Padfield. 
ts   = ndHeTrimState2HeTrimState(ndts,he,atm,h,options);
TrimState.PMpower(1,1) = ts.Pow.PM;
TrimState.VOR(1,1) = mu;

%% Condition 2: 

[FC,muWT,h,he,mu]=gazelle_fc2Nasa88351(he);
ndHe           = rigidHe2ndHe(he,atm,h);

% To compute the nondimensional trim state just use the function 
% getNdHeTrimState.
ndts          = getNdHeTrimState(ndHe,muWT,FC,options);
% % save ndtsCOND2
% % load ('ndtsCOND2')

for i= 1:4;
TrimState.(zvars{i})(2,1) = ndts.solution.(zvars{i});
end

% This function is used to get the power of the helicopter in order to
% comare it with the test fligt data from Padfield. 
ts   = ndHeTrimState2HeTrimState(ndts,he,atm,h,options);
TrimState.PMpower(2,1) = ts.Pow.PM;
TrimState.VOR(2,1) = mu;

%% Condition 3: 

[FC,muWT,h,he,mu]=gazelle_fc3Nasa88351(he);
ndHe           = rigidHe2ndHe(he,atm,h);

% To compute the nondimensional trim state just use the function 
% getNdHeTrimState.
ndts          = getNdHeTrimState(ndHe,muWT,FC,options);
% % save ndtsCOND3
% % load ('ndtsCOND3')

for i= 1:4;
TrimState.(zvars{i})(3,1) = ndts.solution.(zvars{i});
end

% This function is used to get the power of the helicopter in order to
% comare it with the test fligt data from Padfield. 
ts   = ndHeTrimState2HeTrimState(ndts,he,atm,h,options);
TrimState.PMpower(3,1) = ts.Pow.PM;
TrimState.VOR(3,1) = mu;

%% Condition 4: 

[FC,muWT,h,he,mu]=gazelle_fc4Nasa88351(he);
ndHe           = rigidHe2ndHe(he,atm,h);

% To compute the nondimensional trim state just use the function 
% getNdHeTrimState.
ndts          = getNdHeTrimState(ndHe,muWT,FC,options);
% % save ndtsCOND4
% % load ('ndtsCOND4')

for i= 1:4;
TrimState.(zvars{i})(4,1) = ndts.solution.(zvars{i});
end

% This function is used to get the power of the helicopter in order to
% comare it with the test fligt data from Padfield. 
ts   = ndHeTrimState2HeTrimState(ndts,he,atm,h,options);
TrimState.PMpower(4,1) = ts.Pow.PM;
TrimState.VOR(4,1) = mu;

%% Condition 5: 

[FC,muWT,h,he,mu]=gazelle_fc5Nasa88351(he);
ndHe           = rigidHe2ndHe(he,atm,h);

% To compute the nondimensional trim state just use the function 
% getNdHeTrimState.
ndts          = getNdHeTrimState(ndHe,muWT,FC,options);
% % save ndtsCOND5
% % load ('ndtsCOND5')

for i= 1:4;
TrimState.(zvars{i})(5,1) = ndts.solution.(zvars{i});
end

% This function is used to get the power of the helicopter in order to
% comare it with the test fligt data from Padfield. 
ts   = ndHeTrimState2HeTrimState(ndts,he,atm,h,options);
TrimState.PMpower(5,1) = ts.Pow.PM;
TrimState.VOR(5,1) = mu;

%% Condition 6: 

[FC,muWT,h,he,mu]=gazelle_fc6Nasa88351(he);
ndHe           = rigidHe2ndHe(he,atm,h);

% To compute the nondimensional trim state just use the function 
% getNdHeTrimState.
ndts          = getNdHeTrimState(ndHe,muWT,FC,options);
% % save ndtsCOND6
% % load ('ndtsCOND6')

for i= 1:4;
TrimState.(zvars{i})(6,1) = ndts.solution.(zvars{i});
end

% This function is used to get the power of the helicopter in order to
% comare it with the test fligt data from Padfield. 
ts   = ndHeTrimState2HeTrimState(ndts,he,atm,h,options);
TrimState.PMpower(6,1) = ts.Pow.PM;
TrimState.VOR(6,1) = mu;

%% Condition 7: 

[FC,muWT,h,he,mu]=gazelle_fc7Nasa88351(he);
ndHe           = rigidHe2ndHe(he,atm,h);

% To compute the nondimensional trim state just use the function 
% getNdHeTrimState.
ndts          = getNdHeTrimState(ndHe,muWT,FC,options);
% % save ndtsCOND7
% % load ('ndtsCOND7')

for i= 1:4;
TrimState.(zvars{i})(7,1) = ndts.solution.(zvars{i});
end

% This function is used to get the power of the helicopter in order to
% comare it with the test fligt data from Padfield. 
ts   = ndHeTrimState2HeTrimState(ndts,he,atm,h,options);
TrimState.PMpower(7,1) = ts.Pow.PM;
TrimState.VOR(7,1) = mu;

%% Graphics

W2hp = 0.00134102;

axds          = getaxds({'VOR'},{'$$V/(\Omega R)$$ [-]'},1);


zvarsTS     ={'Theta','theta0','theta1C','theta1S','PMpower'};       
trimlabels  ={'$$\Theta [^o]$$','$$\theta_{0} [^o]$$','$$\theta_{1C} [^o]$$',...
                 '$$\theta_{1S} [^o]$$','$$P_M [hp]$$'};
scalefactor =[180/pi,180/pi,180/pi,180/pi,W2hp];  


leg = {'Condition1','Condition2','Condition3','Condition4',...
           'Condition5','Condition6','Condition7'};

mark = {'<','d','v','>','o','s','^'};


FCpdf_i = {ThetaGazelleNasa88351,...
           Theta0GazelleNasa88351,...
           Theta1CGazelleNasa88351,...        
           Theta1SGazelleNasa88351,...
           PowerGazelleNasa88351};  % digitize flight test data. 

for i=1:5;
    
    for j=1:7;
box on        
figure(i);
hold on
 X2 = FCpdf_i{i}.VOR(j,1);  
 Y2 = FCpdf_i{i}.(zvarsTS{i})(j,1)*scalefactor(i);
   p = plot(X2,Y2,...
       'LineStyle','none',...
       'Marker',mark{j},...
       'MarkerEdgeColor','k',...
       'MarkerFaceColor','w',...
       'MarkerSize',8);
 xlabel('$$V/(\Omega R)$$ [-]','FontAngle','italic');
 ylabel(trimlabels{i},'FontAngle','italic');
    end
   l=legend('FC1','FC2','FC3','FC4','FC5','FC6','FC7');
   
    for j=1:7;
 X1 = TrimState.VOR(j,1);
 Y1 = TrimState.(zvarsTS{i})(j,1)*scalefactor(i); 
   h = plot(X1,Y1,...
       'LineStyle','none',...
       'Marker',mark{j},...
       'MarkerEdgeColor','k',...
       'MarkerFaceColor','k',...
       'MarkerSize',8);
 xlabel('$$V/(\Omega R) [-]$$','FontAngle','italic');
 ylabel(trimlabels{i},'FontAngle','italic');
    end
 set(l,'Location','Best') ; 
       
end    


% pictures = {'picFCTheta','picFCtheta0',...
%             'picFCtheta1C','picFCtheta1S',...
%             'picFCPMpower'};
%                               
% for i=1:5;    
% p=figure(i);    
% saveas(p,pictures{i},'epsc');
% end

 io = 1;