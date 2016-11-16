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
        for ii = 1 : length(LIGO_data.OriginTime)
            clear C
            C(:,1) = (LIGO_data.OriginTime(ii) - NEIC_data.OriginTime)./tmax;
            C(:,2) = distance_hvrsn(LIGO_data.Latitude(ii), LIGO_data.Longitude(ii),...
                NEIC_data.Latitude, NEIC_data.Longitude)./dmax;
            [~,ind] = min(sqrt(sum(abs(C).^2,2)));
            if isempty(C)
                m1=m1+1;
                missing_LIGO_ind(m1,:) = ii;
            elseif abs(C(ind,1)) > 1
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
    function tout = tconvert(tin)
        %
        % function tout = tconvert(tin)
        %
        % Converts between gps (numerical format) and date (string)
        %
        % 'tin' can be an entire column vector of date strings or gps seconds
        %
        % The list of leap seconds is:
        %
        % leapseconds = 86400*datenum(strcat(...
        %     {'6/30/1972','12/31/1972','12/31/1973','12/31/1974',...
        %     '12/31/1975','12/31/1976','12/31/1977','12/31/1978','12/31/1979',...
        %     '6/30/1981','6/30/1982','6/30/1983','6/30/1985','12/31/1987',...
        %     '12/31/1989','12/31/1990','6/30/1992','6/30/1993','6/30/1994',...
        %     '12/31/1995','6/30/1997','12/31/1998','12/31/2005','12/31/2008', ...
        %     '6/30/2012','6/30/2015'},...
        %     ' 23:59:59'));
        %
        % This list needs to be updated whenever a new leap second occurs.
        %
        % Last changed: 8/25/2010
        %
        % Jan Harms
        %

        leapseconds = [62246102399,62261999999,62293535999,62325071999,62356607999,...
            62388230399, 62419766399, 62451302399, 62482838399, 62530099199,...
            62561635199, 62593171199, 62656329599, 62735299199, 62798457599,...
            62829993599, 62877254399, 62908790399, 62940326399, 62987759999,...
            63035020799, 63082454399, 63303379199, 63398073599, 63508320000,...
            63602928000];

        if isnumeric(tin)
            %calculate date string
            thisday = tin+62483270409;
         %   thisday = thisday-sum(thisday(:,ones(1,length(leapseconds)))...
         %       >leapseconds(ones(length(thisday),1),:),2);
            tout = (thisday-sum(thisday(:,ones(1,length(leapseconds)))...
                >leapseconds(ones(length(thisday),1),:),2))/86400;
          %  tout = datestr(thisday/86400);
        else
            %calculate GPS seconds
            thisday = 86400*datenum(tin);  
            tout = thisday-62483270409+sum(thisday(:,ones(1,length(leapseconds)))...
                >leapseconds(ones(length(thisday),1),:),2);
        end
    end
    function [dist_km] = distance_hvrsn(lat1, lon1, lat2, lon2)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Calculate the distance between two points on the globe using the
        % haversine formula.
        %
        % Input:
        % lat1 - decimal latitude of the first point
        % lon1 - decimal longitude of the first point
        % lat2 - decimal latitude of the second point
        % lon2 - decimal longitude of the second point
        %
        % Output
        % dist_degree - distance in degrees
        % dist_km - distance in kilometers
        % 
        % Last Edited: 13 January 2016 by Matthew R. Perry
        % Comments: Changed to one output
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        R = 6371000.;    % Earth's radius (m)
        d2r = pi/180;    % deg = rad*180/pi
        % Convert degree latitude and longitude to radians
        si1 = d2r*(lat1);
        si2 = d2r*(lat2);
        % Convert latitude and longitude differences to radians 
        si_del = d2r*(lat2 - lat1);
        lam_del = d2r*(lon2 - lon1);
        % Haversine forumlation for distance
        a = (sin(si_del/2).^2) + (cos(si1).*cos(si2).*(sin(lam_del/2)).^2);
        c = 2 * atan2(sqrt(a), sqrt(1-a));
        %Convert distance radians back to degrees
        dist_km = (R*c)/1000;
        %dist_degree = c * 180/pi;
    end
end