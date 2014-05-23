This is a Readme document for the Getting and cleaning data Course project.
The R code that reads, cleans and summarizes the data is provided in "run_analysis.R"
Detailed description of the code, incl. all steps taken, is provided in the "CodeBook.md".
The code returns the "summary.csv" file that summarizes the data as described below and in the code book.
 
A full description of the starting dataset is here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Data for the project is here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Goals (as stated in the assignment):

1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement. 
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive activity names. 
5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

From the README.txt describing the data:

*********************************************
For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

*********************************************

First, a data frame was constructed from the data provided in many separate files.

Here are starting file descriptions and what I used them for:

"features.txt" are 561 variable names (I used them as variable/column names)
"activity_labels.txt" are 6 activities that each subject performed; they are made as factor variables that go into "activity.label" column I added to the data frame; they connect to the data by numbers in the "Y" file
"Y" files say what activity was measured (these are vectors, each number goes in one row)
"X" files contain the measurements for all variables contained in the "features.txt", it's a data frame
"subject" files contain the ID of the subject that performed the activity

Brief summary of data transformations applied:
-a large data frame was created first, with all 561 variables
-variable names were cleaned up (parantheses, etc. were removed) and added as column names
-only variables referring to measurement means and standard deviations were kept in the data frame
-subject IDs and activity labels were added as additional columns
-data frame was then molded and summarized using the "reshape2" package
-resulting data was written as a csv file



