#Set your working directory, input and output will be directed to here by default
setwd("~/Dropbox/Courses/Stat454:563 Machine Learning/")

# load helper functions
source("HelperFunctions.R")
mut.TSM = mut.name(Mut="TSM.NRTI")
mut.expert = mut.name(Mut="Exp.NRTI")
mut.comp = mut.name(Mut='Comp.NRTI')

data1 <- load.data(dataset="NRTI", drug="ABC", min.muts=10, muts.in=mut.comp)
data2 <- load.data(dataset="NRTI", drug="3TC", min.muts=10, muts.in=mut.comp)
data3 <- load.data(dataset="NRTI", drug="AZT", min.muts=10, muts.in=mut.comp)
data4 <- load.data(dataset="NRTI", drug="D4T", min.muts=10, muts.in=mut.comp)
data5 <- load.data(dataset="NRTI", drug="DDI", min.muts=10, muts.in=mut.comp)

# I should keep seqID when I write my functions for data processing, now I add it back
data1$ID <- as.numeric(rownames(data1))
data2$ID <- as.numeric(rownames(data2))
data3$ID <- as.numeric(rownames(data3))
data4$ID <- as.numeric(rownames(data4))
data5$ID <- as.numeric(rownames(data5))


# drug data YY, merge IC50 data and only keep record with no missing values for all 5 drugs
idx2 <- c("ID", "Y")
YY <- data1[,idx2]
YY <- merge(YY, data2[,idx2],by="ID", all=F)
YY <- merge(YY, data3[,idx2],by="ID", all=F)
YY <- merge(YY, data4[,idx2],by="ID", all=F)
YY <- merge(YY, data5[,idx2],by="ID", all=F)
colnames(YY)[-1] <- c("ABC", "3TC", "AZT", "D4T", "DDI")
YY <- YY[order(YY$ID),]

# genetic mutation data XX
# index of common mutations passed QC from all 5 drugs
idx1 <- Reduce(intersect, list(colnames(data1),colnames(data2),
			   colnames(data3),colnames(data4),colnames(data5)))[-1]
XX <- merge(data.frame(ID=YY$ID), data1[,idx1], by="ID", all=F)
XX <- XX[order(YY$ID),]
#colnames(XX) <- gsub("X.", "", colnames(XX))

rownames(XX) <- rownames(YY) <- XX$ID
XX$ID <- YY$ID <- NULL
XX <- as.matrix(XX)
YY <- as.matrix(YY)

save(XX, YY, file="HIV.complete.rda")


data1 <- load.data(dataset="NRTI", drug="ABC", min.muts=10, muts.in=mut.expert)
data2 <- load.data(dataset="NRTI", drug="3TC", min.muts=10, muts.in=mut.expert)
data3 <- load.data(dataset="NRTI", drug="AZT", min.muts=10, muts.in=mut.expert)
data4 <- load.data(dataset="NRTI", drug="D4T", min.muts=10, muts.in=mut.expert)
data5 <- load.data(dataset="NRTI", drug="DDI", min.muts=10, muts.in=mut.expert)

# I should keep seqID when I write my functions for data processing, now I add it back
data1$ID <- as.numeric(rownames(data1))
data2$ID <- as.numeric(rownames(data2))
data3$ID <- as.numeric(rownames(data3))
data4$ID <- as.numeric(rownames(data4))
data5$ID <- as.numeric(rownames(data5))


# drug data YY, merge IC50 data and only keep record with no missing values for all 5 drugs
idx2 <- c("ID", "Y")
YY <- data1[,idx2]
YY <- merge(YY, data2[,idx2],by="ID", all=F)
YY <- merge(YY, data3[,idx2],by="ID", all=F)
YY <- merge(YY, data4[,idx2],by="ID", all=F)
YY <- merge(YY, data5[,idx2],by="ID", all=F)
colnames(YY)[-1] <- c("ABC", "3TC", "AZT", "D4T", "DDI")
YY <- YY[order(YY$ID),]

# genetic mutation data XX
# index of common mutations passed QC from all 5 drugs
idx1 <- Reduce(intersect, list(colnames(data1),colnames(data2),
			   colnames(data3),colnames(data4),colnames(data5)))[-1]
XX <- merge(data.frame(ID=YY$ID), data1[,idx1], by="ID", all=F)
XX <- XX[order(YY$ID),]
#colnames(XX) <- gsub("X.", "", colnames(XX))

rownames(XX) <- rownames(YY) <- XX$ID
XX$ID <- YY$ID <- NULL
XX <- as.matrix(XX)
YY <- as.matrix(YY)

save(XX, YY, file="HIV.expert.rda")

