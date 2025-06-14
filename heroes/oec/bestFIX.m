function fun = bestFIX(Val,tarjetVal,minVal,maxVal)
%BESTFIX Attributes a mark for the in value Val giving max mark to the
%value that is equal to the tarjetVal
%   Here can be selected the desired distribution, here selected a lineal
%   distribution in each side


fun = 1 - abs(Val-tarjetVal)/abs(maxVal-minVal);

end