
% find the wavelet unit phasor mean field of the data set
function [wpmfresult] = wpmf_comments(wtresult,m);

%make mean field of phasors from transforms 
wpmfresult=exp(1i.*angle(wtresult{1}))/m;
for n=2:m
    wpmfresult=wpmfresult+exp(1i.*angle(wtresult{n}))/m;
end
end %fn