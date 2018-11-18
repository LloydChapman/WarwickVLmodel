Title: MATLAB code for running simulations of Warwick transmission models in “Policy recommendations from transmission modelling for the elimination of visceral leishmaniasis in the Indian subcontinent”

Version: 0.1.0

Author: Lloyd Chapman

Email: Lloyd.Chapman@lshtm.ac.uk

Description: MATLAB code for running simulations of the World Health Organization’s guidelines for visceral leishmaniasis (VL) elimination in the Indian subcontinent (described in [1]), for the Warwick VL ordinary differential equation transmission models described in [2] and [3]. This code is a modified and updated version of the code in [4], which in addition to model W1 (in which asymptomatic individuals are infectious to sandflies) now includes model W0, in which only clinical VL cases are infectious. The main file for choosing the model, setting the parameter values and running the simulations is “RunWHOSimltns.m”. The code outputs the results shown in Fig. 2 and Supplementary Figs 1 and 2 in [3], but can also be used to predict the impact of alternative intervention scenarios (different changes in average onset-to-treatment time for clinical cases and indoor residual insecticide spraying coverages).

Archive contents:
CalcAndPlotIncdnce.m
CalcIncdnceDiffWHO.m
CalcSeasonalR0.m
CalcSpctrlRdsFndmntlMtrxSoln.m
LnrsdInfctnSubsystem.m
MakeCSVfilesWHOSmltns.m
MakeCSVfilesWHOSmltnsDiffAttackPhaseLengths.m
PlotIncdnceDiffAttackPhaseLengths.m
PlotPrevalences.m
PlotPropnInEachState.m
PredictSubdstrctVLIncdnceWHO.m
RunWHOSimltns.m
TransmssnODEsWHO.m
(See individual files for a description of their function.)

Developed in: MATLAB R2015b (8.6.0.267246) @ 1984-2015 The MathWorks, Inc. 

Installation: MATLAB, which requires a user license, must be installed to run the code. It can be downloaded from https://uk.mathworks.com/downloads/. Information on installing and activating MATLAB can be found at https://uk.mathworks.com/help/install/. Save the contents of this archive in a folder, open MATLAB and change the current directory to the folder in which the files are saved. The code can then be run by typing “RunWHOSimltns” at the MATLAB command prompt. Different intervention scenarios can be tested by altering the contents of “RunWHOSimltns.m”.

License: GNU Affero General Public License v3.0 (http://www.gnu.org/licenses/agpl-3.0.txt)

References: [1] World Health Organization Regional Office for South-East Asia. Process of validation of elimination of kala-azar. Available at: http://www.who.int/leishmaniasis/resources/Process_of_validation_of_VL_elimination_SEA _CD_321.pdf?ua=1.
[2] Le Rutte EA, Chapman LAC, Coffeng LE, et al. Elimination of visceral leishmaniasis in the Indian subcontinent: a comparison of predictions from three transmission models. Epidemics 2017; 18:67–80. Supplementary File S1. https://ars.els-cdn.com/content/image/1-s2.0-S1755436516300792-mmc1.pdf
[3] Le Rutte EA, Chapman LAC, et al. Policy recommendations from transmission modelling for the elimination of visceral leishmaniasis in the Indian subcontinent. Clinical Infectious Diseases 2018. https://doi.org/10.1093/cid/ciy007
[4] Le Rutte EA, Chapman LAC, Coffeng LE, et al. Elimination of visceral leishmaniasis in the Indian subcontinent: a comparison of predictions from three transmission models. Epidemics 2017; 18:67–80. Supplementary File S6.
https://ars.els-cdn.com/content/image/1-s2.0-S1755436516300792-mmc6.zip
