# CODEBOOK for Getting and Cleaning Data Coursera Week 4 Assignment
 
## The Analysis process

   1. We assume we are in the working directory for the Files we will be using for this exercise.
   
   2. Read the data files
      (For all files, use read.table("file location and name"), ex. subjtest <- read.table("UCI HAR Dataset/test/subject_test.txt") )
      
      a. read the activity labels file as actvty_lbls (this file contains the numeric value and description for each value of each activity being tracked)
		
      b. read the features_info file as features (this data will become the column headers for the train and test files)
		
      c. read the subject_test file as subjtest  (this file contains a record for subjects equal to the number of records in the x_test file. We will append this file as a new column, Subject, to the x_test file.)
		
         *determine the min and max values in this file to see where these values lie  (2:24)
			
      d. read the x_test file as xtest (this file containts columns of data relating to the different measurements being tracked for the subjects in the test population)
		
      e. read the y_test file as ytest (this file contains a record for activities equal to the number of records in the x_test file. We will append this file as a new column, Activity), to the x_test file.)
		
         *determine the min and max values in this file to make sure they fall between 1 and 6.
			
      f. read the subject_train file as subjtrain (this file contains a record for subjects equal to the number of records in the x_train file. We will append this file as a new column, Subject, to the x_train file.)
		
         *determine the min and max values in this file to see where these values lie  (1:30)
			
      g. read the x_train file as xtrain (this file containts columns of data relating to the different measurements being tracked for the subjects in the test population)
		
      h. read the y_train file as ytrain  (this file contains a record for activities equal to the number of records in the x_train file.  We will append this file as a new column, Activity), to the x_train file.)
		
         *determine the min and max values in this file to make sure they fall between 1 and 6.
			
   3. find more information for these files by using summary(), str, head, etc.   
    
   4. Assumption: the subjects in both files (subject_test and subject_train) are the same for the same values
    
   5. Assumption: the x_test and y_test files contain values (from 1 to 6) for the activity types below:
    
                * 1 WALKING
                 
                * 2 WALKING_UPSTAIRS
                 
                * 3 WALKING_DOWNSTAIRS
                 
                * 4 SITTING
                 
                * 5 STANDING
                 
                * 6 LAYING  
                 
   6. check the names of the x_train file    "V1"......."V561"
    
      a. assign the values from the features data frame read in above to the column names of the xtest and xtrain data frames
		
   7. add column for Activity to the xtest and xtrain data frames and change the column name to Activity.
    
   8. add column for Subject to the xtest and xtrain data frames and change the column name to Subject.
	
   9. join the xtest and xtrain data frames using rbind giving 10299 obs. of 563 variables.
	
  10. check for any missing values - there were none.
    
  11. extract only those columns including the word mean or std anywhere in the column name. 
    
      a. add back the first two columns for Subject and Activity
		
  12. change the names of the numeric values in the Activity column based in the actvty_lbls data frame.
	
  13. clean up any extraneous columns	
	
      a. I had to remove the column of numeric values for Activity leaving only the columns of descriptions.
		
      b. rename the new activity column name to Activity
		
  14. change the column names for the measurements to more readable format minimal changes were done for this)
    
      a. remove instances of ()-
		
      b. change instances of "BodyBody" to "Body"
		
      c. remove instances of ()  
		
      d. I did not change the columns having to do with angle.
		
  15. check to make sure after changing the column names that they were unique and I didn't create any duplicates.
    
  16. groupby Subject and Activity and calculate the mean for each column.
    
      a. after much trial and error, I used the aggregate function as follows:
		
     result <- aggregate(mergedf[,3:88], by=list(Subject=mergedf$Subject, Activity=mergedf$Activity), mean)
			
  17. write the result table to a file run_analysis_output.csv to be uploaded to Coursera and github.
	
