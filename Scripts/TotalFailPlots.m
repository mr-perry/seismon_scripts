function [LLO_Total_Fail, LHO_Total_Fail] = TotalFailPlots(LLO_matching, LHO_matching)
    %
    % Get events where locks failed
    % 
    LLO_Total_Fail = LLO_matching(LLO_matching(:,26)==2,:);
    LHO_Total_Fail = LHO_matching(LHO_matching(:,26)==2,:);
    %%
    % Epcientral Distance vs. LockLoss Time
    %
    figure('unit','normalized','outerposition',[0 0 1 1])
    hold on
    for ii = 1 : length(LLO_Total_Fail(:,18))
        plot([LLO_Total_Fail(ii,18)./1000./111.12,LLO_Total_Fail(ii,18)./1000./111.12],[(LLO_Total_Fail(ii,27)-LLO_Total_Fail(ii,6)).*1440, (LLO_Total_Fail(ii,27)-LLO_Total_Fail(ii,1)).*1440],'--','Color',[0.75 0.75 0.75])
    end
    for ii = 1 : length(LHO_Total_Fail(:,18))
        plot([LHO_Total_Fail(ii,18)./1000./111.12,LHO_Total_Fail(ii,18)./1000./111.12],[(LHO_Total_Fail(ii,27)-LHO_Total_Fail(ii,6)).*1440, (LHO_Total_Fail(ii,27)-LHO_Total_Fail(ii,1)).*1440],'--','Color',[0.75 0.75 0.75])
    end
    h1 = plot(LLO_Total_Fail(:,18)./1000./111.12,(LLO_Total_Fail(:,27)-LLO_Total_Fail(:,6)).*1440,'ko');
    h2 = plot(LHO_Total_Fail(:,18)./1000./111.12,(LHO_Total_Fail(:,27)-LHO_Total_Fail(:,6)).*1440,'ro');
    h3 = plot(LLO_Total_Fail(:,18)./1000./111.12,(LLO_Total_Fail(:,27)-LLO_Total_Fail(:,1)).*1440,'kx');
    h4 = plot(LHO_Total_Fail(:,18)./1000./111.12,(LHO_Total_Fail(:,27)-LHO_Total_Fail(:,1)).*1440,'rx');
    xlabel('Epicental Distance (m???)')
    ylabel('Lock Loss Time (s after Origin Time)')
    title('Lock Loss Time vs. Epicentral Distance')
    axis([0 max(max(LLO_Total_Fail(:,18)./1000./111.12),max(LHO_Total_Fail(:,18)./1000./111.12)) 0 max(max((LLO_Total_Fail(:,27)-LLO_Total_Fail(:,6)).*1440),max((LHO_Total_Fail(:,27)-LHO_Total_Fail(:,6)).*1440))])
    axis square
    legend([h1,h2,h3,h4], 'LLO LockLoss Relative to LIGO OT', 'LLO LockLoss Relative to NEIC OT',...
        'LHO LockLoss Relative to LIGO OT','LHO LockLoss Relative to NEIC OT','Location','Northwest')
    savefig('~/LIGO/FIGURES/TotalFailPlots/Distance_vs_LockLoss')
    print('~/LIGO/FIGURES/TotalFailPlots/Distance_vs_LockLoss.png','-dpng')
    %%
    % Pass Fail Time Series
    
    figure('unit','normalized','outerposition',[0 0 1 1]);
    hold on
    for ii = 1 : length(LLO_Total_Fail(:,6))
        plot([LLO_Total_Fail(ii,6),LLO_Total_Fail(ii,1)],[(LLO_Total_Fail(ii,27)-LLO_Total_Fail(ii,6)).*1440,(LLO_Total_Fail(ii,28))./60],'k-')
    end
    for ii = 1 : length(LHO_Total_Fail(:,6))
        plot([LHO_Total_Fail(ii,6),LHO_Total_Fail(ii,1)],[(LHO_Total_Fail(ii,27)-LHO_Total_Fail(ii,6)).*1440,(LHO_Total_Fail(ii,28))./60],'r-')
    end
    hold on
%     plot(,,'k--o')
    h1=plot(LLO_Total_Fail(:,6),(LLO_Total_Fail(:,27)-LLO_Total_Fail(:,6)).*1440,'ko');
    h2=plot(LLO_Total_Fail(:,1),(LLO_Total_Fail(:,28))./60,'kx');
    h3=plot(LHO_Total_Fail(:,6),(LHO_Total_Fail(:,27)-LHO_Total_Fail(:,6)).*1440,'ro');
    h4=plot(LHO_Total_Fail(:,1),(LHO_Total_Fail(:,28))./60,'rx');
    datetick('x','mm/yyyy')
    h5 = plot([min(LHO_Total_Fail(:,1)), max(LHO_Total_Fail(:,1))],[median((LLO_Total_Fail(:,27)-LLO_Total_Fail(:,6)).*1440),median((LLO_Total_Fail(:,27)-LLO_Total_Fail(:,6)).*1440)],'k--') 
    h6 = plot([min(LHO_Total_Fail(:,1)), max(LHO_Total_Fail(:,1))],[median((LLO_Total_Fail(:,28))./60),median((LLO_Total_Fail(:,28))./60)],'k--') 
    %%ylim([0 60])
    %%
    % Histogram 
    %
    time_bins = 0-2.5:5:360+2.5;
    figure('unit','normalized','outerposition',[0 0 1 1]);
    subplot(2,2,1)
    histogram((LLO_Total_Fail(:,27)-LLO_Total_Fail(:,6)).*1440,time_bins)
    hold on
    LLO_Mean = mean((LLO_Total_Fail(:,27)-LLO_Total_Fail(:,6)).*1440);
    LLO_STD = std((LLO_Total_Fail(:,27)-LLO_Total_Fail(:,6)).*1440);
    plot([LLO_Mean,LLO_Mean],[0 15],'r-')
    plot([LLO_Mean+LLO_STD,LLO_Mean+LLO_STD],[0 15],'r--')
    plot([LLO_Mean-LLO_STD,LLO_Mean-LLO_STD],[0 15],'r--')
    subplot(2,2,3)
    histogram((LLO_Total_Fail(:,28))./60,time_bins)
    hold on
    LLO_Mean2 = mean((LLO_Total_Fail(:,28))./60);
    LLO_STD2 = std((LLO_Total_Fail(:,28))./60);
    plot([LLO_Mean2,LLO_Mean2],[0 15],'r-')
    plot([LLO_Mean2+LLO_STD2,LLO_Mean2+LLO_STD2],[0 15],'r--')
    plot([LLO_Mean2-LLO_STD2,LLO_Mean2-LLO_STD2],[0 15],'r--')
    subplot(2,2,2)
    histogram((LHO_Total_Fail(:,27)-LHO_Total_Fail(:,6)).*1440,time_bins)
    hold on
    LHO_Mean = mean((LHO_Total_Fail(:,27)-LHO_Total_Fail(:,6)).*1440);
    LHO_STD = std((LHO_Total_Fail(:,27)-LHO_Total_Fail(:,6)).*1440);
    plot([LHO_Mean,LHO_Mean],[0 15],'r-')
    plot([LHO_Mean+LHO_STD,LHO_Mean+LHO_STD],[0 15],'r--')
    plot([LHO_Mean-LHO_STD,LHO_Mean-LHO_STD],[0 15],'r--')
    subplot(2,2,4)
    histogram((LHO_Total_Fail(:,28))./60,time_bins)
    hold on
    LHO_Mean = mean((LHO_Total_Fail(:,28))./60);
    LHO_STD = std((LHO_Total_Fail(:,28))./60);
    plot([LHO_Mean,LHO_Mean],[0 15],'r-')
    plot([LHO_Mean+LHO_STD,LHO_Mean+LHO_STD],[0 15],'r--')
    plot([LHO_Mean-LHO_STD,LHO_Mean-LHO_STD],[0 15],'r--')
    %%
    % Parse the events that pass and fail (response time < Lock Loss)
    %
    PassInd_LLO = find((LLO_Total_Fail(:,27)-LLO_Total_Fail(:,6))<(LLO_Total_Fail(:,28))./86400);
    FailInd_LLO = find((LLO_Total_Fail(:,27)-LLO_Total_Fail(:,6))>=(LLO_Total_Fail(:,28))./86400);
    PassInd_LHO = find((LHO_Total_Fail(:,27)-LHO_Total_Fail(:,6))<(LHO_Total_Fail(:,28))./86400);
    FailInd_LHO = find((LHO_Total_Fail(:,27)-LHO_Total_Fail(:,6))>=(LHO_Total_Fail(:,28))./86400);
    Pass_LLO = LLO_Total_Fail(PassInd_LLO,:);
    Fail_LLO = LLO_Total_Fail(FailInd_LLO,:);
    Pass_LHO = LHO_Total_Fail(PassInd_LHO,:);
    Fail_LHO = LHO_Total_Fail(FailInd_LHO,:);
    %%
    % Magnitude Histgrams
    %
    min_mag = min(min(LLO_Total_Fail(:,7)),min(LHO_Total_Fail(:,7)));
    max_mag =  max(max(LLO_Total_Fail(:,7)),max(LHO_Total_Fail(:,7)));
    mag_bins = min_mag-0.25:0.5:max_mag+0.25;
    figure('unit','normalized','outerposition',[0 0 1 1])
    subplot(2,2,1)
    histogram(Pass_LLO(:,7),mag_bins)
    hold on
    plot([median(Pass_LLO(:,7)) median(Pass_LLO(:,7))],[0 20])
    title(sprintf('LLO Passing Events\nMedian -- %2.2f',median(Pass_LLO(:,7))),'fontsize',18)
    xlabel('Magnitude','fontsize',14)
    ylabel('Event Count','fontsize',14)
    axis([4.75 7.25 0 15])
    set(gca,'FontSize',14)
    subplot(2,2,2)
    histogram(Fail_LLO(:,7),mag_bins)
    hold on
    plot([median(Fail_LLO(:,7)) median(Fail_LLO(:,7))],[0 20])
    title(sprintf('LLO Fail Events\nMedian -- %2.2f',median(Fail_LLO(:,7))),'fontsize',18)
    xlabel('Magnitude','fontsize',14)
    ylabel('Event Count','fontsize',14)
    axis([4.75 7.25 0 15])
    set(gca,'FontSize',14)
    subplot(2,2,3)
    histogram(Pass_LHO(:,7),mag_bins)
    hold on
    plot([median(Pass_LHO(:,7)) median(Pass_LHO(:,7))],[0 20])
    title(sprintf('LHO Passing Events\nMedian -- %2.2f',median(Pass_LHO(:,7))),'fontsize',18)
    xlabel('Magnitude','fontsize',14)
    ylabel('Event Count','fontsize',14)
    axis([4.75 7.25 0 15])
    set(gca,'FontSize',14)
    subplot(2,2,4)
    histogram(Fail_LHO(:,7),mag_bins)
    hold on
    plot([median(Fail_LHO(:,7)) median(Fail_LHO(:,7))],[0 20])
    title(sprintf('LHO Failing Events\nMedian -- %2.2f',median(Fail_LHO(:,7))),'fontsize',18)
    xlabel('Magnitude','fontsize',14)
    ylabel('Event Count','fontsize',14)
    axis([4.75 7.25 0 15])
    set(gca,'FontSize',14)
    savefig('~/LIGO/FIGURES/TotalFailPlots/PassFailMagHistograms')
    print('~/LIGO/FIGURES/TotalFailPlots/PassFailMagHistograms.png','-dpng')