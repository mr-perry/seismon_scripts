function [] = LIGO_MagCompare()
    clear all; close all
    LIGO_File1 = '../Data/Original/LLO_analysis_locks.txt';
    LIGO_File2 = '../Data/Original/LHO_analysis_locks.txt';
    NEICQCFile = '../Data/Original/NEIC_QC_2015_2016.csv';
    %
    % Load and Convert LIGO_File1
    LLO = import_LIGO(LIGO_File1,1);
    % Load and Convert LIGO_File2
    LHO = import_LIGO(LIGO_File2,1);
    % Load and Convert NEIC QC File
    NEIC = import_NEICQC(NEICQCFile);
    LLO_match = getMatchingEvents(LLO,NEIC,16,100);
    LHO_match = getMatchingEvents(LHO,NEIC,16,100);
    Total_match = unique([LLO_match;LHO_match],'stable','rows');
    %%
    plotMagDifference(Total_match.FinalMagnitude,Total_match.InitialMagnitude);
    function data = import_LIGO(filename,GPSTimeConvert)
        %% Initialize variables.
        delimiter = ' ';
        startRow = 1;
        endRow = inf;
        formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
        fileID = fopen(filename,'r');
        dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true,'ReturnOnError', false);
        for block=2:length(startRow)
            frewind(fileID);
            dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'ReturnOnError', false);
            for col=1:length(dataArray)
                dataArray{col} = [dataArray{col};dataArrayBlock{col}];
            end
        end
        fclose(fileID);
        Mag = dataArray{:, 2};
        pgm = dataArray{:, 8};
        Latitude = dataArray{:, 11};
        Longitude = dataArray{:, 12};
        Distance = dataArray{:, 13};
        Depth = dataArray{:, 14};
        pgv = dataArray{:, 16};
        pga = dataArray{:, 18};
        pgd = dataArray{:, 20};
        LockLossFlag = dataArray{:, 21};
        if GPSTimeConvert == 1
            OriginTime = tconvert(dataArray{:, 1});
            P_GpsTime = tconvert(dataArray{:, 3});
            S_GpsTime = tconvert(dataArray{:, 4});
            r2_GpsTime = tconvert(dataArray{:, 5});
            r35_GpsTime = tconvert(dataArray{:, 6});
            r5_GpsTime = tconvert(dataArray{:, 7});
            lb_GpsTime = tconvert(dataArray{:, 9});
            ub_GpsTime = tconvert(dataArray{:, 10});
            pgv_GpsTime = tconvert(dataArray{:, 15});
            pga_GpsTime = tconvert(dataArray{:, 17});
            pgd_GpsTime = tconvert(dataArray{:, 19});
            for ii = 1 : length(dataArray{:,22})
                if dataArray{1,22}(ii) >=0 
                    LockLoss_GpsTime(ii,1) = tconvert(dataArray{1, 22}(ii));
                else
                    LockLoss_GpsTime(ii,1) = dataArray{1, 22}(ii);
                end
            end
        else
            OriginTime = dataArray{:, 1};
            P_GpsTime = dataArray{:, 3};
            S_GpsTime = dataArray{:, 4};
            r2_GpsTime = dataArray{:, 5};
            r35_GpsTime = dataArray{:, 6};
            r5_GpsTime = dataArray{:, 7};
            lb_GpsTime = dataArray{:, 9};
            ub_GpsTime = dataArray{:, 10};
            pgv_GpsTime = dataArray{:, 15};
            pga_GpsTime = dataArray{:, 17};
            pgd_GpsTime = dataArray{:, 19};
            LockLoss_GpsTime(:,1) = dataArray{:, 22};
        end
        data = table(OriginTime,Latitude,Longitude,Depth,Mag);
    end
    function data = import_NEICQC(filename)
        delimiter = ',';
        startRow = 2;
        endRow = inf;
        %% Format string for each line of text: Only Columns of interest for this study noted
        %   column3: PDE Origin Time (%f)
        %	column4: PDE Magnitude (%f)
        %   column5: PDE Latitude (%f)
        %	column6: PDE Longitude (%f)
        %   column7: PDE Depth (%f)
        %	column44: Initial Magnitude (%f)
        formatSpec = '%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s%f%f%f%f%f%s%f%f%s%f%s%f%f%f%f%f%s%f%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s%s%f%f%[^\n\r]';
        fileID = fopen(filename,'r');
        dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
        for block=2:length(startRow)
            frewind(fileID);
            dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
            for col=1:length(dataArray)
                dataArray{col} = [dataArray{col};dataArrayBlock{col}];
            end
        end
        %% Close the text file.
        fclose(fileID);
        OriginTime = dataArray{:, 35};
        OriginTime = datenum(OriginTime,'yyyy/mm/dd HH:MM:SS');
        FinalMagnitude = dataArray{:, 4};
        Latitude = dataArray{:, 5};
        Longitude = dataArray{:, 6};
        Depth = dataArray{:, 7};
        InitialMagnitude = dataArray{:, 44};
%         InitialMagnitude = dataArray{:, 10};
%         
        % For now, just save the important information
        %
        data = table(OriginTime,Latitude,Longitude,Depth,FinalMagnitude,InitialMagnitude);
    end
    function data = getMatchingEvents(LIGO_data,NEIC_data,tmax,dmax)
        %
        % Useful variables
        %
        C = [];
        sec_per_day = 86400;
        m1=0;
        M1=0;
        m2=0;
        M2=0;
        %
        % Convert Time Window
        %
        tmax = tmax/sec_per_day;
        % Get matching LIGO events
        for ii = 1 : length(LIGO_data.OriginTime);
            clear C
            C(:,1) = (LIGO_data.OriginTime(ii) - NEIC_data.OriginTime)./tmax;
            C(:,2) = distance_hvrsn(LIGO_data.Latitude(ii), LIGO_data.Longitude(ii),...
                NEIC_data.Latitude, NEIC_data.Longitude)./dmax;
            [~,ind] = min(sqrt(sum(abs(C).^2,2)));
            if isempty(C)
                m1=m1+1;
                missing_LIGO_ind(m1,:) = ii;
            elseif abs(C(ind,1)) > 1;
                m1=m1+1;
                missing_LIGO_ind(m1,:) = ii;
            elseif abs(C(ind,1)) <= 1 && C(ind,2) <= 1
                M1=M1+1;
                matching_LIGO_ind(M1,:) = [ii,ind];
            end
        end
        %
        % Get magnitudes for matching events
        % 
        data = NEIC_data(matching_LIGO_ind(:,2),:);
    end
    function [] = plotMagDifference(FinalMag,InitialMag)
        minMag = 4.0;
        maxMag = max(FinalMag);
        magStep = 0.5;
        MagVec = [minMag:magStep:maxMag];
        AverageDiff = zeros(length(MagVec),1);
        for ii = 1 : length(MagVec);
            ind = find(FinalMag >=  MagVec(ii) & FinalMag < MagVec(ii) + magStep);
            AverageDiff(ii,1) = mean(FinalMag(ind)-InitialMag(ind));
            STDDiff(ii,1) = std(FinalMag(ind)-InitialMag(ind));
        end
        figure;clf
        hold on
        for ii = 1 : length(AverageDiff)
            plot([MagVec(ii)-magStep/2, MagVec(ii)+magStep/2],[AverageDiff(ii),AverageDiff(ii)],'k')
            plot([MagVec(ii), MagVec(ii)],[AverageDiff(ii)-STDDiff(ii),AverageDiff(ii)+STDDiff(ii)],'k')
%             set(get(gca,'child'),'FaceColor','None','EdgeColor','k');
        end
%         errorbar(MagVec,AverageDiff,STDDiff,'k+','MarkerSize',12)
%         bar(MagVec,AverageDiff,1)
%         set(get(gca,'child'),'FaceColor',[0.26 0.83 0.96],'EdgeColor','b');
%         set(get(gca,'child'),'FaceColor','k','EdgeColor','k');
        ylabel('Average Change in Magnitude per Magnitude Bin','fontsize',14)
        xlabel('Final Magnitude','fontsize',14)
        title(sprintf('Average Change in Magnitude per Magnitude Bin\nFinal Magnitude - Initial Magnitude'),...
            'fontsize',18);
        set(gca,'FontSize',14)
        axis([4.0 8.35 min(AverageDiff)-max(STDDiff)-0.2 max(AverageDiff)+max(STDDiff)+0.2])
    end
end