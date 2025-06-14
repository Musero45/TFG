function heMark = overalEvaluationCriteria(heCand,Whats,scaleMark)
%OVERALEVALUATIONCRITERIA Implements the OEC methodology
%   The OEC method searchs to evaluate how good is an helicopter depending
%   on the customer requirements. In other words, it atributes a general
%   mark  that measures the quality of the helicopter for the customer.
%
%   The methodology requires to evaluate each performance i (What) of each
%   helicopter k and calculate a specific mark(k,i). This mark is ponderated with
%   the customer's importance weight(i) (of each What) in order to obtain the
%   general mark for each helicopter k. This is possible with the OEC
%   expression:
%
%       OEC(k) = sum {i=1:NWhats}( mark(k,i)*weight(i) )
%
%   The helicopter with the best OEC result is the helicopter that is the
%   nearest to the customer requirements.
%

disp('Overall Evaluation Criteria...')

%% Previous steps
% Build performances selection using the selected Whats 
heCand  = addAllPerformances(heCand,Whats);

% Obtain max and min performances in all the helicopter cell
maxVals = methodOECmaxValues(heCand);

%% OEC methodology 
% Calculate marks(k,i)
marks   = methodOECmarkFunction(heCand,Whats,maxVals);

% Obtain OEC weights from Whats
weights = methodOECweights(Whats);

% Implement OEC equation
heMark  = methodOECequation(heCand,Whats,maxVals,marks,weights,scaleMark);


end

