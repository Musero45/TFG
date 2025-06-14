function F = getNonLinearDynamicsEquations(t,x,control,muWT,y0,ndHe,options)
% getNonLinearDynamicsEquation connects getStabilityEquations with
% getndHeNonLinearDynamics making it possible to integrate the differential
% equation of the Non-linear problem, by giving the value of F as:
% 
%                         F(x,u,t)= dx/dt
% 
% with x the state vector x = [u,w,oy,Th,v,ox,Ph,ox,Ps] ordered in longitu-
% dinal-lateral order and u = [t0,t1S,t1C,t0tr] the control vector ordered
% in the same way
% It also includes the equations for obtaining the trajectory solution
% 
% ----------------OUTPUTS---------------
% F1 = (du/dt)       |     F5 = (dv/dt)
% F2 = (dw/dt)       |     F6 = (dox/dt)
% F3 = (doy/dt)      |     F7 = (dPh/dt)
% F4 = (dTh/dt)      |     F8 = (doz/dt)
%                    |     F9 = (dPs/dt)
% 
% ******* Additional Outputs: Trajectory *********
%           F10 = (dxT/dt) = uTOR
%           F11 = (dyT/dt) = vTOR
%           F12 = (dzT/dt) = wTOR
% ************************************************

% Wind vector to body axes
Psi    = x(9);
Theta  = x(4);
Phi    = x(7);

MFT    = TFT(Psi,Theta,Phi);

muWV = MFT*muWT;

StabEqSolution = getStabilityEquations (t,x(1:9),control,muWV,y0,ndHe,options);
F              = zeros(12,1);

for i = 1:9
    F(i,1) = StabEqSolution(i);
end

%  TRAJECTORY
invMFT   = transpose(MFT);

VelTOR   = invMFT*[x(1) x(5) x(2)]';
F(10,1)  = VelTOR(1);
F(11,1)  = VelTOR(2);
F(12,1)  = VelTOR(3);

end

