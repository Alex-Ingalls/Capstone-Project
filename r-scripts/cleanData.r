data <- read.csv('clean-data/data_12_mile_radius.csv')
data <- data.frame(data)

#Sort by date then site name
data <- data[order(data[,'NAME'],data[,'DATE']),]

#Reindex the dataframe
row.names(data) <- NULL

#Drop useless columns
data$DAPR <- NULL
data$DASF <- NULL
data$MDPR <- NULL
data$MDSF <- NULL

#Fill in TAVG
for(row in 1:nrow(data)){
  if(isTRUE(is.na(data[row,'TAVG']))){
    max <- as.numeric(data[row,'TMAX'])
    min <- as.numeric(data[row,'TMIN'])
    avg <- ((max+min)/2)
    data[row,'TAVG'] <- avg
  }
  print(row)
}

#Overwrite data with filled in TAVG
write.csv(data,"clean-data/data_roi_12.csv", row.names = FALSE)