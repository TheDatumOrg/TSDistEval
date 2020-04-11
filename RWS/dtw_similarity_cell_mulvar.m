% This script computes the dissimilairty between random series and raw 
% time-series. We use dynamic time warping to compute the distance between 
% a pair of time-series. Other distance measure can be used as well. 
%
% Author: Lingfei Wu
% Date: 01/20/2019

function [KMat, user_dtw_runtime] = dtw_similarity_cell_mulvar(newX, baseX)
    
    m = size(newX,1);
    n = size(baseX,1);    
    KMat = zeros(m,n);
    user_dtw_runtime = 0;
    tic;
    parfor i = 1 : m
        Ei = zeros(1,n);
        l1 = size(newX{i},2);
        data1 = newX{i}';
        for j = 1 : n
            l2 = size(baseX{j},2);
            data2 = baseX{j}';
            wSize = min(40, ceil(max(l1,l2)/10));
            wSize = max(wSize, abs(l1 - l2));
            dtw_telapsed = tic;
            dist = dtw_c(data1, data2, wSize);% window constraints
%             dist = dtw_c(newX(i,:)', baseX(j,:)');% no constraints
            user_dtw_runtime = user_dtw_runtime + toc(dtw_telapsed);
            Ei(j) = dist;
        end
        KMat(i,:) = Ei;
    end
    toc;
    
end
