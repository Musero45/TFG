function B = interpreteQFDmatrix_rows(A,nCat)
%INTERPRETEQFDMATRIX transforms matrix in a base designed reference

disp('Interpreting QFD matrix, relative weight by rows;');

a=size(A,1);
b=size(A,2);

B = zeros(a,b);

for i=1:a
    
    maxval = max(A(i,:));
    ampl = maxval/nCat;
    
    for k=1:nCat-1
        
        val1 = (k-1)*ampl;
        val2 = k*ampl;
   
        for j=1:b
            if ((A(i,j) > val1)&&(val2 >= A(i,j)))
                B(i,j) = k;
            end
        end
    end
    %This fixes the issue which caused that the max value was not
    %included in cat5 (or maximum category) due to precission related
    %problems when calculating the val2 in the last iteration of k.
    val1 = (nCat-1)*ampl;
    val2 = maxval;

    for j=1:b
        if ((A(i,j) > val1)&&(val2 >= A(i,j)))
            B(i,j) = nCat;
        end
    end
    
end

end
