##Set Directory
setwd("~/Desktop/UCI HAR Dataset")
#Read a table in from features
features<-read.table("features.txt")["V2"]
activity_labels<-read.table("activity_labels.txt")["V2"]
#Get Index of features with either mean or std in their name
IndexMeanStd <- grep("mean|std", features$V2)
#Get Training Data and labels
xtrainDat <- read.table("train/X_train.txt")
#Get Test Data
xtestDat <- read.table("test/X_test.txt")
#Add col names to training and test data 
colnames(xtestDat) <- features$V2 
colnames(xtrainDat) <- features$V2 
#Get activity labels for subjects 
y_train <- read.table("train/y_train.txt")
colnames(y_train) <- "Activities"
y_test <- read.table("test/y_test.txt")
colnames(y_test) <- "Activities"
#Get test and train subjects
trainSubjects <- read.table("train/subject_train.txt")
testSubjects <- read.table("test/subject_test.txt")
colnames(trainSubjects)  <- "Subjects"
colnames(testSubjects) <- "Subjects"
#Get col names for test and train set w/ mean and std names
MeanStdIndex <- colnames(xtestDat)[IndexMeanStd]
#Subset test and train dataframe using MeanStdIndex
trainSubset <- subset(xtrainDat, select = MeanStdIndex)
testSubset <- subset(xtestDat, select = MeanStdIndex)
#Column bind data w/ subjects & activites 
finalTrain <- cbind(y_train, trainSubjects,trainSubset)
finalTest <- cbind(y_test, testSubjects, testSubset)
#Merge train and test set
FinalDat <- rbind(finalTrain, finalTest)
#Create tidy dataset and order it in ascending order
tidy<-aggregate(FinalDat[,3:ncol(FinalDat)],list(Subject=FinalDat$Subjects, Activity=FinalDat$Activities), mean)
tidy <- tidy[order(tidy$Subject), ]
#Replace activity names with descriptive names 
tidy$Activity <- activity_labels[tidy$Activity,]
#Write table to a file
write.table(tidy,  file = "/Users/isaacjones/Desktop/Tidy.csv",sep = ",", row.names = F)

