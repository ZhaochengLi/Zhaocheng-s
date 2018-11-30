### Name: Zhaocheng Li
### ID: V00832770
### Instructor: Xuekui Zhang
### CSC454 | Fall-2018 | UVIC

########### Set working directory #############
getwd()
setwd("/Users/lizhaocheng/Desktop/Zhaocheng-s/STAT454/ass/ass2/")

########### load libraries, helper function and required dataset ##############
library(caret)
library(glmnet)
library(MASS) #lda use
library(class) #KNN use
library(rpart) # classification tree
source("HelperFunctions.R")

########### Data Process #############
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
rownames(XX) <- rownames(YY) <- XX$ID
XX$ID <- YY$ID <- NULL
XX <- as.matrix(XX)
YY <- as.matrix(YY)
#save
save(XX, YY, file="HIV.comp.rda")

colnames(XX)=paste0("x",1:ncol(XX))
dat=data.frame(yy=YY, XX)
dat=as.matrix(dat)
#View(dat)

# missclassification rate table 8x20
Matrix = matrix(nrow=8, ncol=20)

#re-order the matrix
reorder=function(mat){
  mat=data.frame(mat)
  mat$ID <- as.numeric(rownames(mat))
  mat=mat[order(mat$ID),]
  mat$ID=NULL
  mat=as.matrix(mat)
}
# cutoff function
cutoff=function(mat,t=0){
  for(ii in 1:5){
    if(ii==1){t=2}
    else if(ii==2 | ii==3){t=3}
    else if(ii==4 | ii==5){t=1.5}
    mat[,ii]=cut(10^(mat[,ii]),c(0,t,Inf))
  }
  for (ii in 1:5){
    for (jj in 1:nrow(mat)){
      if (mat[jj,ii]==1){mat[jj,ii]=0}
      else if (mat[jj,ii]==2){mat[jj,ii]=1}
    }
  }
  return(mat)
}
##############################################
#### FIRST FOUR MODELS, USE CUT OFF FIRST ####
##############################################
dat1=dat

# Classification: CUTOFF
dat1=cutoff(dat1)

# 5-FOLD CV & SETUP
for(pp in 1:20){
  set.seed(pp)

  dat1=data.frame(dat1)
  nfold=5
  idx.cv=createFolds(dat1$yy.ABC, k=nfold, list=F)
  dim(dat1)
  for(ii in 1:nfold){
    # make train data for ii-th fold
    y.train <- dat1[idx.cv!=ii, c(1:5)]
    x.train= as.matrix(dat1[idx.cv!=ii, c(6:233)])
    y.test = dat1[idx.cv==ii, c(1:5)]
    x.test = as.matrix(dat1[idx.cv==ii, c(6:233)])

    # Logistic Regression
    for (kk in 1:ncol(y.train)){
      tmp1 = data.frame(yy=y.train[,kk], x.train)
      tmp2 = data.frame(yy=y.test[,kk], x.test)
      glm.fit = glm(yy~., data=tmp1,family=binomial)
    
      glm.pro=predict(glm.fit,tmp2,type="response")
      glm.pred=rep(0,nrow(y.test))
      glm.pred[glm.pro>.5]=1
      if(ii==1 & kk==1){glm.table=table(glm.pred,y.test[,kk])}
      else{glm.table=glm.table+table(glm.pred,y.test[,kk])}
    }
    # LDA
    for (kk in 1:ncol(y.train)){
      tmp1 = data.frame(yy=y.train[,kk], x.train)
      tmp2 = data.frame(yy=y.test[,kk], x.test)
      lda.fit=lda(yy~.,data=tmp1)
    
      lda.pred=predict(lda.fit,tmp2)
      if(ii==1 & kk==1){lda.table=table(lda.pred$class,y.test[,kk])}
      else{lda.table=lda.table+table(lda.pred$class,y.test[,kk])}
    }
    # KNN
    for(kk in 1:ncol(y.train)){
      tmp1 = data.frame(yy=y.train[,kk], x.train)
      tmp2 = data.frame(yy=y.test[,kk], x.test)
      knn.pred=knn(x.train,x.test,y.train[,kk],k=1)
      if(ii==1 & kk==1){knn.table=table(knn.pred,y.test[,kk])}
      else{knn.table=knn.table+table(knn.pred,y.test[,kk])}
    }
    # classification tree
    for(kk in 1:ncol(y.train)){
      tmp1 = data.frame(yy=y.train[,kk], x.train)
      tmp2 = data.frame(yy=y.test[,kk], x.test)
      # grow the tree
      cfit=rpart(yy~.,method="class", data=tmp1)
      cpred=predict(cfit,tmp2,type="class")
      if(ii==1 & kk==1){c.table=table(cpred,y.test[,kk])}
      else{c.table=c.table+table(cpred,y.test[,kk])}
    }
  }
  # log. reg. confusion table
  glm.table
  # miss classification rate
  #(t[1,1]+t[2,2])/sum(t)
  Matrix[1,pp]=(glm.table[1,2]+glm.table[2,1])/sum(glm.table)
  # LDA
  lda.table
  Matrix[2,pp]=(lda.table[1,2]+lda.table[2,1])/sum(lda.table)
  # KNN
  knn.table
  Matrix[3,pp]=(knn.table[1,2]+knn.table[2,1])/sum(knn.table)
  # Classification Tree
  c.table
  Matrix[4,pp]=(c.table[1,2]+c.table[2,1])/sum(c.table)
}

##########################################################
#### REST THREE MODELS, USE CONTINUOUS VARIABLE FIRST ####
##########################################################
dat2=dat
# 5-FOLD CV & SETUP
for(pp in 1:20){
  set.seed(pp)

  dat2=data.frame(dat2)
  nfold=5
  idx.cv=createFolds(dat2$yy.ABC, k=nfold, list=F)
  for(ii in 1:nfold){
    # make train data for ii-th fold
    y.train = dat2[idx.cv!=ii, c(1:5)]
    x.train = as.matrix(dat2[idx.cv!=ii, c(6:233)])
    y.test = dat2[idx.cv==ii, c(1:5)]
    x.test = as.matrix(dat2[idx.cv==ii, c(6:233)])
  
    # Linear Regression
    for(kk in 1:ncol(y.train)){
      x.test=data.frame(x.test)
      tmp1 = data.frame(yy=y.train[,kk], x.train)
      tmp2 = data.frame(yy=y.test[,kk], x.test)
      lm.fit = lm(yy~., data=tmp1)
      if(kk==1){lm.pred=predict(lm.fit,x.test)}
      else if(kk!=1){lm.pred=cbind(lm.pred,predict(lm.fit,x.test))}
    }
    if(ii==1){lm.table=lm.pred}
    else if(ii!=1){lm.table=rbind(lm.table,lm.pred)}
  
    # regression tree
    for(kk in 1:ncol(y.train)){
      x.test=data.frame(x.test)
      tmp1 = data.frame(yy=y.train[,kk], x.train)
      tmp2 = data.frame(yy=y.test[,kk], x.test)
      rfit=rpart(yy~.,data=tmp1)
      if(kk==1){rpred=predict(rfit,tmp2)}
      else if(kk!=1){rpred=cbind(rpred,predict(rfit,tmp2))}
    }
    if(ii==1){reg.table=rpred}
    else if(ii!=1){reg.table=rbind(reg.table,rpred)}
  }

  # Regression Tree
  reg.table=reorder(reg.table)
  # Linear Model
  lm.table=reorder(lm.table)
  # Classification: CUTOFF
  reg.table=cutoff(reg.table)
  lm.table=cutoff(lm.table)
  # real table for comparison
  true_table=cutoff(as.matrix(dat2[c(1:5)]))
  # LINEAR REGRESSION
  lm.table=table(lm.table,true_table)
  Matrix[5,pp]=(lm.table[1,2]+lm.table[2,1])/sum(lm.table)
  # REGRESSION TREE
  reg.table=table(reg.table,true_table)
  Matrix[6,pp]=(reg.table[1,2]+reg.table[2,1])/sum(reg.table)
}

# given the fact that the glmnet functions will take significant time to run, I put them here especially.
#############################################################
#### penalized linear regression functions, CUTOFF FIRST ####
#############################################################
dat1=dat
# Classification: CUTOFF
dat1=cutoff(dat1)
# 5-FOLD CV & SETUP
for(pp in 1:20){
  set.seed(pp)
  
  dat1=data.frame(dat1)
  nfold=5
  idx.cv=createFolds(dat1$yy.ABC, k=nfold, list=F)
  dim(dat1)
  for(ii in 1:nfold){
    # make train data for ii-th fold
    y.train <- dat1[idx.cv!=ii, c(1:5)]
    x.train= as.matrix(dat1[idx.cv!=ii, c(6:233)])
    y.test = dat1[idx.cv==ii, c(1:5)]
    x.test = as.matrix(dat1[idx.cv==ii, c(6:233)])
    # penalized linear regression
    for (kk in 1:ncol(y.train)){
      #lasso
      la.fit = cv.glmnet(x.train,y.train[,kk],family="binomial",alpha=1)
      la.pred = predict(la.fit,x.test,s="lambda.1se",type="class")
      if(ii==1 & kk==1){la.table=table(la.pred,y.test[,kk])}
      else{la.table=la.table+table(la.pred,y.test[,kk])}
      #ridge
      ri.fit = cv.glmnet(x.train,y.train[,kk],family="binomial",alpha=0)
      ri.pred = predict(ri.fit,x.test,s="lambda.1se",type="class")
      if(ii==1 & kk==1){ri.table=table(ri.pred,y.test[,kk])}
      else{ri.table=ri.table+table(ri.pred,y.test[,kk])}
      # elastic net 0.1
      e1.fit = cv.glmnet(x.train,y.train[,kk],family="binomial",alpha=0.1)
      e1.pred = predict(e1.fit,x.test,s="lambda.1se",type="class")
      if(ii==1 & kk==1){e1.table=table(e1.pred,y.test[,kk])}
      else{e1.table=e1.table+table(e1.pred,y.test[,kk])}
      # elastic net 0.2
      e2.fit = cv.glmnet(x.train,y.train[,kk],family="binomial",alpha=0.2)
      e2.pred = predict(e2.fit,x.test,s="lambda.1se",type="class")
      if(ii==1 & kk==1){e2.table=table(e2.pred,y.test[,kk])}
      else{e2.table=e2.table+table(e2.pred,y.test[,kk])}
      # elastic net 0.3
      e3.fit = cv.glmnet(x.train,y.train[,kk],family="binomial",alpha=0.3)
      e3.pred = predict(e3.fit,x.test,s="lambda.1se",type="class")
      if(ii==1 & kk==1){e3.table=table(e3.pred,y.test[,kk])}
      else{e3.table=e3.table+table(e3.pred,y.test[,kk])}
      # elastic net 0.4
      e4.fit = cv.glmnet(x.train,y.train[,kk],family="binomial",alpha=0.4)
      e4.pred = predict(e4.fit,x.test,s="lambda.1se",type="class")
      if(ii==1 & kk==1){e4.table=table(e4.pred,y.test[,kk])}
      else{e4.table=e4.table+table(e4.pred,y.test[,kk])}
      # elastic net 0.5
      e5.fit = cv.glmnet(x.train,y.train[,kk],family="binomial",alpha=0.5)
      e5.pred = predict(e5.fit,x.test,s="lambda.1se",type="class")
      if(ii==1 & kk==1){e5.table=table(e5.pred,y.test[,kk])}
      else{e5.table=e5.table+table(e5.pred,y.test[,kk])}
      # elastic net 0.6
      e6.fit = cv.glmnet(x.train,y.train[,kk],family="binomial",alpha=0.6)
      e6.pred = predict(e6.fit,x.test,s="lambda.1se",type="class")
      if(ii==1 & kk==1){e6.table=table(e6.pred,y.test[,kk])}
      else{e6.table=e6.table+table(e6.pred,y.test[,kk])}
      # elastic net 0.7
      e7.fit = cv.glmnet(x.train,y.train[,kk],family="binomial",alpha=0.7)
      e7.pred = predict(e7.fit,x.test,s="lambda.1se",type="class")
      if(ii==1 & kk==1){e7.table=table(e7.pred,y.test[,kk])}
      else{e7.table=e7.table+table(e7.pred,y.test[,kk])}
      # elastic net 0.8
      e8.fit = cv.glmnet(x.train,y.train[,kk],family="binomial",alpha=0.8)
      e8.pred = predict(e8.fit,x.test,s="lambda.1se",type="class")
      if(ii==1 & kk==1){e8.table=table(e8.pred,y.test[,kk])}
      else{e8.table=e8.table+table(e8.pred,y.test[,kk])}
      # elastic net 0.9
      e9.fit = cv.glmnet(x.train,y.train[,kk],family="binomial",alpha=0.9)
      e9.pred = predict(e9.fit,x.test,s="lambda.1se",type="class")
      if(ii==1 & kk==1){e9.table=table(e9.pred,y.test[,kk])}
      else{e9.table=e9.table+table(e9.pred,y.test[,kk])}
    }
  }
  mat=matrix(nrow=1,ncol=11)
  # lasso
  #la.table
  mat[1,1]=(la.table[1,2]+la.table[2,1])/sum(la.table)
  # ridge
  mat[1,2]=(ri.table[1,2]+ri.table[2,1])/sum(ri.table)
  # ela 0.1 -- ela 0.9
  mat[1,3]=(e1.table[1,2]+e1.table[2,1])/sum(e1.table)
  mat[1,4]=(e2.table[1,2]+e2.table[2,1])/sum(e2.table)
  mat[1,5]=(e3.table[1,2]+e3.table[2,1])/sum(e3.table)
  mat[1,6]=(e4.table[1,2]+e4.table[2,1])/sum(e4.table)
  mat[1,7]=(e5.table[1,2]+e5.table[2,1])/sum(e5.table)
  mat[1,8]=(e6.table[1,2]+e6.table[2,1])/sum(e6.table)
  mat[1,9]=(e7.table[1,2]+e7.table[2,1])/sum(e7.table)
  mat[1,10]=(e8.table[1,2]+e8.table[2,1])/sum(e8.table)
  mat[1,11]=(e9.table[1,2]+e9.table[2,1])/sum(e9.table)
  Matrix[7,pp]=mat[1,which.min(mat)]
}
  
#################################################################
#### penalized linear regression functions, CONT. VAR. FIRST ####
#################################################################
dat2=dat
# 5-FOLD CV & SETUP
for(pp in 1:20){
  set.seed(pp)
  dat2=data.frame(dat2)
  nfold=5
  idx.cv=createFolds(dat2$yy.ABC, k=nfold, list=F)
  for(ii in 1:nfold){
    y.train = dat2[idx.cv!=ii, c(1:5)]
    x.train = as.matrix(dat2[idx.cv!=ii, c(6:233)])
    y.test = dat2[idx.cv==ii, c(1:5)]
    x.test = as.matrix(dat2[idx.cv==ii, c(6:233)])
    
    for(kk in 1:ncol(y.train)){
      la.fit = cv.glmnet(x.train,y.train[,kk],alpha=1)
      if(kk==1){la.pred = predict(la.fit,x.test,s="lambda.1se")}
      else if(kk!=1){la.pred=cbind(la.pred,predict(la.fit,x.test))}
      
      ri.fit = cv.glmnet(x.train,y.train[,kk],alpha=0)
      if(kk==1){ri.pred = predict(ri.fit,x.test,s="lambda.1se")}
      else if(kk!=1){ri.pred=cbind(ri.pred,predict(ri.fit,x.test))}
      
      e1.fit = cv.glmnet(x.train,y.train[,kk],alpha=0.1)
      if(kk==1){e1.pred = predict(e1.fit,x.test,s="lambda.1se")}
      else if(kk!=1){e1.pred=cbind(e1.pred,predict(e1.fit,x.test))}
      
      e2.fit = cv.glmnet(x.train,y.train[,kk],alpha=0.2)
      if(kk==1){e2.pred = predict(e2.fit,x.test,s="lambda.1se")}
      else if(kk!=1){e2.pred=cbind(e2.pred,predict(e2.fit,x.test))}
      
      e3.fit = cv.glmnet(x.train,y.train[,kk],alpha=0.3)
      if(kk==1){e3.pred = predict(e3.fit,x.test,s="lambda.1se")}
      else if(kk!=1){e3.pred=cbind(e3.pred,predict(e3.fit,x.test))}
      
      e4.fit = cv.glmnet(x.train,y.train[,kk],alpha=0.4)
      if(kk==1){e4.pred = predict(e4.fit,x.test,s="lambda.1se")}
      else if(kk!=1){e4.pred=cbind(e4.pred,predict(e4.fit,x.test))}
      
      e5.fit = cv.glmnet(x.train,y.train[,kk],alpha=0.5)
      if(kk==1){e5.pred = predict(e5.fit,x.test,s="lambda.1se")}
      else if(kk!=1){e5.pred=cbind(e5.pred,predict(e5.fit,x.test))}
      
      e6.fit = cv.glmnet(x.train,y.train[,kk],alpha=0.6)
      if(kk==1){e6.pred = predict(e6.fit,x.test,s="lambda.1se")}
      else if(kk!=1){e6.pred=cbind(e6.pred,predict(e6.fit,x.test))}
      
      e7.fit = cv.glmnet(x.train,y.train[,kk],alpha=0.7)
      if(kk==1){e7.pred = predict(e7.fit,x.test,s="lambda.1se")}
      else if(kk!=1){e7.pred=cbind(e7.pred,predict(e7.fit,x.test))}
      
      e8.fit = cv.glmnet(x.train,y.train[,kk],alpha=0.8)
      if(kk==1){e8.pred = predict(e8.fit,x.test,s="lambda.1se")}
      else if(kk!=1){e8.pred=cbind(e8.pred,predict(e8.fit,x.test))}
      
      e9.fit = cv.glmnet(x.train,y.train[,kk],alpha=0.9)
      if(kk==1){e9.pred = predict(e9.fit,x.test,s="lambda.1se")}
      else if(kk!=1){e9.pred=cbind(e9.pred,predict(e9.fit,x.test))}
    }
    if(ii==1){
      la.table=la.pred
      ri.table=ri.pred
      e1.table=e1.pred
      e2.table=e2.pred
      e3.table=e3.pred
      e4.table=e4.pred
      e5.table=e5.pred
      e6.table=e6.pred
      e7.table=e7.pred
      e8.table=e8.pred
      e9.table=e9.pred
    }
    else if(ii!=1){
      la.table=rbind(la.table,la.pred)
      ri.table=rbind(ri.table,ri.pred)
      e1.table=rbind(e1.table,e1.pred)
      e2.table=rbind(e2.table,e2.pred)
      e3.table=rbind(e3.table,e3.pred)
      e4.table=rbind(e4.table,e4.pred)
      e5.table=rbind(e5.table,e5.pred)
      e6.table=rbind(e6.table,e6.pred)
      e7.table=rbind(e7.table,e7.pred)
      e8.table=rbind(e8.table,e8.pred)
      e9.table=rbind(e9.table,e9.pred)
    }
  }
  mat=matrix(nrow=1,ncol=11)
  # lasso
  la.table=reorder(la.table)
  # ridge
  ri.table=reorder(ri.table)
  # ela 0.1 -- ela 0.9
  e1.table=reorder(e1.table)
  e2.table=reorder(e2.table)
  e3.table=reorder(e3.table)
  e4.table=reorder(e4.table)
  e5.table=reorder(e5.table)
  e6.table=reorder(e6.table)
  e7.table=reorder(e7.table)
  e8.table=reorder(e8.table)
  e9.table=reorder(e9.table)
  # Classification: CUTOFF
  la.table=cutoff(la.table)
  ri.table=cutoff(ri.table)
  e1.table=cutoff(e1.table)
  e2.table=cutoff(e2.table)
  e3.table=cutoff(e3.table)
  e4.table=cutoff(e4.table)
  e5.table=cutoff(e5.table)
  e6.table=cutoff(e6.table)
  e7.table=cutoff(e7.table)
  e8.table=cutoff(e8.table)
  e9.table=cutoff(e9.table)
  # real table for comparison
  true_table=cutoff(as.matrix(dat2[c(1:5)]))
  # miss classification table
  la.table=table(la.table,true_table)
  ri.table=table(ri.table,true_table)
  e1.table=table(e1.table,true_table)
  e2.table=table(e2.table,true_table)
  e3.table=table(e3.table,true_table)
  e4.table=table(e4.table,true_table)
  e5.table=table(e5.table,true_table)
  e6.table=table(e6.table,true_table)
  e7.table=table(e7.table,true_table)
  e8.table=table(e8.table,true_table)
  e9.table=table(e9.table,true_table)
  # lasso miss classification rate
  mat[1,1]=(la.table[1,2]+la.table[2,1])/sum(la.table)
  mat[1,2]=(ri.table[1,2]+ri.table[2,1])/sum(ri.table)
  mat[1,3]=(e1.table[1,2]+e1.table[2,1])/sum(e1.table)
  mat[1,4]=(e2.table[1,2]+e2.table[2,1])/sum(e2.table)
  mat[1,5]=(e3.table[1,2]+e3.table[2,1])/sum(e3.table)
  mat[1,6]=(e4.table[1,2]+e4.table[2,1])/sum(e4.table)
  mat[1,7]=(e5.table[1,2]+e5.table[2,1])/sum(e5.table)
  mat[1,8]=(e6.table[1,2]+e6.table[2,1])/sum(e6.table)
  mat[1,9]=(e7.table[1,2]+e7.table[2,1])/sum(e7.table)
  mat[1,10]=(e8.table[1,2]+e8.table[2,1])/sum(e8.table)
  mat[1,11]=(e9.table[1,2]+e9.table[2,1])/sum(e9.table)
  # Save the best performance
  Matrix[8,pp]=mat[1,which.min(mat)]
}

################################
### Visualizating the result ###
################################
tran=t(Matrix)
boxplot(tran,main="Different boxplots for each model",xlab="Model types",ylab="Miss Classification Rate",names=c("glm.","LDA","KNN","C.Tree","lm.","R.Tree","glmnet(disc. first)","glmnet(cont. first)"),col="orange",border="brown")
save.image(file="a2-boxplot.rda")

