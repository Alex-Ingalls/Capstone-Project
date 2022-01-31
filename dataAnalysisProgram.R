library(tools)
library(stringi)

#Utility Functions
loadData <- function(folder) {
  files <- list.files(path=folder)
  
  for(file in files) {
    filePath <- paste(folder,file,sep='\\')
    temp <<- read.csv(filePath,header=TRUE,sep=",")
  }
}

main <- function(){
  print('### Welcome to Data Analysis ###')
  
  ### READ IN DATA ###
  print('Please select a folder to load data from')
  folderPath <- choose.dir()
  
  print('### Loading selected data ###')
  loadData(folderPath)
  
  ### MERGE INTO SINGLE BIG DATAFRAME ###
}

main()