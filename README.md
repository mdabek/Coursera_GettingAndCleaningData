## The project of cleaning data of the human activity recognition using smartphones data set

The purpose of this project is to clean a data set received from the human activity recognition using smartphones studies.
The description of the source material can be found here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

### Assumptions
* There is a single script used for data cleaning - run_analysis.R. 
* The script runs from the UCI HAR Dataset directory.
* There are two directories with data in the UCI HAR Dataset folder: test and train.

### Data cleaning flow
The script does the following steps:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set. 
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The scripts produces the output.txt file which contains the tidy dataset created in step 5.

### Tidy dataset
The detailed description of the tidy dataset can be found in the CodeBook.md.