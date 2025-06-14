function h = getCurrentFigureNumber

h   = get(0,'CurrentFigure');
if isempty(h)
   h  = 0;
elseif isobject(h)
   % this elseif statement checks that figure is an object
   % This check is required from Matlab versions onwards 2015b
   h  = h.Number; 
end
