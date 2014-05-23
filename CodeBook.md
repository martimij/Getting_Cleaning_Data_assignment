Getting and cleaning data - Course project codebook
========================================================
A full description of the starting dataset:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Goals (as stated in the assignment):

1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement. 
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive activity names. 
5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

Here are the starting file descriptions and what I used them for:

* "x" files contain the measurements for all variables contained in the "features.txt", it's a data frame
* "y" files say what activity was measured (these are vectors, each number goes in one row)
* "features.txt" are variable (column) names (561 total)
* "activity_labels.txt" are 6 activities that each subject performed (connected to "y" files)
* "subject" files contain the ID of the subject who performed the activity

Description of steps I took to get, combine and reshape the data

1. Reading the file with variable names and cleaning names
```{r}
features <- read.table("./UCI HAR Dataset/features.txt", colClasses="character") 
features <- features[,2] 
clean_features <- gsub("\\()", "", features) 
clean_features <- gsub("-", ".", clean_features)
clean_features <- gsub(",", ".", clean_features)
clean_features <- gsub(")", "", clean_features)
clean_features <- gsub("\\(", ".", clean_features)
```
2. Read files with activity labels
```{r}
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", colClasses="character")
Y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", colClasses="factor")
Y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", colClasses="factor")
```

3. Merging activity lables for training and test datasets
```{r}
Y_combined <- rbind(Y_train, Y_test)
```

4. Reading and merging the training and test data
```{r}
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
data_combined <- rbind(train_data, test_data)
```

5. Reading and merging the data with subject IDs
```{r}
subjects_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", colClasses="factor")
subjects_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", colClasses="factor")
subjects_combined <- rbind(subjects_train,subjects_test)
```

6. Adding column (variable) names to the combined data set
```{r}
colnames(data_combined) <- clean_features
```

7. Extracting only variables for mean and standard deviation
```{r}
means_SDs <- grep("mean|std", colnames(data_combined), ignore.case=TRUE) #get appropriate column indices
data_extracted <- data_combined[,means_SDs] 
```

8. Adding the column with activity names
```{r}
Y_combined_withNames <- factor(Y_combined_vector,labels=activity_labels$V2) #values for the column
data_combined2 <- cbind(data_extracted, activity.label=Y_combined_withNames)
```

9. Adding the column with subject IDs
```{r}
data_combined2 <- cbind(data_combined2, subject.ID=subjects_combined$V1)
```

10. Creating a tidy data set with the average of each variable for each activity and each subject
```{r}
library(reshape2)
col_names <- colnames(data_combined2)[1:86] # Extracting only column names to be summarized (with variables)
new_data <- melt(data_combined2, id=c("activity.label", "subject.ID"), measure.vars=col_names)
summary <- dcast(new_data, activity.label+subject.ID ~ variable, mean)
```

11. Writing a csv file with the data summary
```{r}
write.csv(summary, file = "summary.csv")
```