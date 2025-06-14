function [nu,vOut] = glauertForward1_ma(v,alpha)
%
%   TODO compute a particular function to compute the two branches
%   corresponding to the vertical descend condition, i.e. alpha = pi/2
%
%   Example of usage
%   Plot Figure 3.11 at page 109 of the Teoria de los Helicopteros book
%
%   alphaDM    = 180/pi*asin(sqrt(8/9));
%   nv  = 501;
%   v = linspace(0,5,nv);
%   alphaD = [-90,-30,0,30,60,alphaDM,80];
%   na    = length(alphaD);
%   nu    = zeros(na,nv);
%   vu    = zeros(na,nv);
%   leg   = cell(1,na);
%   for i=1:na
%       [nu(i,:),vu(i,:)] = glauertForward1_ma(v,pi/180*alphaD(i));
%       leg{i} = strcat('\alpha = ',num2str(alphaD(i)));
%   end
%   mark   = {'r-','b-.','k--','m--.','g:.','r-*','b-+'};
%   figure(1)
%   for i=1:na
%       plot(vu(i,:),nu(i,:),mark{i}); hold on;
%   end
%   legend(leg)
%
%
%   The following lines add horizontal tangent points and vertical
%   tangents
%   alphaPositives = alphaD > 0;
%   [Vmax,nuMax] = getHtg_gf1ma(pi/180*alphaD(alphaPositives));
%   [VtgV,nutgV] = getVtg_gf1ma(pi/180*alphaD(alphaPositives));
%   plot(Vmax,nuMax,'r-p'); hold on;
%   plot(VtgV(1,:),nutgV(1,:),'b-s'); hold on;
%   plot(VtgV(2,:),nutgV(2,:),'r-s')
%


% Value of alpha at which a first vertical tangent appears
alphaM    = asin(sqrt(8/9));


if alpha < alphaM
    % Normal solution, i.e. obtain the maximum real and positive root of
    % a fourth order polynomial
    nu    = tcmModuloNormal(v,alpha);
    vOut  = v;

else
    % Particular solution when vertical tangents appear and multiple
    % solutions can exist. Thestrategy consists of bifurcates the code
    % into two regions: regionA and regionB

    % Compute the horizontal tangent of the curve (point A1)
    % This point is the border between regionA and regionB
    [V1,n1]  = getHtg_gf1ma(alpha);

    % regionA is the normal solution, i.e. for each v there exists one and
    % only one nu solution
    % regionB is the inverse solution, i.e. for each nu there exists one
    % and only one v solution
    regionA   = v <  V1;
    regionB   = v >= V1;

    if ~isempty(v(regionA))
       nu(regionA)    = tcmModuloNormal(v(regionA),alpha);
       vOut(regionA)  = v(regionA);
    end


    if ~isempty(v(regionB))
       np            = length(v(regionB));

       % compute vertical tangent points A_2 and A_3 coordinates
       % A2 is the vertical tangent with maximum V/vi0
       % A3 is the vertical tangent with manimum V/vi0
       VtgV  = getVtg_gf1ma(alpha);

       % Vertical tangent with maximum V/vi0
       V2       = max(VtgV);
       vEnd     = max(v(regionB));
       if vEnd > V2
          nEnd = tcmModuloNormal(vEnd,alpha);
       else
          error('Condition not programmed')
       end
       xI            = linspace(n1*0.9999,nEnd,np);
       yI            = tcmModuloInverse(xI,alpha);
       nu(regionB)   = xI;
       vOut(regionB) = yI;
    end

end


function n = tcmModuloNormal(v,alpha)
nv   = length(v);
n    = zeros(size(v));
for i=1:nv
    p      = [1, -2*v(i)*sin(alpha), v(i)^2, 0, -1];
    r      = roots(p);
    n(i)  = getMaxRealPositive(r);
end


function v = tcmModuloInverse(n,alpha)
nn   = length(n);
v    = zeros(size(n));
for i=1:nn
    p      = [n(i)^2, -2*n(i)^3*sin(alpha), n(i)^4 - 1];
    r      = roots(p);
    v(i)   = getMaxRealPositive(r);
end
