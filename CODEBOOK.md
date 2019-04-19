## The Original Dataset
Consists of the following files:
- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are also additionally available for the train and test data.

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. This is incorporated into the tidy dataset.

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration.

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

## The Tidy Dataset
The tidy dataset was obtained by the following procedure outlined below
### Procedure for obtaining the tidy dataset:
1. #### Merging the training and test data:
The training and test datasets, both have the same variables along with labels and subject id's corresponding to each observation, this step thus only involved a simple `bind_rows()` call, after reading the data, labels, subject id's into dataframes.

2. #### Extracting only the mean and standard deviations of each measurement:
After merging the training and testing datasets to a single dataframe, the `select()` function from the `dplyr` package was used to only select the means and standard deviations of measurements, the columns to be selected were matched against a regular expression.

3. #### Assigning descriptive activity names for activity labels in the dataset:
The activity id's in the resulting dataset were matched to descriptive activity names as given in activity_labels.txt using a `mutate()` call modifying the `activity` columns.

4. #### Assigning descriptive variable names to all columns:
This part was already a job well done, thanks to the creators of the dataset, all that remained was removing the special characters using `gsub()` calls, matching colnames with regular expressiions and replacing matches with '' (an empty string).

5. #### Creating a secondary tidy dataset:
Using the dataset at the end of the last step another dataset was created which consisted of the means of each of the columns grouped by subject and activity. This was achieved by a `mutate()` call to convert the subject id's to a factor, followed by a call to `group_by` so as to group by subject id and activity, finally a call to `summarise_all()` with the argument `mean`.

### The Variables
 The variables activity and subjectid indicate respectively, the activity label and the id of the subject each row is associated with.
 The variables other than `subjectid` and `activity` are either mean or standard deviations of some measurements, in both time domain and frequency domain. Time domain signals have a 't' prefix whereas frequency domain signals have an 'f' prefix. The frequency domain signals were obtained by applying a FFT(Fast Fourier Transform) to the time domain signals. The measurements are named as such:
 - tBodyAcc-XYZ
 - tGravityAcc-XYZ
 - tBodyAccJerk-XYZ
 - tBodyGyro-XYZ
 - tBodyGyroJerk-XYZ
 - tBodyAccMag
 - tGravityAccMag
 - tBodyAccJerkMag
 - tBodyGyroMag
 - tBodyGyroJerkMag
 - fBodyAcc-XYZ
 - fBodyAccJerk-XYZ
 - fBodyGyro-XYZ
 - fBodyAccMag
 - fBodyAccJerkMag
 - fBodyGyroMag
 - fBodyGyroJerkMag

The mean of each measurement has the word 'mean' in it, and standard deviations have 'std' in their names.
For a more complete list of measurements please refer to features.txt, for more info on how the data was collected and processed, please refer to features_info.txt
