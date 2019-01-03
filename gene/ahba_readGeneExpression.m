function expression = readGeneExpression(expressionFile)
% expression = readGeneExpression(expressionFile)
% expressionFile = 'MicroarrayExpression.csv'; 

M = csvread(expressionFile); 
expression.probe_id  = M(:,1)';
expression.value = M(:,2:end)';

clear M

