#' The raw GPS data from which we generate ctmm objects are stored on Movebank and can be visualised accessing the study named "Avulturinum_Farine"
#' The URL of the study is: https://www.movebank.org/cms/webapp?gwt_fragment=page=studies,path=study475851705
#' Below we provide the code to estimate the total area used (Question 5) by our study population in each different season
#' we thus pooled hourly GPS data of each study group in each season

#' Use the same working directory as in script 1.get&prepare_data.R

#' Load dataset for each tracked individual representing its group in one season (named "GPSdata"). 
load("1hrGPSdata.Rdata")

#' This a list of telemetry objects and each telemetry object contains 1 hour data 
#' for each individual representing its group.


#'Below we calculate the size of the area ultilised by the whole population 
#'in each of the focal seasons.

library(ctmm)
library(lubridate)
library(adehabitatHR)

kdes50 <- c()
kdes95 <- c()


for (i in 1:length(GPS_data)){
  
  a <- SpatialPoints.telemetry(GPS_data[[i]])
  a_ <- kernelUD(a,h="href")
  kdes95[i] <- kernel.area(a_, percent = c(95),unout = "km2")
  kdes50[i] <- kernel.area(a_, percent = c(50),unout = "km2")
  print(i) 
  
}

df <- data.frame(season_type=c("wet", "wet", "intermediate", "intermediate", "dry","dry","wet", "intermediate", "wet", "wet", "intermediate"),kdes50, kdes95)

