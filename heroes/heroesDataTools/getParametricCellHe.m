function cellHe = getParametricCellHe(he,parstr,parspan,varargin)
%getParametricCellHe  Gets a cell of helicopters from an helicopter
%                     by modifying parameters of it.
%                     
%
%   HEi = getParametricCellHe(HE,PARSTR,PARSPAN) gets a cell vector, HEi,
%   of helicopters of the same type than the input helicopter HE by
%   changing the parameter defined by the string PARSTR and assigning to
%   each slot of the cell vector of helicopters HEi the corresponding value
%   defined by the vector PARSPAN. Because most of the helicopter data
%   types at HEROES toolbox contains substructures, the string defining the
%   parameter to be modified should include dots to denote substructuring.
%
%   HEij = getParametricCellHe(HE,PARSTR1,PARSPAN1,PARSTR2,PARSPAN2) 
%   gets a cell array, HEij, of helicopters of the same type than the 
%   input helicopter HE by changing parameters, in a cartesian product
%   sense, defined by the strings PARSTR1 and PARSTR1 assigning to 
%   each slot of the cell array of helicopters HEij the corresponding
%   value defined by the vectors PARSPAN1 and PARSPAN2. 
%
%   Example of usage
%   Build up a vector of rigid helicopters by changing the length from 
%   the tail rotor hub to the fuselage reference point length, l_rt, 
%   of the Bo105 from Padfield assigning a variation from 90% upto 110% of
%   the nominal value. First we load atmosphere and helicopter, then 
%   define the vector of tail rotor lengths ltri and finally specify 
%   the parameter string as 'geometry.ltr'. Note that because this length 
%   is defined at the substructure geometry of the helicopter we are
%   required to denote it using the dot. Then use function 
%   getParametricCellHe to obtain the cell vector of rigid helicopters.
%
%   atm      = getISA;
%   he       = PadfieldBo105(atm);
%   ltri     = he.geometry.ltr*linspace(0.9,1.1,11);
%   ltrstr   = 'geometry.ltr';
%   he_i     = getParametricCellHe(he,ltrstr,ltri);
%
%   Function getParametricCellHe works with any other helicopter data type.
%   For instance, transform the previous rigid helicopter to a
%   nondimensional rigid helicopter, ndHe.
%
%   ndHe     = rigidHe2ndHe(he,atm,0);
%
%   Then build up a cell vector of nondimensional rigid helicopters 
%   by changing the nondimensional length, ndltr, from the hub of 
%   the tail rotor to the fuselage reference point in a consistent way.
%
%   ndltri   = ltri./he.mainRotor.R;
%   ndltrstr = 'geometry.ndltr';
%   ndHe_i   = getParametricCellHe(ndHe,ndltrstr,ndltri);
%
%   Now, we can transform the cell vector of dimensional helicopters to
%   nondimensional rigid helicopters using rigidHe2ndHe and compared the
%   resulting output with the previously built up ndhe_i cell vector just
%   to verify that each nondimensiona rigid ghelicopter of the cell is the
%   same (this assertion has been checked by visual inspection 
%   of geometry.ndltr field).
%
%   ndHe_j   = rigidHe2ndHe(he_i,atm,0);
%   ndHe_i{1}.geometry.ndltr-ndHe_j{1}.geometry.ndltr
%   
%   Build up a cell array of energy helicopters by changing the induced
%   power correction factor, kappa, and the average drag coefficient, cd0,
%   of the SuperPuma. 
%
%   atm      = getISA;
%   he       = superPuma(atm); 
%   kappai   = linspace(1.0,1.2,11);
%   parstri  = 'mainRotor.kappa';
%   cd0j     = linspace(0.01,0.03,5);
%   parstrj  = 'mainRotor.cd0';
%   heij     = getParametricCellHe(he,parstri,kappai,parstrj,cd0j);
% 
%   See also rigidHe2ndHe
%
%   TODO
%   * Rename function because this is a general pourpuse function. In fact,
%   this function inserts a vector of values in a structure with
%   substructures and returns
%   * For the moment being only cell array of ndims=2 are possible to
%   obtain because we consider just two string value pairs. We should
%   implement a version with an arbitrary number of varargin pairs (of
%   course this should beimplemente with a while-end loop of the varargin
%   arguments instead of hardcoding an exceptional high number of varargin
%   pairs)


if isempty(varargin)
    np         = length(parspan);

    % Allocate the cell of helicopters
    cellHe     = cell(size(parspan));

    for i=1:np
        % changing the parameter 
        S            = struct('type','.','subs',regexp(parstr,'\.','split'));
        cellHe{i}    = subsasgn(he, S, parspan(i)); 
    end
elseif length(varargin)==2
    parstr2 = varargin{1};
    parspan2 = varargin{2};
    nr         = length(parspan);
    nc         = length(parspan2);

    % Allocate the cell of helicopters
    cellHe     = cell(nr,nc);
    for i=1:nr
    for j=1:nc
        % changing the parameter 
        S1    = struct('type','.','subs',regexp(parstr,'\.','split'));
        he1   = subsasgn(he, S1, parspan(i)); 
        S2    = struct('type','.','subs',regexp(parstr2,'\.','split'));
        he2   = subsasgn(he1, S2, parspan2(j)); 
        cellHe{i,j} = he2;
    end
    end
else
   error('getParametricCellHe: wrong number of input arguments')
end

