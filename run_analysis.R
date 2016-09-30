#######Set up work directory
setwd("C:/LIFE/Data_Science_Certificate/Course3/Week4/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")

#######Reading in data
subject_train <- read.table("./subject_train.txt", header=T)
subject_test <- read.table("./subject_test.txt", header=T)

X_train <- read.table("./X_train.txt", header=T)
X_test <- read.table("./X_test.txt", header=T)

y_train <- read.table("./y_train.txt", header=T)
y_test <- read.table("./y_test.txt", header=T)

features <- read.table("./features.txt")

#######Changing the variable names for training data and combine to make one training data
colnames(subject_train) <- "Subject"
colnames(y_train) <- "Activity"
colnames(X_train)<-features[,2]
traindata<-cbind(subject_train,X_train,y_train)

#######Changing the variable names for testing data and combine to make one testing data
colnames(subject_test) <- "Subject"
colnames(y_test) <- "Activity"
colnames(X_test)<-features[,2]
testdata<-cbind(subject_test,X_test,y_test)

#######1. Merges the training and the test sets to create one data set.
fulldata<-rbind(traindata,testdata)

#######2. Extracts only the measurements on the mean and standard deviation for each measurement.
toMatch <- c("mean", "std")
subdata<-fulldata[, grep(paste(toMatch,collapse="|"), colnames(fulldata))]

#######3. Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("./activity_labels.txt")
fulldataname<-merge(x = fulldata, y = activity_labels, by.x = "Activity", by.y = "V1", all.x = TRUE)
fulldataname<-fulldataname[,-1]
names(fulldataname)[563]<-"Activity"

#######4. Appropriately labels the data set with descriptive variable names.
names(fulldataname) <- gsub("^t", "Time", names(fulldataname))
names(fulldataname) <- gsub("^f", "Frequency", names(fulldataname))
names(fulldataname) <- gsub("Acc", "Accelerator", names(fulldataname))
names(fulldataname) <- gsub("Mag", "Magnitude", names(fulldataname))
names(fulldataname) <- gsub("Gyro", "Gyroscope", names(fulldataname))


#######5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
aggdata<-aggregate(fulldataname[,2:562], list(fulldataname$Activity,fulldataname$Subject), mean, na.rm=TRUE)
write.table(aggdata, "./aggdata.txt", sep="\t",row.names = FALSE)
