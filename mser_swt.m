%%
%��ȡMSER���򲢱���
%mser.tifΪ��ֵ����mser����ͼ��
im=imread('000078.jpg');
im=im2double(rgb2gray(im));
[m,n]=size(im);
%���MSER����
[mserregions,mserconcomp]=detectMSERFeatures(im,'ThresholdDelta',4);
figure,imshow(im);
hold on
plot(mserregions, 'showPixelList', true,'showEllipses',false)
mserstats=regionprops(mserconcomp,'all');
box=vertcat(mserstats.BoundingBox);
region=mserconcomp.PixelIdxList;
region=vertcat(region{:});
im2=zeros(size(im));
im2(region)=im(region);
figure,imshow(~im2);
imwrite(~im2,'mser.tif');
%%
%��mser����Ļ����ϼ���ʻ����ͼ��
%����Ϊswtmap.tif
str='mser.tif';
swtmap2=SwtTransform(str);
imwrite(swtmap2,'swtmap.tif');
%%
%����ԭͼ�ıʻ����ͼ��
%����Ϊswtmap2.tif
str2='000078.jpg';
swtmap2=SwtTransform(str2);
imwrite(swtmap2,'swtmap2.tif');

