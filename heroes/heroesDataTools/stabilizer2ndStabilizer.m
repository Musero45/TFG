function s = stabilizer2ndStabilizer(stabilizer,R)
%STABILIZER2NDSTABILIZER  Transforms a dimensional stabilizer into a nondimensional one
%
%   P = STABILIZER2NDSTABILIZER(S,R) computes a nondimensional stabilizer P from a
%   dimensional stabilizer S.
%

% stabilizer data
c       = stabilizer.c;          
S       = stabilizer.S;            

% trim state
active  = stabilizer.active;

% Nondimensional variables
ndc = c/R;
ndS = S/(pi*R^2);



s     = struct(...
        'active',active,...
        'airfoil',stabilizer.airfoil,...
        'type',stabilizer.type,...
        'ndc',ndc,...
        'ndS',ndS,...
        'theta',stabilizer.theta,...
        'ks', stabilizer.ks...
);