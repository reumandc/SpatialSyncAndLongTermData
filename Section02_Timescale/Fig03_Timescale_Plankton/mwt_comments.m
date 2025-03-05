%%% the output is a complex value of the Morlet wavelet transformation, with phase decreasing from pi to -pi in each cycle for backwards compatibility %%%
% 
% example parameters and input
% parameters.wavelet.sigma=1.05;
% parameters.wavelet.scale_min=2
% parameters.wavelet.scale_max=50
% t_series=randn(1,100);
% f0=0.5;

function [result] = mwt_comments(t_series, parameters, f0)

 scale_min = f0*parameters.wavelet.scale_min;
%this is the width of the smallest wavelet
 scale_max = f0*parameters.wavelet.scale_max;
%this is the width of the biggest wavelet
 sigma = parameters.wavelet.sigma;
%the frequency increment
 
%determine how many frequencies are in the range  
m_max = floor(log(scale_max/scale_min)/log(sigma))+1;

translength=length(t_series);

result = NaN(m_max+1,translength);
s2=scale_min*sigma.^[0:m_max-1];
margin2=ceil(sqrt(-(2*s2.*s2)*log(0.5)));
m_last=max(find(margin2<2*translength));

%wavsize determines the size of the calculated wavelet
wavsize=ceil(sqrt(-(2*s2(m_last).*s2(m_last))*log(0.001)));
Y = fft([t_series zeros(1,2*wavsize)]);
freqs=0:1/length(Y):1-1/length(Y);
freqs2=[0:1:floor(length(Y)/2) -(ceil(length(Y)/2)-1):1:-1]/length(Y);

%find transform components using wavelets of each frequency
for stage = 1 : m_last

    s=s2(stage);
%begin calculating wavelet

%margin determines how close large wavelets can come to the edges of the
%timeseries
    margin=margin2(stage);

%perform convolution
    XX=(2*pi*s)^(0.5)*(exp(-s^2*(2*pi*(freqs-(1-(f0/s)))).^2/2) - (exp(-s^2*(2*pi*(freqs2)).^2/2)    ) .*(exp(-0.5*(2*pi*f0)^2))).*exp(-1i*2*pi*wavsize./(1./freqs));

    con = ifft(XX.*Y);

%fit result into transform
    result(stage,margin+1:end-margin) = con(wavsize + margin + 1 : 1 : (wavsize - margin + translength));

end %stage


end

