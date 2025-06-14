function zVars = selectPostVars(X)


if iscell(X)
   if length(size(X))==2
      mode  = X{1,1}.type;
   else
      mode  = X{1}.type;
   end
elseif isstruct(X)
   mode  = X.type;
end

switch lower(mode)
   case 'bladestate'
     zVars = setBladeStateVars;

   otherwise
     error('SELECTPOSTVARS: unknown output mode')
end

