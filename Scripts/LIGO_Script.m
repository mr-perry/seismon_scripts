clear all; close all
LIGO_File1 = '../Data/Original/LLO_analysis_locks.txt';
LIGO_File2 = '../Data/Original/LHO_analysis_locks.txt';
NEICQCFile = '../Data/Original/NEIC_QC_2015_2016.csv';
%
% Load and Convert LIGO_File1
LLO = import_LIGO(LIGO_File1,1);
LIGO_to_LibComCat(LLO,'~/LIGO/Data/LibComCat/LLO_LibComCat.csv');
% Load and Convert LIGO_File2
LHO = import_LIGO(LIGO_File2,1);
LIGO_to_LibComCat(LHO,'~/LIGO/Data/LibComCat/LHO_LibComCat.csv');
% Load and Convert NEIC QC File
NEIC = import_NEICQC(NEICQCFile,'~/LIGO/Data/LibComCat/NEIC_QC_2015_2016_reformat.csv');
%%
% Find matching events
%
tmax = 16;
dmax = 100;
[LLO_matching, LLO_missing, LLO] = get_matching_LIGO(LLO, NEIC, tmax, dmax);
[LHO_matching, LHO_missing, LHO] = get_matching_LIGO(LHO, NEIC, tmax, dmax);
%% 
% Reload Original LIGO Data and Put necessary data in final column
%
LLO_Output = import_LIGO(LIGO_File1,0);
LHO_Output = import_LIGO(LIGO_File2,0);
LLO_Output(:,23) = LLO(:,23);
LHO_Output(:,23) = LHO(:,23);
delim = '\t';
dlmwrite('~/LIGO/Data/WithPublishTime/LLO_analysis_locks_with_pub_time.txt',LLO_Output,'delimiter',delim,'precision','%10.1f');
dlmwrite('~/LIGO/Data/WithPublishTime/LHO_analysis_locks_with_pub_time.txt',LHO_Output,'delimiter',delim,'precision','%10.1f');
%%
[LLO_Total_Fail, LHO_Total_Fail] = TotalFailPlots(LLO_matching, LHO_matching);
[LLO_No_Fail, LHO_No_Fail] = NoFailPlots(LLO_matching, LHO_matching);
%%
FailCompare(LLO_No_Fail, LLO_Total_Fail, LHO_No_Fail, LHO_Total_Fail)
%%
plot_LIGO_events(LLO,LHO,'LLO','LHO')
