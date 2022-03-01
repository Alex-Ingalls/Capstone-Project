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

#Remove any GHCN rows with missing PRCP,SNOW,SNWD,TMAX,TMIN
GHCN <- GHCN %>% drop_na(TMAX)
GHCN <- GHCN %>% drop_na(TMIN)
GHCN <- GHCN %>% drop_na(SNWD)
GHCN <- GHCN %>% drop_na(SNOW)
GHCN <- GHCN %>% drop_na(PRCP)

#Drop useless columns in GHCN
GHCN$DAPR <- NULL
GHCN$DASF <- NULL
GHCN$MDPR <- NULL
GHCN$MDSF <- NULL

#Remove any SNOW rows with missing WATER,DENSITY,DEPTH
SNOW <- SNOW %>% drop_na(WATER)
SNOW <- SNOW %>% drop_na(DENSITY)
SNOW <- SNOW %>% drop_na(DEPTH)

#Save new CSV's of the filtered data
write.csv(GHCN,"clean-data/filtered-datasets/GHCNFiltered.csv", row.names = FALSE)
write.csv(SNOW,"clean-data/filtered-datasets/SNOWFiltered.csv", row.names = FALSE)