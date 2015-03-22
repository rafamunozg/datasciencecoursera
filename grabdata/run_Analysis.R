# The script assumes the input file is already located within the Working Directory
# The .zip file was downloaded and unzipped under the /data folder
require(plyr)
require(dplyr)

#first the tests, starting with a clean DF
testdf <- read.delim("./data/UCI HAR Dataset/test/subject_test.txt", header=FALSE)
testdf <- cbind(testdf, read.delim("./data/UCI HAR Dataset/test/y_test.txt", header=FALSE))
names(testdf) <- c("test.subject", "test.activitylabel")

#Adding names for the data load now
rowNames <- read.delim("./data/UCI HAR Dataset/features.txt", header=FALSE, sep="")
testdf <- cbind(testdf, read.delim("./data/UCI HAR Dataset/test/X_test.txt", header=FALSE, sep = "", col.names=rowNames$V2))
#selecting only columns named as std or mean
testdf <- testdf[,grepl("(subject|activity|mean|std)", names(testdf), perl = TRUE)]
#testdf is ready

#now the training data
trainDF <- read.delim("./data/UCI HAR Dataset/train/subject_train.txt", header=FALSE)
trainDF <- cbind(trainDF, read.delim("./data/UCI HAR Dataset/train/y_train.txt", header=FALSE))
names(trainDF) <- c("train.subject", "train.activitylabel")
trainDF <- cbind(trainDF, read.delim("./data/UCI HAR Dataset/train/X_train.txt", header=FALSE, sep="", col.names=rowNames$V2))
#selecting only columns named as std or mean
trainDF <- trainDF[,grepl("(subject|activity|mean|std)", names(trainDF), perl = TRUE)]

#Ready to Merge the data sets
mergedDF <- merge(testdf, trainDF, all = TRUE)

#Labeling activities
act <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")

# Cleaning up some memory
rm(testdf)
rm(trainDF)

# Assuming that the merge-all is really a bind because the both sets are complement and there is 
# no intersect between them, I'm testing for NA and then using the other value to search for the activity
mergedDF <- mutate(mergedDF, activity = act[ifelse(!is.na(train.activitylabel),train.activitylabel,test.activitylabel)])
mergedDF <- mutate(mergedDF, subject = ifelse(!is.na(train.subject),train.subject,test.subject))

#Now going to the tidy stuff
#tidyDF <- 
