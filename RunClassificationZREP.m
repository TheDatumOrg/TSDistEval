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

                    
    
                    LeaveOneOutAccuracies = zeros(length(Datasets),22);

                    %gammaValues =[1e-3 3e-3 1e-2 3e-2 0.10 0.14 0.19 0.28 0.39 0.56 0.79 1.12 1.58 2.23 3.16 4.46 6.30 8.91 10 31.62 1e2 3e2 1e3];
                    gammaValues =[1e-3 3e-3 1e-2 3e-2 0.10 0.14 0.28 0.39 0.56 0.79 1.12 1.58 2.23 3.16 4.46 6.30 8.91 10 31.62 1e2 3e2 1e3];
                    
                    


                    for gammaIter = 1:22
                    
                    %if gammaIter==1
                    %    ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '_L_', num2str(0.1), '_R_', num2str(0.1) ,'.Zrep')  );
                    %elseif gammaIter==2
                    %    ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '_L_', num2str(0.1), '_R_', num2str(0.25) ,'.Zrep')  );
                    %elseif gammaIter==3
                    %    ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '_L_', num2str(0.1), '_R_', num2str(0.5) ,'.Zrep')  );
                    %elseif gammaIter==4
                    %    ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '_L_', num2str(1), '_R_', num2str(0.1) ,'.Zrep')  );
                    %elseif gammaIter==5
                    %    ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '_L_', num2str(1), '_R_', num2str(0.25) ,'.Zrep')  );
                    %elseif gammaIter==6
                    %    ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '_L_', num2str(1), '_R_', num2str(0.5) ,'.Zrep')  );
                    %elseif gammaIter==7
                    %    ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '_L_', num2str(10), '_R_', num2str(0.1) ,'.Zrep')  );
                    %elseif gammaIter==8
                    %    ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '_L_', num2str(10), '_R_', num2str(0.25) ,'.Zrep')  );
                    %elseif gammaIter==9
                    %    ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '_L_', num2str(10), '_R_', num2str(0.5) ,'.Zrep')  );
                    %end
                    
                       % ZRep = dlmread( strcat( 'ALLGRAILREP-GRAIL/ALLGRAILREP/Gamma',num2str(gammaIter), '/', char(Datasets(i)),'/','RepLearningFixedSamples', '_', 'Random', '_', num2str(1) ,'.Zexact') );
                        ZRep = dlmread( strcat( 'RWSREPRESENTATIONS','/',char(Datasets(i)),'/','RWS_UNSupervised_Sigma_',num2str(gammaValues(gammaIter)),'_DMax25', '.Zrep') );
                        %ZRepresentation = dlmread( strcat( 'REPRESENTATIONSFULLKM/',char(Datasets(i)),'/','RepresentationFULLKM_', num2str(gammaValues(gammaIter)) ,'.Z20' ));
                        %ZRepresentation = dlmread( strcat( 'REPRESENTATIONSGamma', num2str(gammaValues(gammaIter)),'/',char(Datasets(i)),'/','RepLearningFixedSamples', '_', char(Methods(Method)), '_', num2str('1') ,'.Ztop10'));
                        
                        acc = LeaveOneOutClassifierZREP(DS,ZRep);
                        LeaveOneOutAccuracies(i,gammaIter) = acc;
                        
                    end
                    
                    [MaxLeaveOneOutAcc,MaxLeaveOneOutAccGamma] = max(LeaveOneOutAccuracies(i,:));
                    
                    %ZRep = dlmread( strcat( 'ALLGRAILREP-GRAIL/ALLGRAILREP/Gamma',num2str(MaxLeaveOneOutAccGamma), '/', char(Datasets(i)),'/','RepLearningFixedSamples', '_', 'Random', '_', num2str(1) ,'.Zexact') );
                    ZRep = dlmread( strcat( 'RWSREPRESENTATIONS','/',char(Datasets(i)),'/','RWS_UNSupervised_Sigma_',num2str(gammaValues(MaxLeaveOneOutAccGamma)),'_DMax25', '.Zrep') );
                     
                    
                    
                    %if MaxLeaveOneOutAccGamma==1
                    %    ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '_L_', num2str(0.1), '_R_', num2str(0.1) ,'.Zrep')  );
                    %elseif MaxLeaveOneOutAccGamma==2
                    %    ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '_L_', num2str(0.1), '_R_', num2str(0.25) ,'.Zrep')  );
                    %elseif MaxLeaveOneOutAccGamma==3
                    %    ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '_L_', num2str(0.1), '_R_', num2str(0.5) ,'.Zrep')  );
                    %elseif MaxLeaveOneOutAccGamma==4
                    %    ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '_L_', num2str(1), '_R_', num2str(0.1) ,'.Zrep')  );
                    %elseif MaxLeaveOneOutAccGamma==5
                    %    ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '_L_', num2str(1), '_R_', num2str(0.25) ,'.Zrep')  );
                    %elseif MaxLeaveOneOutAccGamma==6
                    %    ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '_L_', num2str(1), '_R_', num2str(0.5) ,'.Zrep')  );
                    %elseif MaxLeaveOneOutAccGamma==7
                    %    ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '_L_', num2str(10), '_R_', num2str(0.1) ,'.Zrep')  );
                    %elseif MaxLeaveOneOutAccGamma==8
                    %    ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '_L_', num2str(10), '_R_', num2str(0.25) ,'.Zrep')  );
                    %elseif MaxLeaveOneOutAccGamma==9
                    %    ZRep = dlmread( strcat( 'SIDLREPRESENTATIONS-GRAIL','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '_L_', num2str(10), '_R_', num2str(0.5) ,'.Zrep')  );
                    %end
                    
                                        
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
                    dlmwrite( strcat( 'RESULTS_RunClassificationZREP_RWS_', '.results'), Results, 'delimiter', '\t');
            end
    end
    
end