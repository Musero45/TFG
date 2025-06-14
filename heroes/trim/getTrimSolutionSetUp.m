function TrimSolutionSetUp = getTrimSolutionSetUp(FC)
%function [TrimSolutionSetUp] = getTrimSolutionSetUp(ndHe,trimType,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


xTrimOrder = struct(...
'Theta',1,'Phi',2,'theta0',3,'theta1C',4,'theta1S',5,...       
'theta0tr',6,'beta0',7,'beta1C',8,'beta1S',9,'lambda0',10,...          
'lambda1C',11,'lambda1S',12,'CT0',13,'CT1C',14,'CT1S',15,...                  
'beta0tr',16,'beta1Ctr',17,'beta1Str',18,'lambda0tr',19,...
'lambda1Ctr',20,'lambda1Str',21,'CT0tr',22,'CT1Ctr',23,...
'CT1Str',24,'omega',25,'Psi',26,'uTOR',27,'vTOR',28,...
'wTOR',29,'ueOR',30,'veOR',31,'weOR',32,'omxad',33,...
'omyad',34,'omzad',35,'omegaAdzT',36,'VOR',37,...
'gammaT',38,'betaT',39,'betaf0',40,'alphaf0',41,...
'cs',42 ...
);


TrimSolutionSetUp = getDefaultTrimSolutionSetUp(xTrimOrder);

     TrimSolutionSetUp.FCvars.FC1 = xTrimOrder.(FC{1});
     TrimSolutionSetUp.FCvars.FC2 = xTrimOrder.(FC{3});
     TrimSolutionSetUp.FCvars.FC3 = xTrimOrder.(FC{5});
     TrimSolutionSetUp.FCvars.FC4 = xTrimOrder.(FC{7});
     TrimSolutionSetUp.FCvars.FC5 = xTrimOrder.(FC{9});
     
     [FC1val,FC2val,FC3val,FC4val,FC5val] = ndgrid(FC{2},...
                                                   FC{4},...
                                                   FC{6},...
                                                   FC{8},...
                                                   FC{10}...
                                                    );

     TrimSolutionSetUp.FCvalues.FC1val = FC1val;
     TrimSolutionSetUp.FCvalues.FC2val = FC2val;
     TrimSolutionSetUp.FCvalues.FC3val = FC3val;
     TrimSolutionSetUp.FCvalues.FC4val = FC4val;
     TrimSolutionSetUp.FCvalues.FC5val = FC5val;


% if strcmp(trimType,'straightFlight')
%     
%     [FC1val,FC2val] = ndgrid(varargin{1},varargin{2});
%     
%     n = size(FC1val);
%     
%     FC3val = zeros(n);
%     FC4val = zeros(n);
%     FC5val = zeros(n);
%     
%     TrimSolutionSetUp.FCvars.FC1 = xTrimOrder.VOR;
%     TrimSolutionSetUp.FCvars.FC2 = xTrimOrder.gammaT;
%     TrimSolutionSetUp.FCvars.FC3 = xTrimOrder.veOR;
%     TrimSolutionSetUp.FCvars.FC4 = xTrimOrder.vTOR;
%     TrimSolutionSetUp.FCvars.FC5 = xTrimOrder.cs;
% 
%     TrimSolutionSetUp.FCvalues.FC1val = FC1val;
%     TrimSolutionSetUp.FCvalues.FC2val = FC2val;
%     TrimSolutionSetUp.FCvalues.FC3val = FC3val;
%     TrimSolutionSetUp.FCvalues.FC4val = FC4val;
%     TrimSolutionSetUp.FCvalues.FC5val = FC5val;
%   
% end
% 
% if strcmp(trimType,'spiralFlight')
%     
%     [FC1val,FC2val] = ndgrid(varargin{1},varargin{2});
%     
%     n = size(FC1val);
%     
%     FC3val = varargin{3}*ones(n);
%     FC4val = zeros(n);
%     FC5val = zeros(n);
%     
%     TrimSolutionSetUp.FCvars.FC1 = xTrimOrder.VOR;
%     TrimSolutionSetUp.FCvars.FC2 = xTrimOrder.gammaT;
%     TrimSolutionSetUp.FCvars.FC3 = xTrimOrder.cs;
%     TrimSolutionSetUp.FCvars.FC4 = xTrimOrder.veOR;
%     TrimSolutionSetUp.FCvars.FC5 = xTrimOrder.vTOR;
% 
%     TrimSolutionSetUp.FCvalues.FC1val = FC1val;
%     TrimSolutionSetUp.FCvalues.FC2val = FC2val;
%     TrimSolutionSetUp.FCvalues.FC3val = FC3val;
%     TrimSolutionSetUp.FCvalues.FC4val = FC4val;
%     TrimSolutionSetUp.FCvalues.FC5val = FC5val;
%   
% end


end

function DefaultTrimSolutionSetUp = getDefaultTrimSolutionSetUp(xTrimOrder)

FC1 = xTrimOrder.VOR;
FC2 = xTrimOrder.gammaT;
FC3 = xTrimOrder.vTOR;
FC4 = xTrimOrder.veOR;
FC5 = xTrimOrder.cs;

FC1val = 0;
FC2val = 0;
FC3val = 0;
FC4val = 0;
FC5val = 0;

FCvars = struct('FC1',FC1,'FC2',FC2,'FC3',FC3,'FC4',FC4,'FC5',FC5);

FCvalues = struct('FC1val',FC1val,'FC2val',...
    FC2val,'FC3val',FC3val,'FC4val',FC4val,'FC5val',FC5val);

DefaultTrimSolutionSetUp = struct('FCvars',{FCvars},...
    'FCvalues',{FCvalues});

end
