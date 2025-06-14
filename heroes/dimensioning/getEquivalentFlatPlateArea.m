function f = getEquivalentFlatPlateArea(desreq)
% This FUNCTION is used to get an estimation of the equivalent flat plate
% area to be used in the energy method for computing helicopter performance
%
% Data was digitized from [1] page 9-53 and then using the scripy below a
% function of the form f = K*MTOW^n was fit providing the values of k and n
% according to the three kind of helicopter fuselages, that is low, average 
% and high  drag fuselages.
%
% Example of usage:
% 
% dr.rand.MTOW = 2500*9.8;
% dr.energyEstimations.kindOfFuselage = 'lowDragFuselage';
% f = getFlatPlateEquivalentArea(dr);
%
% which is about 10 ft^2 as page 217 of [2] shows.
%
% See also 
%
%
% [1] AIAA Aerospace Design Engineers Guide, 5th Edition, 2003
%
% [2] J. G. Leishman Principles of Helicopter Aerodynamics, 2002
%
% DOCUMENTATION
% The computation carried out in this function is based on the next script
%
%==========================================================================
% close all
% 
% 
% % Low drag
% lowDragArea = [ ...
%         0           0
%   463.493     2.37452
%   955.109     3.39151
%   1504.69     4.74774
%   2111.91     5.87759
%   2892.37     6.89392
%   4135.12     8.13546
%   5059.95     9.03834
%   6158.15     10.054
%   7487.5     11.1822
%   8903.5     12.3102
%   10348.3     13.2119
%   12255.2     14.2257
%   14884.6     15.6903
%   17138.2     16.7033
%   18380.4     16.9268
%   20200.7     17.9408
%   22367.3     18.3883
%   23696.4     19.0641
%   29329.6     20.1826
%   35800.5     21.2991
%   39873.7     22.0818
%   41867     22.4166
%   47904.2     22.7423
%   49983.7     22.5114
% ];
% 
% % Average drag
% averageDragArea = [ ...
%         0           0
%   436.321     5.42889
%   957.647     7.9164
%   1507.73     10.1776
%   2115.33     11.9862
%   2867.48     14.0207
%   4168.83     16.7327
%   5065.35     18.6537
%   6163.99     20.4612
%   7493.84     22.4944
%   8939.11     24.3011
%   10355.3     25.7685
%   12263     28.0266
%   14864.1     30.6225
%   17147.1     32.5405
%   18360.7     33.3296
%   20210     34.5697
%   22348.2     35.8092
%   23706.4     36.8243
%   29369.2     39.187
%   35840.8     41.548
%   39913.9     42.2175
%   41878.4     42.6655
%   47886.8     43.3307
%   50024.5     43.6652
% ];
% 
% % high drag
% highDragArea = [ ...
%         0           0
%   441.525     14.7049
%   935.743     20.3599
%   1487.35     25.3361
%   2154.24     29.8594
%   2907.79     34.3826
%   4153.21     40.3753
%   5080.01     44.785
%   6179.79     48.6286
%   7482.22     53.2637
%   8957.7     57.4459
%   10375.2     61.2889
%   12284.4     66.2619
%   14887.3     71.9122
%   17171.5     75.9794
%   18385.8     78.126
%   20235.9     80.7236
%   22375.1     83.7731
%   23733.7     85.58
%   29369.8     91.7889
%   35842.8     96.7517
%   39945.7     98.7786
%   41910.4     99.7922
%   47919.2     101.136
%   50085.4     100.679
% ];
% 
% % 
% F = @(k,wdata) k(1).*wdata.^(k(2));
% 
% % Low Drag Area Computation
% kLow   = getKlsqFit(F,lowDragArea);
% k1     = lowDragArea(end,2)*lowDragArea(end,1)^(-1/2);
% ffLow  = @(W)k1.*W.^(1/2);
% weight = linspace(0,50000,31);
% fLow   = ffLow(weight);
% 
% % Average Drag Area Computation
% kAve   = getKlsqFit(F,averageDragArea);
% k2     = averageDragArea(end,2)*averageDragArea(end,1)^(-1/2);
% ffAve  = @(W)k2.*W.^(1/2);
% weight = linspace(0,50000,31);
% fAve   = ffAve(weight);
% 
% % High Drag Area Computation
% kHig = getKlsqFit(F,highDragArea);
% k3     = highDragArea(end,2)*highDragArea(end,1)^(-1/2);
% ffHig  = @(W)k3.*W.^(1/2);
% weight = linspace(0,50000,31);
% fHig   = ffHig(weight);
% 
% 
% figure(1)
% % Plot experimental results
% plot(lowDragArea(:,1),lowDragArea(:,2),'r o'); hold on;
% plot(averageDragArea(:,1),averageDragArea(:,2),'b s'); hold on;
% plot(highDragArea(:,1),highDragArea(:,2),'m v'); hold on;
% 
% legs{1} = 'Exp. Low drag';
% legs{2} = 'Exp. Average drag';
% legs{3} = 'Exp. High drag';
% 
% legs{4} = 'k x^{1/2} (Low)';
% legs{6} = 'k x^{1/2} (Average)';
% legs{8} = 'k x^{1/2} (High)';
% 
% legs{5} = strcat(num2str(kLow(1),'%1.2f'),'x^{',num2str(kLow(2),'%1.2f'),'} (Low)');
% legs{7} = strcat(num2str(kAve(1),'%1.2f'),'x^{',num2str(kAve(2),'%1.2f'),'} (Average)');
% legs{9} = strcat(num2str(kHig(1),'%1.2f'),'x^{',num2str(kHig(2),'%1.2f'),'} (High)');
% 
% % Plot fitting of low drag area
% plot(weight,fLow,'r-'); hold on;
% plot(lowDragArea(:,1),F(kLow,lowDragArea(:,1)),'r--'); hold on;
% 
% % Plot fitting of average drag area
% plot(weight,fAve,'b-'); hold on;
% plot(averageDragArea(:,1),F(kAve,averageDragArea(:,1)),'b--'); hold on;
% 
% % Plot fitting of high drag area
% plot(weight,fHig,'m-'); hold on;
% plot(highDragArea(:,1),F(kHig,highDragArea(:,1)),'m--'); hold on;
% 
% xlabel('Gross Weight [lb]');ylabel('Equivalent Flat Plate Area [ft^2]');
% legend(legs,'Location','Best');
% 
% disp(kLow)
% disp(kAve)
% disp(kHig)
% 
% io = 1;
% 
% 
% function k = getKlsqFit(F,wf)
% 
% npoints = size(wf,1);
% 
% 
% w  = wf(:,1);
% f  = wf(:,2);
% ab = wf(round(npoints/2),:);
% 
% 
% kLow  = ab(2)*ab(1)^(-1/2);
% 
% 
% k0 = [kLow,0.5];
% k  = lsqcurvefit(F,k0,w,f);
%
%
%==========================================================================



lb2N    = 4.448;
ft2m    = 0.3048;

MTOW    = desreq.rand.MTOW;
MTOW_US = MTOW/lb2N;

kindOfFuselage = desreq.energyEstimations.kindOfFuselage;

switch kindOfFuselage
case 'lowDragFuselage'
      k  = [0.278645112912042   0.413503741105163];

case 'averageDragFuselage'
      k = [0.682572554800564   0.390630538493146];

case 'highDragFuselage'
      k = [1.848415642185609   0.376252709140525];

otherwise
      disp('wrong option to define equivalent flat plate area')

end


% Definition of fit function handle
F = @(k,wdata) k(1).*wdata.^(k(2));

% Equivalent flat plate area [ft^2]
f_US    = F(k,MTOW_US); 
f       = f_US*(ft2m)^2;

