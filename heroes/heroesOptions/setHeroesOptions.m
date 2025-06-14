function options = setHeroesOptions
%  SETHEROESOPTIONS Defines the default options of HEROES
%     
%  OPTIONS = SETHEROESOPTIONS returns the default options
%  structure of HEROES, OPTIONS. The default structure is:
%
%             niSolver: @qtrapz
%             umSolver: @fminsearch
%             nlSolver: @fsolve
%            odeSolver: @odeNewmark
%        newmarkParams: [1/6 1/2]
%               TolFun: 1.0000e-06
%              MaxIter: 400
%
%  niSolver - Numerical Integration Solver string [ {qtrapz} | quad | quadl ]
%     This field defines the numerical integration string used to integrate
%     functions defined at discrete points. Performancewise it seems that
%     there is no big difference between trapz and quad.
%
%  umSolver - Unconstrained Minimizer Solver function [ {fminsearch} |fminunc]
%     This field defines the solver function_handle used to solve
%     uncontrained minimization problems. 
%
%  nlSolver - Non Linear Solver function [ {fsolve} | newton_raphson | newton_raphson_m]
%     This field defines the solver function_handle used to solve
%     non linear algebraic equations. 
%
%  odeSolver - ODE Solver [ {ode45} | odeNewmark ]
%     This field defines the function_handle to solve a system of ordinary
%     equations. The form of the ode system 
%
%  newmarkParams - Parameters of Newmark integrator [{[1/6,1/2]} | double]
%     This field defines the values of parameters of the newmark
%     method. newmarkParams(1) corresponds to beta, and newmarkParams(2)
%     to gamma. 
%     Method        Type beta     gamma     Stability          Order of
%                                           condition          accuracy
%     -----------   ---- -------  -----     ------------------ --------
%     Trapezoidal   I    1/4      1/2       Unconditional       2
%     linear acce   I    1/6      1/2       \Omega_c=2*sqrt(3)  2
%     Fox-Goodwin   I    1/12     1/2       \Omega_c=sqrt(6)    2
%     Central-diff  E    0        1/2       \Omega_c=2          2
%     Newmark       (1)  b1       >1/2      Unconditional       1
%     Newmark       (2)  >gamma/2 >1/2      Unconditional       1
%     -----------   ---- -------  -----     ------------------ --------
%     I implicit
%     E explicit
%     b1 = 1/4*(gamma+1/2)^2
%     (1) Maximizes the dissipation at high frequencies
%     \Omega_c = (xi*(gamma-1/2)+sqrt(gamma/2-beta+xi^2*(gamma-1/2)^2))/(gamma/2-beta)
%
%     (2) gamma > 1/2 induces numerical dissipation at high frequencies
%     Feap uses as default values: beta = 1/4 gamma = 1/2
%     Moreover remember that mass matrix definition affects the numerical 
%     integration of the equations. See matched method Hughes pg. 510 
%     (one matched method is: lumped mass + central difference )
%     A quite common choice of newmark parameters to give numerical dissipation
%     at high frequencies is:
%     beta  = [0.3025]; gamma = [0.6];
%
%  TolFun - Tolerance of function [ {1e-6} | float number]
%
%  MaxIter - Maximum numer of iterations [ {400} | integer ]
%
% FIXME DOC NEED UPDATE


% These are the options set by default
options = struct(...
             'niSolver',@qtrapz, ...             [ quad     | {qtrapz} ]
             'umSolver',@fminsearch,...          [ {@fminsearch} | @fminunc]
             'nlSolver',@fsolve,...              [ {fsolve} | newton_raphson | newton_raphson_m]
             'odeSolver',@ode45,...              [ odeNewmark | ode45 | ode23 | ode15s ... ]
             'newmarkParams',[1/6,1/2], ...      [ [1/6,1/2]]
             'TolFun',1e-12, ...                  [ 1e-6     | float number ]
             'TolX',1e-12, ...
             'Display','off', ...                ['off' | 'final' | 'iter' ...]
             'MaxIter',400 ...                   [ 400 | integer ]
);