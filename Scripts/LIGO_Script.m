clear all ;close all
LIGO_File1 = '../Data/Original/LLO_analysis_locks.txt';
LIGO_File2 = '../Data/Original/LHO_analysis_locks.txt';
LLO = import_LIGO(LIGO_File1);
%LIGO_to_LibComCat(LLO,'LLO_LibComCat.csv')
LHO = import_LIGO(LIGO_File2);
%LIGO_to_LibComCat(LHO,'LHO_LibComCat.csv')
plot_LIGO_events(LLO,LHO,'LLO','LHO')
