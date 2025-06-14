function fun = bestMAX(Val,tarjetVal,minVal,maxVal)
%BESTMAX Attributes a mark for the in value Val giving max mark to the
%value that is the maximum (inside the interval minVal and maxVal)
%   Here can be selected the desired distribution, here selected a lineal
%   distribution

tarjetVal = maxVal;
fun = 1 - abs(Val-tarjetVal)/abs(maxVal-minVal);

end