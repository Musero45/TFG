function options = setArmoniaOptions
%  SETARMONIAOPTIONS Defines the default options of ARMONIA
%     
%  OPTIONS = SETARMONIAOPTIONS returns the default options
%  structure of ARMONIA, OPTIONS. The default structure is:
%
%          bemFunction: @bemthb
%                 drag: 'on'
%     pressureDropWake: 'on'
%             tip_loss: @prandtl
%            root_loss: @prandtl
%         bemBreakdown: @wilsonLissaman
%        bemBreakParam: 1.6000
%         bemInitGuess: 'smart'
%             niSolver: @qtrapz
%          integration: 'trapz'
%         nAzimutCycle: 31
%               nCycle: 1
%             umSolver: @fminsearch
%             nlSolver: @fsolve
%            odeSolver: @odeNewmark
%        newmarkParams: [1/6 1/2]
%               TolFun: 1.0000e-06
%              MaxIter: 400
%
%  bemFunction - BEM function [ {@bemmt} | @bemthb | @bemmt_rm ] 
%     This function handle specifies the function used to compute
%     the induced coefficients, a, ap and f.
%
%  drag - BEM computation including drag [ {'on'} | 'off' ] 
%
%  pressureDropWake - Drop of pressure due to wake rotation  [ {'on'} | 'off' ]
%     This string defines whether the drop of pressure due to wake rotation
%     should be considered in the BEM calculations.
%
%  tip_loss - Tip loss model  [ @none | {@prandtl} ]
%     Tip_loss is funtion handle which defines the kind of 
%     tip loss function to be used in the BEM calculations. 
%     Currently only the Prandtl model is considered.
%
%  root_loss - Tip loss model  [ @none | {@prandtl} ]
%     root_loss defines the kind of root loss function to be used in the
%     BEM calculations. Currently only the Prandtl model is considered.
%
%  bemBreakdown - Breakdown function of BEM  [ {@wilsonLissaman} | @wilsonWalker ]
%     This function handle defines the function that describes the 
%     breakdown of momentum theory. The available functions are:
%        * @wilsonLissaman is the one presented in Wind Energy Handbook pg 67.
%          Basically, the following model is implemented:
%            if a < 1 -1/2*sqrt(CT1)
%               CT   = 4*a*(1-a);
%            else
%               CT   = CT1 - 4*(sqrt(CT1)-1)*(1-a);
%            end 
%
%          If CT1 is set to 0 then there is no modification of BEM due to 
%          flow separation. CT1 should be set to 1.8 or 1.6 to correctly 
%          model the thrust coefficient. The last value of 1.6 is the 
%          recommended value which is the default value. CT1 can be set
%          using the bemBreakParameter option.
%
%        * @wilsonWalker is the function presented in Aerodynamics of Wind
%          Wind Turbines pg 53. The implemented model is:
%            if a <= ac
%               CT   = 4*a*(1-a);
%            else
%               CT   = 4*(ac^2 + (1-2*ac)*a);
%            end 
%
%          ac can be set using the bemBreakParameter option.
%
%  bemBreakParameter - Parameter of BEMT breakdown [ {1.6} | float number ]
%     This parameter defines the input parameter of the bemBreakdown function
%     habdle. If the Wilson and Lissaman model is used, bemBreakParameter
%     should be set to acceptable values of CT1 such as 1.6 or 1.8. If
%     Wilson and Walker model is set then bemBreakParameter should be set
%     to acceptable values of ac such as 0.2 or so.
%
%  bemInitGuess - String [ {'smart'} | 'standard' ]
%     TO BE DOCUMENTED
%
%  niSolver - Numerical Integration Solver string [ {qtrapz} | quad | quadl ]
%     This field defines the numerical integration string used to integrate
%     functions defined at discrete points. Performancewise it seems that
%     there is no big difference between trapz and quad.
%
%  integration - Integration of blade loads  [ {'trapz'} | 'fem' ]
%     In order to obtain the root blade loads or blade load at 
%     a particular point of the blade the loads per unit of length
%     computed by BEM theory sould be integrated. The 'trapz' uses
%     the trapezoidal rule ton integrate the forces. The 'fem' option
%     uses the FEM to compute the blade loads. --FIXME-- PLEASE NOTE 
%     THAT NOT ALL THE COMPUTATIONS ALLOW THE FEM INTEGRATION BECAUSE 
%     CURRENTLY THEY ARE NOT IMPLEMENTED
%
%  nAzimutCycle - Number of azimut angles per cycle of rotor 
%     [ {31} | integer | [az(1) az(2)] | [az(1) az(2) az(3)] | [double] ]
%     This integer defines the number of azimut angles to be computed
%     when modelling one rotor cycle. 
%       When a vector of length two, i.e. [az(1) az(2)], is given then a 
%       set of 31 azimuthal angles are defined between az(1) and az(2)
%       When a vector of length three, i.e. [az(1) az(2) az(3)], is given then a 
%       set of az(3) azimuthal angles are defined between az(1) and az(2)
%       When a vector of length greater than 3, i.e. [double], is given then
%       this vector is used as azimuthal angles.
%
%  nCycle - Number cycles rotor 
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
%  TolFun - Tolerance of function [ {1e-12} | float number]
%
%  MaxIter - Maximum numer of iterations [ {400} | integer ]
%
% FIXME DOC NEED UPDATE


% These are the options set by default
options = struct(...
             'bemFunction',@bemthb,...           [bemthb | bemtaerodyn | bemmt]
             'drag','on',             ...        [ on       | off ]
             'pressureDropWake','off', ...       [ on       | off ]
             'tip_loss',@none,   ...             [ @none    | {@prandtl} ]
             'root_loss',@none,  ...             [ @none    | {@prandtl} ]
             'bemBreakdown',@buhl,...            [ {@wilsonLissaman} | {@wilsonWalker}]
             'bemBreakParam',[], ...             [ 1.6      | double]
             'bemInitGuess','standard', ...         [ {smart}  | 'standard']
             'niSolver',@qtrapz, ...             [ quad     | {qtrapz} ]
             'integration','trapz', ...          [ trapz    | fem]
             'nAzimutCycle',31, ...              [ 31       | integer ]
             'nCycle',1, ...                     [ 2        | integer ]
             'umSolver',@fminsearch,...          [ {@fminsearch} | @fminunc]
             'nlSolver',@fsolve,...              [ {fsolve} | newton_raphson | newton_raphson_m]
             'odeSolver',@ode45,...              [ odeNewmark | ode45 | ode23 | ode15s ... ]
             'newmarkParams',[1/6,1/2], ...      [ [1/6,1/2]]
             'TolFun',1e-12, ...                 [ 1e-6     | float number ]
             'MaxIter',400 ...                   [ 400      | integer ]
);

