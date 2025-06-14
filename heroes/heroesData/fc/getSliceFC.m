function fcOut = getSliceFC(idx,fcIn)
%getSliceFC  Slice flight conditions
%
%   G = getFlightCondition(I,F) slices the I index of the flight condition 
%   F. A slice of a flight condition consists is a scalar flight condition
%   corresponding to the index I. Because linear indexing is used this
%   method is valid not only for vector flight conditions but also for
%   n-dimensional matrix flight conditions.
%
%   Examples of usage:
%   First create a vector flight condition. For instance build up a flight
%   contiion for a super puma helicopter in level flight at sea level
%   alitude, MTOW of gross weight and maximum fuel mass.
%   a     = getISA;
%   he    = superPuma(a);
%   nv    = 5;
%   v     = linspace(0,100,nv);
%   fc1d  = getFlightCondition(he,'V',v);
%
%   Now, get one scalar flight condition corresponding to index 3:
%   fc3   = getSliceFC(3,fc1d);
%
%   Then constructs a 2-dimensional matrix flight condition by especifying
%   altitude together with velocity
%   nh    = 3;
%   h     = linspace(0,1000,nh);
%   [H,V] = ndgrid(h,v);
%   fc2d  = getFlightCondition(he,'V',V,'H',H);
%
%   Now, get one scalar flight condition corresponding to subscrip 
%   values(2,3):
%   ind23 = sub2ind(size(H),2,3);
%   fc23  = getSliceFC(ind23,fc2d);
%
%   TODO
%
%


fields = fieldnames(fcIn);
nf     = length(fields);
data   = struct2cell(fcIn);

% Allocate output structure
fcOut  = [];

for i = 1:nf
    fcOut.(fields{i})  = data{i}(idx);
end
