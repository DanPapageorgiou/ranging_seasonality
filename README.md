# ranging_seasonality
Seasonality impacts collective movements in a wild group-living bird.

This repository contains code associated with the analysis run for the manuscript: “Seasonality impacts collective movements in a wild group-living bird” by Papageorgiou, Rozen-Rechels, Nyaguthii and Farine published in Movement Ecology. This work investigates how seasonality and drought influence collective movement in groups of vulturine guineafowl (Accryllium vulturinum), which range freely in the Kenyan savannah. The raw GPS data that were collected for this study are stored on the Movebank data repository: https://www.movebank.org/cms/webapp?gwt_fragment=page=studies,path=study475851705

The first script (1.get&prepare_data.R) includes the steps for downloading data from movebank, excluding outliers and creating a dataset that only contains one GPS fix every five minutes.

The second script (2.code_hr_ dtd.R) provides the code to calculate home range (AKDE, question 1) and daily travelled distance (question 2) by using the ctmm package. The input data in this script should be a data file that contains for each individual, in each season, one GPS fix every five minutes.

The third script (3.code_dhor_shor.R) provides the code to calculate the tendency for individuals to use the same areas on consecutive days (question 3) and the season-to-season range fidelity (question 4) by using the ctmm package. The input data in this script is a data file that contains for each social group, as represented by one individual, in each season, one GPS fix every five minutes.

The fourth script (4.code_popf.R) calculates the population’s KDE in different seasons (question 5), using one GPS fix every hour from each tracked group.

The fifth script (5.LMMs.R) has three input data files (df_hr_dtd.Rdata,  df_dhor.Rdata, df_shor.Rdata), which reproduce the results of the models examined for questions 1-4. All of these LMMs are presented in the Supplementary Material of the paper. 
