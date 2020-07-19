library(dplyr)
library(tidyr)

# Assign the folder's download URL
folder_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Download the folder with the dataset
download.file(folder_url, destfile = "data.zip")

# Unzip the foler
unzip("data.zip")

# Save the name of the parent folder for pasting later
parent_folder <- "UCI HAR Dataset"

# Read in the Features data to be used as column names later on
features <- read.table(paste(parent_folder, "features.txt", sep = "/"), row.names = 1)

# Change features to a vector to use as column names more easily
features <- features[,1]

# Read in activity labels. These will be used to give descriptive labels to activities
activity_labels <- read.table(paste(parent_folder, "activity_labels.txt", sep = "/"), 
                              col.names = c("value", "label"))

# Create a function to read in and combine all files for test or training data
read_and_name <- function(ds = c("test", "train")) {
  # Assign the value of the relevant path for test or training data  
  subdir <- paste(parent_folder, ds, "/", sep = "/")    
  
  # Create a function to read in the various datasets of interest
  read_files <- function(set = c("X_", "y_", "subject")) {
    read.table(paste0(subdir, set, ds, ".txt"))
  }
  # Read in the values for the test or train data
  temp_data <- read_files(set = "X_")
  
  # Read in the activities for the test or train data
  temp_activities <-read_files(set = "y_")
  
  # Read in the subject for the test or train data
  temp_subject <-read_files(set = "subject_")
  
  # Combine all the relevant test or train data
  cbind(temp_subject, temp_activities, temp_data)
  
}

# Read in test data using the customized function
test_data <- read_and_name(ds = "test")

# Read in the train data using the customized function
train_data <- read_and_name(ds = "train")

# Combine the test and train data by binding the rows of the datasets
complete_data <- rbind(test_data, train_data)

# Create a vector of names
complete_names <- c("subject", "activity", features)

# Rename the columns of the complete dataset
names(complete_data) <- complete_names

# Assign descriptive labels to the activity column
complete_data$activity <- activity_labels$label[match(complete_data$activity,
                                                      activity_labels$value)]

# Keep only activity, subject, mean and standard deviation columns.
# Note mean frequency and angle means were dropped, as their calculations were
# Materially different from other mean measurements and they did not have 
# Associated standard deviation measurements.
means_and_std<- complete_data[, grepl("activity|subject|mean\\(\\)|std\\(\\)", 
                                      names(complete_data))]

# Fix the "BodyBody" typo in some of the column names
fast_renaming <- function(original, replacement) {
  gsub(pattern = original, replacement = replacement, x = names(means_and_std))
}


# Make more descriptive names based on the codebook.
names(means_and_std) <- fast_renaming(original = "^t", replacement = "time_domain_signals_of_")
names(means_and_std) <- fast_renaming(original = "^f", replacement = "frequency_domain_of_")
names(means_and_std) <- fast_renaming("^(.*)Acc", "accelerometer_measurement_of_\\1")
names(means_and_std) <- fast_renaming("^(.*)Gyro", "gyrometer_measurement_of_\\1")
names(means_and_std) <- fast_renaming("BodyBody", "Body")
names(means_and_std) <- fast_renaming("BodyJerkMag", "magnitude_of_3_axial_acceleration_of_body_jerk_signals")
names(means_and_std) <- fast_renaming("BodyJerk", "acceleration_of_body_jerk_signals_")
names(means_and_std) <- fast_renaming("BodyMag", "magnitude_of_3_axial_body_acceleration_signals")
names(means_and_std) <- fast_renaming("Body", "raw_body_acceleration_signals_")
names(means_and_std) <- fast_renaming("GravityMag", "magnitude_of_gravity_acceleration_signals")
names(means_and_std) <- fast_renaming("Gravity", "gravity_acceleration_signals_")
names(means_and_std) <- fast_renaming("^(.*)-mean\\(\\)", "mean_of_\\1")
names(means_and_std) <- fast_renaming("^(.*)-std\\(\\)", "standard_deviation_of_\\1")
names(means_and_std) <- fast_renaming("-X", "on_x_axial_plane")
names(means_and_std) <- fast_renaming("-Y", "on_y_axial_plane")
names(means_and_std) <- fast_renaming("-Z", "on_z_axial_plane")

# Take the mean of the mean and standard deviation fields by subject and activity. This is a tidy dataset in wide format.
summary_data <- means_and_std %>%
  aggregate(by = list(means_and_std$subject, means_and_std$activity),
            FUN = mean) %>%
  select(-(subject:activity)) %>%
  rename(subject = Group.1, activity = Group.2)