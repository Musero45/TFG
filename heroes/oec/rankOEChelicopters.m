function heRank = rankOEChelicopters(heMark)
%RANKOECHELICOPTERS Ranks the helicopters using the OEC result as criteria 


disp('Ranking helicopters by OEC...')

Nhe = size(heMark,2); 
vectOEC = zeros(1,Nhe);

% Obtain OEC results
for k=1:Nhe
    vectOEC(k) = heMark{k}.OEC.OEC;
end

% Rank vector
[Rank,Order] = sort(vectOEC,'descend');

No = size (Order,2);
heRank = cell(1,No);

% Generate a ranked helicopter cell
for i=1:No
    heRank{i} = heMark{Order(i)};
    heRank{i}.Rank = i;
end

end

