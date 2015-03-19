# TidyData
Data Cookbook and R Analysis program for cleaning up the dataset.

There are 4 files in this directory:
- README.md
  - this file
- GY_tidydata_step4.txt
  - output for Step 4, the consolidated training and test data set with subject and activity name.
- GY_tidydata_step5.txt
  - output for Step 5, containing the averages for each variable for each activity and subject.
- run_analysis.R
  - the R program that will read the data files and generate the above output text files.

### Pre-Requisites
This program assumes that you have already downloaded and uncompressed the dataset in your local directory. You should then put the run_analysis.R file in the local directory, where the other files like features.txt, features_info.txt and activity_labels.txt can be found.

#### Libraries Required
The R code uses the plyr and the reshape R packages.

#### Steps To Run
1. Put run_analyis.R file in your local directory where your dataset resides (see Pre-Requisites).
2. Load up R.
3. Source the script.
    ```source("run_analysis.R")
    ```
4. Check the local directory for the generated text files.

### Program Algorithm
The program follows the following steps:

1. Read the list of features from _features.txt_ (via `getFeatures()`), and extract only those features with "_mean()_" and "_std()_".
2. Read the list of activities from _activity_labels.txt_ (via `getActivities()`).
3. Reads the train and test data sets and combines both data frames (via `getconsdata()`). For each data set, read in the associated files (via `getdata()`):
  1. Read in the main data set.
  2. Read in the Y file for the activities, and join this to the list of activities to get the activitynames.
  3. Read in the subject file.
  4. Merge all 3 files into a single data frame and return the data frame.
  5. Combines both train and test data frames.
4. Calculates the summary means for each variable (via `gensummaryavgs()`) by doing a `melt` and `dcast`.
5. Writes out the tables to file (via `writedata()`).
