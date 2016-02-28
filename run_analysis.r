run_analysis <- function() {
    
    ## Assumtion:  we are in the correct working directory
    ## read the data files
    ## read the activity labels file
    actvty_lbls <- read.table("UCI HAR Dataset/activity_labels.txt")
    ## some info about this file
    summary(actvty_lbls)
    str(actvty_lbls)
    head(actvty_lbls)
    
    ## read the features_info file (these will become the column headers for the train and test files)
    features <- read.table("UCI HAR Dataset/features.txt")
    ## some info about this file
    summary(features)
    str(features)
    head(features)
    
    ## read in the test files
    subjtest <- read.table("UCI HAR Dataset/test/subject_test.txt")
    ## some info about this file
    summary(subjtest)
    str(subjtest)
    head(subjtest)
    min(subjtest)    ## 2
    max(subjtest)    ## 24
    
    ## these are the readings rows
    xtest <-  read.table("UCI HAR Dataset/test/x_test.txt") 
    ## These are the activity values per reading row
    ytest <-  read.table("UCI HAR Dataset/test/y_test.txt") 
    min(ytest)      ## 1
    max(ytest)      ## 6
    
    ##  names(xtest)    "V1"......."V561"
    
    ## read in the train files
    subjtrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
    ## some info about this file
    summary(subjtrain)
    str(subjtrain)
    head(subjtrain)
    min(subjtrain)   ## 1
    max(subjtrain)   ## 30
    
    ## these are the readings rows
    xtrain <-  read.table("UCI HAR Dataset/train/x_train.txt") 
    ## These are the activity values per reading row
    ytrain <-  read.table("UCI HAR Dataset/train/y_train.txt") 
    min(ytrain)      ## 1
    max(ytrain)      ## 6
    
    
    ## Assumption: the subjects in both files (subjtest and subjtrain) are the same for the same values
    ## Assumption: the xtest and ytest files contain values (from 1 to 6) for the activity type.
    ##              1 WALKING
    ##              2 WALKING_UPSTAIRS
    ##              3 WALKING_DOWNSTAIRS
    ##              4 SITTING
    ##              5 STANDING
    ##              6 LAYING
    
    ##  names(xtrain)    "V1"......."V561"
    
    ## assign the values from the features data frame as column headers for the xtest and xtrain data frames
    colnames(xtest) <- features[,2]
    colnames(xtrain) <- features[,2]
    
    ## add the columns for Activity to the xtest and xtrain data frames and change colname to Activity     
    xtest <- cbind(ytest, xtest)
    colnames(xtest)[1] <- "Activity"
    xtrain <- cbind(ytrain, xtrain)
    colnames(xtrain)[1] <- "Activity"
    
    ## add the columns for subject to the xtest and xtrain data frames and change colname to subject     
    xtest <- cbind(subjtest, xtest)
    colnames(xtest)[1] <- "Subject"
    xtrain <- cbind(subjtrain, xtrain)
    colnames(xtrain)[1] <- "Subject"
    
    ## join (by using th rbind function both data frames (xtest and xtrain))  10299 obs. of 563 variables
    joindf <- rbind(xtest,xtrain)
    
    ## just for kicks, check if there are any missing values
    sum(is.na(joindf))
    
    ## extract only those columns containing the word mean or std in any part of the name
    joinsub <- joindf[,grep("[Mm][Ee][Aa][Nn]|[Ss][Tt][Dd]",names(joindf))]
    ## add back in the first 2 columns
    joinsub <- cbind(joindf[1:2],joinsub)

    ## change the name of the values in the Activity column based on the actvty_lbls data frame
    mergedf <- merge(actvty_lbls,joinsub,by.x="V1",by.y="Activity",all=TRUE)
    ## delete the first column of numeric activity values
    mergedf <-mergedf[-1]
    ## rename the new activity column header
    colnames(mergedf)[1] <- "Activity"
  
    ### relabel the column names to be descriptive. Since I don't understand meaning of the labels
    ### I will only remove the () from the labels.  I think we need all the rest of the verbiage to 
    ### determine differences in each mean or standard deviaion value
    names(mergedf) <- gsub("()-", "", names(mergedf), fixed = TRUE)
    names(mergedf) <- gsub("BodyBody", "Body", names(mergedf), fixed = TRUE)
    names(mergedf) <- gsub("()", "", names(mergedf), fixed = TRUE)
    ## the angle columns could probablt change, but I'm not sure what would be valid values
    
    
    ## check to make sure there are no duplicate column names
    ## there should be 88 unique values
    unique(colnames(mergedf))
    
    ## group by Activity and Subject and calculate mean for each column 
    library(plyr)
    groupColumns = c("Subject","Activity")
    #   dataColumns = c("hr", "rbi","sb")
    ## this statement groups the data correctly but the mean is applied to the whole column.
    ## I don't know how to apply mean to each column value in each row.  
    ## I have tried rowMeans and mean and neither worked
    ## result = ddply(mergedf, groupColumns, function(colMeans) colMeans(mergedf[,3:88]))
    ## head(result)
 
    ##   other things I tried that did not work   
    ##   result <- aggregate(mergedf[, 3:88], list(mergedf[1:2,]), mean)
    ##   library(dplyr)
    ##   df %>% group_by(groupColumns) %>% summarise_each(funs(mean))
    
    ## this seems to have worked!
    result <- aggregate(mergedf[,3:88], by=list(Subject=mergedf$Subject, Activity=mergedf$Activity), mean)    
    
    ## write the dataset 
    ## write.table(result,file="run_analysis.txt",row.names=FALSE)
    write.csv(result,file="run_analysis_output.csv",row.names=FALSE)
    
     }

