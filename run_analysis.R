
# Read the file with variable names
features <- read.table("features.txt", colClasses="character") 
features <- features[,2]  # extract only the 2nd column that contains the variable names

# Clean up variable names
clean_features <- gsub("\\()", "", features) 
clean_features <- gsub("-", ".", clean_features)
clean_features <- gsub(",", ".", clean_features)
clean_features <- gsub(")", "", clean_features)
clean_features <- gsub("\\(", ".", clean_features)

# Read files with activity labels
activity_labels <- read.table("activity_labels.txt", colClasses="character") #activity label names
Y_test <- read.table("test/y_test.txt", colClasses="factor") #activity labels
Y_train <- read.table("train/y_train.txt", colClasses="factor") #activity labels

# Merge activity labes for training and test dataset
Y_combined <- rbind(Y_train, Y_test)

# Read and merge the training and test data
train_data <- read.table("train/X_train.txt")
test_data <- read.table("test/X_test.txt")
data_combined <- rbind(train_data, test_data)

# Read and merge the data with subject IDs
subjects_train <- read.table("train/subject_train.txt", colClasses="factor")
subjects_test <- read.table("test/subject_test.txt", colClasses="factor")
subjects_combined <- rbind(subjects_train,subjects_test)

# Add column (variable) names to the combined data set
colnames(data_combined) <- clean_features

# Extract only variables for mean and standard deviation
means_SDs <- grep("mean|std", colnames(data_combined), ignore.case=TRUE) #get appropriate column indices
data_extracted <- data_combined[,means_SDs] 

# Add the column with activity names
Y_combined_withNames <- factor(Y_combined_vector,labels=activity_labels$V2)
data_combined2 <- cbind(data_extracted, activity.label=Y_combined_withNames)

# Add the column with subject IDs
data_combined2 <- cbind(data_combined2, subject.ID=subjects_combined$V1)

# Melting the data and dcasting to summarize
library(reshape2)
col_names <- colnames(data_combined2)[1:86] # Extracting only column names to be summarized (with variables)
new_data <- melt(data_combined2, id=c("activity.label", "subject.ID"), measure.vars=col_names)
summary <- dcast(new_data, activity.label+subject.ID ~ variable, mean)

# Write a csv file with the summary
write.csv(summary, file = "summary.csv")

