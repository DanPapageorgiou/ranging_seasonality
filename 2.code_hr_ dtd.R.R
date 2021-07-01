#' The raw GPS data from which we generate ctmm objects are stored on Movebank and can be visualised accessing the study named "Avulturinum_Farine"
#' The URL of the study is: https://www.movebank.org/cms/webapp?gwt_fragment=page=studies,path=study475851705
#' Below we provide the code to calculate the home range (AKDE) and daily travelled distance 
#' for each tracked individual, using the ctmm package.
#' For each tracked individual in each season we used 1 GPS fix every five minutes.
#' Use the same working directory as in script 1.get&prepare_data.R


#' Load dataset for each tracked individual one season ( named "GPSdata"). 
load("5minGPSdata.Rdata")

#' This a list of telemetry objects and each telemetry object contains five minute data 
#' for each tracked individual.

library(ctmm)

uere <- 1.297578 #' check ?uere in the ctmm package and Fleming & Calabrese 2019 for a definition and suggestions on how to calculate an uere

AREA_SQM <- c()
speed_km_day <- c()

for (i in 1:length(GPSdata)){
  a <- GPSdata[[i]]
  GUESS <- ctmm.guess(a,interactive=FALSE)
  FITS <- ctmm.fit(a,GUESS)
  sum <- summary(FITS, units=F)
  

  AREA_SQM[i]  <- sum[[3]][1,2]
  
  speed_km_day[i] <- speed(FITS, a)[1,2]
}












