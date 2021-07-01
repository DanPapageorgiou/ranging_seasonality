#' The raw GPS data from which we generate ctmm objects are stored on Movebank and can be visualised accessing the study named "Avulturinum_Farine"
#' The URL of the study is: https://www.movebank.org/cms/webapp?gwt_fragment=page=studies,path=study475851705
#' Below we provide the code to calculate the day-to-day site fidelity (Question 3) and season-to-season range fidelity (Question 4) for each group, using the ctmm package.
#' For each group in each season we used 1 GPS fix every five minutes.
#' Use the same working directory as in script 1.get&prepare_data.R

#' Load dataset for each tracked individual one season ( named "GPSdata"). 
load("5minGPSdata.Rdata")

#' This a list of telemetry objects and each telemetry object contains five minute data 
#' for each individual representing its group.
 

#' First we calculate for each group in one season, 
#' the average temporal overlap in space use of the first 21 days of the focal season (Question 3)

library(dplyr)

autoverlap <-  array(NA, dim = c(21, 21, length(GPSdata)))

for (i in 1:length(GPSdata)){
  a <- unique(as.Date(GPSdata[[i]]$timestamp))
  for (j in 1:20){
    for (k in (j+1):21){
      if(k-j <=3){
        c <- GPSdata[[i]][which(as.Date(GPSdata[[i]]$timestamp) ==  a[j]),]
        d <- GPSdata[[i]][which(as.Date(GPSdata[[i]]$timestamp) ==  a[k]),]
        
        
        GUESSc <- ctmm.guess(c,interactive=FALSE)
        FITSVFc <- ctmm.fit(c,GUESSc)
        GUESSd <- ctmm.guess(d,interactive=FALSE)
        FITSVFd <- ctmm.fit(d,GUESSd)
        
        b <- overlap(list(FITSVFc, FITSVFd))
        autoverlap[j,k,i] <-   b[1,2,2]
        print(paste("group", i, "day", j, "to day", k))
      }
    }
  }
}

fidelity <- c()
for (i in 1 :length(GPSdata)){
  a <-autoverlap[,,i]
  fidelity[i] <- mean(a, na.rm = T)
}

##################################################################

#' Then we calculate for each group season-to-season range fidelity (Question 4)
#' 
#' Load dataset for each tracked individual that represents its group accross all seasons (named "GPSdata"). 

load("5minGPSdata.Rdata")

library(ctmm)
library(dplyr)

ids <- c()
for(i in 1: length(GPSdata)){
  for(j in 1: length(GPSdata[[i]])){
    ids <- c(ids,GPSdata[[i]][[j]]@info$identity)
  }
}
ids <- unique(ids) 


a_ <- list()
seasons_a_ <- list()

for (i in 1:length(ids)){
  a <- list()#this should be a list with all the data of one individual across seasons
  seasons_a <- c()
  
  for(j in 1:length(GPSdata)){
    for(o in 1:length(GPSdata[[j]])){
      if(ids[i] %in% GPSdata[[j]][[o]]@info$identity){
        a[[length(a)+1]] <- GPSdata[[j]][[o]]
        seasons_a <- c(seasons_a, j)
        
      }
    }
    
  }
  a_[[i]] <- a
  seasons_a_[[i]] <- seasons_a
  
}

rm(list=setdiff(ls(), c("a_", "seasons_a_", "ids")))

#calculate fits with the same projections to then be able and calculate overlap
a__ <- list()

for (i in 1: length(ids)){
  a___ <- list()
  for (j in 1:length(a_[[i]])){
    if (j==1){
      projection(a_[[i]][[j]]) <- median(a_[[i]][[j]])
      pro <- projection(a_[[i]][[j]])
    } else {projection(a_[[i]][[j]]) <- pro}
    
    GUESSc <- ctmm.guess(a_[[i]][[j]],interactive=FALSE)
    a___[[j]] <- ctmm.fit(a_[[i]][[j]],GUESSc)
    print(paste("individual", i, "season", seasons_a_[[i]][[j]]), sep="_")
  }
  a__[[i]] <- a___
}

autoverlap <- list()

for (i in 1: length(ids)){
  autoverlap[[i]] <-  matrix(NA, nrow=5, ncol=5)
  
  if(length(a__[[i]]) > 1){
    
    for (j in 1:(length(a__[[i]])-1)){
      
      for (k in (j+1):length(a__[[i]])){
        
        autoverlap[[i]][seasons_a_[[i]][j],seasons_a_[[i]][k]] <- overlap(list(a__[[i]][[j]], a__[[i]][[k]]))[1,2,2]
        print(paste("individual", i, "season", seasons_a_[[i]][[j]], "and season", seasons_a_[[i]][[k]], sep="_"))
      }
    }
  }
}

names(autoverlap) <- ids


