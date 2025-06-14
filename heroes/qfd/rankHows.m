function  [sortHows, Imp, Order, Rank] = rankHows(A,Hows,Whats)
%RANKHOWS Obtains the master variables using the sensibility QFD matrix
%   This function uses the obtained QFD matrix and the customer weights for
%   each Whats in order to obtain the heaviests variables of the project.
%   These variables are ranked using the product of the QFD matrix and the
%   weight vector.

disp('Ranking QFD matrix;');

a = size(A,1);
b = size(A,2);
G = zeros(a,b);
B = cell(b);
D = cell(b);
Wght = zeros(a);

% Obtain qfd customer weights
posI  = 0;
NcatW = Whats.Ncat;
for i=1:NcatW
    CatW  = strcat('cat',num2str(i,'%2.0f'));
    NWcat = Whats.(CatW).N;
    for j=1:NWcat    
        varW = strcat('var',num2str(j,'%2.0f'));
        if strcmp(Whats.(CatW).(varW).activeQFD,'yes')       
            posI = posI+1;
            Wght(posI) = Whats.(CatW).(varW).weights.qfd;
        end
    end
end

% QFD matrix and qfd customer weights product
for i=1:a
    for j=1:b 
        G(i,j) = A(i,j)*Wght(i);
    end
end

% Importance of each variable: sum all the results of each column
Imp = sum(G);

% Ranking the variables
[Rank, Order] = sort(Imp,'descend');

% Recomposition of variables
j=0;
NcatH = Hows.Ncat;
for k=1:NcatH
            
    CatH  = strcat('cat',num2str(k,'%2.0f'));
    NHcat = Hows.(CatH).N;

    for l=1:NHcat

        j=j+1;
        varH  = strcat('var',num2str(l,'%2.0f'));
        varHname = Hows.(CatH).(varH).label.name;
        B(j)= {varHname};
        D(j)= {Imp(j)};

    end

end

[Sorted_D, Index_D] = sort(cell2mat(D),'descend');
sortHows(:,1) = num2cell(Sorted_D);
sortHows(:,2) = B(Index_D);


end