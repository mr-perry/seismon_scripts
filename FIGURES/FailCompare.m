function [] = FailCompare(LLO_No_Fail, LLO_Total_Fail, LHO_No_Fail, LHO_Total_Fail)
    figure('unit','normalized','outerposition',[0 0 .5 .5])
    plot(LLO_No_Fail(:,18)./1000./111.12,LLO_No_Fail(:,7),'gx')
    hold on
    plot(LLO_Total_Fail(:,18)./1000./111.12,LLO_Total_Fail(:,7),'rx')
    plot(LHO_No_Fail(:,18)./1000./111.12,LHO_No_Fail(:,7),'gd')
    plot(LHO_Total_Fail(:,18)./1000./111.12,LHO_Total_Fail(:,7),'rd')
    axis tight
    title('Failure as a function of epicentral distance and magnitude','fontsize',16)
    xlabel('Distance (degs)','fontsize',14)
    ylabel('Magnitude','fontsize',14)
    set(gca,'fontsize',14)
    savefig('~/LIGO/FIGURES/FailCompare/Distance_vs_Mag')
    print('~/LIGO/FIGURES/FailCompare/Distance_vs_Mag.png','-dpng')