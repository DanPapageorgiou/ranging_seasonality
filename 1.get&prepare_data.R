library(move)
library(ctmm)
library(lubridate)

animals <- c("Metal Ring", "Metal Ring") # A vector of all individuals that were tracked in a given focal season.
season_start <- "YYYYMMDDHHMMSSS" # The start of a focal season.
season_end <-  "YYYYMMDDHHMMSSS" # The end of a focal season.
work.d <- "XXX" # Working directory.

setwd(work.d)

#Download dataset from Movebank (https://www.movebank.org/cms/webapp?gwt_fragment=page=studies,path=study475851705) 
loginStored <- movebankLogin(username="XXX", password="XXX") #Access to the data stored on movebank can be given upon reasonable request.

data<- getMovebankData(study="Avulturinum_Farine", animalName=animals, login=loginStored, timestamp_start=season_start, timestamp_end=season_end, removeDuplicatedTimestamps=T)

save(data, file="all_data.Rdata")

uere <- 1.297578 #' check ?uere in the ctmm package and Fleming & Calabrese 2019 for a definition and suggestions on how to calculate an uere

#Exclude outliers and create a dataset ("GPSdata) that includes one GPS fix every five minutes.

GPSdata <- list()

for(j in 1: length(unique(data@trackId))){
  
  a <-  data[[j]]  
  a<- a[order(a$timestamp)]
  a$distance <- c(move::distance(a), NA)
  
  data_ <- list()
  data_[[j]] <- a[which(a$distance < 300 | is.na(a$distance)),] #Exclude outliers
  
  days <- unique(as.Date(data_[[length(data_)]]$timestamp))
  hours <- seq(3,16,1)
  minutes <- seq(0,55,5)
  seconds <- 10
  
  times <- expand.grid(day=days,hour=hours,minute=minutes,second=seconds)
  times <- paste(times$day," ",times$hour,":",times$minute,":",times$second,sep="")
  dat <- sort(strptime(times, format="%Y-%m-%d %H:%M:%S", tz="UTC"))
  
  GPSdata[[j]] <- data_[[j]][which(data_[[j]]$timestamp %in% as.POSIXct(dat))]
  
}


GPSdata <- lapply(GPSdata, as.telemetry, UERE=uere) 

save(GPSdata, file= "5minGPSdata.Rdata")


