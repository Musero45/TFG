function B2CD = Bmatrix2ControlDer(HelisimContData,i)

%%
%   Bmatrix2ControlDer is used to obtain the Control derivates from the
%   Control Matrix B from [1]
% To see the configuration of the matrix and all its terms, take a look to
% the function HelisimBo105ControlMatrices.
%
%   [1] G.D. Padfield Helicopter Flight Dynamics 2007 (2nd edition)
%
%%
CM{i}={@CMBo105,@CMLynx,@CMPuma};
[V,VOR,CM{i}] = HelisimContData();

B2CD.V = V;
B2CD.VOR = VOR;

L=length(V);

Fx_t0 = zeros(1,L);
Fx_t1S = zeros(1,L);
Fx_t1C = zeros(1,L);
Fx_t0tr = zeros(1,L);

Fz_t0 = zeros(1,L);
Fz_t1S = zeros(1,L);
Fz_t1C = zeros(1,L);
Fz_t0tr = zeros(1,L);

My_t0 = zeros(1,L);
My_t1S = zeros(1,L);
My_t1C = zeros(1,L);
My_t0tr = zeros(1,L);

Fy_t0 = zeros(1,L);
Fy_t1S = zeros(1,L);
Fy_t1C = zeros(1,L);
Fy_t0tr = zeros(1,L);

Mx_t0 = zeros(1,L);
Mx_t1S = zeros(1,L);
Mx_t1C = zeros(1,L);
Mx_t0tr = zeros(1,L);

Mz_t0 = zeros(1,L);
Mz_t1S = zeros(1,L);
Mz_t1C = zeros(1,L);
Mz_t0tr = zeros(1,L);


for j=1:L
    
    Fx_t0(j)     = CM{i}(1,1,j);
    Fx_t1S(j)    = CM{i}(1,2,j);
    Fx_t1C(j)    = CM{i}(1,3,j); 
    Fx_t0tr(j)   = CM{i}(1,4,j);
    
    Fz_t0(j)     = CM{i}(2,1,j);
    Fz_t1S(j)    = CM{i}(2,2,j);
    Fz_t1C(j)    = CM{i}(3,3,j); 
    Fz_t0tr(j)   = CM{i}(3,4,j);  
    
    My_t0(j)     = CM{i}(3,1,j);
    My_t1S(j)    = CM{i}(3,2,j);
    My_t1C(j)    = CM{i}(3,3,j); 
    My_t0tr(j)   = CM{i}(3,4,j);
    
    Fy_t0(j)     = CM{i}(5,1,j);
    Fy_t1S(j)    = CM{i}(5,2,j);
    Fy_t1C(j)    = CM{i}(5,3,j); 
    Fy_t0tr(j)   = CM{i}(5,4,j);
    
    Mx_t0(j)    = CM{i}(6,1,j);
    Mx_t1S(j)   = CM{i}(6,2,j);
    Mx_t1C(j)   = CM{i}(6,3,j); 
    Mx_t0tr(j)  = CM{i}(6,4,j);
    
    Mz_t0(j)    = CM{i}(8,1,j);
    Mz_t1S(j)   = CM{i}(8,2,j);
    Mz_t1C(j)   = CM{i}(8,3,j); 
    Mz_t0tr(j)  = CM{i}(8,4,j);
    
end
B2CD.Fx_t0 = Fx_t0;
B2CD.Fx_t1S = Fx_t1S;
B2CD.Fx_t1C = Fx_t1C;
B2CD.Fx_t0tr = Fx_t0tr;

B2CD.Fz_t0 = Fz_t0;
B2CD.Fz_t1S = Fz_t1S;
B2CD.Fz_t1C = Fz_t1C;
B2CD.Fz_t0tr = Fz_t0tr;

B2CD.My_t0 = My_t0;
B2CD.My_t1S = My_t1S;
B2CD.My_t1C = My_t1C;
B2CD.My_t0tr = My_t0tr;

B2CD.Fy_t0 = Fy_t0;
B2CD.Fy_t1S = Fy_t1S;
B2CD.Fy_t1C = Fy_t1C;
B2CD.Fy_t0tr = Fy_t0tr;

B2CD.Mx_t0 = Mx_t0;
B2CD.Mx_t1S = Mx_t1S;
B2CD.Mx_t1C = Mx_t1C;
B2CD.Mx_t0tr = Mx_t0tr;

B2CD.Mz_t0 = Mz_t0;
B2CD.Mz_t1S = Mz_t1S;
B2CD.Mz_t1C = Mz_t1C;
B2CD.Mz_t0tr = Mz_t0tr;
