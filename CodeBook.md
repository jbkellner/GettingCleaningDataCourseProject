GettingCleaningDataCourseProject
================================

Coursera Getting and Cleaning Data Class Project


### CodeBook.md and README.md for run_analysis.R

The CodeBook and README files are identical.  These files detail the content and data for the run_analysis.R script.

 

### Data source and brief description:

The data in the UCI HAR Dataset represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 30 volunteers, aged 19-48, performed six activities (walking, walking upstairs, walking downstairs, sitting, standing, and laying) while wearing the smartphone.  The linear acceleration and angular velocity were captured by the smartphone's embedded accelerometer and gyroscope. Additional information, including details on pre-processing of the data by the original suppliers of the data, are provided in the README.txt file provided with in the UCI HAR Dataset folder.

The dataset was provided as part of the course project for the Coursera Course called Getting and Cleaning Data (https://class.coursera.org/getdata-003/).  

The dataset was originally obtained from the following site which also includes a full description: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones




### Data variables and data transformations:

The following data are imported from the UCI HAR Dataset:

* activitylabels: A two column table of the six activities. Column 1 contains the numbers 1 to 6 in sequential order which correspond to the following activities listed in Column 2: walking, walking upstairs, walking downstairs, sitting, standing, and laying.

* features: A two column table of the 561 accelerometer and gyroscope measurements. Column 1 contains the numbers 1 to 561 in sequential order with the features described in abbreviated format in Column 2.  Feature descriptions were imported as provided, and tidied by removing commas and parentheses, changing all dashes to underscores, and transforming text to all lower case.

The accelerometer data is contained in two data sets located in folders called test and train. The entire data set was randomly partitioned in to these two data sets. The test folder contains data for 30% of the volunteers (2947 observations). The train folder contains data for 70% of the volunteers (7352 observations).

* testsubject and trainsubject: Each of these are a 1 column table containing the volunteer subject number (1-30). testsubject contains all 2947 rows from subject_test.txt, trainsubject contains all 7352 rows from subject_train.txt.

* testx and trainx: Each of these contain 561 columns that correspond to the features data. testsubject contains all 2947 rows from X_test.txt, trainsubject contains all 7352 rows from X_train.txt.

* testy and trainy: Each of these are a 1 column table containing the activity number that corresponds to the activity listed in activitylabels. testsubject contains all 2947 rows from y_test.txt, trainsubject contains all 7352 rows from y_train.txt.

Data in the Inertial Signals subfolders is not utilized.




### Data processing to form a tidy data set

Merge the files from the test and train sets as follows:

* subject: Concatenate testsubject and train subject.

* x: Concatenate testx and trainx.

* y: Concatenate testy and trainy.

* tidydata: Combine subject, y and x into one data set.

* Append headers to the tidydata using the features table, and link the activitylabels to the numbers in the y column (column 2).




#### Subset the dataset, calculate the average of each measurement for each activity and volunteer subject and export.

* Extract only the columns of measurements that include the words mean and standard deviation, but do not include measurements of mean frequency. This reduces the 561 measurements down to 66 columns of measurements.

* This table of 66 mean and standard deviation measurements is combined with two columns appended to the start of the table containing the subject (1-30) and the activity (1-6).

* Calculate the average of each measurement for each activity and volunteer subject and export as a tab delimited file called tidydatameanbyactivitysubject.txt.  An example of this file is also available in the Github repo.



