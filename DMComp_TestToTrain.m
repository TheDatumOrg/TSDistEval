function DM = DMComp_TestToTrain(X,Y,DistanceIndex,Parameter1, Parameter2)

    javaaddpath('./timeseries-1.0-SNAPSHOT.jar');
    javaaddpath('./simcompare.jar');
    obj = edu.uchicago.cs.tsdb.Distance;
    
    [nrowsX, TSLength]=size(X);
    [nrowsY, ~]=size(Y);

    DM = zeros(nrowsX,nrowsY);

    for i=1:nrowsX
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
                    %DM(i,j) = LCSS(tmpX',Y(j,:)',Parameter1,Parameter2);
                    DM(i,j) = obj.LCSSDistance(tmpX,Y(j,:),Parameter1,Parameter2);
                elseif DistanceIndex==9
                    DM(i,j) = TWED_mex(tmpX,1:TSLength,Y(j,:),1:TSLength,Parameter1,Parameter2);
                elseif DistanceIndex==10
                    DM(i,j) = obj.DissimDistance(tmpX,Y(j,:));
                elseif DistanceIndex==11
                    DM(i,j) = obj.TQuESTDistance(tmpX,Y(j,:),Parameter1,1,0,0.1);
                elseif DistanceIndex==12
                    DM(i,j) = obj.SwaleDistance(tmpX,Y(j,:),0,1,Parameter1);
                elseif DistanceIndex==13
                    DM(i,j) = KDTWNorm_mex(tmpX,Y(j,:),Parameter1);
                elseif DistanceIndex==14
                    DM(i,j) = obj.ERPDistance(tmpX,Y(j,:));
                end       
            end    
    end
end