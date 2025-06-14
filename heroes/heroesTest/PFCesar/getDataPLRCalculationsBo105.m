function [ PL R ] = getDataPLRCalculationsBo105
% GETDATAPLRBO105   Gets the pay load range data of Bo-105
%
%   [PL,R] = getDataPLRBo105 gets the pay load, PL, as a function of
%   range, R, of the Bo-105 helicopter with standard fuel according to the 
%   technical information reported in [1] page 39.
%
%   References
%   [1] Eurocopter, Technical Definition BO 105 LS A-3.
%
%    Example of usage
%
%   TODO
%   * digitise the other two weight configurations payload range diagrams
%   corresponding to one and two auxiliary fuel tanks. Add input argument
%   to define weight configuration accordingly.

% Digitize from [1] page XX
PLRdata = [ ...
  0.0         1093.00
  553.6       636.8
  628.0       0.0
];

km2m = 1e3;
kg2N = 9.81;

R  = PLRdata(:,1)*km2m;
PL = PLRdata(:,2)*kg2N;


