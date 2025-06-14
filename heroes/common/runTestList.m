function runTestList(testList,mode)
%RUNTESTLIST  Runs a list of file tests
%
%   RUNTESTLIST(T) runs the list of file tests T which
%   it should be a cell of function handles.
% 

for i=1:length(testList),
    io = testList{i}(mode); 
    runCheckTest(io,func2str(testList{i}));
    close all;
end
