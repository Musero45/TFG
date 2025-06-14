function f = glauert_forward(l,m,a)

f  = zeros(length(l),1);
for i=1:length(l)
    f(i,1) = l(i)-m*tan(a) - 1.0/sqrt(l(i)^2 + m^2);
end
