function no_noise(I)
PSF = fspecial('gaussian',7,10);
V = .0001;
BlurredNoisy = imnoise(imfilter(I,PSF),'gaussian',0,V);
WT = zeros(size(I));
WT(5:end-4,5:end-4) = 1;
INITPSF = ones(size(PSF));
[J, ~] = deconvblind(BlurredNoisy,INITPSF,20,10*sqrt(V),WT);

imshow(J);
title('Deblurred Image');

end

