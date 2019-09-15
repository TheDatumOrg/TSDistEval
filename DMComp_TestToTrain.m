function DM = DMComp_TestToTrain(X,Y,Parameter1)

    [nrowsX, ~]=size(X);
    [nrowsY, ~]=size(Y);

    DM = zeros(nrowsX,nrowsY);

    for i=1:nrowsX
            disp(i);
            tmpX = X(i,:);
            for j=1:nrowsY                  
                if DistanceIndex==1
                    DM(i,j) = ED(tmpX,Y(i,:));
                elseif DistanceIndex==2
                    DM(i,j) = 1-max( NCCc(tmpX,Y(i,:)) );
                elseif DistanceIndex==3
                    DM(i,j) = MSM_mex(tmpX,Y(i,:), Parameter1);
                elseif DistanceIndex==4
                    DM(i,j) = dtw(tmpX,Y(i,:), Parameter1);
                elseif DistanceIndex==5
                    DM(i,j) = edr(tmpX,Y(i,:), Parameter1);
                elseif DistanceIndex==6
                    DM(i,j) = SINK(tmpX,Y(i,:), Parameter1);   
                elseif DistanceIndex==7
                    DM(i,j) = logGAK(tmpX',Y(i,:)',Parameter1,0);
                end       
            end    
    end
end