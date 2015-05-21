
# Getting and Cleaning Data (Coursera)
## Course Project README

This file documents the "run_analysis.R" script in this repository, written
as part of the coursera "Getting And Cleaning Data" final course project.

Before running this script, the working directory should be set to the folder:

    UCI HAR Dataset
    
This folder, and its contents, can be found in an unzipped version of the data
set downloaded at this URL location:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

A description of this data set can be found at this URL location:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

### Inputs

The "run_analysis.R" script uses the following files in the data set mentioned
above as inputs (all relative to the "UCI HAR Dataset" folder:

    ./activity_labels.txt
    ./features.txt
    ./test/y_test.txt
    ./train/y_train.txt
    ./test/subject_test.txt
    ./train/subject_test.txt
    ./test/X_test.txt
    ./train/X_train.txt

### Outputs

The "run_analysis.R" script creates the following files as outputs (all
relatve to the "UCI HAR Dataset" folder:

    ./MergedData.txt
    ./TidyData.txt

### High level Algorithm 

As a general outline, "run_analysis.R" script performs the following steps:

1. It merges the training and the test data sets to create one data set, 
   (referred to as the "merged data set" in this document).

2. It extracts only the measurements on the mean and standard deviation for
   each measurement, and includes them in the "merged data set".

3. It uses descriptive activity names to name activities in the "merged data
   set".

4. It appropriately labels the "merged data set" with descriptive variable
   names.  It writes this data set to a file called:  MergedData.txt

5. From the data set in step 4, it creates a second, independent "tidy data 
   set" with the average of each variable for each activity and each subject.
   It writes this data set to a file called:  TidyData.txt


