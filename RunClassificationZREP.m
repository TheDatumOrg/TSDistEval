function RunClassificationZREP(DataSetStartIndex, DataSetEndIndex)  
  
    Methods = [cellstr('Random'), 'KShape'];
    
    % first 2 values are '.' and '..' - UCR Archive 2018 version has 128 datasets
    dir_struct = dir('./UCR2018/');
    Datasets = {dir_struct(3:130).name};
                     
    % Sort Datasets
    
    [Datasets, DSOrder] = sort(Datasets);    
    
    addpath(genpath('lockstepmeasures/.'));
    addpath(genpath('slidingmeasures/.'));
    addpath(genpath('elasticmeasures/.'));
    
    
    Results = zeros(length(Datasets),1);
    for i = 1:length(Datasets)

            if (i>=DataSetStartIndex & i<=DataSetEndIndex)

                    disp(['Dataset being processed: ', char(Datasets(i))]);
                    DS = LoadUCRdataset(char(Datasets(i)));

                    
    
                    LeaveOneOutAccuracies = zeros(length(Datasets),9);

                    gammaValues = 1:9;

                    for gammaIter = 1:9
                    
                    if gammaIter==1
                        ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(DatasetsNumber)),'/','SIDLREPRESENTATIONS', '_L_', num2str(0.1), '_R_', num2str(0.1) ,'.Zrep')  );
                    elseif gammaIter==2
                        ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(DatasetsNumber)),'/','SIDLREPRESENTATIONS', '_L_', num2str(0.1), '_R_', num2str(0.25) ,'.Zrep')  );
                    elseif gammaIter==3
                        ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(DatasetsNumber)),'/','SIDLREPRESENTATIONS', '_L_', num2str(0.1), '_R_', num2str(0.5) ,'.Zrep')  );
                    elseif gammaIter==4
                        ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(DatasetsNumber)),'/','SIDLREPRESENTATIONS', '_L_', num2str(1), '_R_', num2str(0.1) ,'.Zrep')  );
                    elseif gammaIter==5
                        ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(DatasetsNumber)),'/','SIDLREPRESENTATIONS', '_L_', num2str(1), '_R_', num2str(0.25) ,'.Zrep')  );
                    elseif gammaIter==6
                        ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(DatasetsNumber)),'/','SIDLREPRESENTATIONS', '_L_', num2str(1), '_R_', num2str(0.5) ,'.Zrep')  );
                    elseif gammaIter==7
                        ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(DatasetsNumber)),'/','SIDLREPRESENTATIONS', '_L_', num2str(10), '_R_', num2str(0.1) ,'.Zrep')  );
                    elseif gammaIter==8
                        ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(DatasetsNumber)),'/','SIDLREPRESENTATIONS', '_L_', num2str(10), '_R_', num2str(0.25) ,'.Zrep')  );
                    elseif gammaIter==9
                        ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(DatasetsNumber)),'/','SIDLREPRESENTATIONS', '_L_', num2str(10), '_R_', num2str(0.5) ,'.Zrep')  );
                    end
                    
                                            
                        %ZRepresentation = dlmread( strcat( 'REPRESENTATIONSFULLKM/',char(Datasets(i)),'/','RepresentationFULLKM_', num2str(gammaValues(gammaIter)) ,'.Z20' ));
                        %ZRepresentation = dlmread( strcat( 'REPRESENTATIONSGamma', num2str(gammaValues(gammaIter)),'/',char(Datasets(i)),'/','RepLearningFixedSamples', '_', char(Methods(Method)), '_', num2str('1') ,'.Ztop10'));
                        
                        acc = LeaveOneOutClassifierZREP(DS,ZRep);
                        LeaveOneOutAccuracies(i,gammaIter) = acc;
                        
                    end
                    
                    [MaxLeaveOneOutAcc,MaxLeaveOneOutAccGamma] = max(LeaveOneOutAccuracies(i,:));
                    
                    
                    
                    
                    if gammaIter==MaxLeaveOneOutAccGamma
                        ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(DatasetsNumber)),'/','SIDLREPRESENTATIONS', '_L_', num2str(0.1), '_R_', num2str(0.1) ,'.Zrep')  );
                    elseif gammaIter==MaxLeaveOneOutAccGamma
                        ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(DatasetsNumber)),'/','SIDLREPRESENTATIONS', '_L_', num2str(0.1), '_R_', num2str(0.25) ,'.Zrep')  );
                    elseif gammaIter==MaxLeaveOneOutAccGamma
                        ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(DatasetsNumber)),'/','SIDLREPRESENTATIONS', '_L_', num2str(0.1), '_R_', num2str(0.5) ,'.Zrep')  );
                    elseif gammaIter==MaxLeaveOneOutAccGamma
                        ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(DatasetsNumber)),'/','SIDLREPRESENTATIONS', '_L_', num2str(1), '_R_', num2str(0.1) ,'.Zrep')  );
                    elseif gammaIter==MaxLeaveOneOutAccGamma
                        ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(DatasetsNumber)),'/','SIDLREPRESENTATIONS', '_L_', num2str(1), '_R_', num2str(0.25) ,'.Zrep')  );
                    elseif gammaIter==MaxLeaveOneOutAccGamma
                        ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(DatasetsNumber)),'/','SIDLREPRESENTATIONS', '_L_', num2str(1), '_R_', num2str(0.5) ,'.Zrep')  );
                    elseif gammaIter==MaxLeaveOneOutAccGamma
                        ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(DatasetsNumber)),'/','SIDLREPRESENTATIONS', '_L_', num2str(10), '_R_', num2str(0.1) ,'.Zrep')  );
                    elseif gammaIter==MaxLeaveOneOutAccGamma
                        ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(DatasetsNumber)),'/','SIDLREPRESENTATIONS', '_L_', num2str(10), '_R_', num2str(0.25) ,'.Zrep')  );
                    elseif gammaIter==MaxLeaveOneOutAccGamma
                        ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(DatasetsNumber)),'/','SIDLREPRESENTATIONS', '_L_', num2str(10), '_R_', num2str(0.5) ,'.Zrep')  );
                    end
                    
                                        
                    %ZRepresentation = dlmread( strcat( 'SPIRALREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '.Zrep') );
                    %ZRepresentation = dlmread( strcat( 'RWSREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','RWS_UNSupervised_Sigma1000_DMax25', '.Zrep') );
                    %ZRepresentation = dlmread( strcat( 'REPRESENTATIONSFULLKM/',char(Datasets(i)),'/','RepresentationFULLKM_', num2str(gammaValues(MaxLeaveOneOutAccGamma)) ,'.Z20' ));
                    %ZRepresentation = dlmread( strcat( 'REPRESENTATIONSGamma', num2str(gammaValues(MaxLeaveOneOutAccGamma)),'/',char(Datasets(i)),'/','RepLearningFixedSamples', '_', char(Methods(Method)), '_', num2str('1') ,'.Ztop10'));
                       
                    OneNNAcc = OneNNClassifierZREP(DS,ZRep);
                    
                    %Results(i,1) = gammaValues(MaxLeaveOneOutAccGamma);
                    %Results(i,2) = MaxLeaveOneOutAcc;
                    %Results(i,3) = OneNNAcc;
                    
                    Results(i,1) = OneNNAcc;
                    
                    %dlmwrite( strcat( 'RESULTS_RunClassificationZREP_SPIRAL_', char(Methods(Method)), '_', num2str(i),'.results'), Results, 'delimiter', '\t');
                    dlmwrite( strcat( 'RESULTS_RunClassificationZREP_SIDL_', '.results'), Results, 'delimiter', '\t');
            end
    end
    
end