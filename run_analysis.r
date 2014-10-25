require(data.table)

train_path <- "train"
test_path <- "test"

x_names <- c("X_train", "X_test")
y_names <- c("y_train", "y_test")
subject_names <- c("subject_train", "subject_test")

train_x_fn <- sprintf("%s/%s.txt", train_path, x_names[[1]])
test_x_fn <- sprintf("%s/%s.txt", test_path, x_names[[2]])
train_y_fn <- sprintf("%s/%s.txt", train_path, y_names[[1]])
test_y_fn <- sprintf("%s/%s.txt", test_path, y_names[[2]])
test_subject_fn <-  sprintf("%s/%s.txt", train_path, subject_names[[1]])
train_subject_fn <-  sprintf("%s/%s.txt", test_path, subject_names[[2]])

#
# 1. Merges the training and the test sets to create one data set
#

train_dataset_measures <- read.table(train_x_fn)
test_dataset_measures <- read.table(test_x_fn)
train_activities <- read.table(train_y_fn)
test_activities <- read.table(test_y_fn)
train_subject <- read.table(train_subject_fn)
test_subject <- read.table(test_subject_fn)

#sytem.time showed that rbind is faster then merge
dataset_measures <- rbind(train_dataset_measures, test_dataset_measures)
dataset_activities <- rbind(train_activities, test_activities)
dataset_subjects <- rbind(train_subject, test_subject)
#
# 2. Extracts only the measurements on the mean and standard deviation for each measurement
#
feature_labels <- read.table("features.txt", colClasses=c("integer", "character"))
#labeling dataset at this point is easier
names(dataset_measures) <- feature_labels[,2]
dataset_mean_std <- dataset_measures[,grep(pattern='-mean\\(+|-std\\(+', feature_labels[,2])]
#add subjects to measurements
dataset_mean_std <- cbind(dataset_mean_std, dataset_subjects)
#name the column
colnames(dataset_mean_std)[length(dataset_mean_std)] <- "subjects"
#
# 3. Uses descriptive activity names to name the activities in the data set
#
activity_labels <- read.table("activity_labels.txt", colClasses=c("integer", "character"))
#
dataset_mean_std <- cbind(dataset_mean_std, apply(dataset_activities, 1, function(x) activity_labels[x,2]))
#
# 4. Appropriately labels the data set with descriptive variable names.
#
# already done in 2 except for the activity column
colnames(dataset_mean_std)[length(dataset_mean_std)] <- "activity"
#
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
dataset_mean_avgs_list <- split(dataset_mean_std, list(dataset_mean_std$activity, dataset_mean_std$subjects))

dataset_mean_table <- data.table()

 for (i in 1:length(dataset_mean_avgs_list)) {
    avg_row <- sapply(dataset_mean_avgs_list[[i]][,1:(length(dataset_mean_avgs_list[[i]])-2)], mean)
    #add subject to the table 
    avg_row[length(dataset_mean_avgs_list[[i]])-1] <- dataset_mean_avgs_list[[i]][1, length(dataset_mean_avgs_list[[i]])-1]
    names(avg_row)[length(avg_row)] <- "subject"
    #add activity to the table
    avg_row[length(dataset_mean_avgs_list[[i]])] <- as.character(dataset_mean_avgs_list[[i]][1, length(dataset_mean_avgs_list[[i]])])
    names(avg_row)[length(avg_row)] <- "activity"
    #append a row to a output data table
    dataset_mean_table <- rbind(dataset_mean_table, t(avg_row))
 }
#set appropriate names to rows
setnames(dataset_mean_table,colnames(dataset_mean_table), names(avg_row))
#write output to file
write.table(dataset_mean_table, file="output.txt", append=TRUE, row.name=FALSE)