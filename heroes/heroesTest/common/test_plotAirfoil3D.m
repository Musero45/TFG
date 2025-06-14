function io = test_plotAirfoil3D

close all
setPlot;

dataAifoil3D = OA209ARM;


% % plotAirfoil3D(dataAifoil3D,...
% %               'plot3dMode','parametric',...
% %               'rawdata','yes' ...
% % );

aspan    = pi/180*linspace(-20,30,25);
rspan    = logspace(4,6,3);
mspan    = [0.3,0.4,0.5,0.6,0.7,0.8,0.88]; % linspace(0.3,0.88,2);
logrspan = log10(rspan);

[A,R,M]  = ndgrid(aspan,logrspan,mspan);
arm      = struct(...
'alpha',A,...
'reynolds',R,...
'mach',M ...
);


plotAirfoil3D(dataAifoil3D,...
              'plot3dMode','parametric',...
              'rawdata',arm, ...
              'grid','off'...
);


% % plotAirfoil3D(dataAifoil3D,...
% %               'plot3dMode','parametric',...
% %               'rawdata','yes' ...
% % );
% % 
% % 
plotAirfoil3D(dataAifoil3D,...
              'plot3dMode','bidimensional',...
              'plot3dMethod',@surfc, ...
              'rawdata',arm...
);

%% 1
% plotAirfoil3D default behaviour. When plotAirfoil3D is used without any
% options plots the raw data contained in the airfoil3D structure
% % plotAirfoil3D(dataAifoil3D);

%% 2
% % plotAirfoil3D(dataAifoil3D,'rawdata',arm);


%% saving

% % saveas(figure(7),'2cl_a_M','epsc');
% % saveas(figure(9),'2cd_a_M','epsc');
% % saveas(figure(11),'2cm_a_M','epsc');
 
% % saveas(figure(1),'cl_a_M','epsc');
% % saveas(figure(3),'cd_a_M','epsc');
% % saveas(figure(5),'cm_a_M','epsc');

% saveas(figure(1),'smallcl_a_M','bmp');
% saveas(figure(3),'smallcd_a_M','bmp');
% saveas(figure(5),'smallcm_a_M','bmp');


io = 1;

function plotAirfoil3D(dataA3d,varargin)
% plotAirfoil3D       plots a 3D airfoil data structure
%
%  plotAirfoil3D(DATA) plots a 3D airfoil data structure, DATA. DATA is a
%  structure with the following structure 
%           Readme: [char]
%       ALPHA3D_CL: [nacl x nrcl x nmcl double]
%     Log10Re3D_CL: [nacl x nrcl x nmcl double]
%           M3D_CL: [nacl x nrcl x nmcl double]
%             CL3D: [nacl x nrcl x nmcl double]
%       ALPHA3D_CD: [nacd x nrcd x nmcd double]
%     Log10Re3D_CD: [nacd x nrcd x nmcd double]
%           M3D_CD: [nacd x nrcd x nmcd double]
%             CD3D: [nacd x nrcd x nmcd double]
%       ALPHA3D_CM: [nacm x nrcm x nmcm double]
%     Log10Re3D_CM: [nacm x nrcm x nmcm double]
%           M3D_CM: [nacm x nrcm x nmcm double]
%             CM3D: [nacm x nrcm x nmcm double]
%
% where Readme field contains a description of the aerodynamic data, the
% fields ALPHA3D_CL, Log10Re3D_CL, M3D_CL, CL3D contains the 3D matrices
% describing the function CL(ALPHA, REYNOLDS, MACH) of size 
% [nacl x nrcl x nmcl]. Anologously,  ALPHA3D_CD, Log10Re3D_CD, M3D_CD,
% CD3D and  ALPHA3D_CM, Log10Re3D_CM, M3D_CM, CM3D contains the information
% of the drag and moment coeffienct functions CD(ALPHA, REYNOLDS, MACH) and
% CM(ALPHA, REYNOLDS, MACH), respectively.
%
% By default plotAirfoil3D plots just bidimensional surfaces. 
%
%
% NEXT THERE IS AN ATTEMPT TO USE VOLUME VISUALIZATION THAT PERHAPS IT CAN
% HELP HERE.IT SHOULD BE ADAPTED BECAUSE IT COMES FROM SITE3D
%
%% Plot 3d numerical site
% Here we follow the matlab help notes "Overview Volume Visualization"
% Scalar data is best viewed with isosurfaces, slice planes, 
% and contour slices.
% 
% Steps to Create a Volume Visualization
% 
% Creating an effective visualization requires a number of steps 
% to compose the final scene. These steps fall into four basic categories:
% 1. Determine the characteristics of your data. Graphing volume 
% data usually requires knowledge of the range of both the coordinates 
% and the data values.
% 2. Select an appropriate plotting routine. The information in this 
% section helps you select the right methods.
% 3. Define the view. The information conveyed by a complex 
% three-dimensional graph can be greatly enhanced through careful 
% composition of the scene. Viewing techniques include adjusting camera 
% position, specifying aspect ratio and project type, zooming in or out, 
% and so on.
% 4. Add lighting and specify coloring. Lighting is an effective means to 
% enhance the visibility of surface shape and to provide a 
% three-dimensional perspective to volume graphs. Color can convey data 
% values, both constant and varying.
%
%
% 
% if strcmp(options.numericalSite3d,'yes')
% 
% % TO BE CLEANED-UP
% f3d     = ns3d{1}.f3d;
% z13d    = ns3d{1}.z13d;
% z23d    = ns3d{1}.z23d;
% Coh1    = ns3d{1}.Coh1;
% 
% 
% 
% cm = brighten(jet(89),-.5);
% figure('Colormap',cm)
% contourslice(f3d,z13d,z23d,Coh1,[0.01,0.1,1,10],[],[]);
% % contourslice(Coh1,[],[],[1,12,19,27],8);
% view(3); axis tight
% set(gca,'xscale','log');
% xlabel('$$f$$[Hz]');ylabel('$$z$$[m]');zlabel('$$z$$[m]');
% colormap(jet)
% colorbar('location','EastOutside')
% 
% figure('Colormap',cm)
% contourslice(f3d,z13d,z23d,Coh1,[],[5,25,50,75,100],[5,25,50,75,100]);
% % contourslice(Coh1,[],[],[1,12,19,27],8);
% view(3); axis tight
% set(gca,'xscale','log');
% xlabel('$$f$$[Hz]');ylabel('$$z$$[m]');zlabel('$$z$$[m]');
% colorbar('location','EastOutSide')
% 
% 
% hgcf   = getCurrentFigureNumber;
% figure(hgcf+1)
% z1min = min(z13d(:)); 
% z2min = min(z23d(:)); 
% frmin = min(f3d(:));
% 
% z1max = max(z13d(:)); 
% z2max = max(z23d(:)); 
% frmax = max(f3d(:));
% 
% hslice = surf(...
% linspace(frmin,frmax,100),...
% linspace(z1min,z1max,100), ...
% zeros(100) ...
% );
% 
% % rotate(hslice,[1,1,0],-90)
% rotate(hslice,[-1,0,0],-45)
% fad = get(hslice,'XData');
% zad = get(hslice,'YData');
% zbd = get(hslice,'ZData');
% 
% h = slice(f3d,z13d,z23d,Coh1,fad,zad,zbd);
% set(h,...
% 'FaceColor','interp',...
% 'EdgeColor','none',...
% 'DiffuseStrength',.8)
% hold on
% hx = slice(f3d,z13d,z23d,Coh1,frmax,[],[]);
% set(hx,'FaceColor','interp','EdgeColor','none')
% 
% hy = slice(f3d,z13d,z23d,Coh1,[],z1max,[]);
% set(hy,'FaceColor','interp','EdgeColor','none')
% 
% hz = slice(f3d,z13d,z23d,Coh1,[],[],z2min);
% set(hz,'FaceColor','interp','EdgeColor','none')
% 
% set(gca,'xscale','log');
% xlabel('$$f$$[Hz]');ylabel('$$z$$[m]');zlabel('$$z$$[m]');
% 
% colorbar('location','EastOutSide')
% 
% % Isosurfaces of constant coherence
% figure(hgcf+2)
% hpatch = patch(isosurface(f3d,z13d,z23d,Coh1,0.9));
% isonormals(f3d,z13d,z23d,Coh1,hpatch)
% set(hpatch,'FaceColor','red','EdgeColor','none')
% set(gca,'xscale','log');
% xlabel('$$f$$[Hz]');ylabel('$$z$$[m]');zlabel('$$z$$[m]');
% view([-65,20])
% 
% end


options     = parseOptions(varargin,@setAirfoil3DplotOptions);

% define data set depending on the option rawdata
if ~strcmp(options.rawdata,'yes')
   if isstruct(options.rawdata)
      % Get the interpolating data
      a3d_i     = options.rawdata.alpha;
      logr3d_i  = options.rawdata.reynolds;
      m3d_i     = options.rawdata.mach;

      % Get the raw data
      a3d_cl    = dataA3d.ALPHA3D_CL;
      logr3d_cl = dataA3d.Log10Re3D_CL;
      m3d_cl    = dataA3d.M3D_CL;
      cl3rd     = dataA3d.CL3D;

      a3d_cd    = dataA3d.ALPHA3D_CD;
      logr3d_cd = dataA3d.Log10Re3D_CD;
      m3d_cd    = dataA3d.M3D_CD;
      cd3rd     = dataA3d.CD3D;

      a3d_cm    = dataA3d.ALPHA3D_CM;
      logr3d_cm = dataA3d.Log10Re3D_CM;
      m3d_cm    = dataA3d.M3D_CM;
      cm3rd     = dataA3d.CM3D;

      % Interpolate the aerodynamic data at the interpolating data
      cl3d_i  = interpn(a3d_cl,logr3d_cl,m3d_cl,cl3rd,a3d_i,logr3d_i,m3d_i);
      cd3d_i  = interpn(a3d_cd,logr3d_cd,m3d_cd,cd3rd,a3d_i,logr3d_i,m3d_i);
      cm3d_i  = interpn(a3d_cm,logr3d_cm,m3d_cm,cm3rd,a3d_i,logr3d_i,m3d_i);
      dataA3d = struct('Readme','interpolated by plotAirfoil3D',... 
                       'ALPHA3D_CL',a3d_i,...
                       'Log10Re3D_CL',logr3d_i,...
                       'M3D_CL',m3d_i,...
                       'CL3D',cl3d_i,...
                       'ALPHA3D_CD',a3d_i,...
                       'Log10Re3D_CD',logr3d_i,...
                       'M3D_CD',m3d_i,...
                       'CD3D',cd3d_i,...
                       'ALPHA3D_CM',a3d_i,...
                       'Log10Re3D_CM',logr3d_i,...
                       'M3D_CM',m3d_i,...
                       'CM3D',cm3d_i ...
     );

   else
      error('PLOTAIRFOIL3D: wrong rawdata option')
   end
end

%lift coefficient data
clARM        = struct(...
'alpha',dataA3d.ALPHA3D_CL , ...
'Mach',dataA3d.M3D_CL , ...
'log10Re',dataA3d.Log10Re3D_CL , ...
'coeff',dataA3d.CL3D, ...
'coefflabel',{{'$$c_l$$ [-]'}} ...
);

clax  = plotcoeff3d(clARM,options);

% drag coefficient data
cdARM        = struct(...
'alpha',dataA3d.ALPHA3D_CD , ...
'Mach',dataA3d.M3D_CD , ...
'log10Re',dataA3d.Log10Re3D_CD , ...
'coeff',dataA3d.CD3D, ...
'coefflabel',{{'$$c_d$$ [-]'}} ...
);

cdax  = plotcoeff3d(cdARM,options);

% moment coefficient data
cmARM        = struct(...
'alpha',dataA3d.ALPHA3D_CM , ...
'Mach',dataA3d.M3D_CM , ...
'log10Re',dataA3d.Log10Re3D_CM , ...
'coeff',dataA3d.CM3D, ...
'coefflabel',{{'$$c_m$$ [-]'}} ...
);

cdax  = plotcoeff3d(cmARM,options);

io =1;


function ax  = plotcoeff3d(cARM,options) 

if strcmp(options.AoAunit,'rad')
   AoAunit  = 1.0;
   AoAlab   = '$$\alpha$$ [$$$^o$]';
else
   AoAunit  = 180/pi;
   AoAlab   = '$$\alpha$$ [-]';
end
% Get the size of matrices
[na,nr,nm]   = size(cARM.coeff);

% Plot cARM coefficient structure as a function of alpha and Mach 
% for Re constant Coeff(alpha,Mach; ReynoldsConstant)
if mod(nr,2)
   nrey  = (nr - 1)/2;
else
   nrey  = nr/2;
end

x_alpha     = reshape(cARM.alpha(:,nrey,:),[na,nm]);
y_mach      = reshape(cARM.Mach(:,nrey,:),[na,nm]);
z_coeff     = reshape(cARM.coeff(:,nrey,:),[na,nm]);

C           = struct('x',x_alpha,'y',y_mach,'z',z_coeff);
axds        = getaxds('x',AoAlab,AoAunit);
ayds        = getaxds('y','M [-]',1);
azds        = getaxds({'z'},cARM.coefflabel,1);


ax         = plotStructureNdMatrix(C,axds,ayds,azds,options);

% Plot cARM coefficient structure as a function of alpha and Reynolds  
% for Mach constant Coeff(alpha,Reynolds; Machcom)
if mod(nm,2)
   nmach  = (nm - 1)/2;
else
   nmach  = nm/2;
end

x_alpha     = reshape(cARM.alpha(:,:,nmach),[na,nr]);
y_reynolds  = reshape(cARM.log10Re(:,:,nmach),[na,nr]);
z_coeff     = reshape(cARM.coeff(:,:,nmach),[na,nr]);

C           = struct('x',x_alpha,'y',y_reynolds,'z',z_coeff);
axds        = getaxds('x',AoAlab,AoAunit);
ayds        = getaxds('y','Re [-]',1);
azds        = getaxds({'z'},cARM.coefflabel,1);


ax         = plotStructureNdMatrix(C,axds,ayds,azds,options);


function options = setAirfoil3DplotOptions

options         = setHeroesPlotOptions;
options.rawdata = 'yes';
options.AoAunit = 'deg'; % [{'deg'} | 'rad']

