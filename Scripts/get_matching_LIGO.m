function [matching_data, missing_data, LIGO_data] = ...
    get_matching_LIGO(LIGO_data, NEIC_data, tmax, dmax)    
    %
    % Useful variables
    %
    sec_per_day = 86400;
    m1=0;
    M1=0;
    m2=0;
    M2=0;
    %
    % Convert Time window
    %
    tmax = tmax/sec_per_day;
    for ii = 1 : length(LIGO_data);
        clear C
        C(:,1) = (LIGO_data(ii,1) - NEIC_data.data(:,1))./tmax;
        C(:,2) = distance_hvrsn(LIGO_data(ii,11),LIGO_data(ii,12),NEIC_data.data(:,3),NEIC_data.data(:,4))./dmax;
        [~,ind] = min(sqrt(sum(abs(C).^2,2)));
        if isempty(C)
            m1=m1+1;
            missing_LIGO_ind(m1,:) = [ii];
        elseif abs(C(ind,1)) > 1
            m1 = m1 + 1;
            missing_LIGO_ind(m1,:) = [ii];
        elseif abs(C(ind,1)) <= 1 && C(ind,2) <= 1
            M1 = M1 + 1;
            matching_LIGO_ind(M1,:) = [ii,ind];
        end
    end
    matching_data = [NEIC_data.data(matching_LIGO_ind(:,2),:),LIGO_data(matching_LIGO_ind(:,1),:)];
    %
    % Get Matrix of first pub times
    %
    First_Pubs = zeros(length(NEIC_data.sINST(:,2)),3);
    for ii = 1 : length(NEIC_data.sINST(:,2));
        First_Pubs(ii,1) = NEIC_data.sINST{ii,2};
        First_Pubs(ii,2) = NEIC_data.sINST{ii,3};
        First_Pubs(ii,3) = NEIC_data.sINST{ii,4};
        First_Pubs(ii,4) = NEIC_data.sINST{ii,5};
        First_Pubs(ii,5) = NEIC_data.sINST{ii,6};
    end
    First_Pubs(:,6) = min(First_Pubs,[],2);
    for ii = 1 : length(matching_LIGO_ind(:,2))
        matching_data(ii,28) = First_Pubs(matching_LIGO_ind(ii,2),6);
        LIGO_data(matching_LIGO_ind(ii,1),23) = First_Pubs(matching_LIGO_ind(ii,2),6);
        LIGO_data(matching_LIGO_ind(ii,1),24:33) = NEIC_data.HypoProg(matching_LIGO_ind(ii,2),:);
    end
    LIGO_data(LIGO_data(:,23)==0,23) = NaN;
    missing_data = LIGO_data(missing_LIGO_ind,:);
    %
    % Sort Data by NEIC OT
    %
    [~,I] = sort(matching_data(:,1));
    matching_data = matching_data(I,:);
end