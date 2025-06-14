%% How to write good validation data for heroes
% This file is intented to help contributors to heroes to produce good
% validation data files to be used during the validation process of heroes.
% Validation process is a key process during mathematical based simulation 
% software development.
%
% The next list of items is by no means an exhaustive list of 
% recomendations but it is somehow a starting point to produce good
% validation data according to heroes standards.
%
% * Comment the code as much as possible by describing how the data was
% obtained and what assumptions were made
% * Add detailed bibliographic information by specifying figure, table,
% page of document from which the data was obtained. Add the bibliography
% following a numeric scheme like the following example. The quotes "" are
% used to denote example, they shouldn't be used in the actual comment. 
% "Data were digitized from figure 4.7, page 201, of [1] ...
% and at the end of the help comment provide the cite number [1] as follows
% "[1] G.D. Padfield Helicopter Flight Dynamics 2007" 
% * The output of the validation data functions should be as close as
% possible to heroes data type. In other words, if the validation data
% function is related to helicopter trim try to output the validation data
% using the heroes trim data type.
% *Data trazability should be kept at a maximum. This means that, if for
% instance, data is in british units keep it as they are, and then change
% it, explicitly to the International System.
%

