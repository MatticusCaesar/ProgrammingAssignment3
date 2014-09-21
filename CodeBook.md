##Getting and Cleaning Data Project
by: Matt Marchand
last updated: 9/21/2014

Please note, there are chunks of this document that are not my own words.  I have cited web sites where data was drawn from other sources.  
I have never seen a need for reinventing the wheel.

###Source Data

The source data for this project can be found here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Data Set Information: (copied from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones )

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

Source files are:
features.txt - list of variables, ultimately the column headers
activity_labels.txt - mapping of activities by id
subject_train.txt - numeric identifiers for training data subjects
x_train.txt - raw training data
y_train.txt - training data activity ids
subject_test.txt - numeric identifiers for test data subjects
x_test.txt - raw test data
y_test.txt - test data activity ids

###Attribute Information:  (copied from the README.txt associated with the dataset)

For each record in the dataset it is provided:

Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
Triaxial Angular velocity from the gyroscope.
A 561-feature vector with time and frequency domain variables.
Its activity label.
An identifier of the subject who carried out the experiment.

###Transformations Performed: (Partially copied from https://class.coursera.org/getdata-007/human_grading/view/courses/972585/assessments/3/submissions)

###Part I -  Merges the training and the test sets to create one data set.

Read variables("features") and activity information (read.csv)
Read training data sets and assign feature/column names, then merge into one master training data set (cbind)
Read test data sets and assign feature/column names, then merge into one master test data set (cbind)
Append rows of test data set to training dats set to create the master data set (rbind)

###Part II - Extracts only the measurements on the mean and standard deviation for each measurement. 
Extracted the column names to a logical vector using grepl 
Rewrite the subset to a new dataframe

###Part III - Uses descriptive activity names to name the activities in the data set
Merge the activity_labels file into the required_dataset

###Part IV - Appropriately labels the data set with descriptive variable names
Write the column names to a vector
Use a series of gsub commands to make a series of vectorized feature name edits:
	Edit "t" to "Time-"
	Edit "Freq" to "Frequency" - end of names
	Edit "f" to "Frequency-" - beginning of names
	Edit "std" to "StdDev"
	Edit "mean" to "Mean"
	Strip out "()" sequences
Replace the edited column names into the required data set
Not required, but saved this as a .csv file

###Part V - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
Melt the required_dataset into a new frame
Cast the dataframe using the mean function on all data variables
Save to disk using write.table as requested (I think write.csv is better, but whatever) as the second tidy data set