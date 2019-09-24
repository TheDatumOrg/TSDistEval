function DM = DMComp_TestToTrain(X,Y,DistanceIndex,Parameter1, Parameter2)

    [nrowsX, ~]=size(X);
    [nrowsY, ~]=size(Y);

    DM = zeros(nrowsX,nrowsY);

    parfor i=1:nrowsX
            %disp(i);
            tmpX = X(i,:);
            for j=1:nrowsY                  
                if DistanceIndex==1
                    DM(i,j) = ED(tmpX,Y(j,:));
                elseif DistanceIndex==2
                    DM(i,j) = 1-max( NCCc(tmpX,Y(j,:)) );
                elseif DistanceIndex==3
                    DM(i,j) = MSM_mex(tmpX,Y(j,:), Parameter1);
                elseif DistanceIndex==4
                    DM(i,j) = dtw(tmpX,Y(j,:), Parameter1);
                elseif DistanceIndex==5
                    DM(i,j) = edr(tmpX,Y(j,:), Parameter1);
                elseif DistanceIndex==6
                    DM(i,j) = SINK(tmpX,Y(j,:), Parameter1);   
                elseif DistanceIndex==7
                    DM(i,j) = logGAK(tmpX',Y(j,:)',Parameter1,0);
                elseif DistanceIndex==8
                    DM(i,j) = LCSS(tmpX',Y(j,:)',Parameter1,Parameter2);
                end       
            end    
    end
end