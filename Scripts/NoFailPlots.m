function [LLO_No_Fail, LHO_No_Fail] = NoFailPlots(LLO_matching, LHO_matching)
    %
    % Get events where locks failed
    % 
    LLO_No_Fail = LLO_matching(LLO_matching(:,26)==1,:);
    LHO_No_Fail = LHO_matching(LHO_matching(:,26)==1,:);