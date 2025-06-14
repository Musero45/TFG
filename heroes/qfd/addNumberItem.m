function Classplusn = addNumberItem(Class)
%ADDNUMBERITEM Counts the number of items of Whats or Hows and add to the
%element the number

Classplusn = Class;
n  = 0;
Ncat = Class.Ncat;
for i=1:Ncat
    
    Cat  = strcat('cat',num2str(i,'%2.0f'));
    Ncat = Class.(Cat).N;
    for j=1:Ncat
               
        var = strcat('var',num2str(j,'%2.0f'));
        
        n = n+1;
        Classplusn.(Cat).(var).n = n;
        
    end

end

end

