function fun = bestMIN(Val,tarjetVal,minVal,maxVal)
%BESTMIN Attributes a mark for the in value Val giving max mark to the
%value that is the minimum (inside the interval minVal and maxVal)
%   Here can be selected the desired distribution, here selected a lineal
%   distribution

tarjetVal = minVal;
fun = 1 - abs(Val-tarjetVal)/abs(maxVal-minVal);

end