function valuesstruct = getHowValuesOEC(heli,Hows,vectRankHows,nVal)
%GETHOWVALUESOEC Obtains the values (continious or discrete) to use in OEC
%helicotper generation

valuesstruct = struct();

numvars = size(vectRankHows,2);
Ncat = Hows.Ncat;

for i=1:numvars
    
    howindex = vectRankHows(i);
    N = 0;
    NprevCat = 0;
    
    for j=1:Ncat
        
        Catlabel = strcat('cat',num2str(j,'%2.0f'));
        NinCat = Hows.(Catlabel).N;
        N = N + NinCat;
        if N >= howindex
            break
        end
        NprevCat = NinCat;
    end
    
    varnum = howindex - NprevCat;
    varlabel = strcat('var',num2str(varnum,'%2.0f'));
    How = Hows.(Catlabel).(varlabel);
    disp(['... ',How.label.name,' ...']);
    
    if isfield(How.addressOEC,'values')
        valuesvector = How.addressOEC.values;
    else
        valuesvector = ContiniousgenerationOEC(heli,How.addressOEC,nVal);
    end
    
    structlabel = strcat('OECvar',num2str(i,'%2.0f'));
    
    valuesstruct.(structlabel) = struct('rigidaddress',How.addressOEC.address,...
                                    'values',valuesvector);                             
                                
end

end

