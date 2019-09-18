function [NewData,NewLabels] = StratifiedSampling(Data,ClassNames,ClassLabels,NewDataSize)

    rng(1);

    [n,m] = size(Data);

    nClasses = length(ClassNames);

    NewData = [];
    NewLabels = [];

    for i=1:nClasses

        ClassI = ( ClassLabels == i);
        nClassI = sum(double(ClassI))

        NewSizeClassI = floor(NewDataSize*nClassI/n)

        DataTmp = Data(find(ClassLabels==i),:);

        nClassI == size(DataTmp,1);

        ShuffleIDs = randperm(nClassI);

        NewData = [NewData; DataTmp(ShuffleIDs(1:NewSizeClassI),:)];
        NewLabels = [NewLabels; i*ones(NewSizeClassI,1)];
    end

end

