# Title: Course Project for Coursera Getting and Cleaning Data
# Brief description:
# Author: jbkellner
# Date created: May 14, 2014
# Last modified: May 24, 2014
# Dependencies: This script assumes the data to be processed is in a folder 
# called UCI HAR Dataset located in the current working directory
# if the folder is missing, it will be downloaded from the web.
library(utils,stats)


# STEP 1A: Read in the focal data into the R global environment

# Check that the data folder exists and set as the working directory, stop if it is missing
if(!file.exists("UCI HAR Dataset")){
     url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
     print("The data folder UCI HAR Dataset is missing, it can be downloaded from the web at:")
     print(url)
     rm(url)
     
     #download.file(url,destfile="Dataset.zip",method="curl")
     #unzip("as.character(getdata-projectfiles-UCI HAR Dataset.zip)",list=TRUE)
     
} else
{
     print("The data folder UCI HAR Dataset was located, construction of a tidy dataset will proceed.")
     setwd("UCI HAR Dataset")
}

# activity_labels link the class labels with their activity name
activitylabels<-read.table("activity_labels.txt") 
activitylabels<-as.matrix(activitylabels)
activitylabels[,1]<-as.numeric(activitylabels[,1])
activitylabels[,2]<-tolower(activitylabels[,2])

# features.txt is a list of all features
# remove characters such as minus(replace with understore), comma, parentheses
features<-read.table("features.txt") 
features[,2]<-gsub("-","_",features[,2])
features[,2]<-gsub(",","",features[,2])
features[,2]<-gsub("\\(","",features[,2])
features[,2]<-gsub("\\)","",features[,2])
features[,2]<-tolower(features[,2])


# Import data from both the test and train sets
# data for 30% of the volunteers is in the test folder
# data for 70% of the volunteers is in the train folder

# subject: each row identifies the subject who performed the activity
# from each window sample, ranges from 1:30
testsubject<-read.table("test/subject_test.txt")
trainsubject<-read.table("train/subject_train.txt")

# X is a 561-feature vector with time and frequency domain variables
testx<-read.table("test/X_test.txt")  
trainx<-read.table("train/X_train.txt") 

# y: the activity label for x
testy<-read.table("test/y_test.txt")  
trainy<-read.table("train/y_train.txt") 

# Return to the main directory
setwd("..")

# This section includes Steps 1B, 3, and 4
# STEP 1B: Merge the files from the test and train sets and make a 
# master data.frame called tidydata to export as a text file called tidydata.txt
# STEP 3: Name the activities in the data set.
# This is accomplished using the factor function to label the activities.
# STEP 4: Label the data set columns.
# This is accomplished by using the names function to label the columns by the 
# the features that were imported and cleaned in Step 1A.

# subject, identifies the subject who performed the activity
subject<-rbind(testsubject,trainsubject)
names(subject)<-"subject"

# x, a 561-feature vector with time and frequency domain variables
x<-rbind(testx,trainx)
names(x)<-features[,2] # get the column names from the feature file

# y, activity label for x
y<-rbind(testy,trainy)
names(y)<-"activity"
y$activity<-factor(y$activity,levels=activitylabels[,1],labels=activitylabels[,2])

# remove combined files
rm(testsubject,trainsubject)
rm(testx,trainx)
rm(testy,trainy)


# Create a master tidy data set called tidy data
# and export this as a tab delimited file called tidydata.txt
tidydata<-cbind(subject,y,x)
write.table(tidydata,"tidydata.txt",sep="\t")

rm(x,y,subject)


# STEPS 2: Extract only the mean and standard deviation of the measurements

# There are a total of 17 measurements in the features file
# that have been described using numerous statistics.
# We are interested in extracting the mean and standard deviation of these measurements
# described as mean() and std()

featuresmeanall<-grep("_mean",features[,2]) # features that calculate the mean
featuresmeanfreq<-grep("_meanfreq",features[,2]) # features that calculate the meanfreq
featuresmean<-as.numeric(row.names(table(featuresmeanall,exclude=featuresmeanfreq))) # remove meanfreq features
featuresstd<-grep("_std",features[,2]) # features that calculate the std
featuresmeanstd<-sort(c(featuresmean,featuresstd)) # combine mean and std into one list

tidydatameanstd<-tidydata[,c(1:2,(2+featuresmeanstd))] # 2 is added as the measurements started in column 3
write.table(tidydatameanstd,"tidydatameanstd.txt",sep="\t")

rm(featuresmeanall,featuresmeanfreq,featuresmean,featuresstd)
rm(featuresmeanstd)

# STEP 5: Calculate the average of each variable for each activity and each subject

tidydatasplitmeanstd<-split(tidydatameanstd,list(tidydatameanstd$subject,tidydatameanstd$activity))

tidydatameanbyactivitysubject<-matrix(NA,length(tidydatasplitmeanstd),ncol(tidydatameanstd))
for(i in 1:length(tidydatasplitmeanstd)){
     temp<-tidydatasplitmeanstd[[i]]
     tidydatameanbyactivitysubject[i,]<-c(temp[1,1],temp[1,2],sapply(temp[,3:ncol(temp)],mean))
}
tidydatameanbyactivitysubject<-as.data.frame(tidydatameanbyactivitysubject)
names(tidydatameanbyactivitysubject)<-names(tidydatameanstd)
tidydatameanbyactivitysubject$activity<-factor(tidydatameanbyactivitysubject$activity,levels=activitylabels[,1],labels=activitylabels[,2])
format(tidydatameanbyactivitysubject[,c(1,3:68)],scientific=TRUE)
format(tidydatameanbyactivitysubject,justify="right")

# Submit this dataset tidydatameanbyactivitysubject
write.table(tidydatameanbyactivitysubject,"tidydatameanbyactivitysubject.txt",sep="\t")

rm(tidydatasplitmeanstd,temp,i)
rm(features,activitylabels)

# Code to test and make sure the exported data is readable
testread<-read.table("tidydatameanbyactivitysubject.txt") 
testread==tidydatameanbyactivitysubject
