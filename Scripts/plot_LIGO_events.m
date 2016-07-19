function [] = plot_LIGO_events(data1,data2,dataname1,dataname2)
    maxlon = max(max(data1(:,12)),max(data2(:,12)));
    minlon = min(min(data1(:,12)),min(data2(:,12)));
    if minlon < -170 && maxlon > 170
        %
        % Adjust Event Locations
        %
        for ii = 1 : length(data1(:,12))
            if data1(ii,12) < 0
                data1(ii,12) = data1(ii,12)+360;
            end
        end
        for ii = 1 : length(data2(:,12))
            if data2(ii,12) < 0
                data2(ii,12) = data2(ii,12)+360;
            end
        end
        %
        % Adjust World Map
        %
        load('Countries.mat');
        L = length(places);
        for ii = 1 : L
            clon=lon{ii,1};
            for jj = 1 : length(clon)
                if clon(jj) < 0
                    clon(jj) = clon(jj) + 360;
                end
            end
            clon(abs(diff(clon))>359) = NaN;
            lon{ii,1}=clon;
        end
        maxlat = max(max(data1(:,11)),max(data2(:,11)));
        minlat = min(min(data1(:,11)),min(data2(:,11)));
        maxlon = max(max(data1(:,12)),max(data2(:,12)));
        figure;clf
        hold on
        for ii = 1 : L
            plot(lon{ii,1},lat{ii,1},'k')
        end
        %
        % Plot Events
        %
        for ii = 1 : length(data1(:,12))
            if data1(ii,21) == 0
%                 if data1(ii,2)>=5.0 && data1(ii,2) < 6
%                     h1 = scatter(data1(ii,12),data1(ii,11),20,[0.5 0.5 0.5],'d');
%                 elseif data1(ii,2)>=6.0 && data1(ii,2) < 7
%                     h1 = scatter(data1(ii,12),data1(ii,11),40,[0.5 0.5 0.5],'d');
%                 elseif data1(ii,2)>=7.0
%                     h1 = scatter(data1(ii,12),data1(ii,11),60,[0.5 0.5 0.5],'d');
%                 end
            elseif data1(ii,21) == 1
                if data1(ii,2)>=5.0 && data1(ii,2) < 6
                    h2 = scatter(data1(ii,12),data1(ii,11),20,'g','d');
                elseif data1(ii,2)>=6.0 && data1(ii,2) < 7
                    h2 = scatter(data1(ii,12),data1(ii,11),40,'g','d');
                elseif data1(ii,2)>=7.0
                    h2 = scatter(data1(ii,12),data1(ii,11),60,'g','d');
                end
            elseif data1(ii,21) == 2
                if data1(ii,2)>=5.0 && data1(ii,2) < 6
                    h3 = scatter(data1(ii,12),data1(ii,11),20,'r','d');
                elseif data1(ii,2)>=6.0 && data1(ii,2) < 7
                    h3 = scatter(data1(ii,12),data1(ii,11),40,'r','d');
                elseif data1(ii,2)>=7.0
                    h3 = scatter(data1(ii,12),data1(ii,11),60,'r','d');
                end
            end
        end
        %%
        for ii = 1 : length(data2(:,12))
            if data2(ii,21) == 0
%                 if data2(ii,2)>=5.0 && data2(ii,2) < 6
%                     h4 = scatter(data2(ii,12),data2(ii,11),20,[0.5 0.5 0.5],'s');
%                 elseif data2(ii,2)>=6.0 && data2(ii,2) < 7.0
%                     h4 = scatter(data2(ii,12),data2(ii,11),40,[0.5 0.5 0.5],'s');
%                 elseif data2(ii,2)>=7.0
%                     h4 = scatter(data2(ii,12),data2(ii,11),60,[0.5 0.5 0.5],'s');
%                 end
            elseif data1(ii,21) == 1
                if data2(ii,2)>=5.0 && data2(ii,2)<6.0    
                    h4 = scatter(data2(ii,12),data2(ii,11),20,'g','s');
                elseif data2(ii,2)>=6.0 && data2(ii,2)<7.0    
                    scatter(data2(ii,12),data2(ii,11),40,'g','s')
                elseif data2(ii,2)>=6.0
                    scatter(data2(ii,12),data2(ii,11),60,'g','s')
                end
            elseif data1(ii,21) == 2
                if data2(ii,2)>=5.0 && data2(ii,2)<6.0 
                    scatter(data2(ii,12),data2(ii,11),20,'r','s')
                elseif data2(ii,2)>=6.0 && data2(ii,2)<7.0 
                    scatter(data2(ii,12),data2(ii,11),40,'r','s')
                elseif data2(ii,2)>=6.0
                    scatter(data2(ii,12),data2(ii,11),60,'r','s')
                end
            end
        end
        h5 = plot(-119.407656+360,46.455144,'ms','MarkerSize',15); % Hanford;
        h6 = plot(-90.774242+360,30.562894,'md','MarkerSize',15); % Livingston
        %
        % Get XTickLabel
        %
        X = round(linspace(minlon,maxlon,10));
        X_Tick = X;
        X(X>180) = X(X>180)-360;
        X_label = num2str(X');
        set(gca,'DataAspectRatio',[1,cosd(0),1])
        set(gca,'fontsize',15)
        axis([0 360 -90 90]);
        set(gca,'XTick',X_Tick);
        set(gca,'XTickLabel',X_label);
        xlabel('Longitude')
        ylabel('Latitude')
        title('LIGO -- Seismic Events')
        legend([h2,h3,h4,h5,h6],strcat(dataname1,' -- Locked No Failure'),...
            strcat(dataname1,' -- Locked and Failure'),strcat(dataname2,' -- Colors same as before'),...
            'LIGO Hanford','LIGO Livingston','Location','SouthOutside')
        grid on
        box on
    end
end
        