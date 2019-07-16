function call = ahba_readPACall(callFile)
% [call_value, probe_id] = ahba_readPACall(callFile)
% callFile = 'PACall.csv'; 

M = csvread(callFile); 

call.probe_id  = M(:,1)';
call.value = M(:,2:end)';

clear M

