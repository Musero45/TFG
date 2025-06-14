function weights = methodOECweights(Whats)
%OECWEIGHTS Obtains the weights for the OEC metod
%   This function takes QFD weights and transform the elements in base 1.


disp('...calculating OEC customer weights.')

% Count Whats
nI = 0;
NcatW = Whats.Ncat;
for i=1:NcatW

    CatW  = strcat('cat',num2str(i,'%2.0f'));
    NWcat = Whats.(CatW).N;
    for j=1:NWcat

        varW = strcat('var',num2str(j,'%2.0f'));
        if strcmp(Whats.(CatW).(varW).activeOEC,'yes')
            
            nI = nI+1;

        end
    end
end

% Allocate vector
weightsqfd = zeros(1,nI);

% Obtain all the QFD weights
posI = 0;
NcatW = Whats.Ncat;
for i=1:NcatW

    CatW  = strcat('cat',num2str(i,'%2.0f'));
    NWcat = Whats.(CatW).N;
    for j=1:NWcat

        varW = strcat('var',num2str(j,'%2.0f'));
        if strcmp(Whats.(CatW).(varW).activeOEC,'yes')
            
            posI = posI+1;
            weightsqfd(posI) = Whats.(CatW).(varW).weights.qfd;

        end
    end
end

% Sum the elements
S = sum(weightsqfd);

% Transform in base 1
weights = weightsqfd/S;


end

