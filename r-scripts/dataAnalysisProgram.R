library(tools)
library(stringi)

#Utility Functions
loadData <- function(folder) {
  files <- list.files(path=folder)
  
  for(file in files) {
    
    #Get file path
    filePath <- paste(folder,file,sep='\\')
    
    #Assign each CSV's contents to a variable
    temp <<- read.csv(filePath,header=TRUE,sep=",")
  }
  #ask user if they wish to merge with an existing dataframe
  #If so, call mergeData(), passing in the selected dataframe
}

cleanData <- function(file) {
  #Choose what metric to 'clean' by
  
  #logic to execute the cleaning
  
  #Save cleaned data to new file in a different folder
}

mergeData <- function(Folder,file,dataFrame) {
  #iterate through the folder
  
  #ask user which column to join by
  
  #for each data file, join a master data frame by some column name
  
  #return global master dataframe
}

displayOptions <- function() {
  #print available options
  #Add data
  #Merge data
  
  
  #depending on which selected (using readline()), execute that option
}

analyzeData <- function(masterDataFrame) {
  #ask user which analysis function to preform
  
  #depending on which selected, then ask which column(s) to analyze
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