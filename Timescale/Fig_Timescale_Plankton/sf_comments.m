function scalefrequency1=sf_comments(parameters);
scale_min = parameters.wavelet.scale_min;
scale_max = parameters.wavelet.scale_max;
sigma = parameters.wavelet.sigma;

%find a range of scales that starts at scale_min and includes scale_max
s_max = floor(log(scale_max/scale_min)/log(sigma));
s = 0:1:s_max+1;

%find frequencies
scalefrequency1=1./(scale_min.*(sigma.^(s)));
end