#set path to reference reading files into from

setwd("C:/Users/sipatel/Documents/R/project3")

#read files

traindata <- read.table("./train/X_train.txt")

testdata <- read.table("./test/X_test.txt")

#bind files?

fulldata <- rbind(traindata, testdata)

#load and then add column names to fulldata

allnames <- read.table("./features.txt")

colnames(fulldata) <- c(as.character(allnames[,2]))

#subset for only columns that are mean and standard deviations

stdmeans <- fulldata[,grep("mean|std",colnames(fulldata),ignore.case=TRUE)]
