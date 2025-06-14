function sS = getPadfieldLinearStabilityState(rigidheStr,varargin)
%getPadfieldLinearStabilityState  Gets stability and control derivatives 
%                                 of Bo105, Lynx and Puma rigid 
%                                 helicopters according to results 
%                                 published in [1]
%
%   SS = getPadfieldLinearStabilityState(S) gets the nondimensional 
%   stability and control derivatives of a rigid helicopter defined 
%   by the string S. Valid values of string S are the following ones: 
%   'Bo105', 'Lynx', 'Puma', 'Bo105D', 'LynxD', 'PumaD'. The first 
%   third helicopters, 'Bo105', 'Lynx', 'Puma' corresponds to 
%   interpolated data from the graphical information shown in [1]
%    while 'Bo105D', 'LynxD', 'PumaD' stands for the discrete 
%   digitalise information from the graphical information shown in [1].
%   
%
%   SS = getPadfieldLinearStabilityState(S,OPTIONS) gets 
%
%
%   Authors: Sergio Esteban, Nano Rubio
%
%   [1] G.D. Padfield Helicopter Flight Dynamics 1996
%
%   Example of usage:
%
%   Plot the non dimensional stability and control derivatives of 
%   Bo105, Lynx and Puma. Equivalent to 
%   ss{1} = getPadfieldLinearStabilityState('Bo105');
%   ss{2} = getPadfieldLinearStabilityState('Lynx');
%   ss{3} = getPadfieldLinearStabilityState('Puma');
%   plotStabilityDerivatives(ss,{'Bo105','Lynx','Puma'},{});
%   plotControlDerivatives(ss,{'Bo105','Lynx','Puma'},{});
%
%   Just plot the actual figures from [1], pages 269-275:
%   ss{1} = getPadfieldLinearStabilityState('Bo105D','nondimensional','no');
%   ss{2} = getPadfieldLinearStabilityState('LynxD','nondimensional','no');
%   ss{3} = getPadfieldLinearStabilityState('PumaD','nondimensional','no');
%   plotStabilityDerivatives(ss,{'Bo105','Lynx','Puma'},{});
%   plotControlDerivatives(ss,{'Bo105','Lynx','Puma'},{});
%
%   See also
%
%   TODO:
%   - Modify y labels to account for the dimensional stability and control
%   derivatives




if strcmp(rigidheStr,'Bo105')
    O   = 44.4;
    R   = 4.91;
    OR  = O*R;
    RO  = O/R;
    O2  = O*O;
    O2R = O2*R;
elseif strcmp(rigidheStr,'Puma')
    O    = 27;
    R    = 7.5;
    OR   = O*R;
    RO   = O/R;
    O2   = O*O;
    O2R  = O2*R;
elseif strcmp(rigidheStr,'Lynx')
    O    = 35.63;
    R    = 6.4;
    OR   = O*R;
    RO   = O/R;
    O2   = O*O;
    O2R  = O2*R;
elseif strcmp(rigidheStr,'Bo105D')
    O   = 44.4;
    R   = 4.91;
    OR  = O*R;
    RO  = O/R;
    O2  = O*O;
    O2R = O2*R;
elseif strcmp(rigidheStr,'PumaD')
    O    = 27;
    R    = 7.5;
    OR   = O*R;
    RO   = O/R;
    O2   = O*O;
    O2R  = O2*R;
elseif strcmp(rigidheStr,'LynxD')
    O    = 35.63;
    R    = 6.4;
    OR   = O*R;
    RO   = O/R;
    O2   = O*O;
    O2R  = O2*R;
else
    error('getPadfieldLinearStabilityState:helicopterModelChk', 'Wrong helicopter model. Check input argument spell (Bo105, Puma, Lynx)')
end


options    = parseOptions(varargin,@setPadfieldLinearStabilityStateOptions);

% Forward speed in knots
V=[0 20 40 60 80 100 120 140];
mux = V./OR;
% velocidad
V_interp = 0:1:140;
mux_interp = V_interp./OR;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LONGITUDINAL STABILITY DERIVATIVES - FIG 4B.7
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LONGITUDINAL U-DERIVATIVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Xu ESTIMATION
% DATA FROM THE CHART
Xu_1=[1.85 0.75 1.3 2.25 2.9 3.55 4.2 4.8];
Xu_2=[1.65 1.35 1.55 1.9 2.2 2.45 2.75 3];
Xu_3=[1.9 1.35 1.75 2.35 2.9 3.52 4 4.45];

% estimation paramters
maxyXu=0; % max valkue in the y-axis
minyXu=-0.06; % min valu in the x-axis
k1= minyXu - maxyXu; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyXu; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Xu1=Xu_1*m + b;
Xu2=Xu_2*m + b;
Xu3=Xu_3*m + b;

% interpolation of the longitudinal estability derivatives
Xu1_interp = spline(V,Xu1,V_interp);
Xu2_interp = spline(V,Xu2,V_interp);
Xu3_interp = spline(V,Xu3,V_interp);

% Zu ESTIMATION
% DATA FROM THE CHART
Zu_1=[0.5 4.1 3.1 1.75 1.05 0.75 0.5 0.4];
Zu_2=[1.05 4.55 3.5 2.3 1.75 1.45 1.4 1.25];
Zu_3=[0.75 4.6 3.45 2.2 1.7 1.45 1.4 1.45];

% estimation paramters
maxyZu=0.05; % max valkue in the y-axis
minyZu=-0.25; % min valu in the x-axis
k1= minyZu - maxyZu; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyZu; % offset of the line
b=maxyZu; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Zu1=Zu_1*m + b;
Zu2=Zu_2*m + b;
Zu3=Zu_3*m + b;

% interpolation of the longitudinal estability derivatives
Zu1_interp = spline(V,Zu1,V_interp);
Zu2_interp = spline(V,Zu2,V_interp);
Zu3_interp = spline(V,Zu3,V_interp);

% Mu ESTIMATION
% DATA FROM THE CHART
Mu_1=[3.4 3.6 4.1 4.225 4.275 4.25 4.15 4];
Mu_2=[0.8 2.7 3.8 4.05 4.15 4.2 4.15 4];
Mu_3=[5 5.15 5.15 5.15 5.15 5.15 5.15 5.15];

% estimation paramters
maxyMu=0.12; % max valkue in the y-axis
minyMu=0; % min valu in the x-axis
k1= minyMu - maxyMu; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyMu; % offset of the line
b=maxyMu; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Mu1=Mu_1*m + b;
Mu2=Mu_2*m + b;
Mu3=Mu_3*m + b;

% interpolation of the longitudinal estability derivatives
Mu1_interp = spline(V,Mu1,V_interp);
Mu2_interp = spline(V,Mu2,V_interp);
Mu3_interp = spline(V,Mu3,V_interp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LONGITUDINAL W-DERIVATIVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Xw ESTIMATION
% DATA FROM THE CHART
Xw_1=[2.65 2.35 1.725 1.4 1.35 1.375 1.475 1.55];
Xw_2=[3.5 3.45 3.4 3.5 3.7 3.85 3.9 3.825];
Xw_3=[3.4 3.7 3.7 3.9 4.45 5 5 4.275];

% estimation paramters
maxyXw=0.06; % max valkwe in the y-axis
minyXw=-0.02; % min valu in the x-axis
k1= minyXw - maxyXw; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyXw; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Xw1=Xw_1*m + b;
Xw2=Xw_2*m + b;
Xw3=Xw_3*m + b;

% interpolation of the longitudinal estability derivatives
Xw1_interp = spline(V,Xw1,V_interp);
Xw2_interp = spline(V,Xw2,V_interp);
Xw3_interp = spline(V,Xw3,V_interp);

% Zw ESTIMATION
% DATA FROM THE CHART
Zw_1=[0.8 1.6 2.85 3.65 4.15 4.5 4.8 5.1];
Zw_2=[0.8 1.75 3.05 3.85 4.35 4.7 4.95 5.25];
Zw_3=[0.8 1.75 3.05 3.85 4.35 4.7 4.95 5.25];

% estimation paramters
maxyZw=-0.2; % max valkue in the y-axis
minyZw=-1; % min valu in the x-axis
k1= minyZw - maxyZw; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=minyZw; % offset of the line
b=maxyZw; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Zw1=Zw_1*m + b;
Zw2=Zw_2*m + b;
Zw3=Zw_3*m + b;

% interpolation of the longitudinal estability derivatives
Zw1_interp = spline(V,Zw1,V_interp);
Zw2_interp = spline(V,Zw2,V_interp);
Zw3_interp = spline(V,Zw3,V_interp);

% Mw ESTIMATION
% DATA FROM THE CHART
Mw_1=[3 2.45 2.15 1.95 1.7 1.45 1.225 0.95];
Mw_2=[3.6 3.8 4.1 4.3 4.5 4.7 4.9 5.1];
Mw_3=[4.15 2.65 2.6 2.5 2.25 1.85 1.225 0.55];

% estimation paramters
maxyMw=0.06; % max valkue in the y-axis
minyMw=-0.04; % min valu in the x-axis
k1= minyMw - maxyMw; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=minyMw; % offset of the line
b=maxyMw; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Mw1=Mw_1*m + b;
Mw2=Mw_2*m + b;
Mw3=Mw_3*m + b;

% interpolation of the longitudinal estability derivatives
Mw1_interp = spline(V,Mw1,V_interp);
Mw2_interp = spline(V,Mw2,V_interp);
Mw3_interp = spline(V,Mw3,V_interp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LONGITUDINAL Q-DERIVATIVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Xq ESTIMATION
% DATA FROM THE CHART
Xq_1=[4.25 4.6 4.8 4.85 4.65 4.15 3.25 2.15] ;
Xq_2=[4.25 4.4 4.5 4.4 4.2 3.9 3.35 2.75];
Xq_3=[4.25 4.4 4.5 4.3 3.9 3.1 2 0.45];

% estimation paramters
maxyXq=10; % max valkue in the y-axis
minyXq=-2; % min valu in the x-axis
k1= minyXq - maxyXq; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyXq; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Xq1=Xq_1*m + b;
Xq2=Xq_2*m + b;
Xq3=Xq_3*m + b;

% interpolation of the longitudinal estability derivatives
Xq1_interp = spline(V,Xq1,V_interp);
Xq2_interp = spline(V,Xq2,V_interp);
Xq3_interp = spline(V,Xq3,V_interp);

% Zq ESTIMATION
% DATA FROM THE CHART
Zq_1=[4.4000 3.8429 3.2857 2.7286 2.1714 1.6143 1.0571 0.5000];
Zq_2=[4.4000 3.8429 3.2857 2.7286 2.1714 1.6143 1.0571 0.5000];
Zq_3=[4.4000 3.8429 3.2857 2.7286 2.1714 1.6143 1.0571 0.5000];

% estimation paramters
maxyZq=80; % max valkqe in the y-axis
minyZq=-20; % min valu in the x-axis
k1= minyZq - maxyZq; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=minyZq; % offset of the line
b=maxyZq; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Zq1=Zq_1*m + b;
Zq2=Zq_2*m + b;
Zq3=Zq_3*m + b;

% interpolation of the longitudinal estability derivatives
Zq1_interp = spline(V,Zq1,V_interp);
Zq2_interp = spline(V,Zq2,V_interp);
Zq3_interp = spline(V,Zq3,V_interp);

% Mq ESTIMATION
% DATA FROM THE CHART
Mq_1=[2.05 2.1857 2.3214 2.4571 2.5929 2.7286 2.8643 3.0000];
Mq_2=[ 0.5000 0.5786 0.6571 0.7357 0.8143 0.8929 0.9714 1.0500];
Mq_3=[4.1500 4.1857 4.2214 4.3357 4.4643 4.5929 4.7214 4.8500];

% estimation paramters
maxyMq=0; % max valkue in the y-axis
minyMq=-5; % min valu in the x-axis
k1= minyMq - maxyMq; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=minyMq; % offset of the line
b=maxyMq; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Mq1=Mq_1*m + b;
Mq2=Mq_2*m + b;
Mq3=Mq_3*m + b;

% interpolation of the longitudinal estability derivatives
Mq1_interp = spline(V,Mq1,V_interp);
Mq2_interp = spline(V,Mq2,V_interp);
Mq3_interp = spline(V,Mq3,V_interp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LATERAL STABILITY DERIVATIVES - FIG 4B.8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LATERAL V-DERIVATIVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Yv ESTIMATION
% DATA FROM THE CHART
Yv_1=[0.65 1.0714 1.6429 2.2143 2.7857 3.3571 3.9286 4.5000];
Yv_2=[0.6500 1.0929 1.5357 1.9786 2.4214 2.8643 3.3071 3.7500];
Yv_3=[0.6500 1.0571 1.4643 1.8714 2.2786 2.6857 3.0929 3.5000];

% estimation paramters
maxyYv=0; % max valkue in the y-axis
minyYv=-0.3; % min valu in the x-axis
k1= minyYv - maxyYv; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyYv; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Yv1=Yv_1*m + b;
Yv2=Yv_2*m + b;
Yv3=Yv_3*m + b;

% interpolation of the longitudinal estability derivatives
Yv1_interp = spline(V,Yv1,V_interp);
Yv2_interp = spline(V,Yv2,V_interp);
Yv3_interp = spline(V,Yv3,V_interp);

% Lv ESTIMATION
% DATA FROM THE CHART
Lv_1=[2.95 2.65 2.15 1.9 1.8 1.9 2 2.3];
Lv_2=[0.7000 0.7143 0.7286 0.7429 0.7571 0.7714 0.7857 0.8000];
Lv_3=[4.5 4.05 3.35 3.1 3.1 3.25 3.45 3.8];

% estimation paramters
maxyLv=0.05; % max valkue in the y-axis
minyLv=-0.25; % min valu in the x-axis
k1= minyLv - maxyLv; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyLv; % offset of the line
b=maxyLv; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Lv1=Lv_1*m + b;
Lv2=Lv_2*m + b;
Lv3=Lv_3*m + b;

% interpolation of the longitudinal estability derivatives
Lv1_interp = spline(V,Lv1,V_interp);
Lv2_interp = spline(V,Lv2,V_interp);
Lv3_interp = spline(V,Lv3,V_interp);

% Nv ESTIMATION
% DATA FROM THE CHART
Nv_1=[4.6 4.2 3.6 3.2 2.9 2.7 2.55 2.5];
Nv_2=[3.7 3.65 3.6 3.6 3.7 3.8 4 4.25];
Nv_3=[4.6 3.95 2.85 2.1 1.6 1.2 0.9 0.55];

% estimation paramters
maxyNv=0.12; % max valkue in the y-axis
minyNv=0; % min valu in the x-axis
k1= minyNv - maxyNv; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyNv; % offset of the line
b=maxyNv; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Nv1=Nv_1*m + b;
Nv2=Nv_2*m + b;
Nv3=Nv_3*m + b;

% interpolation of the longitudinal estability derivatives
Nv1_interp = spline(V,Nv1,V_interp);
Nv2_interp = spline(V,Nv2,V_interp);
Nv3_interp = spline(V,Nv3,V_interp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LATERAL p-DERIVATIVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Yp ESTIMATION
% DATA FROM THE CHART
Yp_1=[1.25 0.9 0.65 0.6 0.8 1.35 2.15 3.3 ];
Yp_2=[1.25 1.1 1.05 1.05 1.2 1.55 2.05 2.65];
Yp_3=[1.25 1.1 1.05 1.25 1.65 2.45 3.55 5.1];

% estimation paramters
maxyYp=2; % max valkue in the y-axis
minyYp=-10; % min valu in the x-axis
k1= minyYp - maxyYp; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyYp; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Yp1=Yp_1*m + b;
Yp2=Yp_2*m + b;
Yp3=Yp_3*m + b;

% interpolation of the longitudinal estability derivatives
Yp1_interp = spline(V,Yp1,V_interp);
Yp2_interp = spline(V,Yp2,V_interp);
Yp3_interp = spline(V,Yp3,V_interp);

% Lp ESTIMATION
% DATA FROM THE CHART
Lp_1=[4.0500 4.0000 3.9500 3.9000 3.8500 3.8000 3.7500 3.7000];
Lp_2=[0.6500 0.6429 0.6357 0.6286 0.6214 0.6143 0.6071 0.6000];
Lp_3=[5.2000 5.1429 5.0857 5.0286 4.9714 4.9143 4.8571 4.8000];

% estimation paramters
maxyLp=0; % max valkue in the y-axis
minyLp=-15; % min valu in the x-axis
k1= minyLp - maxyLp; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyLp; % offset of the line
b=maxyLp; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Lp1=Lp_1*m + b;
Lp2=Lp_2*m + b;
Lp3=Lp_3*m + b;

% interpolation of the longitudinal estability derivatives
Lp1_interp = spline(V,Lp1,V_interp);
Lp2_interp = spline(V,Lp2,V_interp);
Lp3_interp = spline(V,Lp3,V_interp);

% Np ESTIMATION
% DATA FROM THE CHART
Np_1=[4.0000 3.9571 3.9143 3.8714 3.8286 3.7857 3.7429 3.7000];
Np_2=[0.8500 0.8571 0.8643 0.8714 0.8786 0.8857 0.8929 0.9000];
Np_3=[4.6500 4.5500 4.4500 4.3500 4.2500 4.1500 4.0500 3.9500];

% estimation paramters
maxyNp=1; % max valkue in the y-axis
minyNp=-3; % min valu in the x-axis
k1= minyNp - maxyNp; % calculation of the total lenght of the y-axis 
k2=5.4; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyNp; % offset of the line
b=maxyNp; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Np1=Np_1*m + b;
Np2=Np_2*m + b;
Np3=Np_3*m + b;

% interpolation of the longitudinal estability derivatives
Np1_interp = spline(V,Np1,V_interp);
Np2_interp = spline(V,Np2,V_interp);
Np3_interp = spline(V,Np3,V_interp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LATERAL R-DERIVATIVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Yr ESTIMATION
% DATA FROM THE CHART
Yr_1=[1.1000 1.6571 2.2143 2.7714 3.3286 3.8857 4.4429 5.0000];
Yr_2=[1.1000 1.6571 2.2143 2.7714 3.3286 3.8857 4.4429 5.0000];
Yr_3=[1.1000 1.6571 2.2143 2.7714 3.3286 3.8857 4.4429 5.0000];

% estimation paramters
maxyYr=20; % max valkue in the y-axis
minyYr=-80; % min valu in the x-axis
k1= minyYr - maxyYr; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyYr; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Yr1=Yr_1*m + b;
Yr2=Yr_2*m + b;
Yr3=Yr_3*m + b;

% interpolation of the longitudinal estability derivatives
Yr1_interp = spline(V,Yr1,V_interp);
Yr2_interp = spline(V,Yr2,V_interp);
Yr3_interp = spline(V,Yr3,V_interp);

% Lr ESTIMATION
% DATA FROM THE CHART
Lr_1=[2.8 3.1 3.35 3.65 3.9 4.2 4.45 4.7];
Lr_2=[2 1.85 1.55 1.35 1.2 1.1 1.075 1.05];
Lr_3=[2.2 2 1.6 1.35 1.2 0.95 0.9 0.8];

% estimation paramters
maxyLr=0.6; % max valkue in the y-axis
minyLr=-0.6; % min valu in the x-axis
k1= minyLr - maxyLr; % calculation of the total lenght of the y-axis 
k2=5.45; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyLr; % offset of the line
b=maxyLr; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Lr1=Lr_1*m + b;
Lr2=Lr_2*m + b;
Lr3=Lr_3*m + b;

% interpolation of the longitudinal estability derivatives
Lr1_interp = spline(V,Lr1,V_interp);
Lr2_interp = spline(V,Lr2,V_interp);
Lr3_interp = spline(V,Lr3,V_interp);

% Nr ESTIMATION
% DATA FROM THE CHART
Nr_1=[0.7 1.2 1.85 2.4 2.9 3.3 3.7 4.1];
Nr_2=[0.7 0.9 1.3 1.55 1.65 1.75 1.75 1.75];
Nr_3=[0.9 1.35 2.1 2.65 3.15 3.5 3.85 4.2];

% estimation paramters
maxyNr=0; % max valkue in the y-axis
minyNr=-2; % min valu in the x-axis
k1= minyNr - maxyNr; % calculation of the total lenght of the y-axis 
k2=5.4; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyNr; % offset of the line
b=maxyNr; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Nr1=Nr_1*m + b;
Nr2=Nr_2*m + b;
Nr3=Nr_3*m + b;

% interpolation of the longitudinal estability derivatives
Nr1_interp = spline(V,Nr1,V_interp);
Nr2_interp = spline(V,Nr2,V_interp);
Nr3_interp = spline(V,Nr3,V_interp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LATERAL INTO LONGITUDINAL STABILITY DERIVATIVES - FIG 4B.9
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LATERAL INTO LONGITUDINAL V-DERIVATIVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Xv ESTIMATION
% DATA FROM THE CHART
Xv_1=[4.15 3.8 3.3 3.05 2.85 2.8 2.75 2.7];
Xv_2=[0.75 1.15 1.75 2.1 2.25 2.325 2.35 2.4];
Xv_3=[3.9 3.6 3.15 2.9 2.75 2.7 2.65 2.6];

% estimation paramters
maxyXv=0.04; % max valkue in the y-axis
minyXv=-0.04; % min valu in the x-axis
k1= minyXv - maxyXv; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyXv; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Xv1=Xv_1*m + b;
Xv2=Xv_2*m + b;
Xv3=Xv_3*m + b;

% interpolation of the longitudinal estability derivatives
Xv1_interp = spline(V,Xv1,V_interp);
Xv2_interp = spline(V,Xv2,V_interp);
Xv3_interp = spline(V,Xv3,V_interp);

% Zv ESTIMATION
% DATA FROM THE CHART
Zv_1=[3.45 4.1 4.3 4.3 4.35 4.4 4.6 4.8];
Zv_2=[2.95 2.2 2 1.9 1.8 1.65 1.4 1.15];
Zv_3=[3.25 4 4.1 4 3.95 3.95 4 4.1];

% estimation paramters
maxyZv=0.06; % max valkue in the y-axis
minyZv=-0.04; % min valu in the x-axis
k1= minyZv - maxyZv; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyZv; % offset of the line
b=maxyZv; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Zv1=Zv_1*m + b;
Zv2=Zv_2*m + b;
Zv3=Zv_3*m + b;

% interpolation of the longitudinal estability derivatives
Zv1_interp = spline(V,Zv1,V_interp);
Zv2_interp = spline(V,Zv2,V_interp);
Zv3_interp = spline(V,Zv3,V_interp);

% Mv ESTIMATION
% DATA FROM THE CHART
Mv_1=[1.6 2.1 2.85 3.3 3.6 3.65 3.7 3.8];
Mv_2=[4.7 4.55 4.35 4.2 4.15 4.1 4.125 4.1];
Mv_3=[0.4 1.3 2.8 3.55 3.9 4.1 4.25 4.35];

% estimation paramters
maxyMv=0.1; % max valkue in the y-axis
minyMv=-0.04; % min valu in the x-axis
k1= minyMv - maxyMv; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyMv; % offset of the line
b=maxyMv; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Mv1=Mv_1*m + b;
Mv2=Mv_2*m + b;
Mv3=Mv_3*m + b;

% interpolation of the longitudinal estability derivatives
Mv1_interp = spline(V,Mv1,V_interp);
Mv2_interp = spline(V,Mv2,V_interp);
Mv3_interp = spline(V,Mv3,V_interp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LATERAL INTO LONGITUDINAL R-DERIVATIVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Xr ESTIMATION
% DATA FROM THE CHART
Xr_1=[1.3625 1.3625 1.3625 1.3625 1.3625 4.4 1.3625 1.3625];
Xr_2=[1.3625 1.3625 0.8 1.3625 1.3625 1.3625 3.05 3.6];
Xr_3=[1.3625 1.3625 1.3625 1.3625 1.3625 1.3625 1.3625 1.3625];

% estimation paramters
maxyXr=1E6; % max valkue in the y-axis
minyXr=-3E6; % min valu in the x-axis
k1= minyXr - maxyXr; % calculation of the total lenght of the y-axis 
k2=5.45; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyXr; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Xr1=Xr_1*m + b;
Xr2=Xr_2*m + b;
Xr3=Xr_3*m + b;

% interpolation of the longitudinal estability derivatives
Xr1_interp = interp1(V,Xr1,V_interp);
Xr2_interp = interp1(V,Xr2,V_interp);
Xr3_interp = interp1(V,Xr3,V_interp);

% Zr ESTIMATION
% DATA FROM THE CHART
Zr_1=[3.65 3.65 3.65 3.65 3.65 1.975 3.65 3.65];
Zr_2=[3.65 3.65 4.9 3.65 3.65 3.65 0.65 1.25];
Zr_3=[3.65 3.65 3.65 3.65 3.65 3.65 3.65 3.65];

% estimation paramters
maxyZr=0.04E3; % max valkue in the y-axis
minyZr=-0.02E3; % min valu in the x-axis
k1= minyZr - maxyZr; % calculation of the total lenght of the y-axis 
k2=5.475; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyZr; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Zr1=Zr_1*m + b;
Zr2=Zr_2*m + b;
Zr3=Zr_3*m + b;

% interpolation of the longitudinal estability derivatives
Zr1_interp = interp1(V,Zr1,V_interp);
Zr2_interp = interp1(V,Zr2,V_interp);
Zr3_interp = interp1(V,Zr3,V_interp);

% Mr ESTIMATION
% DATA FROM THE CHART
Mr_1=[4.5833 4.5833 4.5833 4.5833 4.5833 1.85 4.5833 4.5833];
Mr_2=[4.5833 4.5833 5.25 4.5833 4.5833 4.5833 2 0.7];
Mr_3=[4.5833 4.5833 4.5833 4.5833 4.5833 4.5833 4.5833 4.5833];

% estimation paramters
maxyMr=1E6; % max valkue in the y-axis
minyMr=-0.2E6; % min valu in the x-axis
k1= minyMr - maxyMr; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyMr; % offset of the line
b=maxyMr; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
%Mr1=Mr_1*m + b;
Mr1=[0 0 0 0 0 5.9636E5 0 0];
%Mr2=Mr_2*m + b;
Mr2=[0 0 -1.4545E5 0 0 0 5.6364E5 8.4727E5];
%Mr3=Mr_3*m + b;
Mr3=[0 0 0 0 0 0 0 0];

% interpolation of the longitudinal estability derivatives
Mr1_interp = interp1(V,Mr1,V_interp);
Mr2_interp = interp1(V,Mr2,V_interp);
Mr3_interp = interp1(V,Mr3,V_interp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LATERAL INTO LONGITUDINAL P-DERIVATIVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Xp ESTIMATION
% DATA FROM THE CHART
Xp_1=[5.2000 5.1214 5.0429 4.9 4.82 4.8071 4.7286 4.6500];
Xp_2=[1.4 1.5 1.6857 1.7286 1.7714 1.8143 1.8571 1.9000];
Xp_3=[4.0000 3.9643 3.9286 3.8 3.75 3.75 3.7857 3.7500];

% estimation paramters
maxyXp=0.06; % max valkue in the y-axis
minyXp=-0.02; % min valu in the x-axis
k1= minyXp - maxyXp; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyXp; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Xp1=Xp_1*m + b;
Xp2=Xp_2*m + b;
Xp3=Xp_3*m + b;

% interpolation of the longitudinal estability derivatives
Xp1_interp = spline(V,Xp1,V_interp);
Xp2_interp = spline(V,Xp2,V_interp);
Xp3_interp = spline(V,Xp3,V_interp);

% Zp ESTIMATION
% DATA FROM THE CHART
Zp_1=[3.2700 3.4993 3.7286 3.975 4.3 4.575 4.875 5.2000];
Zp_2=[3.2700 2.95 2.7 2.3 1.95 1.55 1.1 0.7000];
Zp_3=[3.2700 3.4993 3.7286 3.9579 4.15 4.4164 4.6457 4.8750];

% estimation paramters
maxyZp=1.5; % max valkue in the y-axis
minyZp=-1; % min valu in the x-axis
k1= minyZp - maxyZp; % calculation of the total lenght of the y-axis 
k2=5.45; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyZp; % offset of the line
b=maxyZp; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Zp1=Zp_1*m + b;
Zp2=Zp_2*m + b;
Zp3=Zp_3*m + b;

% interpolation of the longitudinal estability derivatives
Zp1_interp = spline(V,Zp1,V_interp);
Zp2_interp = spline(V,Zp2,V_interp);
Zp3_interp = spline(V,Zp3,V_interp);

% Mp ESTIMATION
% DATA FROM THE CHART
Mp_1=[0.8 0.9 1 1.1 1.1 1 0.95 0.925];
Mp_2=[4.75 4.7 4.6 4.55 4.55 4.55 4.55 4.55];
Mp_3=[3.9 4.1 4.4 4.55 4.55 4.55 4.55 4.55];

% estimation paramters
maxyMp=0.6; % max valkue in the y-axis
minyMp=-0.4; % min valu in the x-axis
k1= minyMp - maxyMp; % calculation of the total lenght of the y-axis 
k2=5.45; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyMp; % offset of the line
b=maxyMp; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Mp1=Mp_1*m + b;
Mp2=Mp_2*m + b;
Mp3=Mp_3*m + b;

% interpolation of the longitudinal estability derivatives
Mp1_interp = spline(V,Mp1,V_interp);
Mp2_interp = spline(V,Mp2,V_interp);
Mp3_interp = spline(V,Mp3,V_interp);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LONGITUDINAL INTO LATERAL STABILITY DERIVATIVES - FIG 4B.10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LATERAL INTO LONGITUDINAL V-DERIVATIVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Yu ESTIMATION
% DATA FROM THE CHART
Yu_1=[1.3 1.55 2.25 2.5 2.5 2.475 2.425 2.45];
Yu_2=[4.7 4.35 3.45 3.1 3.05 3.05 3.05 3.05];
Yu_3=[1.6 1.6 2.4 2.55 2.5 2.475 2.425 2.35];

% estimation paramters
maxyYu=0.04; % max valkue in the y-axis
minyYu=-0.04; % min valu in the x-axis
k1= minyYu - maxyYu; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyYu; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Yu1=Yu_1*m + b;
Yu2=Yu_2*m + b;
Yu3=Yu_3*m + b;

% interpolation of the longitudinal estability derivatives
Yu1_interp = spline(V,Yu1,V_interp);
Yu2_interp = spline(V,Yu2,V_interp);
Yu3_interp = spline(V,Yu3,V_interp);

% Lu ESTIMATION
% DATA FROM THE CHART
Lu_1=[0.65 2.725 4.625  4.85 4.8 4.75 4.75 4.75];
Lu_2=[5.2 4.925 4.585 4.525 4.5 4.45 4.45 4.45];
Lu_3=[0.65 3.05 5.1 5.2 5.1 4.95 5 5];

% estimation paramters
maxyLu=0.4; % max valkue in the y-axis
minyLu=-0.1; % min valu in the x-axis
k1= minyLu - maxyLu; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyLu; % offset of the line
b=maxyLu; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Lu1=Lu_1*m + b;
Lu2=Lu_2*m + b;
Lu3=Lu_3*m + b;

% interpolation of the longitudinal estability derivatives
Lu1_interp = spline(V,Lu1,V_interp);
Lu2_interp = spline(V,Lu2,V_interp);
Lu3_interp = spline(V,Lu3,V_interp);

% Nu ESTIMATION
% DATA FROM THE CHART
Nu_1=[0.7643 2.95 4.3 4.15 3.975 3.9 4 4.1];
Nu_2=[3.2 2.2929 2.2929 2.65 2.75 2.825 2.825 2.825];
Nu_3=[0.7643 3.85 4.9 4.6 4.4 4.45 4.475 4.6];

% estimation paramters
maxyNu=0.08; % max valkue in the y-axis
minyNu=-0.06; % min valu in the x-axis
k1= minyNu - maxyNu; % calculation of the total lenght of the y-axis 
k2=5.35; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyNu; % offset of the line
b=maxyNu; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Nu1=Nu_1*m + b;
Nu2=Nu_2*m + b;
Nu3=Nu_3*m + b;

% interpolation of the longitudinal estability derivatives
Nu1_interp = spline(V,Nu1,V_interp);
Nu2_interp = spline(V,Nu2,V_interp);
Nu3_interp = spline(V,Nu3,V_interp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LATERAL INTO LONGITUDINAL Q-DERIVATIVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Yq ESTIMATION
% DATA FROM THE CHART
Yq_1=[5.25 5.1 5.025 5.025 5.025 5.025 5.025 5.025];
Yq_2=[1.3750 1.6 1.8 1.8 1.8250 1.8500 1.8750 1.9000];
Yq_3=[4 3.85 3.7 3.7 3.7 3.7 3.7 3.7];

% estimation paramters
maxyYq=0.6; % max valkue in the y-axis
minyYq=-0.2; % min valu in the x-axis
k1= minyYq - maxyYq; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyYq; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Yq1=Yq_1*m + b;
Yq2=Yq_2*m + b;
Yq3=Yq_3*m + b;

% interpolation of the longitudinal estability derivatives
Yq1_interp = spline(V,Yq1,V_interp);
Yq2_interp = spline(V,Yq2,V_interp);
Yq3_interp = spline(V,Yq3,V_interp);

% Lq ESTIMATION
% DATA FROM THE CHART
Lq_1=[5.1 4.85 4.55 4.45 4.4 4.35 4.325 4.175];
Lq_2=[1.1 1.105 1.15 1.15 1.15 1.15 1.15 1.15];
Lq_3=[1.85 1.4 1.05 0.975 0.95 0.9 0.8 0.725];

% estimation paramters
maxyLq=2; % max valkue in the y-axis
minyLq=-3; % min valu in the x-axis
k1= minyLq - maxyLq; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyLq; % offset of the line
b=maxyLq; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Lq1=Lq_1*m + b;
Lq2=Lq_2*m + b;
Lq3=Lq_3*m + b;

% interpolation of the longitudinal estability derivatives
Lq1_interp = spline(V,Lq1,V_interp);
Lq2_interp = spline(V,Lq2,V_interp);
Lq3_interp = spline(V,Lq3,V_interp);

% Nq ESTIMATION
% DATA FROM THE CHART
Nq_1=[4.0000 3.7429 3.4 3.1286 2.9714 2.7143 2.4571 2.2000];
Nq_2=[2.7000 2.8429 2.9857 3.1286 3.2714 3.4143 3.5571 3.7000];
Nq_3=[2.7000 2.125 1.7 1.5 1.25 0.9857 0.6429 0.3000];

% estimation paramters
maxyNq=1; % max valkue in the y-axis
minyNq=-1; % min valu in the x-axis
k1= minyNq - maxyNq; % calculation of the total lenght of the y-axis 
k2=5.4; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyNq; % offset of the line
b=maxyNq; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Nq1=Nq_1*m + b;
Nq2=Nq_2*m + b;
Nq3=Nq_3*m + b;

% interpolation of the longitudinal estability derivatives
Nq1_interp = spline(V,Nq1,V_interp);
Nq2_interp = spline(V,Nq2,V_interp);
Nq3_interp = spline(V,Nq3,V_interp);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LATERAL INTO LONGITUDINAL W-DERIVATIVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Yw ESTIMATION
% DATA FROM THE CHART
Yw_1=[2.75 1.25 1.075 1.2 1.4 1.475 1.55 1.575];
Yw_2=[2.75 4.225 4.625 4.625 4.65 4.7 4.9 5];
Yw_3=[2.75 1.475 1.5 1.85 2.075 2.3 2.55 2.75];

% estimation paramters
maxyYw=0.03; % max valkue in the y-axis
minyYw=-0.03; % min valu in the x-axis
k1= minyYw - maxyYw; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyYw; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Yw1=Yw_1*m + b;
Yw2=Yw_2*m + b;
Yw3=Yw_3*m + b;

% interpolation of the longitudinal estability derivatives
Yw1_interp = spline(V,Yw1,V_interp);
Yw2_interp = spline(V,Yw2,V_interp);
Yw3_interp = spline(V,Yw3,V_interp);

% Lw ESTIMATION
% DATA FROM THE CHART
Lw_1=[3.6667 1.2 0.9167 1.3 1.55 1.6 1.55 1.45];
Lw_2=[3.6667 4.1 4.2500 4.2800 4.3100 4.3400 4.3700 4.4000];
Lw_3=[3.6667 0.9 0.9167 1.65 2.1 2.45 2.6 2.8];

% estimation paramters
maxyLw=0.4; % max valkue in the y-axis
minyLw=-0.2; % min valu in the x-axis
k1= minyLw - maxyLw; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyLw; % offset of the line
b=maxyLw; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Lw1=Lw_1*m + b;
Lw2=Lw_2*m + b;
Lw3=Lw_3*m + b;

% interpolation of the longitudinal estability derivatives
Lw1_interp = spline(V,Lw1,V_interp);
Lw2_interp = spline(V,Lw2,V_interp);
Lw3_interp = spline(V,Lw3,V_interp);

% Nw ESTIMATION
% DATA FROM THE CHART
Nw_1=[3.5 1 1.95 3.35 3.9 3.7 2.8 1.3];
Nw_2=[4.35 4 3 2.15 1.75 1.65 1.85 2.4];
Nw_3=[3.5 0.8 2.45 4.25 5.1 5 4.15 2.6];

% estimation paramters
maxyNw=0.06; % max valkue in the y-axis
minyNw=-0.02; % min valu in the x-axis
k1= minyNw - maxyNw; % calculation of the total lenght of the y-axis 
k2=5.4; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyNw; % offset of the line
b=maxyNw; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Nw1=Nw_1*m + b;
Nw2=Nw_2*m + b;
Nw3=Nw_3*m + b;

% interpolation of the longitudinal estability derivatives
Nw1_interp = spline(V,Nw1,V_interp);
Nw2_interp = spline(V,Nw2,V_interp);
Nw3_interp = spline(V,Nw3,V_interp);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONTROL DERIVATIVES - MAIN ROTOR LONGITUDINAL - FIG 4B.11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COLLECTIVE PITCH LONG. CONTROL DERIVATIVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Xtheta_0 ESTIMATION
% DATA FROM THE CHART
Xtheta_0_1=[0.4 0.9 1.2 1.35 1.45 1.55 1.625 1.7];
Xtheta_0_2=[2.05 2.55 2.95 3.35 3.75 4.1 4.35 4.45];
Xtheta_0_3=[1.7 2.2 2.65 3.05 3.45 3.85 4.35 4.95];

% estimation paramters
maxyXtheta_0=8; % max valkue in the y-axis
minyXtheta_0=-6; % min valu in the x-axis
k1= minyXtheta_0 - maxyXtheta_0; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyXtheta_0; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Xtheta_01=Xtheta_0_1*m + b;
Xtheta_02=Xtheta_0_2*m + b;
Xtheta_03=Xtheta_0_3*m + b;

% interpolation of the longitudinal estability derivatives
Xtheta_01_interp = spline(V,Xtheta_01,V_interp);
Xtheta_02_interp = spline(V,Xtheta_02,V_interp);
Xtheta_03_interp = spline(V,Xtheta_03,V_interp);

% Ztheta_0 ESTIMATION
% DATA FROM THE CHART
Ztheta_0_1=[1.85 1.6 1.95 2.6 3.125 3.6 4.05 4.5];
Ztheta_0_2=[1.3 1.1 1.4 1.95 2.45 2.95 3.45 3.85];
Ztheta_0_3=[1.85 1.6 1.95 2.6 3.125 3.6 4.05 4.5];

% estimation paramters
maxyZtheta_0=-60; % max valkue in the y-axis
minyZtheta_0=-160; % min valu in the x-axis
k1= minyZtheta_0 - maxyZtheta_0; % calculation of the total lenght of the y-axis 
k2=5.45; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyZtheta_0; % offset of the line
b=maxyZtheta_0; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Ztheta_01=Ztheta_0_1*m + b;
Ztheta_02=Ztheta_0_2*m + b;
Ztheta_03=Ztheta_0_3*m + b;

% interpolation of the longitudinal estability derivatives
Ztheta_01_interp = spline(V,Ztheta_01,V_interp);
Ztheta_02_interp = spline(V,Ztheta_02,V_interp);
Ztheta_03_interp = spline(V,Ztheta_03,V_interp);

% Mtheta_0 ESTIMATION
% DATA FROM THE CHART
Mtheta_0_1=[4.4000 4.0143 3.6286 3.2429 2.8571 2.4714 2.0857 1.7000];
Mtheta_0_2=[4.6000 4.5264 4.4529 4.3793 4.3057 4.2321 4.1586 4.0850];
Mtheta_0_3=[5.1000 4.4357 3.6286 3.0071 2.4429 1.7786 1.1143 0.4500];

% estimation paramters
maxyMtheta_0=40; % max valkue in the y-axis
minyMtheta_0=-10; % min valu in the x-axis
k1= minyMtheta_0 - maxyMtheta_0; % calculation of the total lenght of the y-axis 
k2=5.55; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyMtheta_0; % offset of the line
b=maxyMtheta_0; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Mtheta_01=Mtheta_0_1*m + b;
Mtheta_02=Mtheta_0_2*m + b;
Mtheta_03=Mtheta_0_3*m + b;

% interpolation of the longitudinal estability derivatives
Mtheta_01_interp = spline(V,Mtheta_01,V_interp);
Mtheta_02_interp = spline(V,Mtheta_02,V_interp);
Mtheta_03_interp = spline(V,Mtheta_03,V_interp);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LONGITUDINAL CYCLIC PITCH LONG. CONTROL DERIVATIVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Xtheta_1S ESTIMATION
% DATA FROM THE CHART
Xtheta_1S_1=[4.65 4 3.45 2.7 2.2 1.75 1.4 1.15];
Xtheta_1S_2=[5.15 4.95 4.8 4.7 4.65 4.75 4.8 4.85];
Xtheta_1S_3=[3.45 3.2 2.95 2.7 2.8 3.15 3.65 4.55];

% estimation paramters
maxyXtheta_1S=-6; % max valkue in the y-axis
minyXtheta_1S=-10; % min valu in the x-axis
k1= minyXtheta_1S - maxyXtheta_1S; % calculation of the total lenght of the y-axis 
k2=5.55; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyXtheta_1S; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Xtheta_1S1=Xtheta_1S_1*m + b;
Xtheta_1S2=Xtheta_1S_2*m + b;
Xtheta_1S3=Xtheta_1S_3*m + b;

% interpolation of the longitudinal estability derivatives
Xtheta_1S1_interp = spline(V,Xtheta_1S1,V_interp);
Xtheta_1S2_interp = spline(V,Xtheta_1S2,V_interp);
Xtheta_1S3_interp = spline(V,Xtheta_1S3,V_interp);

% Ztheta_1S ESTIMATION
% DATA FROM THE CHART
Ztheta_1S_1=[1.08 1.4 1.89 2.3 2.75 3.2 3.7 4.2];
Ztheta_1S_2=[1.08 1.4 1.89 2.3 2.75 3.2 3.7 4.2];
Ztheta_1S_3=[1.08 1.4 1.89 2.3 2.8 3.3 3.85 4.4];

% estimation paramters
maxyZtheta_1S=20; % max valkue in the y-axis
minyZtheta_1S=-80; % min valu in the x-axis
k1= minyZtheta_1S - maxyZtheta_1S; % calculation of the total lenght of the y-axis 
k2=5.4; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyZtheta_1S; % offset of the line
b=maxyZtheta_1S; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Ztheta_1S1=Ztheta_1S_1*m + b;
Ztheta_1S2=Ztheta_1S_2*m + b;
Ztheta_1S3=Ztheta_1S_3*m + b;

% interpolation of the longitudinal estability derivatives
Ztheta_1S1_interp = spline(V,Ztheta_1S1,V_interp);
Ztheta_1S2_interp = spline(V,Ztheta_1S2,V_interp);
Ztheta_1S3_interp = spline(V,Ztheta_1S3,V_interp);

% Mtheta_1S ESTIMATION
% DATA FROM THE CHART
Mtheta_1S_1=[3.15 3.1 3.05 3 2.95 2.8 2.675 2.55];
Mtheta_1S_2=[4.975 4.975 4.975 4.975 4.975 4.975 4.975 4.975];
Mtheta_1S_3=[1.45 1.4 1.375 1.35 1.25 1.125 0.95 0.625];

% estimation paramters
maxyMtheta_1S=60; % max valkue in the y-axis
minyMtheta_1S=0; % min valu in the x-axis
k1= minyMtheta_1S - maxyMtheta_1S; % calculation of the total lenght of the y-axis 
k2=5.55; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyMtheta_1S; % offset of the line
b=maxyMtheta_1S; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Mtheta_1S1=Mtheta_1S_1*m + b;
Mtheta_1S2=Mtheta_1S_2*m + b;
Mtheta_1S3=Mtheta_1S_3*m + b;

% interpolation of the longitudinal estability derivatives
Mtheta_1S1_interp = spline(V,Mtheta_1S1,V_interp);
Mtheta_1S2_interp = spline(V,Mtheta_1S2,V_interp);
Mtheta_1S3_interp = spline(V,Mtheta_1S3,V_interp);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LATERAL CYCLIC PITCH LONG. CONTROL DERIVATIVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Xtheta_1C ESTIMATION
% DATA FROM THE CHART
Xtheta_1C_1=[2.75 2.74 2.73 2.72 2.69 2.64 2.55 2.47];
Xtheta_1C_2=[4.9500 4.9393 4.9286 4.9179 4.9071 4.8964 4.8857 4.8750];
Xtheta_1C_3=[0.95 0.95 0.94 0.91 0.88 0.8 0.7 0.45];

% estimation paramters
maxyXtheta_1C=4; % max valkue in the y-axis
minyXtheta_1C=0; % min valu in the x-axis
k1= minyXtheta_1C - maxyXtheta_1C; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyXtheta_1C; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Xtheta_1C1=Xtheta_1C_1*m + b;
Xtheta_1C2=Xtheta_1C_2*m + b;
Xtheta_1C3=Xtheta_1C_3*m + b;

% interpolation of the longitudinal estability derivatives
Xtheta_1C1_interp = spline(V,Xtheta_1C1,V_interp);
Xtheta_1C2_interp = spline(V,Xtheta_1C2,V_interp);
Xtheta_1C3_interp = spline(V,Xtheta_1C3,V_interp);

% Ztheta_1C ESTIMATION
% DATA FROM THE CHART
Ztheta_1C_1=[4 1.3 2.075 3.24 3.24 2.85 3.24 3.24];
Ztheta_1C_2=[4 0.9 2.65 2.8 3.09 3.24 2.55 2.7];
Ztheta_1C_3=[4.25 1.5 2.9 3.24 2.95 3.24 3.24 2.9];

% estimation paramters
maxyZtheta_1C=1.5; % max valkue in the y-axis
minyZtheta_1C=-1; % min valu in the x-axis
k1= minyZtheta_1C - maxyZtheta_1C; % calculation of the total lenght of the y-axis 
k2=5.4; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyZtheta_1C; % offset of the line
b=maxyZtheta_1C; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Ztheta_1C1=Ztheta_1C_1*m + b;
Ztheta_1C2=Ztheta_1C_2*m + b;
Ztheta_1C3=Ztheta_1C_3*m + b;

% interpolation of the longitudinal estability derivatives
Ztheta_1C1_interp = spline(V,Ztheta_1C1,V_interp);
Ztheta_1C2_interp = spline(V,Ztheta_1C2,V_interp);
Ztheta_1C3_interp = spline(V,Ztheta_1C3,V_interp);

% Mtheta_1C ESTIMATION
% DATA FROM THE CHART
Mtheta_1C_1=[2.3800 2.3929 2.4057 2.4186 2.4314 2.4443 2.4571 2.4700];
Mtheta_1C_2=[1.09 1.09 1.09 1.09 1.09 1.09 1.09 1.09];
Mtheta_1C_3=[5.02 5.05 5.06 5.07 5.09 5.14 5.2 5.28];

% estimation paramters
maxyMtheta_1C=5; % max valkue in the y-axis
minyMtheta_1C=-20; % min valu in the x-axis
k1= minyMtheta_1C - maxyMtheta_1C; % calculation of the total lenght of the y-axis 
k2=5.45; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyMtheta_1C; % offset of the line
b=maxyMtheta_1C; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Mtheta_1C1=Mtheta_1C_1*m + b;
Mtheta_1C2=Mtheta_1C_2*m + b;
Mtheta_1C3=Mtheta_1C_3*m + b;

% interpolation of the longitudinal estability derivatives
Mtheta_1C1_interp = spline(V,Mtheta_1C1,V_interp);
Mtheta_1C2_interp = spline(V,Mtheta_1C2,V_interp);
Mtheta_1C3_interp = spline(V,Mtheta_1C3,V_interp);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONTROL DERIVATIVES - MAIN ROTOR LATERAL - FIG 4B.12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COLLECTIVE PITCH LAT. CONTROL DERIVATIVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ytheta_0 ESTIMATION
% DATA FROM THE CHART
Ytheta_0_1=[1.65 1.45 0.6 0.35 0.33 0.315 0.3 0.28];
Ytheta_0_2=[0.68 1.45 2.38 2.9 3.25 3.55 3.85 4.14];
Ytheta_0_3=[1.77 1.6 1.1 1.15 1.35 1.6 1.85 2.15];

% estimation paramters
maxyYtheta_0=2; % max valkue in the y-axis
minyYtheta_0=-6; % min valu in the x-axis
k1= minyYtheta_0 - maxyYtheta_0; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyYtheta_0; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Ytheta_01=Ytheta_0_1*m + b;
Ytheta_02=Ytheta_0_2*m + b;
Ytheta_03=Ytheta_0_3*m + b;

% interpolation of the longitudinal estability derivatives
Ytheta_01_interp = spline(V,Ytheta_01,V_interp);
Ytheta_02_interp = spline(V,Ytheta_02,V_interp);
Ytheta_03_interp = spline(V,Ytheta_03,V_interp);

% Ltheta_0 ESTIMATION
% DATA FROM THE CHART
Ltheta_0_1=[3.6 3.15 2.2 1.95 1.87 1.82 1.7 1.5];
Ltheta_0_2=[3.75 3.9 4.2 4.38 4.5 4.6 4.7 4.78];
Ltheta_0_3=[3.75 3.45 2.8 2.95 3.3 3.65 3.95 4.1];

% estimation paramters
maxyLtheta_0=60; % max valkue in the y-axis
minyLtheta_0=-20; % min valu in the x-axis
k1= minyLtheta_0 - maxyLtheta_0; % calculation of the total lenght of the y-axis 
k2=5.45; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyLtheta_0; % offset of the line
b=maxyLtheta_0; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Ltheta_01=Ltheta_0_1*m + b;
Ltheta_02=Ltheta_0_2*m + b;
Ltheta_03=Ltheta_0_3*m + b;

% interpolation of the longitudinal estability derivatives
Ltheta_01_interp = spline(V,Ltheta_01,V_interp);
Ltheta_02_interp = spline(V,Ltheta_02,V_interp);
Ltheta_03_interp = spline(V,Ltheta_03,V_interp);

% Ntheta_0 ESTIMATION
% DATA FROM THE CHART
Ntheta_0_1=[1.35 1.45 1.55 1.65 1.7 1.65 1.35 0.9];
Ntheta_0_2=[4.45 4.3 4.09 3.9 3.76 3.75 3.75 3.85];
Ntheta_0_3=[1.1 1.3 1.55 1.775 1.975 1.95 1.8 1.35];

% estimation paramters
maxyNtheta_0=30; % max valkue in the y-axis
minyNtheta_0=-20; % min valu in the x-axis
k1= minyNtheta_0 - maxyNtheta_0; % calculation of the total lenght of the y-axis 
k2=5.35; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyNtheta_0; % offset of the line
b=maxyNtheta_0; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Ntheta_01=Ntheta_0_1*m + b;
Ntheta_02=Ntheta_0_2*m + b;
Ntheta_03=Ntheta_0_3*m + b;

% interpolation of the longitudinal estability derivatives
Ntheta_01_interp = spline(V,Ntheta_01,V_interp);
Ntheta_02_interp = spline(V,Ntheta_02,V_interp);
Ntheta_03_interp = spline(V,Ntheta_03,V_interp);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LONGITUDINAL CYCLIC PITCH LAT. CONTROL DERIVATIVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ytheta_1S ESTIMATION
% DATA FROM THE CHART
Ytheta_1S_1=[3.3 3.28 3.15 3 2.75 2.69 2.55 2.4];
Ytheta_1S_2=[0.55 0.57 0.85 1.1 1.45 1.79 2.15 2.55];
Ytheta_1S_3=[4.8 4.75 4.65 4.475 4.4 4.475 4.55 4.7];

% estimation paramters
maxyYtheta_1S=1; % max valkue in the y-axis
minyYtheta_1S=-4; % min valu in the x-axis
k1= minyYtheta_1S - maxyYtheta_1S; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyYtheta_1S; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Ytheta_1S1=Ytheta_1S_1*m + b;
Ytheta_1S2=Ytheta_1S_2*m + b;
Ytheta_1S3=Ytheta_1S_3*m + b;

% interpolation of the longitudinal estability derivatives
Ytheta_1S1_interp = spline(V,Ytheta_1S1,V_interp);
Ytheta_1S2_interp = spline(V,Ytheta_1S2,V_interp);
Ytheta_1S3_interp = spline(V,Ytheta_1S3,V_interp);

% Ltheta_1S ESTIMATION
% DATA FROM THE CHART
Ltheta_1S_1=[2.89 2.89 2.75 2.65 2.5 2.3 2.15 1.95];
Ltheta_1S_2=[1.09 1.09 1.09 1.1 1.15 1.25 1.29 1.35];
Ltheta_1S_3=[4.68 4.69 4.55 4.42 4.38 4.3 4.24 4.18];

% estimation paramters
maxyLtheta_1S=20; % max valkue in the y-axis
minyLtheta_1S=-80; % min valu in the x-axis
k1= minyLtheta_1S - maxyLtheta_1S; % calculation of the total lenght of the y-axis 
k2=5.45; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyLtheta_1S; % offset of the line
b=maxyLtheta_1S; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Ltheta_1S1=Ltheta_1S_1*m + b;
Ltheta_1S2=Ltheta_1S_2*m + b;
Ltheta_1S3=Ltheta_1S_3*m + b;

% interpolation of the longitudinal estability derivatives
Ltheta_1S1_interp = spline(V,Ltheta_1S1,V_interp);
Ltheta_1S2_interp = spline(V,Ltheta_1S2,V_interp);
Ltheta_1S3_interp = spline(V,Ltheta_1S3,V_interp);

% Ntheta_1S ESTIMATION
% DATA FROM THE CHART
Ntheta_1S_1=[2.98 2.95 2.92 2.95 2.98 2.85 2.57 2.07];
Ntheta_1S_2=[1.3375 1.32 1.25 1.13 0.98 0.87 0.8 0.85];
Ntheta_1S_3=[4.55 4.45 4.48 4.51 4.52 4.45 4.22 3.75];

% estimation paramters
maxyNtheta_1S=5; % max valkue in the y-axis
minyNtheta_1S=-15; % min valu in the x-axis
k1= minyNtheta_1S - maxyNtheta_1S; % calculation of the total lenght of the y-axis 
k2=5.35; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyNtheta_1S; % offset of the line
b=maxyNtheta_1S; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Ntheta_1S1=Ntheta_1S_1*m + b;
Ntheta_1S2=Ntheta_1S_2*m + b;
Ntheta_1S3=Ntheta_1S_3*m + b;

% interpolation of the longitudinal estability derivatives
Ntheta_1S1_interp = spline(V,Ntheta_1S1,V_interp);
Ntheta_1S2_interp = spline(V,Ntheta_1S2,V_interp);
Ntheta_1S3_interp = spline(V,Ntheta_1S3,V_interp);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LATERAL CYCLIC PITCH LAT. CONTROL DERIVATIVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ytheta_1C ESTIMATION
% DATA FROM THE CHART
Ytheta_1C_1=[4.5300 4.5400 4.5500 4.5600 4.5700 4.5800 4.5900 4.6000];
Ytheta_1C_2=[0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9];
Ytheta_1C_3=[4.39 4.38 4.37 4.35 4.35 4.37 4.38 4.39];

% estimation paramters
maxyYtheta_1C=15; % max valkue in the y-axis
minyYtheta_1C=-15; % min valu in the x-axis
k1= minyYtheta_1C - maxyYtheta_1C; % calculation of the total lenght of the y-axis 
k2=5.45; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyYtheta_1C; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Ytheta_1C1=Ytheta_1C_1*m + b;
Ytheta_1C2=Ytheta_1C_2*m + b;
Ytheta_1C3=Ytheta_1C_3*m + b;

% interpolation of the longitudinal estability derivatives
Ytheta_1C1_interp = spline(V,Ytheta_1C1,V_interp);
Ytheta_1C2_interp = spline(V,Ytheta_1C2,V_interp);
Ytheta_1C3_interp = spline(V,Ytheta_1C3,V_interp);

% Ltheta_1C ESTIMATION
% DATA FROM THE CHART
Ltheta_1C_1=[4.3600 4.3600 4.3600 4.3600 4.3600 4.3600 4.3600 4.3600];
Ltheta_1C_2=[0.5450 0.5450 0.5450 0.5450 0.5450 0.5450 0.5450 0.5450];
Ltheta_1C_3=[4.75 4.75 4.75 4.75 4.75 4.75 4.75 4.75];

% estimation paramters
maxyLtheta_1C=50; % max valkue in the y-axis
minyLtheta_1C=-200; % min valu in the x-axis
k1= minyLtheta_1C - maxyLtheta_1C; % calculation of the total lenght of the y-axis 
k2=5.45; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyLtheta_1C; % offset of the line
b=maxyLtheta_1C; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Ltheta_1C1=Ltheta_1C_1*m + b;
Ltheta_1C2=Ltheta_1C_2*m + b;
Ltheta_1C3=Ltheta_1C_3*m + b;

% interpolation of the longitudinal estability derivatives
Ltheta_1C1_interp = spline(V,Ltheta_1C1,V_interp);
Ltheta_1C2_interp = spline(V,Ltheta_1C2,V_interp);
Ltheta_1C3_interp = spline(V,Ltheta_1C3,V_interp);

% Ntheta_1C ESTIMATION
% DATA FROM THE CHART
Ntheta_1C_1=[4.0500 4.0214 3.9929 3.9643 3.9357 3.9071 3.8786 3.8500];
Ntheta_1C_2=[1.07 1.07 1.07 1.07 1.07 1.07 1.07 1.07];
Ntheta_1C_3=[4.3000 4.2357 4.1714 4.1071 4.0429 3.9786 3.9143 3.8500];

% estimation paramters
maxyNtheta_1C=10; % max valkue in the y-axis
minyNtheta_1C=-40; % min valu in the x-axis
k1= minyNtheta_1C - maxyNtheta_1C; % calculation of the total lenght of the y-axis 
k2=5.35; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyNtheta_1C; % offset of the line
b=maxyNtheta_1C; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Ntheta_1C1=Ntheta_1C_1*m + b;
Ntheta_1C2=Ntheta_1C_2*m + b;
Ntheta_1C3=Ntheta_1C_3*m + b;

% interpolation of the longitudinal estability derivatives
Ntheta_1C1_interp = spline(V,Ntheta_1C1,V_interp);
Ntheta_1C2_interp = spline(V,Ntheta_1C2,V_interp);
Ntheta_1C3_interp = spline(V,Ntheta_1C3,V_interp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONTROL DERIVATIVES TAIL ROTOR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Xtheta_OT ESTIMATION
% DATA FROM THE CHART
Xtheta_OT_1=[1.375 1.375 1.375 1.375 1.375 4.5 1.375 1.375];
Xtheta_OT_2=[1.375 1.375 0.8 1.375 1.375 1.375 3.09375 3.64375];
Xtheta_OT_3=[1.375 1.375 1.375 1.375 1.375 1.375 1.375 1.375];

% estimation paramters
maxyXtheta_OT=0.01E3; % max valkue in the y-axis
minyXtheta_OT=-0.03E3; % min valu in the x-axis
k1= minyXtheta_OT - maxyXtheta_OT; % calculation of the total lenght of the y-axis 
k2=5.5; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyXtheta_OT; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Xtheta_OT1=Xtheta_OT_1*m + b;
Xtheta_OT2=Xtheta_OT_2*m + b;
Xtheta_OT3=Xtheta_OT_3*m + b;

% interpolation of the longitudinal estability derivatives
Xtheta_OT1_interp = interp1(V,Xtheta_OT1,V_interp);
Xtheta_OT2_interp = interp1(V,Xtheta_OT2,V_interp);
Xtheta_OT3_interp = interp1(V,Xtheta_OT3,V_interp);

% Ytheta_OT ESTIMATION
% DATA FROM THE CHART
Ytheta_OT_1=[4.35 4.5 4.6 4.34 4.05 3.75 3.55 3.3];
Ytheta_OT_2=[4.25 4.4 4.38 4.08 3.8 3.5 3.25 3.05];
Ytheta_OT_3=[3.45 3.75 3.6 3 2.5 2.1 1.75 1.35];

% estimation paramters
maxyYtheta_OT=10; % max valkue in the y-axis
minyYtheta_OT=2; % min valu in the x-axis
k1= minyYtheta_OT - maxyYtheta_OT; % calculation of the total lenght of the y-axis 
k2=5.45; % length in cm of the y-axis
m=k1/k2; % slope of the line
%b=minyYtheta_OT; % offset of the line
b=maxyYtheta_OT; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Ytheta_OT1=Ytheta_OT_1*m + b;
Ytheta_OT2=Ytheta_OT_2*m + b;
Ytheta_OT3=Ytheta_OT_3*m + b;

% interpolation of the longitudinal estability derivatives
Ytheta_OT1_interp = spline(V,Ytheta_OT1,V_interp);
Ytheta_OT2_interp = spline(V,Ytheta_OT2,V_interp);
Ytheta_OT3_interp = spline(V,Ytheta_OT3,V_interp);

% Ztheta_OT ESTIMATION
% DATA FROM THE CHART
Ztheta_OT1=[0 0 0 0 0 0.175 0 0]*1E3;
Ztheta_OT2=[0 0 -0.15 0 0 0 0.335 0.27]*1E3;
Ztheta_OT3=[0 0 0 0 0 0 0 0]*1E3;

% estimation paramters
maxyZtheta_OT=0.4E3; % max valkue in the y-axis
minyZtheta_OT=-0.2E3; % min valu in the x-axis

% interpolation of the longitudinal estability derivatives
Ztheta_OT1_interp = interp1(V,Ztheta_OT1,V_interp);
Ztheta_OT2_interp = interp1(V,Ztheta_OT2,V_interp);
Ztheta_OT3_interp = interp1(V,Ztheta_OT3,V_interp);

% Ltheta_OT ESTIMATION
% DATA FROM THE CHART
Ltheta_OT_1=[4.97 4.92 4.9 4.95 5 5.05 5.05 5.05];
Ltheta_OT_2=[3.05 3.175 3.15 2.93 2.75 2.6 2.45 2.35];
Ltheta_OT_3=[2.29 2.5 2.38 2 1.6 1.35 1.07 0.8];

% estimation paramters
maxyLtheta_OT=12; % max valkue in the y-axis
minyLtheta_OT=-2; % min valu in the x-axis
k1= minyLtheta_OT - maxyLtheta_OT; % calculation of the total lenght of the y-axis 
k2=5.47; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyLtheta_OT; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Ltheta_OT1=Ltheta_OT_1*m + b;
Ltheta_OT2=Ltheta_OT_2*m + b;
Ltheta_OT3=Ltheta_OT_3*m + b;

% interpolation of the longitudinal estability derivatives
Ltheta_OT1_interp = spline(V,Ltheta_OT1,V_interp);
Ltheta_OT2_interp = spline(V,Ltheta_OT2,V_interp);
Ltheta_OT3_interp = spline(V,Ltheta_OT3,V_interp);

% Mtheta_OT ESTIMATION
% estimation paramters
maxyMtheta_OT=0.01E3; % max valkue in the y-axis
minyMtheta_OT=-0.002E3; % min valu in the x-axis

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Mtheta_OT1=[0 0 0 0 0 0.005125 0 0]*1E3;
Mtheta_OT2=[0 0 -0.0015 0 0 0 0.00575 0.0085]*1E3;
Mtheta_OT3=[0 0 0 0 0 0 0 0]*1E3;

% interpolation of the longitudinal estability derivatives
Mtheta_OT1_interp = interp1(V,Mtheta_OT1,V_interp);
Mtheta_OT2_interp = interp1(V,Mtheta_OT2,V_interp);
Mtheta_OT3_interp = interp1(V,Mtheta_OT3,V_interp);

% Ntheta_OT ESTIMATION
% DATA FROM THE CHART
Ntheta_OT_1=[1.05 0.9 0.85 1.08 1.3 1.55 1.75 1.9];
Ntheta_OT_2=[0.5 0.37 0.42 0.6 0.8 0.95 1.1 1.2];
Ntheta_OT_3=[2.25 1.95 2.08 2.65 3.1 3.5 3.85 4.2];

% estimation paramters
maxyNtheta_OT=-5; % max valkue in the y-axis
minyNtheta_OT=-30; % min valu in the x-axis
k1= minyNtheta_OT - maxyNtheta_OT; % calculation of the total lenght of the y-axis 
k2=5.3; % length in cm of the y-axis
m=k1/k2; % slope of the line
b=maxyNtheta_OT; % offset of the line

% TRANFORMATION FROM MEASUREMNT FROM THE GRAPH TO ACTUAL VALUES FOR THE
% CHART
Ntheta_OT1=Ntheta_OT_1*m + b;
Ntheta_OT2=Ntheta_OT_2*m + b;
Ntheta_OT3=Ntheta_OT_3*m + b;

% interpolation of the longitudinal estability derivatives
Ntheta_OT1_interp = spline(V,Ntheta_OT1,V_interp);
Ntheta_OT2_interp = spline(V,Ntheta_OT2,V_interp);
Ntheta_OT3_interp = spline(V,Ntheta_OT3,V_interp);

vars = {'Xu' 'Xw' 'Xq' 'Xv' 'Xp' 'Xr' ...
        'Zu' 'Zw' 'Zq' 'Zv' 'Zp' 'Zr' ...
        'Mu' 'Mw' 'Mq' 'Mv' 'Mp' 'Mr' ...
        'Yu' 'Yw' 'Yq' 'Yv' 'Yp' 'Yr' ...
        'Lu' 'Lw' 'Lq' 'Lv' 'Lp' 'Lr' ...
        'Nu' 'Nw' 'Nq' 'Nv' 'Np' 'Nr' ...
        'Xt0' 'Xt1C' 'Xt1S' 'Xt0T' ...
        'Zt0' 'Zt1C' 'Zt1S' 'Zt0T' ...
        'Mt0' 'Mt1C' 'Mt1S' 'Mt0T' ...
        'Yt0' 'Yt1C' 'Yt1S' 'Yt0T' ...
        'Lt0' 'Lt1C' 'Lt1S' 'Lt0T' ...
        'Nt0' 'Nt1C' 'Nt1S' 'Nt0T' ...
        'V','mux'};

Puma  = {Xu1_interp Xw1_interp Xq1_interp Xv1_interp Xp1_interp Xr1_interp ...
        Zu1_interp Zw1_interp Zq1_interp Zv1_interp Zp1_interp Zr1_interp ...
        Mu1_interp Mw1_interp Mq1_interp Mv1_interp Mp1_interp Mr1_interp ...
        Yu1_interp Yw1_interp Yq1_interp Yv1_interp Yp1_interp Yr1_interp ...
        Lu1_interp Lw1_interp Lq1_interp Lv1_interp Lp1_interp Lr1_interp ...
        Nu1_interp Nw1_interp Nq1_interp Nv1_interp Np1_interp Nr1_interp ...
        Xtheta_01_interp Xtheta_1C1_interp Xtheta_1S1_interp Xtheta_OT1_interp ...
        Ztheta_01_interp Ztheta_1C1_interp Ztheta_1S1_interp Ztheta_OT1_interp ...
        Mtheta_01_interp Mtheta_1C1_interp Mtheta_1S1_interp Mtheta_OT1_interp ...
        Ytheta_01_interp Ytheta_1C1_interp Ytheta_1S1_interp Ytheta_OT1_interp ...
        Ltheta_01_interp Ltheta_1C1_interp Ltheta_1S1_interp Ltheta_OT1_interp ...
        Ntheta_01_interp Ntheta_1C1_interp Ntheta_1S1_interp Ntheta_OT1_interp ...
        V_interp mux_interp};
    
Lynx  = {Xu2_interp Xw2_interp Xq2_interp Xv2_interp Xp2_interp Xr2_interp ...
        Zu2_interp Zw2_interp Zq2_interp Zv2_interp Zp2_interp Zr2_interp ...
        Mu2_interp Mw2_interp Mq2_interp Mv2_interp Mp2_interp Mr2_interp ...
        Yu2_interp Yw2_interp Yq2_interp Yv2_interp Yp2_interp Yr2_interp ...
        Lu2_interp Lw2_interp Lq2_interp Lv2_interp Lp2_interp Lr2_interp ...
        Nu2_interp Nw2_interp Nq2_interp Nv2_interp Np2_interp Nr2_interp ...
        Xtheta_02_interp Xtheta_1C2_interp Xtheta_1S2_interp Xtheta_OT2_interp ...
        Ztheta_02_interp Ztheta_1C2_interp Ztheta_1S2_interp Ztheta_OT2_interp ...
        Mtheta_02_interp Mtheta_1C2_interp Mtheta_1S2_interp Mtheta_OT2_interp ...
        Ytheta_02_interp Ytheta_1C2_interp Ytheta_1S2_interp Ytheta_OT2_interp ...
        Ltheta_02_interp Ltheta_1C2_interp Ltheta_1S2_interp Ltheta_OT2_interp ...
        Ntheta_02_interp Ntheta_1C2_interp Ntheta_1S2_interp Ntheta_OT2_interp ...
        V_interp mux_interp};
    
Bo105 = {Xu3_interp Xw3_interp Xq3_interp Xv3_interp Xp3_interp Xr3_interp ...
        Zu3_interp Zw3_interp Zq3_interp Zv3_interp Zp3_interp Zr3_interp ...
        Mu3_interp Mw3_interp Mq3_interp Mv3_interp Mp3_interp Mr3_interp ...
        Yu3_interp Yw3_interp Yq3_interp Yv3_interp Yp3_interp Yr3_interp ...
        Lu3_interp Lw3_interp Lq3_interp Lv3_interp Lp3_interp Lr3_interp ...
        Nu3_interp Nw3_interp Nq3_interp Nv3_interp Np3_interp Nr3_interp ...
        Xtheta_03_interp Xtheta_1C3_interp Xtheta_1S3_interp Xtheta_OT3_interp ...
        Ztheta_03_interp Ztheta_1C3_interp Ztheta_1S3_interp Ztheta_OT3_interp ...
        Mtheta_03_interp Mtheta_1C3_interp Mtheta_1S3_interp Mtheta_OT3_interp ...
        Ytheta_03_interp Ytheta_1C3_interp Ytheta_1S3_interp Ytheta_OT3_interp ...
        Ltheta_03_interp Ltheta_1C3_interp Ltheta_1S3_interp Ltheta_OT3_interp ...
        Ntheta_03_interp Ntheta_1C3_interp Ntheta_1S3_interp Ntheta_OT3_interp ...
        V_interp mux_interp};

PumaD  = {Xu1 Xw1 Xq1 Xv1 Xp1 Xr1 ...
        Zu1 Zw1 Zq1 Zv1 Zp1 Zr1 ...
        Mu1 Mw1 Mq1 Mv1 Mp1 Mr1 ...
        Yu1 Yw1 Yq1 Yv1 Yp1 Yr1 ...
        Lu1 Lw1 Lq1 Lv1 Lp1 Lr1 ...
        Nu1 Nw1 Nq1 Nv1 Np1 Nr1 ...
        Xtheta_01 Xtheta_1C1 Xtheta_1S1 Xtheta_OT1 ...
        Ztheta_01 Ztheta_1C1 Ztheta_1S1 Ztheta_OT1 ...
        Mtheta_01 Mtheta_1C1 Mtheta_1S1 Mtheta_OT1 ...
        Ytheta_01 Ytheta_1C1 Ytheta_1S1 Ytheta_OT1 ...
        Ltheta_01 Ltheta_1C1 Ltheta_1S1 Ltheta_OT1 ...
        Ntheta_01 Ntheta_1C1 Ntheta_1S1 Ntheta_OT1 ...
        V mux};
    
LynxD = {Xu2 Xw2 Xq2 Xv2 Xp2 Xr2 ...
        Zu2 Zw2 Zq2 Zv2 Zp2 Zr2 ...
        Mu2 Mw2 Mq2 Mv2 Mp2 Mr2 ...
        Yu2 Yw2 Yq2 Yv2 Yp2 Yr2 ...
        Lu2 Lw2 Lq2 Lv2 Lp2 Lr2 ...
        Nu2 Nw2 Nq2 Nv2 Np2 Nr2 ...
        Xtheta_02 Xtheta_1C2 Xtheta_1S2 Xtheta_OT2 ...
        Ztheta_02 Ztheta_1C2 Ztheta_1S2 Ztheta_OT2 ...
        Mtheta_02 Mtheta_1C2 Mtheta_1S2 Mtheta_OT2 ...
        Ytheta_02 Ytheta_1C2 Ytheta_1S2 Ytheta_OT2 ...
        Ltheta_02 Ltheta_1C2 Ltheta_1S2 Ltheta_OT2 ...
        Ntheta_02 Ntheta_1C2 Ntheta_1S2 Ntheta_OT2 ...
        V mux};
    
Bo105D = {Xu3 Xw3 Xq3 Xv3 Xp3 Xr3 ...
        Zu3 Zw3 Zq3 Zv3 Zp3 Zr3 ...
        Mu3 Mw3 Mq3 Mv3 Mp3 Mr3 ...
        Yu3 Yw3 Yq3 Yv3 Yp3 Yr3 ...
        Lu3 Lw3 Lq3 Lv3 Lp3 Lr3 ...
        Nu3 Nw3 Nq3 Nv3 Np3 Nr3 ...
        Xtheta_03 Xtheta_1C3 Xtheta_1S3 Xtheta_OT3 ...
        Ztheta_03 Ztheta_1C3 Ztheta_1S3 Ztheta_OT3 ...
        Mtheta_03 Mtheta_1C3 Mtheta_1S3 Mtheta_OT3 ...
        Ytheta_03 Ytheta_1C3 Ytheta_1S3 Ytheta_OT3 ...
        Ltheta_03 Ltheta_1C3 Ltheta_1S3 Ltheta_OT3 ...
        Ntheta_03 Ntheta_1C3 Ntheta_1S3 Ntheta_OT3 ...
        V mux};

if strcmp(rigidheStr,'Bo105')
    data = Bo105;
elseif strcmp(rigidheStr,'Puma')
    data = Puma;
elseif strcmp(rigidheStr,'Lynx')
    data = Lynx;
elseif strcmp(rigidheStr,'Bo105D')
    data = Bo105D;
elseif strcmp(rigidheStr,'PumaD')
    data = PumaD;
elseif strcmp(rigidheStr,'LynxD')
    data = LynxD;
else
    error('getPadfieldLinearStabilityState:helicopterModelChk', 'Wrong helicopter model. Check input argument spell (Bo105, Puma, Lynx)')
end

units =[O O OR O OR OR ...
        O O OR O OR OR ...
        RO RO O RO O O ...
        O O OR O OR OR ...
        RO RO O RO O O ...
        RO RO O RO O O ...
        O2R O2R O2R O2R ...
        O2R O2R O2R O2R ...
        O2 O2 O2 O2 ...
        O2R O2R O2R O2R ...
        O2 O2 O2 O2 ...
        O2 O2 O2 O2 ...
        OR/0.514444 1/0.514444];


nfields = length(units);

if strcmp(options.nondimensional,'yes')
    for i = 1:nfields
        sS.(vars{i}) = data{i}./units(i);
    end
elseif strcmp(options.nondimensional,'no')
    for i = 1:nfields
        sS.(vars{i}) = data{i};
    end
else
    error('getPadfieldLinearStabilityState: wrong option')
end



function options = setPadfieldLinearStabilityStateOptions

options  = struct(...
               'nondimensional','yes' ...
              );
