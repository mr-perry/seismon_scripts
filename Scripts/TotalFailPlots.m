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
    h1 = plot(LLO_Total_Fail(:,18)./1000./111.12,(LLO_Total_Fail(:,27)-LLO_Total_Fail(:,6)).*1440,'ko');
    h2 = plot(LHO_Total_Fail(:,18)./1000./111.12,(LHO_Total_Fail(:,27)-LHO_Total_Fail(:,6)).*1440,'ro');
    h3 = plot(LLO_Total_Fail(:,18)./1000./111.12,(LLO_Total_Fail(:,27)-LLO_Total_Fail(:,1)).*1440,'kx');
    h4 = plot(LHO_Total_Fail(:,18)./1000./111.12,(LHO_Total_Fail(:,27)-LHO_Total_Fail(:,1)).*1440,'rx');
    xlabel('Epicental Distance (deg)','fontsize',14)
    ylabel('Lock Loss Time (minutes after Origin Time)','fontsize',14)
    title('Lock Loss Time vs. Epicentral Distance','fontsize',18)
    axis([0 max(max(LLO_Total_Fail(:,18)./1000./111.12),max(LHO_Total_Fail(:,18)./1000./111.12)) 0 max(max((LLO_Total_Fail(:,27)-LLO_Total_Fail(:,6)).*1440),max((LHO_Total_Fail(:,27)-LHO_Total_Fail(:,6)).*1440))])
    axis square
    legend([h1,h2,h3,h4], 'LLO LockLoss Relative to LIGO OT', 'LLO LockLoss Relative to NEIC OT',...
        'LHO LockLoss Relative to LIGO OT','LHO LockLoss Relative to NEIC OT','Location','Northwest')
    set(gca,'fontsize',14)
    savefig('~/LIGO/FIGURES/TotalFailPlots/Distance_vs_LockLoss')
    print('~/LIGO/FIGURES/TotalFailPlots/Distance_vs_LockLoss.png','-dpng')
    %%
    %
    %
    %%
    % Pass Fail Time Series
    LLO_LockLoss_Min = (LLO_Total_Fail(:,27)-LLO_Total_Fail(:,6)).*1440;
    LHO_LockLoss_Min = (LHO_Total_Fail(:,27)-LHO_Total_Fail(:,6)).*1440;
    LLO_Publish_Min = (LLO_Total_Fail(:,28))./60;
    LHO_Publish_Min = (LHO_Total_Fail(:,28))./60;
    LLO_pass_ind = find(LLO_LockLoss_Min > LLO_Publish_Min);
    LLO_fail_ind = find(LLO_LockLoss_Min <= LLO_Publish_Min);
    LHO_pass_ind = find(LHO_LockLoss_Min > LHO_Publish_Min);
    LHO_fail_ind = find(LHO_LockLoss_Min <= LHO_Publish_Min);
    %
    figure('unit','normalized','outerposition',[0 0 1 1]);
    hold on
    %
    % LLO Pass Plot
    %
    for ii = 1 : length(LLO_pass_ind)
        if ii == 1
            h1 = plot([LLO_Total_Fail(LLO_pass_ind(ii),6),LLO_Total_Fail(LLO_pass_ind(ii),1)],...
            [LLO_Publish_Min(LLO_pass_ind(ii)),LLO_LockLoss_Min(LLO_pass_ind(ii))],'b-x');
        else
            plot([LLO_Total_Fail(LLO_pass_ind(ii),6),LLO_Total_Fail(LLO_pass_ind(ii),1)],...
            [LLO_Publish_Min(LLO_pass_ind(ii)),LLO_LockLoss_Min(LLO_pass_ind(ii))],'b-x')
        end
    end
    %
    %  LLO Fail Plot
    %
    for ii = 1 : length(LLO_fail_ind)
        if ii == 1 
            h2 = plot([LLO_Total_Fail(LLO_fail_ind(ii),6),LLO_Total_Fail(LLO_fail_ind(ii),1)],...
            [LLO_Publish_Min(LLO_fail_ind(ii)),LLO_LockLoss_Min(LLO_fail_ind(ii))],'r-x');
        else
            plot([LLO_Total_Fail(LLO_fail_ind(ii),6),LLO_Total_Fail(LLO_fail_ind(ii),1)],...
            [LLO_Publish_Min(LLO_fail_ind(ii)),LLO_LockLoss_Min(LLO_fail_ind(ii))],'r-x')
        end            
    end
    %
    % LHO Pass Plot
    %
    for ii = 1 : length(LHO_pass_ind)
        if ii == 1
            h3 = plot([LHO_Total_Fail(LHO_pass_ind(ii),6),LHO_Total_Fail(LHO_pass_ind(ii),1)],...
            [LHO_Publish_Min(LHO_pass_ind(ii)),LHO_LockLoss_Min(LHO_pass_ind(ii))],'b--o');
        else
            plot([LHO_Total_Fail(LHO_pass_ind(ii),6),LHO_Total_Fail(LHO_pass_ind(ii),1)],...
            [LHO_Publish_Min(LHO_pass_ind(ii)),LHO_LockLoss_Min(LHO_pass_ind(ii))],'b--o')
        end
    end
    %
    %  LHO Fail Plot
    %
    for ii = 1 : length(LHO_fail_ind)
        if ii == 1
            h4 = plot([LHO_Total_Fail(LHO_fail_ind(ii),6),LHO_Total_Fail(LHO_fail_ind(ii),1)],...
            [LHO_Publish_Min(LHO_fail_ind(ii)),LHO_LockLoss_Min(LHO_fail_ind(ii))],'r--o');
        else
            plot([LHO_Total_Fail(LHO_fail_ind(ii),6),LHO_Total_Fail(LHO_fail_ind(ii),1)],...
            [LHO_Publish_Min(LHO_fail_ind(ii)),LHO_LockLoss_Min(LHO_fail_ind(ii))],'r--o')
        end
    end
    ylim([0 60])
    datetick('x','mm/yyyy')
    legend([h1,h2,h3,h4],'LLO Pass','LLO Fail','LHO Pass','LHO Fail')
%%