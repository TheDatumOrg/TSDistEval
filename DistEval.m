

CorrMatrix = zeros(9,9);
for i=1:9
    for j=1:9
        CorrMatrix(i,j) = pdist2(test(:,i)',test(:,j)','corr');
    end
end