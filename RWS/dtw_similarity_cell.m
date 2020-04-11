% This script computes the dissimilairty between random series and raw 
% time-series. We use dynamic time warping to compute the distance between 
% a pair of time-series. Other distance measure can be used as well. 
%
% Author: Lingfei Wu
% Date: 01/20/2019

function [KMat, user_dtw_runtime] = dtw_similarity_cell(newX, baseX)
    
    [m, l1] = size(newX);
    n = size(baseX,1);
    
    nrm_newX = zeros(m,1);
    tic;
    for i=1:m
		nrm_newX(i)=dtw_c(newX(i,:)',zeros(1));
    end
    nrm_baseX = zeros(n,1);
    for i=1:n
		nrm_baseX(i)=dtw_c(baseX{i}',zeros(1));
    end
    toc
    
    KMat = zeros(m,n);
    user_dtw_runtime = 0;
    tic;
    for i = 1 : m
        Ei = zeros(1,n);
        data1 = newX(i,:)';
        for j = 1 : n
            l2 = length(baseX{j});
            wSize = min(40, ceil(max(l1,l2)/10));
            wSize = max(wSize, abs(l1 - l2));
            wSize = 0;
            data2 = baseX{j}';
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
