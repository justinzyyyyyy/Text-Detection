imdsTrain = imageDatastore('E:\�ٶ���\ͼ����\text-detection\HOG_SVM',...  
    'IncludeSubfolders',true,...  
    'LabelSource','foldernames'); 
Train_disp = countEachLabel(imdsTrain);
disp(Train_disp);
imageSize = [256,256];% ������ͼ����д˳ߴ������ ?
image1 = readimage(imdsTrain,1); 
scaleImage = imresize(image1,imageSize); 
[features, visualization] = extractHOGFeatures(scaleImage); 
imshow(scaleImage);hold on; plot(visualization) 
numImages = length(imdsTrain.Files); 
featuresTrain = zeros(numImages,size(features,2),'single'); % featuresTrainΪ������ ?
for i = 1:numImages 
 imageTrain = readimage(imdsTrain,i); 
 imageTrain = imresize(imageTrain,imageSize); 
 featuresTrain(i,:) = extractHOGFeatures(imageTrain); 
end 
trainLabels = imdsTrain.Labels;
classifer = fitcsvm(featuresTrain,trainLabels,'KernelFunction','linear'); 
save('./svm_model/model','classifer');



