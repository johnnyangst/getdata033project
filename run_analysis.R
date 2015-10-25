## John Kirker
## Getting and Cleaning Data Course Project
## Due 10/25/2015
## assume data used is in local workspace
## using "../UCI HAR Dataset/test"
## using "../UCI HAR Dataset/train"

##library(dplyr)
library(reshape2)
######################### LOAD TABLES ###########################
## test
xTest <- read.table("UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
## train
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
## features
features <- read.table("UCI HAR Dataset/features.txt")
## activity
activityLbls <- read.table("UCI HAR Dataset/activity_labels.txt")
#################################################################
################### COMBINE TEST/TRAIN TABLES ###################
## combine X
xMerged <- rbind(xTest,xTrain)
## combine y
yMerged <- rbind(yTest,yTrain)
## combine subject
subjectMerged <- rbind(subjectTest,subjectTrain)
#################################################################
## gather only columns with "mean" and "std" in name
columnNames <- grep("-(mean|std)\\(\\)", features[, 2])
# subset xData
xMerged <- xMerged[, columnNames]
# change column names
names(xMerged) <- features[columnNames, 2]
yMerged[,1] <- activityLbls[yMerged[,1], 2]
names(yMerged) <- "Activity"
names(subjectMerged) <- "Subject"

## Combine everything
globalData <- cbind(xMerged, yMerged, subjectMerged)
#dataCol <- ncol(globalData) - 2
## Melt and cast
globalData.melted <- melt(globalData, id = c("Subject","Activity"))
globalData.mean <- dcast(globalData.melted, Subject + Activity ~ variable, mean)
## write tidy data to txt file
write.table(globalData.mean,"tidyData.txt", row.names = FALSE, quote = FALSE)

