function Whats = getWHATS(class,Cat)
%GETHOWCAT Puts all Whats together

Ncat = size(Cat,2);

Whats.class = class;
Whats.Ncat = Ncat;
for i=1:Ncat
    name    = strcat('cat',num2str(i,'%2.0f'));
    Whats.(name) = Cat{i};
end
 
end

    