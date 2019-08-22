close all;
clear;
clc;
im=(imread('000078.jpg'));
im2=double(im);
% ��ȡͼ��
I_src =imread('swtmap.tif');
I_src=im2double(I_src);
I_Src =im2double(imread('swtmap2.tif'));
[a,b]=size(I_src);
% ��ʾԭͼ
%figure;
%imshow(im);
%title('ԭʼͼ��');
I_bw = ~im2bw(I_src,0.9);
% ��ͨ�����
S = regionprops(I_bw,'all');
%����Ӿ������Ϊһ��
RECT = cat(1,S.BoundingBox);
figure;
imshow(im);
title('������С��Ӿ���');
hold on;
Length = size(RECT,1);
for i = 1:Length
    rectangle('position', RECT(i,:), 'EdgeColor', 'r','LineWidth',1.5);
end
hold off
%%
%������С��Ӿ���(ɸѡǰ)
Length = size(RECT,1);
% �洢�����
Ratio = zeros(Length,1);
% �洢�ҶȾ�ֵ
R_mean = zeros(Length,1);
% �洢�Ҷ���ֵ
R_median = zeros(Length,1);
% �洢�Ҷȷ���
R_variance = zeros(Length,1);
%�洢���α߳�
side = zeros(Length,1);
%�洢�����ر�
rate=zeros(Length,1);
%�洢���
area=zeros(Length,1);
Rate=zeros(Length,1);
%�洢���õľ���
real=zeros(Length,1);
j=1;
for i = 1:size(RECT,1)
    % ���㳤���
    Ratio(i,1) = max(RECT(i,3:4))/min(RECT(i,3:4));
    % ȡ�����ζ�Ӧ��ԭͼ������
    %RECT(i,1) RECT(i,2) RECT(i,3) RECT(i,4)�ֱ�Ϊ���ε����Ͻǵĺ������꣬�Լ���Ⱥ͸߶�
    I_rect = (I_Src(round(RECT(i,2)):round(RECT(i,2))+RECT(i,4),round(RECT(i,1)):round(RECT(i,1))+RECT(i,3)));
    %ͳ��������
    s=1;
    count=0;
     I_rect2=zeros(size(I_rect,1)*size(I_rect,2),1);
    for x=1:size(I_rect,1)
        for y=1:size(I_rect,2)          
            if I_rect(x,y)~=1
                count=count+1;
                I_rect2(s,1)=I_rect(x,y).*1000;
                s=s+1;
            end
        end
    end
    
    %�������
    area(i,1)=size(I_rect,1)*size(I_rect,2);
    %��������ռ��
    rate(i,1)=count/(size(I_rect,1)*size(I_rect,2));
    %������С���ֵ��
    I_rect3=I_rect2( I_rect2~=0);
    %Rate(i,1)=max(I_rect3);
    
    % �����ֵ
    R_mean(i,1) = mean(I_rect3);
    % ������ֵ
    R_median(i,1) = median(I_rect3(:));
    % ���㷽��
    R_variance(i,1) = var(I_rect3(:));
       
end

%%
%��һ��
R_mean=R_mean./max(R_mean);
R_median=R_median./max(R_median);
R_variance=R_variance./max(R_variance);

%�趨��ֵ(�ɵ���)��ɸѡ������
min_area=min(area(:,1));
max_area=max(area(:,1));
for i=1:size(RECT,1)
    if (Ratio(i,1)<=4)  && area(i,1)>=6*min_area &&  rate(i,1)<=0.9 &&  rate(i,1)>=0.3 && area(i,1)<=(max_area/4) && R_variance(i,1)<=0.2 && R_mean(i,1)<=0.5 &&R_variance(i,1)/R_mean(i,1)<=0.8
        real(j,1)=i;
        j=j+1;
    end
end

%%��ɸѡ�����С��Ӿ����Լ���¼����
real2=(real~=0);
real_length=sum(real2(:));
%����ɸѡ֮�������
Ratio2=zeros(real_length,1);
R_mean2=zeros(real_length,1);
R_median2=zeros(real_length,1);
R_variance2=zeros(real_length,1);
rate2=zeros(real_length,1);
for k=1:real_length
    Ratio2(k,1)=Ratio(real(k,1),1);
    R_mean2(k,1)=R_mean(real(k,1),1);
    R_median2(k,1)=R_median(real(k,1),1);
    R_variance2(k,1)=R_variance(real(k,1),1);
    rate2(k,1)=rate(real(k,1),1);
end

remark=zeros(real_length,1);
figure;
imshow(im);
title('������С��Ӿ���');
hold on;
for k=1:real_length
    rectangle('position', RECT(real(k,1),:), 'EdgeColor', 'r','LineWidth',1.5);
end
hold off

%%
figure;
imshow(im);
title('�����ϲ�����');
hold on;
%�ϲ����ڵľ���
s1=zeros(real_length,1);
s2=zeros(size(s1));
w=zeros(size(s1));
Area=zeros(size(s1));
Real_length=real_length;
for k=1:Real_length
    s1(k)=RECT(real(k),1);
    s2(k)=RECT(real(k),2);
    w(k)=RECT(real(k),3);
    h(k)=RECT(real(k),4);
    Area(k)=w(k)*h(k);
end
p=1;q=2;i=1;
text1=zeros(size(s1));
text2=zeros(size(s1));

JuXing=zeros(real_length,4);
jj=1;
while(p<=Real_length&&q<=Real_length )
    if Real_length==1
        break;
    end
    if abs(s1(q)-s1(p)-w(p))<=20 && abs(s2(q)-s2(p))<=15 && max(R_mean2(q,1),R_mean2(p,1))/min(R_mean2(q,1),R_mean2(p,1))<=10 && h(q)/h(p)<=2              
          %��ɫ����
          I_p = im2(round(s2(p)):round(s2(p))+h(p),round(s1(p)):round(s1(p))+w(p),:);
          I_q = im2(round(s2(q)):round(s2(q))+h(q),round(s1(q)):round(s1(q))+w(q),:);
          I_p1 = I_bw(round(s2(p)):round(s2(p))+h(p),round(s1(p)):round(s1(p))+w(p));
          [xp,yp]=find(I_p1==1);
          I_q1 = I_bw(round(s2(q)):round(s2(q))+h(q),round(s1(q)):round(s1(q))+w(q));
          [xq,yq]=find(I_q1==1);
          m=min(length(xp),length(xq));
          r_p=zeros(m,1);g_p=zeros(m,1);b_p=zeros(m,1);
          for k=1:size(m)
              r_p(k)=I_p(xp(k),yp(k),1);
              g_p(k)=I_p(xp(k),yp(k),2);
              b_p(k)=I_p(xp(k),yp(k),3);
          end
          r_q=zeros(m,1);g_q=zeros(m,1);b_q=zeros(m,1);
          for k=1:size(m)
              r_q(k)=I_q(xq(k),yq(k),1);
              g_q(k)=I_q(xq(k),yq(k),2);
              b_q(k)=I_q(xq(k),yq(k),3);
          end
          rmean=(r_p+r_q)./2;
          r=abs(r_p-r_q);
          g=abs(g_p-g_q);
          b=abs(b_p-b_q);
          color=sqrt((2.+rmean./256).*(r.*r)+4.*(g.*g)+(2.+(255.-rmean)./256).*(b.*b));
          color2=mean(color(:));
                       
        if color2<=20
          text1(i)=p;text2(i)=q;
          i=i+1;
          p=q;
          q=q+1;
          continue;
        else
            q=q+1;
            continue;
        end
    end
     if q==Real_length && p==1
             
             s1(1)=[];w(1)=[];
             s2(1)=[];h(1)=[];
             Real_length=Real_length-1;
             p=1;
             q=2;
             continue;
     else if q==Real_length && p~=1
         text2=text2(text2~=0);
         length2=length(text2);
         text1=text1(text1~=0);
         text1(length2+1)=text2(length2);
         s_real=zeros(length2+1,1);
         h_real=zeros(length2+1,1);
         for s=1:length2+1
             s_real(s)=s2(text1(s));
             h_real(s)=h(text1(s))+s2(text1(s));
         end
         S2=min(s_real(:));
         W=s1(text2(length2))-s1(text1(1))+w(text2(length2));
         H=max(h_real(:))-S2;
         if H<=70 && H >=15 && W/H>=1.2
             I_Rect = I_Src(round(S2):round(S2)+H,round(s1(text1(1))):round(s1(text1(1)))+W,:);
             %I_Rect=im2bw( I_Rect);
             [xx,yy]=find(I_Rect~=1);
             Count=W*H-length(xx);
             if Count/(W*H)<=0.7
                rectangle('position', [s1(text1(1)),S2,W,H], 'EdgeColor', 'r','LineWidth',1.5);
                JuXing(jj,:)=[s1(text1(1)),S2,W,H];
                jj=jj+1;
             end
         end
         S2=0;H=0;
            s1(text1)=[];w(text1)=[];
            s2(text1)=[];h(text1)=[];
            Real_length=Real_length-length2-1;
            p=1;q=2;i=1;text1=zeros(real_length,1);text2=zeros(real_length,1);
            continue;
         end
     end
        q=q+1;
end

%%
%�ϲ��ظ��ľ��ο�
JuXing(any(JuXing,2)==0,:)=[];
xmin=JuXing(:,1);
ymin=JuXing(:,2);
xmax=xmin+JuXing(:,3);
ymax=ymin+JuXing(:,4);
overlapRatio = bboxOverlapRatio(JuXing,JuXing);
n = size(overlapRatio,1); 
overlapRatio(1:n+1:n^2) = 0;
g = graph(overlapRatio);
componentIndices = conncomp(g);
xmin = accumarray(componentIndices', xmin, [], @min);
ymin = accumarray(componentIndices', ymin, [], @min);
xmax = accumarray(componentIndices', xmax, [], @max);
ymax = accumarray(componentIndices', ymax, [], @max);
textBBoxes = [xmin,ymin,xmax-xmin+1,ymax-ymin+1];
numRegionsInGroup = histcounts(componentIndices);
textBBoxes(numRegionsInGroup >= 2,:) = [];
ITextRegion = insertShape(im, 'Rectangle', textBBoxes,'Color','r','LineWidth',3);
%figure;
%imshow(ITextRegion);
imageSize = [256,256];
figure;
imshow(im);
title('�ı����');
hold on;
%HOG+SVM�ı��ͷ��ı�����
for i=1:size(textBBoxes,1)
    I_text = im(round(ymin(i,1)):round(ymax(i,1)),round(xmin(i,1)):round(xmax(i,1)),:);
    flow_model_mat = load('./svm_model/model');
    classifer = flow_model_mat.classifer; 
    scaleTestImage = imresize(I_text,imageSize); 
    featureTest = extractHOGFeatures(scaleTestImage); 
    [predictIndex,score] = predict(classifer,featureTest); 
    if strcmp(char(predictIndex),'text')==1
         rectangle('position', [xmin(i,1),ymin(i,1),xmax(i,1)-xmin(i,1),ymax(i,1)-ymin(i,1)], 'EdgeColor', 'r','LineWidth',1);
    end
end



