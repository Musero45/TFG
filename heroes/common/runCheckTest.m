function runCheckTest(io,filename)

disp('---------------------------------------------------------------------')
if io == -1
   disp(strcat(filename,': Test failed'))
elseif io == 0
   disp(strcat(filename,': Test failed: run but not validated'))
elseif io == 1
   disp (strcat(filename,':Test passed: run'))
elseif io == 2
   disp (strcat(filename,':Test passed: run and validated'))
end
disp('---------------------------------------------------------------------')