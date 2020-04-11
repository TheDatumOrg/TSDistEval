function RunGRAILRepLearning(DataSetStartIndex, DataSetEndIndex, Method, gamma)  
    
    Methods = [cellstr('Random'), 'KShape'];
    
    % first 2 values are '.' and '..' - UCR Archive 2018 version has 128 datasets
    dir_struct = dir('./UCR2018/');
    Datasets = {dir_struct(3:130).name};
                     
    % Sort Datasets
    
    [Datasets, DSOrder] = sort(Datasets);  

    addpath(genpath('lockstepmeasures/.'));
    addpath(genpath('kernelmeasures/.'));
    
    for i = 1:length(Datasets)

            if (i>=DataSetStartIndex && i<=DataSetEndIndex)

                    display(['Dataset being processed: ', char(Datasets(i))]);
                    DS = LoadUCRdataset(char(Datasets(i)));
                    
                    for rep = 1 : 1
                        
                        rep
                        rng(rep);
                        
                        %if (rep>=RepStartIndex & rep<=RepEndIndex)
                        
                            %for gamma = 1 : 20

                                gamma
                                NumOfSamples = min(max( [4*length(DS.ClassNames), ceil(0.4*DS.DataInstancesCount),20] ),100);
                                if Method==1
                                    %Dictionary = dlmread( strcat( 'DICTIONARIESRANDOM/',char(Datasets(i)),'/','RunDLFixedSamples', '_', char(Methods(Method)), '_', num2str(rep) ,'.Dictionary') );
                                    
                                    permed_index = randperm(DS.DataInstancesCount);
                                    Dictionary = DS.Data(permed_index(1:NumOfSamples),:);
                            
                                elseif Method==2
                                    %Dictionary = dlmread( strcat( 'DICTIONARIESKSHAPE/',char(Datasets(i)),'/','RunDLFixedSamples', '_', char(Methods(Method)), '_', num2str(rep) ,'.Dictionary') );
                                end
                                
                                
                                [Zexact, Ztop5, Ztop10, Ztop20, Z99per, Z98per, Z97per, Z95per, Z90per, Z85per, Z80per, DistComp, RuntimeNystrom, RuntimeFD]=RepLearnGRAIL(DS.Data, Dictionary, gamma);

                                Results = [DistComp, RuntimeNystrom, RuntimeFD];
                                RTResult = RuntimeNystrom + RuntimeFD;
                                
                                %myflag = true;
                                %count=0;
                                %while(myflag)
                                
                                    
                                    %try
                                    dlmwrite( strcat( 'GRAILREPRESENTATIONS', '/',char(Datasets(i)),'/','RepLearningFixedSamples', '_', char(Methods(Method)), '_Gamma_',num2str(gamma),'_', num2str(rep) ,'.Zexact'), Zexact, 'delimiter', '\t');

                                    dlmwrite( strcat( 'GRAILREPRESENTATIONS-RT', '/',char(Datasets(i)),'/','RESULTS_RepLearningFixedSamples_', char(Methods(Method)), '_Gamma_',num2str(gamma), '_',num2str(rep) ,'.RT'), RTResult, 'delimiter', '\t');      
                                    
                                    %myflag = false;
                                    %%%%%%%%fclose('all') ;
                                    %catch
                                    %    disp('attempt to write failed - trying again');
                                    %    pause(30+rep+gamma)
                                        
                                    %end
                                    %count=count+1;
                                    %if count==5
                                    %    disp('5 attempts! - I quit!');
                                    %    break;
                                    %end
                                    
                                %end   

                            %end
                            
                            
                            
                            
                            
                        %end
                        
                    end
            end
            
            
    end
    
    
end
