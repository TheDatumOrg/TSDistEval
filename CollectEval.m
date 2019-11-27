% Compute average > = < and stat significant


Results = zeros(13,5);

for i=2:13
    [p,h] = signrank(test(:,1),test(:,i),'alpha', 0.05);
    Results(i,1)=h;    
    Results(i,2)=mean(test(:,i));
    
    better=0;
    same=0;
    worse=0;
    for k=1:128
        if test(k,i)>test(k,1) better=better+1; end
        if test(k,i)==test(k,1) same=same+1; end
        if test(k,i)<test(k,1) worse=worse+1; end
    end
    Results(i,3)= better;
    Results(i,4)= same;
    Results(i,5)= worse;
    
end
            
            
    