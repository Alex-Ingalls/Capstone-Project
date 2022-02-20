#Clean NAO Data
temp <- read.csv('raw-data/NAO/NAO_Index_80_20.csv')

tempDf <- data.frame(temp)

#create new column 'DATE'
tempDf <- cbind(tempDf,DATE='')

makeDate = function(df,row) {
  
  #Access year, month and day values of a given row
  Y <- df[row,1]
  M <- df[row,2]
  D <- df[row,3]
  
  #stitch them together into a string
  date <- paste(Y,M,D,sep="-")
  
  return(date)
}

#Make a date value for each row, add it to the df
for(row in 1:nrow(tempDf)){
  
  #Create the date based on existing row data
  date <- makeDate(tempDf,row)
  
  #assign the DATE column to the newly created date
  tempDf[row,5] <- date
}

#Remove Y,M,D columns
tempDf$YEAR <- NULL
tempDf$MONTH <- NULL
tempDf$DAY <- NULL

#Rename columns
colnames(tempDf) <- c('NAO_Value','DATE')

# #Fix DATE
# NAO <- read.csv('clean-data/NAO_Index_80_20.csv')
# NAO <- data.frame(NAO)

#export to CSV
#write.csv(tempDf,'clean-data/NAO_Index_80_20.csv',row.names=FALSE)