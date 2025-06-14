function r =rotor2ndRotor(rotor)
%ROTOR2NDROTOR  Transforms a dimensional rotor into a nondimensional one
%
%   P = ROTOR2NDROTOR(R) computes a nondimensional rotor P from a
%   dimensional rotor R.
%


% rotor data
R     = rotor.R;
c     = rotor.c;
b     = rotor.b;
eta   = rotor.eta;  

% Nondimensional variables
sigma  = c*b/(pi*R);
cd0    = rotor.cd0;
CQ00   = sigma*cd0/8;
kappa  = rotor.kappa;
K      = rotor.K;
cldata = rotor.cldata;
cddata = rotor.cddata;

r     = struct(...
        'eta',eta,...
        'sigma',sigma,...
        'cd0',cd0,...
        'cldata',cldata, ...
        'cddata',cddata, ...
        'CQ00',CQ00,...
        'kappa',kappa,...
        'K',K ...
);
