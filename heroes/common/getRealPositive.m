function y  = getRealPositive(x)

ij   = 0;
for i=1:length(x)
    if isreal(x(i)) 
       if x(i) >= 0
          ij=ij+1;
          y(ij) = x(i);
       end
    end
end
if ij~=1
   error('WATCHOUT wrong computation')
end
