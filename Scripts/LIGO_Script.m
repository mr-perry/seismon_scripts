clear all; close all
LIGO_File1 = '../Data/Original/LLO_analysis_locks.txt';
LIGO_File2 = '../Data/Original/LHO_analysis_locks.txt';
NEICQCFile = '../Data/Original/NEIC_QC_2015_2016.csv';
%
% Load and Convert LIGO_File1
LLO = import_LIGO(LIGO_File1);
LIGO_to_LibComCat(LLO,'~/LIGO/Data/LibComCat/LLO_LibComCat.csv');
% Load and Convert LIGO_File2
LHO = import_LIGO(LIGO_File2);
LIGO_to_LibComCat(LHO,'~/LIGO/Data/LibComCat/LHO_LibComCat.csv');
%% Load and Convert NEIC QC File
NEIC = import_NEICQC(NEICQCFile,'~/LIGO/Data/LibComCat/NEIC_QC_2015_2016_reformat.csv');
%%
% Find matching events
%
tmax = 16;
dmax = 100;
[LLO_matching, LLO_missing] = get_matching_LIGO(LLO, NEIC, tmax, dmax);
[LHO_matching, LHO_missing] = get_matching_LIGO(LHO, NEIC, tmax, dmax);
%%
[LLO_Total_Fail, LHO_Total_Fail] = TotalFailPlots(LLO_matching, LHO_matching);

%%
plot_LIGO_events(LLO,LHO,'LLO','LHO')
