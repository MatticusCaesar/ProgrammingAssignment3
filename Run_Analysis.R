# Run_Analysis.R
# Getting and Cleaning Data Course Project
# Coursera via John Hopkins University
# by: Matt Marchand
# last updated: 9/21/2014
# 
# This script will do the following per the assignment:
# 
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names. 
# 5) From the data set in step 4, creates a second, independent tidy data set with the average of each 
#            variable for each activity and each subject.

# IMPORTANT!!!
# This script was written in R 3.1.1 using RStudio running on Windows 8.1 Pro
# It assumes that the following packages are installed:
# data.table 
# dplyr
# tidyr
# reshape2

# INTITAL SETUP SECTION
# load libraries to be safe
library(data.table)
library(dplyr)
library(tidyr)
library(reshape2)

# Set working directory to the location of the unzipped folder where the data files are located:
setwd("C:/Users/Matt/Desktop/Coursera/Getting and Cleaning Data/UCI HAR Dataset")
# END OF INITIAL SETUP SECTION

# PART 1 - MERGE DATA INTO 1 SET
# Read variables("features") and activity information
features <- read.table('./features.txt', header=FALSE)
activity_labels <- read.table('./activity_labels.txt', header=FALSE)
colnames(activity_labels) <- c("Activity_ID", "Activity")

# Read training data sets and assign feature/column names, then merge into one master training data set
subject_train <- read.table('./train/subject_train.txt', header=FALSE)
x_train <- read.table('./train/x_train.txt', header=FALSE)
y_train <- read.table('./train/y_train.txt', header=FALSE)
colnames(subject_train) <- c("Subject_ID")
colnames(x_train) <- features[, 2]
colnames(y_train) <- c("Activity_ID")
training_dataset <- cbind(y_train, subject_train, x_train)

# Read test data sets and assign feature/column names, then merge into one master test data set
subject_test <- read.table('./test/subject_test.txt',header=FALSE)
x_test <- read.table('./test/x_test.txt', header=FALSE)
y_test <- read.table('./test/y_test.txt', header=FALSE)
colnames(subject_test)  <- c("Subject_ID")
colnames(x_test) <- features[, 2]
colnames(y_test) <- c("Activity_ID")
test_dataset <- cbind(y_test, subject_test, x_test)

# Append rows of test data set to training dats set to create the master data set
master_dataset <- rbind(training_dataset, test_dataset)
# END OF PART 1

# PART II - EXTRACT ONLY MEASUREMENTS ON MEAN & STDDEV FOR EACH MEASUREMENT
# I had no success trying to do this using the master_dataset itself, so I tried
# extracting the column names to a logical vector using grepl then manipulating that
required_columns <- grepl("Activity_ID|Subject_ID|mean|std", names(master_dataset))
required_dataset <- master_dataset[required_columns == TRUE]
#END OF PART II

# PART III - USE DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE Dataset
# Merge the activity_labels into the required_dataset
required_dataset <- merge(activity_labels, required_dataset, by.x="Activity_ID", by.y="Activity_ID", all=TRUE)
# END OF PART III

# PART IV - APPROPRIATELY LABEL THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES
# While I recognize this is an academic exercise, The original variable names are 
# reasonably well documented, so this is an exercise in busywork.  
# Not to mention it will make the variable names really long and cumbersome.
# I'll make a few changes just so I can say "I did it", but in real life I'd 
# probably skip this step with these documented labels.
# Write the column names to a vector
columnnames_to_edit <- names(required_dataset)

# Use a series of gsub commands to make a series of edits.  
# Operations are vectorized so no looping is necessary.
columnnames_to_edit <- gsub("^t", "Time-", columnnames_to_edit) # Edit "t" to "Time-"
columnnames_to_edit <- gsub("Freq", "Frequency", columnnames_to_edit) # Edit "Freq" to "Frequency" - end of names
columnnames_to_edit <- gsub("^f", "Frequency-", columnnames_to_edit) # Edit "f" to "Frequency-" - beginning of names
columnnames_to_edit <- gsub("std", "StdDev", columnnames_to_edit) # Edit "std" to "StdDev"
columnnames_to_edit <- gsub("mean", "Mean", columnnames_to_edit) # Edit "mean" to "Mean"
columnnames_to_edit <- gsub("\\()", "", columnnames_to_edit) # Strip out "()" sequences

# Replace the edited column names into the required data set
names(required_dataset) <- columnnames_to_edit

# Save to disk as the first tidy data set
write.csv(required_dataset, "./GettingandCleaningData_Project_TidyData1.csv")
# END OF PART IV

# PART V - FROM THE DATA IN PART IV, CREATE A SECOND, INDEPENDENT, TIDY DATA SET WITH
# THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT
# Melt the required_dataset into a new frame
melted_required_dataset <- melt(required_dataset, rowlabels = c("Subject_ID", "Activity_ID", "Activity"), measure.vars = names(required_dataset[4:82]))

# Cast the dataframe using the mean function on all data variables
cast_dataframe <- dcast(melted_required_dataset, Subject_ID + Activity ~ variable, mean)
 
# Save to disk as the second tidy data set
write.table(cast_dataframe, "./GettingandCleaningData_Project_TidyData2.txt", sep=",", row.names=FALSE)
# END OF PART V
