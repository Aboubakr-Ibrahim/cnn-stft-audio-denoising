function layers = build_mask_cnn(inputSize)
%BUILD_MASK_CNN Compact fully convolutional ideal-ratio-mask estimator.
layers=[
    imageInputLayer(inputSize,'Normalization','none','Name','input')
    convolution2dLayer(3,16,'Padding','same','Name','conv1')
    batchNormalizationLayer('Name','bn1')
    reluLayer('Name','relu1')
    convolution2dLayer(3,32,'Padding','same','Name','conv2')
    batchNormalizationLayer('Name','bn2')
    reluLayer('Name','relu2')
    convolution2dLayer(3,32,'Padding','same','Name','conv3')
    reluLayer('Name','relu3')
    convolution2dLayer(1,1,'Padding','same','Name','mask_logits')
    sigmoidLayer('Name','bounded_mask')
    regressionLayer('Name','loss')];
end
