#
install.packages("readr")
install.packages("plyr")
library(readr)
library(plyr)
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# This script (run_analysis.R) is written as part of the coursera "Getting And
# Cleaning Data" final course project.
#
# Before running this script, the working directory should be set to the folder:
#
#    "UCI HAR Dataset"
#
# This folder, and its contents, can be found in an unzipped version of the data
# set downloaded from this URL location:
#
#    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
# A description of this data set can be found from this URL location:
#
#    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#
# As a general outline, this script performs the following steps:
#
#    (1) It merges the training and the test data sets to create one data set,
#        which is called the "merged data set".
#
#    (2) It extracts only the measurements on the mean and standard deviation
#        for each measurement, to include in the "merged data set".
#
#    (3) It uses descriptive activity names to name activities in the "merged 
#        data set".
#
#    (4) It appropriately labels the "merged data set" with descriptive variable
#        names.  It also writes this data set to a file called:  MergedData.txt
#
#    (5) From the data set in step 4, it creates a second, independent "tidy
#        data set" with the average of each variable for each activity and each
#        subject.  It also write this data set to a file called:  TidyData.txt
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#

#-------------------------------------------------------------------------------
# Read the "activity_labels.txt" file.  This table helps to map activity-codes
# to human readable activity-names.
#-------------------------------------------------------------------------------

activityLabels <- read.csv(
    "./activity_labels.txt",
    header = FALSE,
    sep = " ",
    col.names=list("ActivityId", "ActivityName"))

#-------------------------------------------------------------------------------
# Read the "features.txt" file.  This table contains (most of) the column names
# associated with the measurements in our data set.
#-------------------------------------------------------------------------------

featuresColNames <- read.csv(
    "./features.txt",
    header = FALSE,
    sep = " ",
    col.names=list("FeatureColId", "FeatureColName"))

#-------------------------------------------------------------------------------
# Read the "./test/y_test.txt" and "./train/y_train.txt" files.  These tables
# identify the activity associated with each measurement in the test and train 
# data sets.
#-------------------------------------------------------------------------------

testActivityRows <- read.csv(
    "./test/y_test.txt",
    header = FALSE,
    sep = " ",
    col.names=list("ActivityId"))

trainActivityRows <- read.csv(
    "./train/y_train.txt",
    header = FALSE,
    sep = " ",
    col.names=list("ActivityId"))

# Label all of the activities with their textual counterparts.
testActivityRows   <- activityLabels[testActivityRows$ActivityId,]
trainActivityRows  <- activityLabels[trainActivityRows$ActivityId,]

# Merge the test and train rows together.
# Add a measurement-id column we'll use to join things later.
mergedActivityRows <- rbind(testActivityRows, trainActivityRows)
mergedActivityRows$measurementId <- 1:nrow(mergedActivityRows)

#-------------------------------------------------------------------------------
# Read the "./test/subject_test.txt" and "./train/subject_test.txt" files. 
# These tables identify the subject (person) associated with each measurement in
# the test and train data sets.
#-------------------------------------------------------------------------------

testSubjectRows <- read.csv(
    "./test/subject_test.txt",
    header = FALSE,
    sep = " ",
    col.names=list("SubjectId"))

trainSubjectRows <- read.csv(
    "./train/subject_train.txt",
    header = FALSE,
    sep = " ",
    col.names=list("SubjectId"))

# Merge the test and train rows together.
# Add a measurement-id column we'll use to join things later.
mergedSubjectRows <- rbind(testSubjectRows, trainSubjectRows)
mergedSubjectRows$measurementId <- 1:nrow(mergedSubjectRows)

#-------------------------------------------------------------------------------
# Read the "./test/X_test.txt" and "./train/X_train.txt" files.  These tables
# identify the features associated with each measurement in the test and train 
# data sets.  Note: Use the "readr" package, for much faster file i/o.
#-------------------------------------------------------------------------------

testFeaturesRows <- read_fwf(
    "./test/X_test.txt", 
    col_positions = fwf_widths(
        widths = rep(16,561),
        col_names=featuresColNames$FeatureColName))

trainFeaturesRows <- read_fwf(
    "./train/X_train.txt", 
    col_positions = fwf_widths(
        widths = rep(16,561),
        col_names=featuresColNames$FeatureColName))

# Subset to only the columns labelled as "mean()" or "std()" of measurements.
testFeaturesRows  <- testFeaturesRows[
    ,grep("(-mean\\(\\)|-std\\(\\))", names(testFeaturesRows))]

trainFeaturesRows <- trainFeaturesRows[
    ,grep("(-mean\\(\\)|-std\\(\\))", names(trainFeaturesRows))]

# Merge the test and train rows together.
# Add a measurement-id column we'll use to join things later.
mergedFeaturesRows <- rbind(testFeaturesRows, trainFeaturesRows)
mergedFeaturesRows$measurementId <- 1:nrow(mergedFeaturesRows)

#-------------------------------------------------------------------------------
# Build the merged data set (built from the test and train data sets).
#-------------------------------------------------------------------------------

# Join subject rows, activity rows, and feature rows.
mergedData <- join_all(
    list(mergedSubjectRows, mergedActivityRows, mergedFeaturesRows))

# Write the merged data set into its own file, for later use.
write.table(mergedData, "./MergedData.txt", sep = ",", row.names = FALSE)

#-------------------------------------------------------------------------------
# Build a tidy data set, which is an aggregate of the original merged data set, 
# rolled up as an average for each variable, for each activity and each subject.
#-------------------------------------------------------------------------------

# Create a copy of the merged data set.
mergedDataCopy <- mergedData

# Mark some columns for eventual deletion.
colnames(mergedDataCopy)[
    colnames(mergedDataCopy) == "ActivityName"] <- "tempActName"
colnames(mergedDataCopy)[
    colnames(mergedDataCopy) == "SubjectId"] <- "tempSubjId"

# Create a tidy data set, rolled up as an average of each variable, for each
# activity, and each subject.
tidyData <- aggregate(
    mergedDataCopy,
    list(ActivityName = mergedDataCopy$tempActName, 
         SubjectId = mergedDataCopy$tempSubjId),
    mean)

# Remove columns we no longer need.
tidyData$measurementId <- NULL
tidyData$ActivityId <- NULL
tidyData$tempSubjId <- NULL
tidyData$tempActName <- NULL

# Rename certain column names of the tidy data set to reflect their new meaning.
colnames(tidyData) <- ifelse(
    colnames(tidyData) == "SubjectId" | colnames(tidyData) == "ActivityName", 
    colnames(tidyData),
    paste("MeanOf:[", colnames(tidyData), "]", sep=""))

# Write the tidy data set into its own file, for later use.
write.table(tidyData, "./TidyData.txt", sep = ",", row.names = FALSE)

