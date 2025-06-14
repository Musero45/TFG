function tr = massBlade_mr2inertiaBlade_tr(mr,tr)

bm         = mr.bm;
R          = mr.R;
c          = mr.c0;
Rt         = tr.R;
ct         = tr.c0;
et         = tr.e;

% Mass blade of tail rotor considering the same mass blade per unit of
% lenght
bmt        = bm/(R*c)*(Rt*ct);

% Uniform mass blade per unit of length assumed. Blade center of gravity
% at the half of the blade length
xGB        = (Rt-et)/2;

% Mass inertia moments of the uniform blade
IBeta      = bmt*Rt^2/3;
ITheta     = bmt*Rt^2/12;
IZeta      = IBeta + ITheta;


% Change fields to the input tail rotor structure
tr.IBeta   = IBeta;
tr.ITheta  = ITheta;
tr.IZeta   = IZeta;
tr.xGB     = xGB;
tr.bm      = bm;

