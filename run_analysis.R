## Loads required libraries.
library(plyr)
library(reshape2)

## Gets the features from the file for lookup.
getFeatures <- function(filename, regexpr) {
  features <- read.table(filename)

  ## Clean up the column names.
  names(features) <- c("col","colname")
  features$colname <- gsub("\\(\\)","",features$colname)

  ## Obtains the list of features with "mean" and "std" in them.
  features[grepl(regexpr, features$colname),] 
}


# Gets the activities from the file for lookup.
getActivities <- function(filename) {
  activities <- read.table(filename)

  ## Clean up the column names.
  names(activities) <- c("activitycode","activityname")
  
  ## Return the activities list.
  activities
}


## Loads the data set (either train/test set).
getdata <- function(filetype, featureslist, activitieslist) {
  Xfile <- paste0(filetype,"/X_",filetype,".txt")
  Yfile <- paste0(filetype,"/y_",filetype,".txt")
  subjfile <- paste0(filetype, "/subject_",filetype,".txt")

  rawX <- read.table(Xfile)
  rawY <- read.table(Yfile)
  rawS <- read.table(subjfile)

  ## Extracts required columns from the X file.
  tdata <- rawX[,featureslist$col]
  names(tdata) <- featureslist$colname
  tdata

  ## Process the Y file.
  names(rawY) <- "activitycode"
  adata <- join(rawY, activitieslist, by="activitycode", type="left", match="all")

  ## Process the subject file.
  names(rawS) <- "subject"

  ## Combines all 3 files into a single data frame.
  #combdata <- cbind(rawS, adata$activityname, tdata)
  #names(combdata)[2] <- "activityname"
  #combdata
  cbind(rawS, adata, tdata)
}


## Load the train and test data and combine them.
getconsdata <- function(featureslist, activitieslist) {
  train <- getdata("train", featureslist, activitieslist)
  ttest <- getdata("test",  featureslist, activitieslist)
  rbind(train,ttest)
}


## Generates the averages for each variable.
gensummaryavgs <- function(datatbl) {
  melted <- melt(datatbl, id=c("subject","activityname"))
  dcast(melted, activityname + subject ~ variable, mean)
}


## Write out the data to a file.
writedata <- function(datatbl, filename) {
  write.table(datatbl, filename, append=FALSE, col.names=TRUE)
}


## Read the consolidated table.
readdata <- function(filename) {
  read.table(filename, header=TRUE)
}


## Main program.
##
## Get the list of activities and features, then load the consolidate data.
flist <- getFeatures("features.txt","mean()|std()")
alist <- getActivities("activity_labels.txt")
fdata <- getconsdata(flist, alist)
summarymeans <- gensummaryavgs(fdata)

## Write the data tables to file.
writedata(fdata,"GY_tidydata_step4.txt")
writedata(summarymeans, "GY_tidydata_step5.txt")

## Print out the tidy data set.
summarymeans
