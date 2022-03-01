library(stringr)
library(tidyverse)

#Load in data
GHCN <- read.csv('clean-data/filtered-datasets/GHCNFiltered.csv')
GHCN <- data.frame(GHCN)

SNOW <- read.csv('clean-data/filtered-datasets/SNOWFiltered.csv')
SNOW <- data.frame(SNOW)

NAO <- read.csv('clean-data/NAO_Index_80_20.csv')
NAO <- data.frame(NAO)

#Fix SNOW date format
for(row in 1:nrow(SNOW)){
  
  #get current value
  badDate <- SNOW[row,'DATE']
  
  #cast to string
  badDate <- toString(badDate)
  
  #Cut out Year, Month, Day
  day <- str_sub(badDate,6,7)
  month <- str_sub(badDate,9,10)
  year <- str_sub(badDate,1,4)
  
  #Replace '/' with '-'
  goodDate <- paste(year,'-',month,'-',day,sep='')
  
  SNOW[row,'DATE'] <- goodDate
}

#Sort datasets by name and date
GHCN <- GHCN[order(GHCN[,2],GHCN[,6]),]
SNOW <- SNOW[order(SNOW[,1],SNOW[,4]),]

#Reset GHCN and SNOW indexes
row.names(GHCN) <- NULL
row.names(SNOW) <- NULL

#Create new GHCN columns
GHCN$DELTA_SNWD <- NA
GHCN$DELTA_TMAX_TMIN <- NA
GHCN$DELTA_TMAX_1D <- NA
GHCN$DELTA_TMIN_1D <- NA

#Populate new columns
for(row in 2:nrow(GHCN)){
  if(GHCN[row,'NAME'] == GHCN[row-1,'NAME']){
    GHCN[row,"DELTA_SNWD"] <- (GHCN[row,'SNWD']-GHCN[row-1,'SNWD'])
    GHCN[row,"DELTA_TMAX_TMIN"] <- (GHCN[row,'TMAX']-GHCN[row,'TMIN'])
    GHCN[row,"DELTA_TMAX_1D"] <- (GHCN[row,'TMAX']-GHCN[row-1,'TMAX'])
    GHCN[row,"DELTA_TMIN_1D"] <- (GHCN[row,'TMIN']-GHCN[row-1,'TMIN'])
    print(row) 
  }
  else{
    next
  }
}

#Create new SNOW columns
SNOW$DELTA_DEPTH <- NA
SNOW$DELTA_DENSITY <- NA
SNOW$DELTA_WATER <- NA

#Populate new columns
for(row in 2:nrow(SNOW)){
  if(SNOW[row,'SITE_NAME'] == SNOW[row-1,'SITE_NAME']){
    SNOW[row,"DELTA_DEPTH"] <- (SNOW[row,'DEPTH']-SNOW[row-1,'DEPTH'])
    SNOW[row,"DELTA_DENSITY"] <- (SNOW[row,'DENSITY']-SNOW[row-1,'DENSITY'])
    SNOW[row,"DELTA_WATER"] <- (SNOW[row,'WATER']-SNOW[row-1,'WATER'])
    print(row)
  }
}

#Add NAO data to both datasets
GHCN_NAO <- merge(x=GHCN,y=NAO,by=c("DATE"),all.x=TRUE,no.dups = FALSE)
SNOW_NAO <- merge(x=SNOW,y=NAO,by=c("DATE"),all.x=TRUE,no.dups = FALSE)

GHCN_NAO <- read.csv("clean-data/filtered-datasets/GHCN_DELTA_NAO.csv")
SNOW_NAO <- read.csv("clean-data/filtered-datasets/SNOW_DELTA_NAO.csv")
GHCN_NAO <- data.frame(GHCN_NAO)
SNOW_NAO <- data.frame(SNOW_NAO)


# write.csv(GHCN_NAO,"clean-data/filtered-datasets/GHCN_DELTA_NAO.csv", row.names = FALSE)
# write.csv(SNOW_NAO,"clean-data/filtered-datasets/SNOW_DELTA_NAO.csv", row.names = FALSE)
