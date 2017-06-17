runanalysis <- function(){
  if(!file.exists("Dataset.zip")){
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  f <- file.path(getwd(), "Dataset.zip")
  download.file(url, f)
  }
  dataDir <- "UCI HAR Dataset"
  if(!file.exists(dataDir)) { unzip("Dataset.zip", exdir = ".") }
  x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
  x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
  y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
  y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
  subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
  subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
  featureNames <- read.table("UCI HAR Dataset/features.txt")
  activityLabels <-read.table("UCI HAR Dataset/activity_labels.txt")
  
  features <- (grep("(mean|std)\\(\\)", featureNames[,2]))
  x_train <- x_train[,features]
  x_test <- x_test[,features]
  
  features <- featureNames[features,2]
  features <- gsub("-mean\\(\\)", "Mean", features)
  features <- gsub("-std\\(\\)", "StdDev", features)
  
  train <- cbind(subject_train, y_train, x_train)
  
  test <- cbind(subject_test, y_test, x_test)
  
  combined_data <- rbind(train, test)
  
  colnames(combined_data) <- c("subject","activity",features)
  
  combined_data[,2] <- factor(combined_data[,2], levels = activityLabels[,1], labels = activityLabels[,2])
  combined_data[,1] <- as.factor(combined_data[,1])
   
  library(plyr)
  limitedColMeans <- function(data) { colMeans(data[,-c(1,2)]) }
  tidy <- ddply(combined_data, .(subject, activity), limitedColMeans)
  
  write.csv(tidy, "tidy.csv", row.names=FALSE)

}


