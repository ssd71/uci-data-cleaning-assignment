library(dplyr, readr)


# Save current working directory to return to
old.path <- getwd()



# The following block code downloads and unzips the dataset
if(!dir.exists("UCIHAR")){
    
    
    if(!file.exists("UCIHAR.zip")){
        
        
        # downloads the dataset
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "UCIHAR.zip")
        
        
    }
    
    
    unzip("UCIHAR.zip") # unzips the dataset
    
    
}

# You must be on the directory you've unziped the file, or alter the line below accordingly
setwd("UCIHAR")



# Feature names are extracted and cleaned

cleanfeatures <- readLines("./features.txt") %>% # Read raw feature names
    
    # The following two lines are for getting the actual names listed in
    # features.txt(i.e removing the row indices from read lines)
    strsplit(' ') %>%
    sapply(function(x) x[[2]]) 




# The section below reads the train and test datasets into tbl_df's 
# and merges them



# Read X_train.txt feature vectors into a tbl_df, using cleanfeatures
# as column names
traindfx <- read_table("./train/X_train.txt", col_names = cleanfeatures)


# Read y_train.txt training labels and 
# subject_train.txt subject id's into tbl_df's
traindfy <- read_table("./train/y_train.txt", col_names = "activity")
trainsubjects <- read_table("./train/subject_train.txt", col_names="subjectid")



# Merges the feature vectors with labels and subject id's for the training 
# dataset
train <- bind_cols(traindfx, traindfy, trainsubjects)




# Reads X_test.txt testing feature vectors into a tbl_df
testdfx <- read_table("./test/X_test.txt", col_names = cleanfeatures)


# Read y_test.txt testing labels and 
# subject_test.txt subject id's into tbl_df's
testdfy <- read_table("./test/y_test.txt", col_names = "activity")
testsubjects <- read_table("./test/subject_test.txt", col_names="subjectid")


# Merges the feature vectors, labels and subject id's for the testing dataset
test <- bind_cols(testdfx, testdfy, testsubjects)



# The following block of code selects and merges relevant columns from 
# the training and testing datasets into a single dataset named ucihar



ucihar <- 
    # Actual Merging step
    bind_rows(train, test) %>%
    
    # `select`ion of relevant columns i.e measurements on mean and 
    # standard deviation of each measurement to form the required dataset
    select(matches("mean\\(\\)|std\\(\\)|activity|subject"))




# General Tidying up


# Cleaning column names of any special characters (R does not play very well
# with special characters)
colnames(ucihar) <- tidyfeatures <- gsub("[-,\\(\\)]", '', colnames(ucihar))


# Assigning descriptive activity labels to the activity column
# taken from the activity_labels.txt, matching activity id with
# full name of activity
activitynames <- read.table("./activity_labels.txt")
ucihar <- ucihar %>% mutate(activity = activitynames[activity,2])


# Creating a second independent dataset which contains the means of each 
# variable grouped by subject and activity labels
ucihar2 <- mutate(ucihar, subjectid=as.factor(subjectid))  %>% 
    group_by(activity, subjectid) %>%
    summarise_all(mean)



# Writes out the table to a text file
write.table(ucihar2, file = "ucihar2.txt", row.names = F)