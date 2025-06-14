function varargout = plotStructureNdMatrix(X,AXDS,AYDS,zvars,options)
% plotStructureNdMatrix             plots a Cell of Structures With Matrix 
%                                   Fields (COSWMF) or a Structure With 
%                                   Matrix Fields (SWMF)
%
% COSWMF := {s.m} being s and structure and m an arbitrary fieldname with
% matrix contents
% SWMF := s.m being s and structure and m an arbitrary fieldname with
% matrix contents
%
% We need to guarantee that zvars is a structure because we do not want to
% especify several sets of zvars as it happens in AXDS and AYDS
% if iscell(zvars)
%    zvars = zvars{1};
% end


if isempty(AYDS) || iscell(AYDS)
   mode = '2d';
else
   mode = '3d';
end
% if iscell(zvars.var)==1
%    sx = size(X.(zvars.var{1}));
% elseif ischar(zvars.var)==1
%    sx = size(X.(zvars.var));
% end


% % % % % % % % if min(sx) == 1 % power state fields are vectors
% % % % % % % %    mode = '2d';
% % % % % % % % elseif min(sx) > 1 % power state fields are matrices
% % % % % % % %    mode = '3d';
% % % % % % % % end



% if isstruct(zvars)
%    Zvars = {zvars};
% elseif iscell(zvars)
%    Zvars = zvars;
% end


% if min(sx) == 1 % power state fields are vectors
if strcmp(mode,'2d')
   if iscell(X) % Cell to be plot using plotCellOfStructures
       % watchout this statement is to explicitly state that in 
       % this functioning mode the AYDS argument is a cell of legends and
       % this is responsability of the user
       leg = AYDS;
       ax  = plotCellOfStructures(X,AXDS,zvars,leg,options);
   elseif isstruct(X)
       if strcmp(options.plot2dMode,'oneFigure') == 1
          ax  = plot2dStructure(X,AXDS,zvars,options);
       elseif strcmp(options.plot2dMode,'nFigures') == 1
          % Because plotCellOfStructures expects that X is a cell
          if isstruct(X)
             X = {X};
          end
          ax  = plotCellOfStructures(X,AXDS,zvars,[],options);
       else
          error('PLOTNDEPOWERSTATE: wrong value for plot2dMode')
       end
    else
          error('PLOTNDEPOWERSTATE: wrong X data type')
    end
% elseif min(sx) > 1 % power state fields are matrices
elseif strcmp(mode,'3d') % power state fields are matrices
   ax  = plot3dStructure(X,AXDS,AYDS,zvars,options);
end

if nargout == 1
   varargout{1} = ax;
end
