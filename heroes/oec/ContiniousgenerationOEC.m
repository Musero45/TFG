function vals = ContiniousgenerationOEC(heli,addressOEC,nVal)
%CONTINOUSGENERATIONOEC Generates the vector that is going to be used for
%each How in OEC helicopters generation

centralval = getnestedstructvalue(heli,addressOEC.address);
minval = centralval*addressOEC.downVal;
maxval = centralval*addressOEC.upVal;

vals = linspace(minval,maxval,nVal);

end