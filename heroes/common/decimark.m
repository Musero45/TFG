function h=decimark(x,y,r,legtxt,linestyle)
% Decimate and mark
%
% h=decimark(x,y,r,legtxt,linestyle)
%
% Arguments:
%  (x,y)     : coordinates for data to be plotted
%  r         : number of markers to be plotted, default=10
%  legtxt    : legend text (char array or cell array), optional
%  linestyle : linestyles (cell array), optional
%
% Outputs:
%  h        : handles to plotted lines and markers
%
% Example:
%  t = 0:0.001:2*pi;
%  y = [sin(t)' cos(t)'];
%  decimark(t,y,10,{'sin', 'cos'})
%
% See also: plot, legend, decimate

% 2000.04.18 (revised 2000.05.08)
% Lars Gregersen <lars.greger...@it.dk>
% With help and input from:
%  Yasushi KONDO <yko...@eco.toyama-u.ac.jp>
%  Jordan Rosenthal <j...@ece.gatech.edu>
%  Jehudi Maes <Jehudi.M...@rug.ac.be>

if ~exist('r','var') | isempty(r)
  r = 10;
end

if ~exist('legtxt','var')
  legtxt = [];
end

% handle row vector arguments x and y
if size(x,1)==1
  x = x(:);
end
if size(y,1)==1
  y = y(:);
end

if (iscell(legtxt) & length(legtxt)>size(y,2)) | ...
    (ischar(legtxt) & size(legtxt,1)>size(y,2))
    error('Too many elements of text specified for the legend')
end    

if ~exist('linestyle','var')
  linestyle = {'-'};
end

% The following code find the indices into x and y to
% use for the markers
numcol = size(y,2);
step = length(x)/r;
idx = floor(1:step:length(x));
remain = (1:numcol)/numcol*(length(x)-max(idx));
ycol = (0:numcol-1)*length(x);
xx = repmat(idx',1,numcol)+remain(ones(length(idx),1),: );
%myoscar
xx = round(xx);

% Use these markers
markers = 'ox+*sdv^<>ph';

% Plot the markers as lines with the same starting and end point
% For now simply use 'o' as markers (this will be changed later).
h = plot(kron(x(xx),[1;1;nan]),...
  kron(y(xx+ycol(ones(length(idx),1),:)),[1;1;nan]),...
  'o',...
  x, y);

for i=1:numcol
  set(h(numcol+i), 'color', get(h(i), 'color'))
  set(h(i), ...
    'marker',markers(i), ...
    'linestyle',linestyle{rem(i-1,length(linestyle))+1})
  set(h(numcol+i),'linestyle',linestyle{rem(i-1,length(linestyle))+1})
end

if ~isempty(legtxt)
  if iscell(legtxt)
    legend(legtxt{:})
  else
    legend(legtxt)
  end
end

if nargout==0
  clear h
end 
