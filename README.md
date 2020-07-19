# Getting-and-Cleaning-Data-Course-Project

This project is made up of a script called run_analysis.R and a codebook.

The script downloads data from a study at the University of California Irvine (UCI) Center for Machine Learning and Intelligent Systems website. The data are multivariate, time-series data data that were donated on 2012-12-10 as per UCI's website.

The data come from an experiement where 30 volunteers (subjects) participated in 6 recorded physical activities, which were manually coded based on video data. Measurements were taken during these exercises using accelerometers and gyroscopes on Samsung Galaxy SII's that were attached to participants' waists. These data were divided into various datasets for training and testing.

The script then reads in data from the features data to be used as column names, based on information that was found in the features_info file included with the data. It then reads in measurement values, activity information, and subject information and binds their columns to one dataset for testing and training data respectively. This is done based on the fact that the dimensions of the data fit together and the description of the data provided on the UCI site. 

The testing and training datasets are then merged by binding their rows. Columns are renamed using the features data and activivities are given descriptive labels by using the mapping provided in activity_labels.txt. 

The script then creates a dataframe of only subjects, activities, and columns that take the standard deviation and means of measurement variables. Note that the "freqMeans" and means for angle measurements are discluded, as their calculations were judged to be materially different from other mean columns and they also did not have an associated standard deviation column. 

The script then renames columns to make them more descriptive based on information found in the features_label and instructions in the assignment.

Finally, all of these columns are grouped by the subject and activity and aggregated to a single mean measurement per variable in order to create a tidy dataset as instructed on Coursera. 

The codebook describes manipulation that was done to all variables, along with all renaming that was done to make variables more interpretable.

