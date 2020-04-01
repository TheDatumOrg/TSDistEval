function acc = OneNNClassifierWITHDMCBFBIG(DS, DMTESTTOTRAIN, UpToThisID)
    
    acc = 0;
    
    for id = 1 : DS.TestInstancesCount

        %best_so_far = inf;
        best_so_far = -99999999999;
        
        for i = 1 : UpToThisID
            
            %compare_to_this = DS.Train(i,:);

            distance = DMTESTTOTRAIN(id, i);
            

            if distance > best_so_far
                class = DS.TrainClassLabels(i);
                best_so_far = distance;
            end
        end
        
        if (DS.TestClassLabels(id) == class)
            acc = acc + 1;
        end
    end
    
    acc = acc / DS.TestInstancesCount;
end
