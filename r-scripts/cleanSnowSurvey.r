library(stringr)

temp <- read.csv('raw-data/Snow_survey/Maine_Snow_Survey_Data_79_21.csv')

tempDf <- data.frame(temp)

#Change col name
colnames(tempDf)[10] <- 'DATE'

#Alter each date format by row
for(row in 1:nrow(tempDf)){
  
  #get current value
  badDate <- tempDf[row,10]
  
  #cast to string
  badDate <- toString(badDate)
  
  #Cut out Year, Month, Day
  day <- str_sub(badDate,1,2)
  month <- str_sub(badDate,4,5)
  year <- str_sub(badDate,7,11)
  
  #Replace '/' with '-'
  goodDate <- paste(year,'-',month,'-',day,sep='')
  
  tempDf[row,10] <- goodDate
}

#Remove unneccesary columns/data
tempDf$ï..X <- NULL
tempDf$Y <- NULL
tempDf$OBJECTID <- NULL
tempDf$SURVEY <- NULL
tempDf$SURVEY_YEAR <- NULL
tempDf$SURVEY_DATE <- NULL
tempDf$CONFIDENCE_LEVEL <- NULL
tempDf$SOURCE <- NULL
tempDf$COMMENT <- NULL
tempDf$TRACE <- NULL
tempDf$ERROR <- NULL

#Write out to CSV
write.csv(tempDf,'clean-data/Snow_Survey_79_21.csv',row.names=FALSE)