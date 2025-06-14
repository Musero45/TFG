%%%%%%%%%%%
function airfoilARM = singleAirfloil2ARMairfoilHe(data)

% singleAirfloil2ARMairfoil(data)
% creates an ARM airfoil from values of cl, cd and cm in the [-pi,pi]
% interval of angles of attack. Since the input exists for a unique value
% of Reynolds number and Mach number, the same curves cl-alpha are
% replicated for all Reynolds numbers and all Mach numbers.
%
% The variation with Re and M is considered numerically although there is
% not change in the values with Re and M, that is cl(alpha,Re1,M1) = 
% cl(alpha,Re2,M2)
%
% a Log10(Re) variation [4,20] and a M variation [0,2] are considered
% simply for interpolation porpouses
%
% The input to the function is a structure "data" with fields
%
%    'name':     [string].          Name of the airfoil
%    'reference: [string].          Reference source of the data
%    'M':        [double].          Test Mach number.
%    'Re':       [double].          Test Reynolds number. 
%    'alphacl':  [1xnalpha]. [rad]. Column vector of angle of attack values for cl. 
%    'clvect':   [1xnalpha]. [-].   Column vector of cl values. 
%    'alphacd':  [1xnalpha]. [rad]. Column vector of angle of attack values for cd. 
%    'cdvect':   [1xnalpha]. [rad]. Column vector of cd values. 
%    'alphacm':  [1xnalpha]. [-].   Column vector of angle of attack values for cl. 
%    'cmvect':   [1xnalpha]. [rad]. Column vector of cm values. 
%


name0     = data.name;
reference = data.reference;
M         = data.Mach;
Re        = data.Reynolds;
alphacl   = data.alphacl;
clvect    = data.cl;
alphacd   = data.alphacd;
cdvect    = data.cd;
alphacm   = data.alphacm;
cmvect    = data.cm;



nL10Re    = 4;
L10Re1    = 0;
L10Re2    = 20;

nM        = 3;
M1        = 0;
M2        = 2;

%name0         = char(singleAirfoil);
name          = strcat(name0,'_ARM');

%%%%Matrices para cl

%[alphaop,clop,cdop,kmax,alphacl,clvect] = singleAirfoil('cl');

ncl       = length(alphacl);

alpha3Dcl = repmat(alphacl,1,nL10Re);
alpha3Dcl = repmat(alpha3Dcl,[1 1 nM]);

log10Re3Dcl = linspace(L10Re1,L10Re2,nL10Re);
log10Re3Dcl = repmat(log10Re3Dcl,ncl,1);
log10Re3Dcl = repmat(log10Re3Dcl,[1 1 nM]);

Mvect  = linspace(M1,M2,nM);

for mi = 1:nM

M3Dcl(:,:,mi) = Mvect(mi)*ones(ncl,nL10Re);

end

cl3D = repmat(clvect,1,nL10Re);
cl3D = repmat(cl3D,[1 1 nM]);

%%%%Matrices para cd

%[alphaop,clop,cdop,kmax,alphacd,cdvect] = singleAirfoil('cd');

ncd       = length(alphacd);

alpha3Dcd = repmat(alphacd,1,nL10Re);
alpha3Dcd = repmat(alpha3Dcd,[1 1 nM]);

log10Re3Dcd = linspace(L10Re1,L10Re2,nL10Re);
log10Re3Dcd = repmat(log10Re3Dcd,ncd,1);
log10Re3Dcd = repmat(log10Re3Dcd,[1 1 nM]);

Mvect  = linspace(M1,M2,nM);

for mi = 1:nM

M3Dcd(:,:,mi) = Mvect(mi)*ones(ncd,nL10Re);

end

cd3D = repmat(cdvect,1,nL10Re);
cd3D = repmat(cd3D,[1 1 nM]);

%%%%Matrices para cm

%[alphaop,clop,cdop,kmax,alphacm,cmvect] = singleAirfoil('cm');

ncm       = length(alphacm);

alpha3Dcm = repmat(alphacm,1,nL10Re);
alpha3Dcm = repmat(alpha3Dcm,[1 1 nM]);

log10Re3Dcm = linspace(L10Re1,L10Re2,nL10Re);
log10Re3Dcm = repmat(log10Re3Dcm,ncm,1);
log10Re3Dcm = repmat(log10Re3Dcm,[1 1 nM]);

Mvect  = linspace(M1,M2,nM);

for mi = 1:nM

M3Dcm(:,:,mi) = Mvect(mi)*ones(ncm,nL10Re);

end

cm3D = repmat(cmvect,1,nL10Re);
cm3D = repmat(cm3D,[1 1 nM]);

ARMdata = genvarname(name);

%readme = strcat('ARM data created with singleAirfloil2ARMairfoil.m from WTToolBox @',name0);

airfoilARM        = struct('name',name,...
                        'reference',reference,... 
                        'M',M,...
                        'Re',Re,...
                        'ALPHA3D_CL',alpha3Dcl,...
                        'Log10Re3D_CL',log10Re3Dcl,...
                        'M3D_CL',M3Dcl,...
                        'ALPHA3D_CD',alpha3Dcd,...
                        'Log10Re3D_CD',log10Re3Dcd,...
                        'M3D_CD',M3Dcd,...
                        'ALPHA3D_CM',alpha3Dcm,...
                        'Log10Re3D_CM',log10Re3Dcm,...
                        'M3D_CM',M3Dcm,...
                        'CL3D',cl3D,...
                        'CD3D',cd3D,...
                        'CM3D',cm3D);
 
 %name = strcat(path,filesep,name);                   
                    
 %save (name,'-struct','ARMdata');  
 
end