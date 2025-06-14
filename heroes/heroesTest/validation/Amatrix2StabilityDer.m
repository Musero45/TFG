function A2SD = Amatrix2StabilityDer(ndHe,muWT,HelisimStabData,options,i)
%%
%   Amatrix2StabilityDer is used to obtain the Stability derivates from the
%   Stability Matrix A from [1]
% To see the configuration of the matrix and all its terms, take a look to
% the function HelisimBo105StabilityMatrices.
%
%   [1] G.D. Padfield Helicopter Flight Dynamics 2007 (2nd edition)
%
% TODO
% This is an almost ready general function to transform a stability matrix
% A into a Stability derivatives components. The problem is how to deal
% with the index i (which it seems directly bad programming) and
% HelisimStabData. For the moment being, we use it and in the near future
% we'll discuss how to improve it.
%
%

SM={@SMBo105,@SMLynx,@SMPuma};
[V,VOR,SM{i}] = HelisimStabData();
A2SD.V = V;
A2SD.VOR = VOR;
%%
% This section of the code is used to calculate the trim variables 'ue',
% 've' and 'we' that we will need to obtain the real values for the stability
% derivates which are shown in the matrix of [1]. The configuration of the
% values in the Padfield Matrix are in page 277 of [1]
% To know more about the Stability Matrix and its components, take a look
% to the function HelisimBo105StabilityMatrices.

FC            = {'VOR',VOR,...
                 'betaf0',0,...
                 'wTOR',0,...
                 'cs',0,...
                 'vTOR',0};
ndts          = getNdHeTrimState(ndHe,muWT,FC,options);

ueOR = ndts.solution.ueOR;
veOR = ndts.solution.veOR;
weOR = ndts.solution.weOR;
%%
L=length(V);

Fx_u = zeros(1,L);
Fx_w = zeros(1,L);
Fx_omy = zeros(1,L);
Fx_The = zeros(1,L);
Fx_v = zeros(1,L);
Fx_omx = zeros(1,L);
Fx_Phi = zeros(1,L);
Fx_omz = zeros(1,L);

Fz_u = zeros(1,L);
Fz_w = zeros(1,L);
Fz_omy = zeros(1,L);
Fz_The = zeros(1,L);
Fz_v = zeros(1,L);
Fz_omx = zeros(1,L);
Fz_Phi = zeros(1,L);
Fz_omz = zeros(1,L);

My_u = zeros(1,L);
My_w = zeros(1,L);
My_omy = zeros(1,L);
My_The = zeros(1,L);
My_v = zeros(1,L);
My_omx = zeros(1,L);
My_Phi = zeros(1,L);
My_omz = zeros(1,L);

Fy_u = zeros(1,L);
Fy_w = zeros(1,L);
Fy_omy = zeros(1,L);
Fy_The = zeros(1,L);
Fy_v = zeros(1,L);
Fy_omx = zeros(1,L);
Fy_Phi = zeros(1,L);
Fy_omz = zeros(1,L);

Mx_u = zeros(1,L);
Mx_w = zeros(1,L);
Mx_omy = zeros(1,L);
Mx_The = zeros(1,L);
Mx_v = zeros(1,L);
Mx_omx = zeros(1,L);
Mx_Phi = zeros(1,L);
Mx_omz = zeros(1,L);

Mz_u = zeros(1,L);
Mz_w = zeros(1,L);
Mz_omy = zeros(1,L);
Mz_The = zeros(1,L);
Mz_v = zeros(1,L);
Mz_omx = zeros(1,L);
Mz_Phi = zeros(1,L);
Mz_omz = zeros(1,L);

%%
for j=1:L
    
    Fx_u(j)     = SM{i}(1,1,j);
    Fx_w(j)     = SM{i}(1,2,j);
    Fx_omy(j)   = SM{i}(1,3,j) - weOR(j);
    Fx_The(j)   = SM{i}(1,4,j);
    Fx_v(j)     = SM{i}(1,5,j);
    Fx_omx(j)   = SM{i}(1,6,j);
    Fx_Phi(j)   = SM{i}(1,7,j);
    Fx_omz(j)   = SM{i}(1,L,j) + veOR(j);
    
    Fz_u(j)     = SM{i}(2,1,j);
    Fz_w(j)     = SM{i}(2,2,j);
    Fz_omy(j)   = SM{i}(2,3,j) + ueOR(j);
    Fz_The(j)   = SM{i}(2,4,j);
    Fz_v(j)     = SM{i}(2,5,j);
    Fz_omx(j)   = SM{i}(2,6,j) - veOR(j);
    Fz_Phi(j)   = SM{i}(2,7,j);
    Fz_omz(j)   = SM{i}(2,8,j);
    
    My_u(j)     = SM{i}(3,1,j);
    My_w(j)     = SM{i}(3,2,j);
    My_omy(j)   = SM{i}(3,3,j);
    My_The(j)   = SM{i}(3,4,j);
    My_v(j)     = SM{i}(3,5,j);
    My_omx(j)   = SM{i}(3,6,j);
    My_Phi(j)   = SM{i}(3,7,j);
    My_omz(j)   = SM{i}(3,8,j);
    
    Fy_u(j)     = SM{i}(5,1,j);
    Fy_w(j)     = SM{i}(5,2,j);
    Fy_omy(j)   = SM{i}(5,3,j);
    Fy_The(j)   = SM{i}(5,4,j);
    Fy_v(j)     = SM{i}(5,5,j);
    Fy_omx(j)   = SM{i}(5,6,j) + weOR(j);
    Fy_Phi(j)   = SM{i}(5,7,j);
    Fy_omz(j)   = SM{i}(5,8,j) -ueOR(j);
    
    Mx_u(j)    = SM{i}(6,1,j);
    Mx_w(j)    = SM{i}(6,2,j);
    Mx_omy(j)  = SM{i}(6,3,j);
    Mx_The(j)  = SM{i}(6,4,j);
    Mx_v(j)    = SM{i}(6,5,j);
    Mx_omx(j)  = SM{i}(6,6,j);
    Mx_Phi(j)  = SM{i}(6,7,j);
    Mx_omz(j)  = SM{i}(6,8,j);
    
    Mz_u(j)    = SM{i}(8,1,j);
    Mz_w(j)    = SM{i}(8,2,j);
    Mz_omy(j)  = SM{i}(8,3,j);
    Mz_The(j)  = SM{i}(8,4,j);
    Mz_v(j)    = SM{i}(8,5,j);
    Mz_omx(j)  = SM{i}(8,6,j);
    Mz_Phi(j)  = SM{i}(8,7,j);
    Mz_omz(j)  = SM{i}(8,8,j);
    
end
A2SD.Fx_u = Fx_u;
A2SD.Fx_w = Fx_w;
A2SD.Fx_omy = Fx_omy;
A2SD.Fx_The = Fx_The;
A2SD.Fx_v = Fx_v;
A2SD.Fx_omx = Fx_omx;
A2SD.Fx_Phi = Fx_Phi;
A2SD.Fx_omz = Fx_omz;

A2SD.Fz_u = Fz_u;
A2SD.Fz_w = Fz_w;
A2SD.Fz_omy = Fz_omy;
A2SD.Fz_The = Fz_The;
A2SD.Fz_v = Fz_v;
A2SD.Fz_omx = Fz_omx;
A2SD.Fz_Phi = Fz_Phi;
A2SD.Fz_omz = Fz_omz;

A2SD.My_u = My_u;
A2SD.My_w = My_w;
A2SD.My_omy = My_omy;
A2SD.My_The = My_The;
A2SD.My_v = My_v;
A2SD.My_omx = My_omx;
A2SD.My_Phi = My_Phi;
A2SD.My_omz = My_omz;

A2SD.Fy_u = Fy_u;
A2SD.Fy_w = Fy_w;
A2SD.Fy_omy = Fy_omy;
A2SD.Fy_The = Fy_The;
A2SD.Fy_v = Fy_v;
A2SD.Fy_omx = Fy_omx;
A2SD.Fy_Phi = Fy_Phi;
A2SD.Fy_omz = Fy_omz;

A2SD.Mx_u = Mx_u;
A2SD.Mx_w = Mx_w;
A2SD.Mx_omy = Mx_omy;
A2SD.Mx_The = Mx_The;
A2SD.Mx_v = Mx_v;
A2SD.Mx_omx = Mx_omx;
A2SD.Mx_Phi = Mx_Phi;
A2SD.Mx_omz = Mx_omz;

A2SD.Mz_u = Mz_u;
A2SD.Mz_w = Mz_w;
A2SD.Mz_omy = Mz_omy;
A2SD.Mz_The = Mz_The;
A2SD.Mz_v = Mz_v;
A2SD.Mz_omx = Mz_omx;
A2SD.Mz_Phi = Mz_Phi;
A2SD.Mz_omz = Mz_omz;

