
# Data Load from the folder test & train
varTestLabels <- read.table("test/y_test.txt", col.names="label")
varTestSubjects <- read.table("test/subject_test.txt", col.names="subject")
varTestData <- read.table("test/X_test.txt")
varTrainLabels <- read.table("train/y_train.txt", col.names="label")
varTrainSubjects <- read.table("train/subject_train.txt", col.names="subject")
varTrainData <- read.table("train/X_train.txt")

# New format for variables coming from files of the folder test & train
varData <- rbind(cbind(varTestSubjects, varTestLabels, varTestData),cbind(varTrainSubjects, varTrainLabels, varTrainData))

# Data Load the file features.txt
varFeat <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)

# Mean and standard deviation of V2 on features.txt
varFeatStd <- varFeat[grep("mean\\(\\)|std\\(\\)", varFeat$V2), ]

# Incremental + 2 from varData with varFeatStd
varDataStd <- varData[, c(1, 2, varFeatStd$V1+2)]

# Data Load the file activity_labels.txt and Replace varLabels
varLabels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
varDataStd$label <- varLabels[varDataStd$label, 2]

# List of column names and feature names and remove non-alphabetic character and converting to lowercase
varCol <- c("subject", "label", varFeatStd$V2)
#varCol <- tolower(gsub("[^[:alpha:]]", "", varCol))
colnames(varDataStd) <- varCol

# Mean from Subject and label
varAggData <- aggregate(varDataStd[, 3:ncol(varDataStd)],by=list(subject = varDataStd$subject,label = varDataStd$label),mean)

# write data in tidy_data.txt
write.table(format(varAggData, scientific=T), "tidy_data.txt",row.names=F, quote=FALSE)

