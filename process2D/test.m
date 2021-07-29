img= imread('test.png');%读取图像
%rng default;

I = double(img)/255;%checkerboard(10);

PSF = fspecial('gaussian',7,10);
V = .0001;
BlurredNoisy = imnoise(imfilter(I,PSF),'gaussian',0,V);
WT = zeros(size(I));
WT(5:end-4,5:end-4) = 1;
INITPSF = ones(size(PSF));
[J, P] = deconvblind(BlurredNoisy,INITPSF,20,10*sqrt(V),WT);

imshow(J);
title('Deblurred Image');

%{
%I = I(10+1:256,222+1:256);%选定图像的范围
figure(1); 
imshow(I);%显示原图像
title('Original Image');

LEN = 31; THETA = 11;
PSF = fspecial('motion',LEN,THETA);%产生运动模糊函数
blurred = imfilter(I,PSF,'circular','conv');%产生运动模糊图像
figure(2); subplot(221),
imshow(blurred);%显示运动模糊图像
title('Blurred');

wnr1 = deconvwnr(blurred,PSF);%使用维纳滤波器进行滤波
subplot(222); imshow(wnr1);%显示维纳滤波器后滤波的图像
title('Restored, True PSF');
wnr2 = deconvwnr(blurred,fspecial('motion',LEN,THETA));%使用两倍长度的点扩散函数进行维纳滤波
subplot(223); imshow(wnr2); %显示恢复的图像
title('Restored, "Long" PSF');


wnr3 = deconvwnr(blurred,fspecial('motion',LEN,THETA));%使用两倍角度的点扩散函数进行维纳滤波
subplot(224); imshow(wnr3); %显示恢复的图像
title('Restored, Steep');
noise = 0.1*randn(size(I));%生成随机噪声
blurredNoisy = imadd(blurred,im2uint8(noise));%模糊图像加入随机噪声
figure(3); subplot(221)
imshow(blurredNoisy);%显示加入噪声的模糊图像
title('Blurred & Noisy');
wnr4 = deconvwnr(blurredNoisy,PSF);%使用维纳滤波器进行滤波
subplot(222),
imshow(wnr4);%显示恢复后的图像


title(‘Inverse Filtering of Noisy Data’);
NSR = sum(noise(😃.2)/sum(im2double(I(😃).2);%计算噪声信号功率比
wnr5 = deconvwnr(blurredNoisy,PSF,NSR);%加入NSR参数使用维纳滤波器滤波
subplot(223); imshow(wnr5);%显示恢复后的图像
title(‘Restored with NSR’);
wnr6 =deconvwnr(blurredNoisy,PSF,NSR/2);%改变NSR参数使用维纳滤波器滤波
subplot(224),
imshow(wnr6);%显示恢复后的图像
title(‘Restored with NSR/2’);
NP = abs(fftn(noise)).^2;%计算噪声功率谱
NPOW = sum(NP(😃)/prod(size(noise)); % 噪声能量
NCORR = fftshift(real(ifftn(NP))); % 噪声的自相关函数
IP = abs(fftn(im2double(I))).^2;%计算图像功率谱
IPOW = sum(IP(😃)/prod(size(I)); % 图像能量
ICORR = fftshift(real(ifftn(IP))); % 图像自相关函数
wnr7 = deconvwnr(blurredNoisy,PSF,NCORR,ICORR);%增加参数进行维纳滤波
figure(4); subplot(121)
imshow(wnr7);%显示恢复后的图像
title(‘Restored with ACF’);
ICORR1 = ICORR(:,ceil(size(I,1)/2));
wnr8 = deconvwnr(blurredNoisy,PSF,NPOW,…
ICORR1);%使用噪声能量和图像一维自相关函数进行维纳滤波
subplot(122); imshow(wnr8);%显示恢复后的图像
title(‘Restored with NP & 1D-ACF’);
PSF2 = fspecial(‘gaussian’,11,5);%高斯模糊函数
Blurred = imfilter(I,PSF2,‘conv’);%模糊后的图像
figure(5); subplot(121)
imshow(Blurred);%显示模糊后的图像
title(‘Blurred’);
V = .02;
BlurredNoisy2 = imnoise(Blurred,‘gaussian’,0,V);%加入高斯白噪声
subplot(122); imshow(BlurredNoisy2);%显示加噪后的图像
title(‘Blurred & Noisy’);
NP = Vprod(size(I)); % 噪声能量
[reg1 LAGRA] = deconvreg(BlurredNoisy2,PSF,NP);%规则化滤波
figure(6); subplot(221)
imshow(reg1),%显示恢复后的图像
title(‘Restored with NP’);
reg2 = deconvreg(BlurredNoisy2,PSF,NP1.3);%加大噪声能量进行规则化滤波
subplot(222); imshow(reg2);%显示恢复后的图像
title(‘Restored with larger NP’);
reg3 = deconvreg(BlurredNoisy2,PSF,NP/1.3);%减小噪声能量进行规则化滤波
subplot(223); imshow(reg3);%显示恢复后的图像
title(‘Restored with smaller NP’);
Edged = edgetaper(BlurredNoisy2,PSF);%使图像的边缘模糊
reg4 = deconvreg(Edged,PSF,NP/1.3);%规则化滤波
subplot(224); imshow(reg4);%显示恢复后的图像
title(‘Edgetaper effect’);
reg5 = deconvreg(Edged,PSF,[],LAGRA);%加入拉格朗日乘子进行滤波
figure(7); subplot(221)
imshow(reg5);%显示恢复后的图像
title(‘Restored with LAGRA’);
reg6 = deconvreg(Edged,PSF,[],LAGRA100);%增大拉格朗日乘子进行滤波
subplot(222); imshow(reg6);%显示恢复后的图像
title(‘Restored with large LAGRA’);
reg7 = deconvreg(Edged,PSF,[],LAGRA/100);%减小拉格朗日乘子进行滤波
subplot(223); imshow(reg7);%显示恢复后的图像
title(‘Restored with small LAGRA’);
REGOP = [1 -2 1];%图像光滑程度约束
reg8 = deconvreg(BlurredNoisy2,PSF,[],LAGRA,…
REGOP);%加入光滑约束进行滤波
subplot(224); imshow(reg8);%显示恢复后的图像
title(‘Constrained by 1D Laplacian’);
PSF3 = fspecial(‘gaussian’,5,5);%高斯模糊函数
Blurred = imfilter(I,PSF3,‘symmetric’,‘conv’);%模糊后的图像
figure(8); subplot(121)
imshow(Blurred);%显示模糊后的图像
title(‘Blurred’);
V = .002;
BlurredNoisy3 = imnoise(Blurred,‘gaussian’,0,V);%加入高斯白噪声
subplot(122); imshow(BlurredNoisy3);%显示加噪后的模糊图像
title(‘Blurred & Noisy’);
luc1 = deconvlucy(BlurredNoisy3,PSF,5);%使用lucy-richardson方法滤波
figure(9); subplot(131)
imshow(luc1);%显示恢复后的图像
title(‘Restored Image, NUMIT = 5’);
luc1_cell = deconvlucy({BlurredNoisy3},PSF,5);%使用deconvlucy滤波
luc2_cell = deconvlucy(luc1_cell,PSF);%继续对恢复的图像反卷积
luc2 = im2uint8(luc2_cell{2});%转化图像类型
subplot(132); imshow(luc2);%显示恢复的图像
title(‘Restored Image, NUMIT = 15’);
DAMPAR = im2uint8(3*sqrt(V));%噪声参数
luc3 = deconvlucy(BlurredNoisy3,PSF,15,DAMPAR);%控制噪声放大
subplot(133); imshow(luc3);%显示恢复的图像
title(‘Restored Image with Damping, NUMIT = 15’);
I = rgb2gray(I);%转化为灰度图像
PSF = fspecial(‘gaussian’,7,10);%高斯模糊函数
Blurred4 = imfilter(I,PSF,‘symmetric’,‘conv’);%产生模糊图像
figure(11); subplot(221)
imshow(Blurred4);%显示模糊后的图像
title(‘Blurred Image’);
UNDERPSF = ones(size(PSF)-4);%较小的PSF
[J1 P1] = deconvblind(Blurred4,UNDERPSF);%反卷积去模糊
subplot(222); imshow(J1);%显示去模糊后的图像
title(‘Deblurring with Undersized PSF’);
OVERPSF = padarray(UNDERPSF,[4 4],‘replicate’,‘both’);%较大的PSF
[J2 P2] = deconvblind(Blurred4,OVERPSF);%对图像反卷积去模糊
subplot(223); imshow(J2);%显示去模糊后的图像
title(‘Deblurring with Oversized PSF’);
INITPSF = padarray(UNDERPSF,[2 2],‘replicate’,‘both’);%最初的PSF
[J3 P3] = deconvblind(Blurred4,INITPSF);%对图像反卷积去模糊
subplot(224); imshow(J3);
title(‘Deblurring with INITPSF’);%显示去模糊后的图像
figure(12); subplot(221);
imshow(PSF,[],‘InitialMagnification’,‘fit’);%显示真实的点扩散函数
title(‘True PSF’); subplot(222);
imshow(P1,[],‘InitialMagnification’,‘fit’);%显示较小PSF下恢复的PSF
title(‘Reconstructed Undersized PSF’);
subplot(223);
imshow(P2,[],‘InitialMagnification’,‘fit’);%显示较大PSF下恢复的PSF
title(‘Reconstructed Oversized PSF’);
subplot(224);
imshow(P3,[],‘InitialMagnification’,‘fit’);%显示最初PSF下恢复的PSF
title(‘Reconstructed true PSF’);

%}
%https://blog.csdn.net/m0_38127487/article/details/115259587