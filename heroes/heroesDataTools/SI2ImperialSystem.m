function y = SI2ImperialSystem

%--------------------------------------------------------------------------
% Paso de variables de entrada a sistema imperial:
%--------------------------------------------------------------------------
% 1 kg      = 2.20462262 lb
% 1 m       = 0.00053995 nm
% 1 W       = 0.00135962 hp
% 1 l       = 0.26417205 gal
% 1 $/kg    = 0.45359237 $/lb
% 1 kg/l    = 8.34540447 lb/gal
% 1 $/l     = 3.78541180 $/gal

kg_lb           = 2.20462262;
m_nm            = 0.00053995;
W_hp            = 0.00135962;
kgl_lbgal       = 8.34540447;  
dolarkg_dolarlb = 0.45359237;
dolarl_dolargal = 3.78541180;


y = struct (...
          'kg2lb', kg_lb,...
           'm2nm', m_nm,...
           'W2hp', W_hp,...
      'kgl2lbgal', kgl_lbgal,...
'dolarkg2dolarlb', dolarkg_dolarlb,...
'dolarl2dolargal', dolarl_dolargal...
);
end

