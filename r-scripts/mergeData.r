#install.packages('stringr')
library(stringr)
library(tidyverse)

#Load in data
GHCN <- read.csv('clean-data/GHCN.csv')
GHCN <- data.frame(GHCN)

NAO <- read.csv('clean-data/NAO_Index_80_20.csv')
NAO <- data.frame(NAO)

SNOW <- read.csv('clean-data/Snow_Survey_79_21.csv')
SNOW <- data.frame(SNOW)

#List of unique LAT/LON pairs
GHCNPairs <- list()
SNOWPairs <- list()

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
precisionLimit <- 0.05

matchingCoords <- data.frame(matrix(ncol = 4, nrow = 0))
colnames(matchingCoords) <- c('GHCN_LAT','GHCN_LON','SNOW_LAT','SNOW_LON')

#Make a data frame of matching coordinate pairs
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

#For GHCN sites, add a column for the snow info from the corresponding SNOW site
#Ignore SNOW sites that do not have a matching GHCN site?
#Afterwards, for each row, add a NAO value based on DATE
#Finally, interpolate missing values


#Merge by Latitude/Longitude and DATE
#data <- data.table(GHCN,SNOW,key=c("LATITUDE","LONGITUDE","DATE"))
