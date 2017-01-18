## 0. Reading the data ####

## Downloading the file and putting it in the data folder

# Creating folder data if it does not exists in the current directory
if(!file.exists("./data")){dir.create("./data")}

# Storing the file url in variable fileUrl
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Downloading the file to the data folder
download.file(fileUrl, destfile = "./data/Dataset.zip")
# If Apple in download.file() use argument: method = "curl"

## Unzipping the downloaded data file "Dataset.zip" to the default directory included in the 
# zip file: "\UCI HAR Dataset"
unzip(zipfile = "./data/Dataset.zip", exdir = "./data")

# file.path() function constructs the needed file paths and puts it into variable "path"
path <- file.path("./data" , "UCI HAR Dataset")

## Reading the Activity files
Activity_Train_data <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)
Activity_Test_data <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
# Structure of the data that has been read
str(Activity_Train_data)
str(Activity_Test_data)

## Reading the Subject files
Subject_Train_data <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
Subject_Test_data <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)
# Structure of the data that has been read
str(Subject_Train_data)
str(Subject_Test_data)

## Reading the Features files
Features_Train_data <- read.table(file.path(path, "train", "X_train.txt"),header= FALSE)
Features_Test_data <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
# Structure of the data that has been read
str(Features_Train_data)
str(Features_Test_data)


## 1. Merges the training and the test sets to create one data set.####

# Concatenating (merging vertically) the Activity training and test data frames
Activity_data <- rbind(Activity_Test_data, Activity_Train_data)
str(Activity_data)

# naming variables in Activity_data
names(Activity_data) <- c("activity")
str(Activity_data)

# Concatenating (merging vertically) the Subject training and test data frames
Subject_data <- rbind(Subject_Train_data, Subject_Test_data)
str(Subject_data)

# naming variables in Activity_data
names(Subject_data) <- c("subject")
str(Subject_data)

# Concatenating (merging vertically) the Features training and test data frames
Features_data <- rbind(Features_Train_data, Features_Test_data)
str(Features_data)

# naming variables in Features_data
Features_Names_data <- read.table(file.path(path, "features.txt"),head=FALSE)
names(Features_data)<- Features_Names_data$V2
str(Features_data)

# Joining (merging horizontally) the Subject_data, Activity_data and Features_data
Data <- cbind(Subject_data, Activity_data, Features_data)
str(Data)
dim(Data)
View(Data)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. ####

# Extracting the column indices that contain either mean or std
Mean_and_STD_cols <- grep(".*Mean.*|.*Std.*", names(Data), ignore.case=TRUE)

# Adding activity and subject columns to the list
Columns <- c(Mean_and_STD_cols, 562, 563)

Mean_STD_data <- Data[,Columns]
str(Mean_STD_data)
dim(Mean_STD_data)
View(Mean_STD_data)


## Uses descriptive activity names to name the activities in the data set ####

# Reading descriptive activity names from "activity_labels.txt"
activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)

# update values with correct activity names
Data[, 2] <- activityLabels[Data[, 2], 2]
View(Data)


## 4. Appropriately labels the data set with descriptive variable names.####

# List of original names
names(Data)

# Labeling with descriptive names
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("^t", "Time", names(Data))
names(Data)<-gsub("^f", "Frequency", names(Data))
names(Data)<-gsub("tBody", "TimeBody", names(Data))
names(Data)<-gsub("-mean()", "Mean", names(Data), ignore.case = TRUE)
names(Data)<-gsub("-std()", "STD", names(Data), ignore.case = TRUE)
names(Data)<-gsub("-freq()", "Frequency", names(Data), ignore.case = TRUE)
names(Data)<-gsub("angle", "Angle", names(Data))
names(Data)<-gsub("gravity", "Gravity", names(Data))

# List of new descriptive names
names(Data)
View(Data)


## 5. From the data set in step 4, creates a second, independent tidy data set with the ####
# average of each variable for each activity and each subject.

library(plyr);
Data_2nd <- aggregate (. ~subject + activity, Data, mean)
Data_2nd <- Data_2nd[order(Data_2nd$subject,Data_2nd$activity), ]
View(Data_2nd)
write.table(Data_2nd, file = "tidydata.txt", row.name = FALSE)






