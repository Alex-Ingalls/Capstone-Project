#install.packages('stringr')
library(stringr)
library(tidyverse)

#Load in data
GHCN <- read.csv('clean-data/GHCN.csv')
GHCN <- data.frame(GHCN)

GHCNTemp <- read.csv('clean-data/GHCNTemp.csv')
GHCNTemp <- data.frame(GHCNTemp)

NAO <- read.csv('clean-data/NAO_Index_80_20.csv')
NAO <- data.frame(NAO)

SNOW <- read.csv('clean-data/Snow_Survey_79_21.csv')
SNOW <- data.frame(SNOW)

SNOWTemp <- read.csv('clean-data/SNOWTemp.csv')
SNOWTemp <- data.frame(SNOWTemp)

#Empty list of unique LAT/LON pairs
GHCNPairs <- list()
SNOWPairs <- list()

#Fill in the lists with unique coordinate pairs (lat/lon)
for(row in 1:nrow(GHCN)){
  lat <- GHCN[row,3]
  lon <- GHCN[row,4]
  coords <- toString(paste(lat,lon,sep=":"))
  if(coords %in% GHCNPairs){
    next
  }
  else{
    GHCNPairs <<- c(GHCNPairs,coords)
  }
}

for(row in 1:nrow(SNOW)){
  lat <- SNOW[row,8]
  lon <- SNOW[row,9]
  coords <- toString(paste(lat,lon,sep=":"))
  if(coords %in% SNOWPairs){
    next
  }
  else{
    SNOWPairs <<- c(SNOWPairs,coords)
  }
}

#Find matching pairs within a range
#0.1 = 55.55 Km
#0.01 = 5.55 Km
#0.001 = 5.55 m
precisionLimit <- 0.035

#Create empty df for the matching coordinate pairs
matchingCoords <- data.frame(matrix(ncol = 4, nrow = 0))
colnames(matchingCoords) <- c('GHCN_LAT','GHCN_LON','SNOW_LAT','SNOW_LON')

#Fill in the df with locations within a tolerance range
for(i in 1:length(GHCNPairs)){
  GLAT <- str_extract(GHCNPairs[i],"[^:]+")
  GLAT <- as.numeric(GLAT)
  GLON <- str_extract(GHCNPairs[i],'[^:]*$')
  GLON <- as.numeric(GLON)
  for(j in 1:length(SNOWPairs)){
    SLAT <- str_extract(SNOWPairs[j],"[^:]+")
    SLAT <- as.numeric(SLAT)
    SLON <- str_extract(SNOWPairs[j],'[^:]*$')
    SLON <- as.numeric(SLON)
    if((GLAT <= (SLAT+precisionLimit)) && (GLAT >= (SLAT-precisionLimit))){
      if((GLON <= (SLON+precisionLimit)) && (GLON >= (SLON-precisionLimit))){
        matchingCoords[nrow(matchingCoords)+ 1,] <- c(GLAT,GLON,SLAT,SLON)
      }
    }
  }
}

#Create a temporary GHCN data frame with matching columns to GHCN
GHCNTemp <- data.frame(matrix(ncol = ncol(GHCN),nrow = nrow(GHCN)))
colnames(GHCNTemp) <- colnames(GHCN)

#Create a temporary SNOW data frame with matching columns to SNOW
SNOWTemp <- data.frame(matrix(ncol = ncol(GHCN),nrow = nrow(SNOW)))
colnames(SNOWTemp) <- colnames(SNOW)

#Overwrite GHCN df with just the matching coordinate pair rows
for(row in 1:nrow(SNOW)){
  if(GHCN[row,3] %in% matchingCoords[,1]){
    if(GHCN[row,4] %in% matchingCoords[,2]){
      GHCNTemp[row,] <- GHCN[row,]
    }
  }
  if(row %% 1000 == 0){
    print(row)
  }
}

#Overwrite SNOW df with just the matching coordinate pair rows
for(row in 1:nrow(SNOW)){
  if(SNOW[row,8] %in% matchingCoords[,3]){
    if(SNOW[row,9] %in% matchingCoords[,4]){
      SNOWTemp[row,] <- SNOW[row,]
    }
  }
  if(row %% 1000 == 0){
    print(row)
  }
}

#Add desired columns to GHCN from SNOW
GHCNTemp$DEPTH <- NA
GHCNTemp$WATER <- NA
GHCNTemp$DENSITY <- NA

#Sort the dataframes by latitude
GHCNTemp <- arrange(GHCNTemp,3)
SNOWTemp <- arrange(SNOWTemp,8)

#Drop latitude values of NA in both dataframes
GHCNTemp <- GHCNTemp %>% drop_na(LATITUDE)
SNOWTemp <- SNOWTemp %>% drop_na(LATITUDE)

#Rewrite DATE format in SNOWTemp
for(row in 1:nrow(SNOWTemp)){
  badDate <- SNOWTemp[row,4]
  day <- substr(badDate,6,7)
  month <- substr(badDate,9,10)
  year <- substr(badDate,1,4)
  goodDate <- paste(year,'-',month,'-',day,sep='')
  print(goodDate)
  SNOWTemp[row,4] <- goodDate
}

#Overwrite lat/lon in GHCNTemp with lat/lon from SNOWTemp to make merging easier/faster
for(row in 1:nrow(GHCNTemp)){
  for(ele in 1:nrow(matchingCoords)){
    if(isTRUE(GHCNTemp[row,3] == matchingCoords[ele,1])){
      if(isTRUE(GHCNTemp[row,4] == matchingCoords[ele,2])){
        GHCNTemp[row,3] <- matchingCoords[ele,3]
        GHCNTemp[row,4] <- matchingCoords[ele,4]
      }
    }
  }
  if(row %% 1000 == 0){
   print(row) 
  }
}

#left join GHCNTemp and SNOWTemp by lat,lon, and date
total <- merge(x=GHCNTemp,y=SNOWTemp,by=c('LATITUDE','LONGITUDE','DATE'),all.x = TRUE,no.dups = FALSE)

#Drop any latitude values of NA
total <- total %>% drop_na(LATITUDE)

#Remove unwanted columns
total$DEPTH.x <- NULL
total$WATER.x <- NULL
total$DENSITY.x <- NULL
total$SITE_ID <- NULL
total$MOVED_TO_SITE_ID <- NULL
total$NA. <- NULL
total$NA..1 <- NULL
total$NA..2 <- NULL
total$NA..3 <- NULL
total$NA..4 <- NULL
total$NA..5 <- NULL
total$NA..6 <- NULL
total$STATION <- NULL
total$SITE_NAME <- NULL

#left join total with NAO for a final dataframe, 'data'
data <- merge(x=total,y=NAO,by=c("DATE"),all.x=TRUE,no.dups = FALSE)

#Total time to run program: 30s

#Save 'data' df to csv
#write.csv(data,"clean-data/data.csv", row.names = FALSE)

## TO DO ##
# Drop col 7 - 10 in GHCNTemp?
# Finally, interpolate missing values

