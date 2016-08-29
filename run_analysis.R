#run_analysis.R

########################################################################
########################################################################

#PROCESS
##Load dplyr package
library(dplyr)

##Read features and activity label files into R
features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

##Read train files into R
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
x_train <- read.table("UCI HAR Dataset/train/x_train.txt")

##Read test fiels into R
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
x_test <- read.table("UCI HAR Dataset/test/x_test.txt")

#merge train x/y/subject datasets to create one comprehensive dataset
##To start, give the activity labels file column names for each variable
colnames(activity_labels) <- c("V1","Activity")

##give the subject_train file a V1 column header
subject <- rename(subject_train, subject=V1)

##bind the subject and y_train files 
train1 <- cbind(y_train,subject)

##Merge the file above with the activity labels, and use "V1" for the merge
train2 <- merge(train1,activity_labels, by=("V1"))

##Give the 2nd colume of the features file to the column name of the x_train file
colnames(x_train) <- features[,2]

##Bind train2 and the x_train files (with the new column name from features.txt)
train3 <- cbind(train2,x_train)

##Remove the V1 colume from train3 becuase it is no longer needed
train4 <- train3[,-1]

## create a new object that contains only columns that contain the word "subject"/"Activity"/"mean"/ or "std"
train5 <- select(train4,contains("subject"), contains("Activity"), contains("mean"), contains("std"))

#merge train x/y/subject datasets to create one comprehensive dataset
##The activity labels file will need column names, but we have already done this so no need to duplicate
##give the subject_train file a V1 column header
subject2 <- rename(subject_test, subject=V1)

##bind the subject and y_test files 
test1 <- cbind(y_test,subject2)

##Merge the file above with the activity labels, and use "V1" for the merge
test2 <- merge(test1,activity_labels, by=("V1"))

##Give the 2nd colume of the features file to the column name of the x_test file
colnames(x_test) <- features[,2]

##Bind test2 and the x_test files (with the new column name from features.txt)
test3 <- cbind(test2,x_test)

##Remove the V1 colume from test3 becuase it is no longer needed
test4 <- test3[,-1]

## create a new object that contains only columns that contain the word "subject"/"Activity"/"mean"/ or "std"
test5 <- select(test4,contains("subject"), contains("Activity"), contains("mean"), contains("std"))

#Bind the train5 and test5 datasets to produce one comprehensive dataset
##and create a .txt file in the working diretory for "mergetraintest"
mergetraintest <- rbind(train5,test5)
write.table(mergetraintest,"./mergetraintest.txt",sep=" ",row.name=FALSE) 

#create a seperate dataset that shows only the average of each variable for each activity and subject
run_analysis <- (mergetraintest%>%group_by(subject,Activity) %>% summarise_each(funs( mean)))
print(run_analysis)

##Write run_analysis to a text file in our working directory
write.table(run_analysis,"./run_analysis.txt",sep=" ",row.name=FALSE) 
