function [] = myHist()
%a = double(imread('test.jpg')); % matlab自带图片
%hist(a(:),250); % 分成十个bin

I=imread('test.jpg');
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);
figure,imhist(R);title('R');
figure,imhist(G);title('G');
figure,imhist(B);title('B');
end

