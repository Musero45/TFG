function B = interpreteQFDmatrix_global(A,nCat)
%INTERPRETEQFDMATRIX transforms matrix in a base designed reference

disp('Interpreting QFD matrix;');

maxval = max(max(A));
ampl = maxval/nCat;

a=size(A,1);
b=size(A,2);

B = zeros(a,b);
for k=1:nCat
    val1 = (k-1)*ampl;
    val2 = k*ampl;
for i=1:a
    for j=1:b
        if ((A(i,j) > val1)&&(val2 >= A(i,j)))
            B(i,j) = k;
        end
    end
end
end

end
