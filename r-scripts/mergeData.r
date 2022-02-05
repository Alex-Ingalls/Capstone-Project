install.packages('sqldf')
library(sqldf)
library(data.table)

#Load in data
GHCN <- read.csv('clean-data/GHCN.csv')
GHCN <- data.frame(GHCN)

NAO <- read.csv('clean-data/NAO_Index_80_20.csv')
NAO <- data.frame(NAO)

SNOW <- read.csv('clean-data/Snow_Survey_79_21.csv')
SNOW <- data.frame(SNOW)

#Merge by Latitude/Longitude and DATE
data <- data.table(GHCN,SNOW,key=c("LATITUDE","LONGITUDE","DATE"))

for(i in 1:nrow(GHCN)){
  for(j in 1:nrow(SNOW)){
    if(((SNOW[j,8]) <= (GHCN[i,3]+0.01)) && ((SNOW[j,8]) >= (GHCN[i,3]-0.01))){
      print(SNOW[j,8])
      print(GHCN[i,3])
    }
  }
}