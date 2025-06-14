function QFD = generateQFDmatrix(whats,hows)
%GENERATEQFDMATRIX generates the QFD matrix for the QFD method
%   It obtains the number of Whats (activated) n and the number of Hows m and
%   generates a matrix n*m

% Count Whats
nI = 0;
for i=1:whats.Ncat 
    CatW  = strcat('cat',num2str(i,'%2.0f'));
    NWcat = whats.(CatW).N;
    for j=1:NWcat
         varW = strcat('var',num2str(j,'%2.0f'));
         if strcmp(whats.(CatW).(varW).activeQFD,'yes')
             nI = nI+1;
         end
    end   
end
Nrows = nI;

% Count Hows
n = zeros(hows.Ncat,1);
for i=1:hows.Ncat
    label = strcat('cat',num2str(i,'%2.0f'));
    n(i)  = hows.(label).N;
end
Ncolumns = sum(n);

% Generate QFD matrix n*m
QFD = zeros(Nrows,Ncolumns);

disp('Generating QFD matrix: ');
disp(['... Nwhats = ', num2str(Nrows),' and Nhows = ',num2str(Ncolumns)]);

end