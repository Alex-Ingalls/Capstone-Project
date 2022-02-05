#Clean GHCN Data
library(dplyr)
library(readr)

tempDf <- list.files(path="raw-data/GHCN/",full.names=TRUE) %>% 
  lapply(read_csv) %>% 
  bind_rows

write.csv(tempDf,'raw-data/GHCN/GHCN.csv',row.names=FALSE)