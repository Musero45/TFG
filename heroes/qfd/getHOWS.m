function Hows = getHOWS(class,Cat)
%GETHOWCAT Put all Hows together

Ncat = size(Cat,2);

Hows.class = class;
Hows.Ncat = Ncat;
for i=1:Ncat
    name    = strcat('cat',num2str(i,'%2.0f'));
    Hows.(name) = Cat{i};
end
 
end

    