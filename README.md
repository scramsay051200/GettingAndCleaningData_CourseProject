
# Getting and Cleaning Data (Coursera)
## Course Project README

This file documents the "run_analysis.R" in this repository, written as part 
of the coursera "Getting And Cleaning Data" final course project.

Before running this script, the working directory should be set to the folder:

    UCI HAR Dataset
    
This folder, and its contents, can be found in an unzipped version of the data
set downloaded from this URL location:

[](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

A description of this data set can be found from this URL location:

[](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

As a general outline, this script performs the following steps:

    1. It merges the training and the test data sets to create one data set,
       (referred to as the "merged data set" in this document).

    2. It extracts only the measurements on the mean and standard deviation
       for each measurement, and includes them in the "merged data set".

    3. It uses descriptive activity names to name activities in the "merged 
       data set".

    4. It appropriately labels the "merged data set" with descriptive variable
       names.  It writes this data set to a file called:  MergedData.txt

    5. From the data set in step 4, it creates a second, independent "tidy
       data set" with the average of each variable for each activity and each
       subject.  It writes this data set to a file called:  TidyData.txt
