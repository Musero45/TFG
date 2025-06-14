function stabilityMap = getPadfieldEigenvaluesMap(he)

MB = [0         0        0       0        0        0         0         0; ...
      -14.2112 -14.1327 -13.9468 -13.8140 -13.7201 -13.66522 -13.6137 -13.6301;...
      -3.8365 -3.8553 -3.9368 -4.0705 -4.2542 -4.5113 -4.8596 -5.2399;...
      0.2361 + 0.5248i -0.2762 + 0.9791i -0.4 + 1.5964i -0.4979 + 2.1473i -0.5648 + 2.6403i -0.6103 + 3.0909i -0.6376 + 3.5057i -0.6430 + 3.8845i;...
      0.2361 - 0.5248i -0.2762 - 0.9791i -0.4 - 1.5964i -0.4979 - 2.1473i -0.5648 - 2.6403i -0.6103 - 3.0909i -0.6376 - 3.5057i -0.6430 - 3.8845i;...
      -0.2098 + 0.5993i 0.0663 + 0.4906i -0.5727 -0.6414 -0.6533 -0.6048 -0.5127 -0.4482;...
      -0.2098 - 0.5993i 0.0663 - 0.4906i 0.01 + 0.3548i 0.0107 + 0.3154i 0.0162 + 0.3051i 0.0329 + 0.3096i 0.0768 + 0.3230i 0.1503 + 0.3215i;...
      -0.3246 + 0.0053i -0.4486 0.01 - 0.3548i 0.0107 - 0.3154i 0.0162 - 0.3051i 0.0329 - 0.3096i 0.0768 - 0.3230i 0.1503 - 0.3215i;...
      -0.3246 - 0.0053i -0.0298 -0.0013 -0.0185 -0.0243 -0.0271 -0.0293 -0.0318...
     ];
 
if strcmp(he,'Bo105')
    M = MB;
elseif strcmp(he,'Puma')
    M = MP;
elseif strcmp(he,'Lynx')
    M = ML;
else
    error('getPadfieldEigenvaluesMap:helicopterModelChk', 'Wrong helicopter model. Check input argument spell (Bo105, Puma, Lynx)')
end



stabilityMap   = struct(...
'mux',[],...
'V',[],...
'eigW',[],...
'si',M ...
);

% Add characteristic time to damp initial perturbation and frequency of
% autovectors
stabilityMap     = si2si_reim(stabilityMap,M);


function stabilityMapOut = si2si_reim(stabilityMapIn,si)
% WATCHOUT! THIS IS A BLATANT COPY OF THE LOCAL si2si_reim FUNCTION LOCATED
% AT GETSTABILITYMAP. THIS IS REALLY BAD PROGRAMMING 
%
% TO BE CLEANED UP

%
stabilityMapOut  = stabilityMapIn;

re_si    = real(si);
im_si    = imag(si);
md_si    = abs(si);
ph_si    = angle(si);
ssv      = size(si,1);

% the assignment is splitted in two loops because of the aesthetics of
% building the structure in such a way that t12 and omega fields are
% displayed ordered
for i = 1:ssv
    var_re = strcat('t12_',num2str(i));
    stabilityMapOut.(var_re) = log(2)./re_si(i,:);
end

for i = 1:ssv
    var_im = strcat('omega_',num2str(i));
    stabilityMapOut.(var_im) = im_si(i,:);
end

for i = 1:ssv
    var_md = strcat('abs_',num2str(i));
    stabilityMapOut.(var_md) = md_si(i,:);
end

for i = 1:ssv
    var_ph = strcat('phi_',num2str(i));
    stabilityMapOut.(var_ph) = ph_si(i,:);
end

for i = 1:ssv
    var_zt = strcat('zeta_',num2str(i));
    stabilityMapOut.(var_zt) = -re_si(i,:)./im_si(i,:);
end


