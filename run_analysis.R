
#install packages and instantiate libraries

install.packages("dplyr")
install.packages("reshape2")
library(dplyr)

#read files (confirm location makes sense in light of your working directory)

traindata <- read.table("./train/X_train.txt")

testdata <- read.table("./test/X_test.txt")

ytrain <- read.table("./train/Y_train.txt")

ytest <- read.table("./test/Y_test.txt")

subtest <- read.table("./test/subject_test.txt")

subtrain <- read.table("./train/subject_train.txt")

#Uses descriptive activity names to name the activities in the data set (TASK #3)

names(ytest) <- c("Activity")
names(ytrain) <- c("Activity")


ytrain1 <- sub("1","WALKING",ytrain[,1],ignore.case=TRUE)
ytrain2 <- sub("2","WALKING_UPSTAIRS",ytrain1,ignore.case=TRUE)
ytrain3 <- sub("3","WALKING_DOWNSTAIRS",ytrain2,ignore.case=TRUE)
ytrain4 <- sub("4","SITTING",ytrain3,ignore.case=TRUE)
ytrain5 <- sub("5","STANDING",ytrain4,ignore.case=TRUE)
ytrain6 <- sub("6","LAYING",ytrain5,ignore.case=TRUE)

ytrainfinal <- as.data.frame(ytrain6)

ytest1 <- sub("1","WALKING",ytest[,1],ignore.case=TRUE)
ytest2 <- sub("2","WALKING_UPSTAIRS",ytest1,ignore.case=TRUE)
ytest3 <- sub("3","WALKING_DOWNSTAIRS",ytest2,ignore.case=TRUE)
ytest4 <- sub("4","SITTING",ytest3,ignore.case=TRUE)
ytest5 <- sub("5","STANDING",ytest4,ignore.case=TRUE)
ytest6 <- sub("6","LAYING",ytest5,ignore.case=TRUE)

ytestfinal <- as.data.frame(ytest6)

#bind x and y files

names(ytestfinal) <- "Activity"
names(ytrainfinal) <- "Activity"
alltrain <- cbind(traindata,subtrain, ytrainfinal)
alltest <- cbind(testdata, subtest, ytestfinal)

#bind test and train files (TASK #1)
fulldata <- rbind(alltrain, alltest)

#Appropriately labels the data set with descriptive variable names.  (TASK #4)

allnames <- read.table("./features.txt")
morenames <- c("Subject","Activity")

callnames <- as.character(allnames[,2])
allnames1 <- sub("BodyAcc"," Body Acceleration ",callnames,ignore.case=TRUE)
allnames2 <- sub("GravityAcc"," Gravity Acceleration ",allnames1,ignore.case=TRUE)
allnames3 <- sub("BodyGyro"," Body Gyroscope ",allnames2,ignore.case=TRUE)

colnames(fulldata) <- c(allnames3,morenames)

#Extract only the measurements on the mean and standard deviation for each measurement. (TASK #2)

stdmean <- fulldata[,grep("mean|std|Activity|Subject",colnames(fulldata),ignore.case=TRUE)]

#From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject. (TASK #5)

tidysubject <- group_by(stdmean,Subject) %>% summarise_each(funs(mean))

#drop the Activity column from tidysubject and replace it with NA values to allow for binding with activity table

tidysubject <- tidysubject[,-c(88)]

tidysubject <- mutate(tidysubject,Activity="NA")

tidyactivity <- group_by(stdmean,Activity) %>% summarise_each(funs(mean))

#drop the Subject column from tidyactivity and replace it with NA values to allow for binding with activity table

tidyactivity <- tidyactivity[,-c(88)]
tidyactivity <- mutate(tidyactivity,Subject="NA")

tidy <- rbind(tidysubject,tidyactivity)

#put activity and subject columns next to each other for cleanliness

tidy <- tidy[c(88,1:87)]

#print tidy sata

print(tidy)
