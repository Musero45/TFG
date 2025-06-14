function data = getadeltai(clData,cdData,linInt,mode)
%   getadeltai  provides the value of lift coefficient slope a in the
%   interval of angles of attack where the lift coefficient curve is linear
%   with respect the angle of attack linInt
%
%   clData is a 2-D matrix with the first column being the angle of attack
%   in [rad] and the second column the lift coefficient cl value.
%
%   cdData is a 2-D matrix with the first column being the angle of attack
%   in [rad] and the second column the lift coefficient cd value.
%
%   linInt is the interval of angles of attack where the lift coefficient
%   curve is linear with respect the angle of attack.
%
%   mode is a string with values 'ZLL' (Zero Lift Chord) of 'C' (Chord)
%
%   Example of usage
%   From an unknown source someone has obtained the following information
%   about a certain airfoil
% 
% clData = [ ...
% -6.81 -0.311
% -6.69 -0.310
% -6.37 -0.267
% -5.58 -0.185
% -4.22 -0.047
% -2.18 0.172
% -0.21 0.393
% 1.18  0.541
% 2.95  0.744
% 4.08  0.872
% 5.37  1.026
% 6.63  1.138
% 7.69  1.242
% 8.70  1.341
% 9.62  1.412
% 10.74 1.433
% 12.02 1.420
% 13.70 1.277
% 15.46 1.211
% 17.12 1.221
% 18.93 1.183
% 20.81 1.122
% 22.86 1.041
% 25.16 0.982
% 27.69 0.869
% 30.32 0.781
% 32.19 0.714
% ];
%  
% The first column is the angle of attack (degrees) and the second row the
% lif coefficient. It is required to obtain the lift coefficient between
% -pi and pi every degree. First obtain the cldata matrix using radians
% d2r    = pi/180; 
% clData(:,1) =d2r*clData(:,1);
% cdData(:,1) =d2r*cdData(:,1);
%
% Second, define the interval of angles of attack with linear behaviour of
% the lift coefficient in [rad].
%
% linInt = [-5 5]*d2r
%
% Third, define the mode indicating the selected reference chord to define
% the angles of attack. In this case the Zero Lift Line is selected
%
% mode = 'ZLL'
%
% Observe that the selected mode has an influence in the calculated values
% for delta0, delta1 and delta2
% 

% Chord as reference line

% Selection of cl-alpha portion corresponding to linInt interval

linalcl   = clData(and(clData(:,1)>=linInt(1),clData(:,1)<=linInt(2)),1);
lincl     = clData(and(clData(:,1)>=linInt(1),clData(:,1)<=linInt(2)),2);

quadalcd  = cdData(and(cdData(:,1)>=linInt(1),cdData(:,1)<=linInt(2)),1);
quadcd    = cdData(and(cdData(:,1)>=linInt(1),cdData(:,1)<=linInt(2)),2);

fitDataclC = polyfit(linalcl,lincl,1);

a       = fitDataclC(1);
alpha0C = interp1(lincl,linalcl,0);
    
fitDatacdC = polyfit(quadalcd,quadcd,2);

delta2C      = fitDatacdC(1);
delta1C      = fitDatacdC(2);
delta0C      = fitDatacdC(3);


% ZLN as reference line

% Selection of cl-alpha portion corresponding to linInt interval

clData(:,1) = clData(:,1)-alpha0C;
cdData(:,1) = cdData(:,1)-alpha0C;

linInt      = linInt-alpha0C;

linalcl   = clData(and(clData(:,1)>=linInt(1),clData(:,1)<=linInt(2)),1);
lincl     = clData(and(clData(:,1)>=linInt(1),clData(:,1)<=linInt(2)),2);

quadalcd  = cdData(and(cdData(:,1)>=linInt(1),cdData(:,1)<=linInt(2)),1);
quadcd    = cdData(and(cdData(:,1)>=linInt(1),cdData(:,1)<=linInt(2)),2);

fitDataclLSN = polyfit(linalcl,lincl,1);

a          = fitDataclLSN(1);
alpha0LSN  = 0;
    
fitDatacdLSN = polyfit(quadalcd,quadcd,2);

delta2LSN      = fitDatacdLSN(1);
delta1LSN      = fitDatacdLSN(2);
delta0LSN      = fitDatacdLSN(3);

 

 

data = struct('a',a',...
              'alpha0LSN',alpha0LSN,...
              'delta0LSN',delta0LSN,...
              'delta1LSN',delta1LSN,...
              'delta2LSN',delta2LSN,...
              'clfunLSN',@(alpha)polyval(fitDataclLSN,alpha),...
              'cdfunLSN',@(alpha)polyval(fitDatacdLSN,alpha),...
              'alpha0C',alpha0C,...
              'delta0C',delta0C,...
              'delta1C',delta1C,...
              'delta2C',delta2C,...
              'clfunC',@(alpha)polyval(fitDataclC,alpha),...
              'cdfunC',@(alpha)polyval(fitDatacdC,alpha));
          
          

