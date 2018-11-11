library(caret)
library(glmnet)
set.seed(10, kind = "Mersenne-Twister", normal.kind = "Inversion")
################################################################
###                     LOAD DATA PART                       ###
################################################################
#Set your working directory, input and output will be directed to here by default
setwd("~/Desktop/Zhaocheng-s/STAT454/ass/ass1/Examples")

# load helper functions
source("HelperFunctions.R")
mut.TSM = mut.name(Mut="TSM.NRTI")
mut.expert = mut.name(Mut="Exp.NRTI")
mut.comp = mut.name(Mut='Comp.NRTI')

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
#save
save(XX, YY, file="HIV.expert.rda")

#################
#Fit single model, called twice by stacking function
#################
multiFit <- function(xmat, ymat, alpha=NULL, method=c("lm","lasso","ridge","elasticnet"))
{
  mtd <- match.arg(method)
  
  ny <- ncol(ymat)
  y.fitted <- matrix(NA, nrow(xmat), ny)
  coef.mat <- matrix(NA, ncol(xmat)+1, ny)
  
  if (mtd == "lm"){
    for (kk in 1:ny){
      tmp <- data.frame(yy=ymat[,kk], xmat)
      model <- lm(yy~., data=tmp)
      coef.mat[,kk] <- coef(model)
      y.fitted[,kk] <- fitted(model)
    }
  }
  if (mtd %in% c("lasso", "ridge", "elasticnet")){
    for (kk in 1:ny){
      #fit lasso model
      model <- cv.glmnet(xmat, ymat[,kk], alpha=alpha)
      coef.mat[,kk] <- as.numeric(coef(model, s="lambda.1se"))
      y.fitted[,kk] <- predict(model,xmat,s="lambda.1se")
    }
  }
  return(list(y.fitted=y.fitted, coef.mat=coef.mat, model=model))
}

##cv improved stacking
cv.multiFit <- function(nfold=5, idx.cv=NULL, xmat, ymat, 
                        alpha=NULL, method=c("lm","lasso","ridge","elasticnet"))
{
  # Use createFold function, it can generated stratified split according to outcome variable
  # you should use average of 5 drugs as parameter for this function in assignment 1
  if(is.null(idx.cv)) idx.cv <- createFolds(rowMeans(ymat), k=nfold, list=F)  
  
  # prepare results to be returned
  coefs <- array(NA, c(ncol(xmat)+1, ncol(ymat), nfold))
  y.fitted <- ymat; y.fitted[!is.na(y.fitted)] <- NA
  models <- vector("list", nfold)
  
  for(ii in 1:nfold){
    #make train and test data for ii-th fold
    y.train <- ymat[idx.cv!=ii, ]
    y.test <-  ymat[idx.cv==ii, ]
    x.train <- xmat[idx.cv!=ii, ]
    x.test <-  xmat[idx.cv==ii, ]
    
    fit1 <- multiFit(xmat=xmat, ymat=ymat, alpha=alpha, method=method)
    y.fitted[idx.cv==ii, ] <- cbind(1, x.test) %*% fit1$coef.mat
    models[[ii]] <- fit1$model
    coefs[,,ii] <- fit1$coef.mat
  }
  return(list(y.fitted=y.fitted, coef.mat=apply(coefs, c(1,2),mean), model=models))
}
  
nostacking = function(xmat, ymat, method=c("lm","lasso","ridge","elasticnet"), alpha=NULL){
  mtd=match.arg(method)
  if (mtd=="lasso") alpha=1 
  if (mtd=="ridge") alpha=0
  if (mtd=="elasticnet")
  {
    if(is.null(alpha)) stop("need alpha value for ElasticNet")
    if((alpha<0) | (alpha>1)) stop("ElasticNet need alpha between 0 and 1")
  }
  ny = ncol(ymat)
  np = ncol(xmat)
  nn = nrow(xmat)
  if(nrow(ymat)!=nn) stop("Sample size of predictors and outcomes are not match!")	
  fit1=multiFit(xmat=xmat, ymat=ymat, alpha=alpha, method=mtd)
  return(list(y.fitted=fit1$y.fitted, coef.mat=fit1$coef.mat, model=fit1$model))
}

#################
#Fit stacking model
#################
stacking <- function(xmat, ymat, CV=F,
                     method1=c("lm","lasso","ridge","elasticnet"), alpha1=NULL,
                     method2=c("none","lm","lasso","ridge","elasticnet"), alpha2=NULL)
{
  ###METHODS EVALUATION###
  mtd1 <- match.arg(method1)
  mtd2 <- match.arg(method2)
  
  if (mtd1=="lasso") alpha1=1 
  if (mtd2=="lasso") alpha2=1 
  if (mtd1=="ridge") alpha1=0
  if (mtd2=="ridge") alpha2=0
  if (mtd1=="elasticnet")
  {
    if(is.null(alpha1)) stop("need alpha value for ElasticNet")
    if((alpha1<0) | (alpha1>1)) stop("ElasticNet need alpha between 0 and 1")
  }
  if (mtd2=="elasticnet") 
  {
    if(is.null(alpha2)) stop("need alpha value for ElasticNet")
    if((alpha2<0) | (alpha2>1)) stop("ElasticNet need alpha between 0 and 1")
  }
  
  ny = ncol(ymat)
  np = ncol(xmat)
  nn = nrow(xmat)
  if(nrow(ymat)!=nn) stop("Sample size of predictors and outcomes are not match!")	
  ### CV-STACKING CV-MULTIFIT EXECUTION ###
  if(CV & (mtd2=="none")) stop("cv improved stacking need to specify stage 2")
  if(CV & (mtd2!="none")){
    fit1 = cv.multiFit(xmat=xmat, ymat=ymat, alpha=alpha1, method=mtd1)
  }
  else{
    fit1 = multiFit(xmat=xmat, ymat=ymat, alpha=alpha1, method=mtd1)
  }
  model1 = fit1$model
  # Is y.fitted returned by multifit the real value fitted using testing set?
  y.step1 = fit1$y.fitted
  coef.step1 = fit1$coef.mat
  
  if(mtd2=="none")
  {
    y.step2 <- y.step1
    coef.step2 <- NA
    model2 <- NA
  }
  else
  { 
    #View(y.step1)
    y.step1=as.matrix(y.step1)
    fit2 = multiFit(xmat=y.step1, ymat=ymat, alpha=alpha2, method=mtd2)
    model2 = fit2$model
    coef.step2 = fit2$coef.mat	
  }
  return(list(coef.step1=coef.step1, coef.step2=coef.step2, 
              model1=model1, method1=method1,
              model2=model2, method2=method2))
}
################################################################
###        10-Fold CV PART(with Stacking inside)             ###
################################################################
## 10-fold CV setting
set.seed(0)
colnames(XX)=paste0("x",1:ncol(XX))
dat=data.frame(yy=YY, XX)

nfold=10
#View(YY)
idx.cv=createFolds(dat$yy.ABC, k=nfold, list=F)
#View(idx.cv)

# external layer CV to compare lasso and linear regression
for(ii in 1:nfold){
  # make train data for ii-th fold
  y.train <- dat[idx.cv!=ii, c(1:5)]
  #View(y.train)
  #****require better job*****
  x.train= as.matrix(dat[idx.cv!=ii, c(6:26)])
  # test data
  y.test = dat[idx.cv==ii, c(1:5)]
  #View(y.test)
  x.test = as.matrix(dat[idx.cv==ii, c(6:26)])
  
  #call stacking with training set
  #cv-multifit
  ######
  cv.lm = stacking(x.train, y.train, T, "lm", NULL, "lm", NULL)
  cv.lasso = stacking(x.train, y.train, T, "lasso", 1, "lasso", 1)
  cv.ridge = stacking(x.train, y.train, T, "ridge", 0, "ridge", 0)
  cv.enet1 = stacking(x.train, y.train, T, "elasticnet", 0.1, "elasticnet", 0.1)
  cv.enet2 = stacking(x.train, y.train, T, "elasticnet", 0.2, "elasticnet", 0.2)
  cv.enet3 = stacking(x.train, y.train, T, "elasticnet", 0.3, "elasticnet", 0.3)
  cv.enet4 = stacking(x.train, y.train, T, "elasticnet", 0.4, "elasticnet", 0.4)
  cv.enet5 = stacking(x.train, y.train, T, "elasticnet", 0.5, "elasticnet", 0.5)
  cv.enet6 = stacking(x.train, y.train, T, "elasticnet", 0.6, "elasticnet", 0.6)
  cv.enet7 = stacking(x.train, y.train, T, "elasticnet", 0.7, "elasticnet", 0.7)
  cv.enet8 = stacking(x.train, y.train, T, "elasticnet", 0.8, "elasticnet", 0.8)
  cv.enet9 = stacking(x.train, y.train, T, "elasticnet", 0.9, "elasticnet", 0.9)
  ######  
  
  #call stacking with training set
  ######
  #md.lm = stacking(x.train, y.train, F, "lm", NULL, "lm", NULL)
  #md.lasso = stacking(x.train, y.train, F, "lasso", 1, "lasso", 1)
  #md.ridge = stacking(x.train, y.train, F, "ridge", 0, "ridge", 0)
  #md.enet1 = stacking(x.train, y.train, F, "elasticnet", 0.1, "elasticnet", 0.1)
  #md.enet2 = stacking(x.train, y.train, F, "elasticnet", 0.2, "elasticnet", 0.2)
  #md.enet3 = stacking(x.train, y.train, F, "elasticnet", 0.3, "elasticnet", 0.3)
  #md.enet4 = stacking(x.train, y.train, F, "elasticnet", 0.4, "elasticnet", 0.4)
  #md.enet5 = stacking(x.train, y.train, F, "elasticnet", 0.5, "elasticnet", 0.5)
  #md.enet6 = stacking(x.train, y.train, F, "elasticnet", 0.6, "elasticnet", 0.6)
  #md.enet7 = stacking(x.train, y.train, F, "elasticnet", 0.7, "elasticnet", 0.7)
  #md.enet8 = stacking(x.train, y.train, F, "elasticnet", 0.8, "elasticnet", 0.8)
  #md.enet9 = stacking(x.train, y.train, F, "elasticnet", 0.9, "elasticnet", 0.9)
  ######  
  
  #call non-stacking with training set
  #######
  #ns.lm = nostacking(x.train, y.train, "lm", NULL)
  #ns.lasso = nostacking(x.train, y.train, "lasso", 1)
  #ns.ridge = nostacking(x.train, y.train, "ridge", 0)
  #ns.enet1 = nostacking(x.train, y.train, "elasticnet", 0.1)
  #ns.enet2 = nostacking(x.train, y.train, "elasticnet", 0.2)
  #ns.enet3 = nostacking(x.train, y.train, "elasticnet", 0.3)
  #ns.enet4 = nostacking(x.train, y.train, "elasticnet", 0.4)
  #ns.enet5 = nostacking(x.train, y.train, "elasticnet", 0.5)
  #ns.enet6 = nostacking(x.train, y.train, "elasticnet", 0.6)
  #ns.enet7 = nostacking(x.train, y.train, "elasticnet", 0.7)
  #ns.enet8 = nostacking(x.train, y.train, "elasticnet", 0.8)
  #ns.enet9 = nostacking(x.train, y.train, "elasticnet", 0.9)
  #######
  
  #testing data predicted value
  #stacking cv-multifit
  #######
  #lm
  lm.cvpred1 = cbind(1,x.test) %*% cv.lm$coef.step1
  lm.cvpred2 = cbind(1,lm.cvpred1) %*% cv.lm$coef.step2
  #lasso
  la.cvpred1 = cbind(1,x.test) %*% cv.lasso$coef.step1
  la.cvpred2 = cbind(1,la.cvpred1) %*% cv.lasso$coef.step2
  #ridge
  ri.cvpred1 = cbind(1,x.test) %*% cv.ridge$coef.step1
  ri.cvpred2 = cbind(1,ri.cvpred1) %*% cv.ridge$coef.step2
  #elasticnet
  enet1.cvpred1 = cbind(1,x.test) %*% cv.enet1$coef.step1
  enet1.cvpred2 = cbind(1,enet1.cvpred1) %*% cv.enet1$coef.step2
  enet2.cvpred1 = cbind(1,x.test) %*% cv.enet2$coef.step1
  enet2.cvpred2 = cbind(1,enet2.cvpred1) %*% cv.enet2$coef.step2
  enet3.cvpred1 = cbind(1,x.test) %*% cv.enet3$coef.step1
  enet3.cvpred2 = cbind(1,enet3.cvpred1) %*% cv.enet3$coef.step2
  enet4.cvpred1 = cbind(1,x.test) %*% cv.enet4$coef.step1
  enet4.cvpred2 = cbind(1,enet4.cvpred1) %*% cv.enet4$coef.step2
  enet5.cvpred1 = cbind(1,x.test) %*% cv.enet5$coef.step1
  enet5.cvpred2 = cbind(1,enet5.cvpred1) %*% cv.enet5$coef.step2
  enet6.cvpred1 = cbind(1,x.test) %*% cv.enet6$coef.step1
  enet6.cvpred2 = cbind(1,enet6.cvpred1) %*% cv.enet6$coef.step2
  enet7.cvpred1 = cbind(1,x.test) %*% cv.enet7$coef.step1
  enet7.cvpred2 = cbind(1,enet7.cvpred1) %*% cv.enet7$coef.step2
  enet8.cvpred1 = cbind(1,x.test) %*% cv.enet8$coef.step1
  enet8.cvpred2 = cbind(1,enet8.cvpred1) %*% cv.enet8$coef.step2
  enet9.cvpred1 = cbind(1,x.test) %*% cv.enet9$coef.step1
  enet9.cvpred2 = cbind(1,enet9.cvpred1) %*% cv.enet9$coef.step2
  #######
  
  #testing data predicted value
  #stacking
  #######
  #lm
  #lm.pred1 = cbind(1,x.test) %*% md.lm$coef.step1
  #lm.pred2 = cbind(1,lm.pred1) %*% md.lm$coef.step2
  #lasso
  #la.pred1 = cbind(1,x.test) %*% md.lasso$coef.step1
  #la.pred2 = cbind(1,la.pred1) %*% md.lasso$coef.step2
  #ridge
  #ri.pred1 = cbind(1,x.test) %*% md.ridge$coef.step1
  #ri.pred2 = cbind(1,ri.pred1) %*% md.ridge$coef.step2
  #elasticnet
  #enet1.pred1 = cbind(1,x.test) %*% md.enet1$coef.step1
  #enet1.pred2 = cbind(1,enet1.pred1) %*% md.enet1$coef.step2
  #enet2.pred1 = cbind(1,x.test) %*% md.enet2$coef.step1
  #enet2.pred2 = cbind(1,enet2.pred1) %*% md.enet2$coef.step2
  #enet3.pred1 = cbind(1,x.test) %*% md.enet3$coef.step1
  #enet3.pred2 = cbind(1,enet3.pred1) %*% md.enet3$coef.step2
  #enet4.pred1 = cbind(1,x.test) %*% md.enet4$coef.step1
  #enet4.pred2 = cbind(1,enet4.pred1) %*% md.enet4$coef.step2
  #enet5.pred1 = cbind(1,x.test) %*% md.enet5$coef.step1
  #enet5.pred2 = cbind(1,enet5.pred1) %*% md.enet5$coef.step2
  #enet6.pred1 = cbind(1,x.test) %*% md.enet6$coef.step1
  #enet6.pred2 = cbind(1,enet6.pred1) %*% md.enet6$coef.step2
  #enet7.pred1 = cbind(1,x.test) %*% md.enet7$coef.step1
  #enet7.pred2 = cbind(1,enet7.pred1) %*% md.enet7$coef.step2
  #enet8.pred1 = cbind(1,x.test) %*% md.enet8$coef.step1
  #enet8.pred2 = cbind(1,enet8.pred1) %*% md.enet8$coef.step2
  #enet9.pred1 = cbind(1,x.test) %*% md.enet9$coef.step1
  #enet9.pred2 = cbind(1,enet9.pred1) %*% md.enet9$coef.step2
  #######
  
  #nostacking
  #######
  #lm.nspred = cbind(1,x.test) %*% ns.lm$coef.mat
  #la.nspred = cbind(1,x.test) %*% ns.lasso$coef.mat
  #ri.nspred = cbind(1,x.test) %*% ns.ridge$coef.mat
  #enet1.nspred = cbind(1,x.test) %*% ns.enet1$coef.mat
  #enet2.nspred = cbind(1,x.test) %*% ns.enet2$coef.mat
  #enet3.nspred = cbind(1,x.test) %*% ns.enet3$coef.mat
  #enet4.nspred = cbind(1,x.test) %*% ns.enet4$coef.mat
  #enet5.nspred = cbind(1,x.test) %*% ns.enet5$coef.mat
  #enet6.nspred = cbind(1,x.test) %*% ns.enet6$coef.mat
  #enet7.nspred = cbind(1,x.test) %*% ns.enet7$coef.mat
  #enet8.nspred = cbind(1,x.test) %*% ns.enet8$coef.mat
  #enet9.nspred = cbind(1,x.test) %*% ns.enet9$coef.mat
  ######
  
  if (ii==1){
    #Stacking cv-multifit
    #######
    cvtable.lm=lm.cvpred2
    cvtable.lasso=la.cvpred2
    cvtable.ridge=ri.cvpred2
    cvtable.enet1=enet1.cvpred2
    cvtable.enet2=enet2.cvpred2
    cvtable.enet3=enet3.cvpred2
    cvtable.enet4=enet4.cvpred2
    cvtable.enet5=enet5.cvpred2
    cvtable.enet6=enet6.cvpred2
    cvtable.enet7=enet7.cvpred2
    cvtable.enet8=enet8.cvpred2
    cvtable.enet9=enet9.cvpred2
    #######
    
    #Stacking
    #######
    #table.lm=lm.pred2
    #table.lasso=la.pred2
    #table.ridge=ri.pred2
    #table.enet1=enet1.pred2
    #table.enet2=enet2.pred2
    #table.enet3=enet3.pred2
    #table.enet4=enet4.pred2
    #table.enet5=enet5.pred2
    #table.enet6=enet6.pred2
    #table.enet7=enet7.pred2
    #table.enet8=enet8.pred2
    #table.enet9=enet9.pred2
    #######
    
    #nostacking
    #######
    #nstable.lm=lm.nspred
    #nstable.la=la.nspred
    #nstable.ri=ri.nspred
    #nstable.enet1=enet1.nspred
    #nstable.enet2=enet2.nspred
    #nstable.enet3=enet3.nspred
    #nstable.enet4=enet4.nspred
    #nstable.enet5=enet5.nspred
    #nstable.enet6=enet6.nspred
    #nstable.enet7=enet7.nspred
    #nstable.enet8=enet8.nspred
    #nstable.enet9=enet9.nspred
    ######
  }
  else{
    #Staking cv-multifit
    #######
    cvtable.lm = rbind(cvtable.lm, lm.cvpred2)
    cvtable.lasso = rbind(cvtable.lasso, la.cvpred2)
    cvtable.ridge = rbind(cvtable.ridge, ri.cvpred2)
    cvtable.enet1 = rbind(cvtable.enet1, enet1.cvpred2)
    cvtable.enet2 = rbind(cvtable.enet2, enet2.cvpred2)
    cvtable.enet3 = rbind(cvtable.enet3, enet3.cvpred2)
    cvtable.enet4 = rbind(cvtable.enet4, enet4.cvpred2)
    cvtable.enet5 = rbind(cvtable.enet5, enet5.cvpred2)
    cvtable.enet6 = rbind(cvtable.enet6, enet6.cvpred2)
    cvtable.enet7 = rbind(cvtable.enet7, enet7.cvpred2)
    cvtable.enet8 = rbind(cvtable.enet8, enet8.cvpred2)
    cvtable.enet9 = rbind(cvtable.enet9, enet9.cvpred2)
    #######
    
    #Staking
    #######
    #table.lm = rbind(table.lm, lm.pred2)
    #table.lasso = rbind(table.lasso, la.pred2)
    #table.ridge = rbind(table.ridge, ri.pred2)
    #table.enet1 = rbind(table.enet1, enet1.pred2)
    #table.enet2 = rbind(table.enet2, enet2.pred2)
    #table.enet3 = rbind(table.enet3, enet3.pred2)
    #table.enet4 = rbind(table.enet4, enet4.pred2)
    #table.enet5 = rbind(table.enet5, enet5.pred2)
    #table.enet6 = rbind(table.enet6, enet6.pred2)
    #table.enet7 = rbind(table.enet7, enet7.pred2)
    #table.enet8 = rbind(table.enet8, enet8.pred2)
    #table.enet9 = rbind(table.enet9, enet9.pred2)
    #######
    
    #nostacking
    #######
    #nstable.lm=rbind(nstable.lm, lm.nspred)
    #nstable.la=rbind(nstable.la, la.nspred)
    #nstable.ri=rbind(nstable.ri, ri.nspred)
    #nstable.enet1=rbind(nstable.enet1, enet1.nspred)
    #nstable.enet2=rbind(nstable.enet2, enet2.nspred)
    #nstable.enet3=rbind(nstable.enet3, enet3.nspred)
    #nstable.enet4=rbind(nstable.enet4, enet4.nspred)
    #nstable.enet5=rbind(nstable.enet5, enet5.nspred)
    #nstable.enet6=rbind(nstable.enet6, enet6.nspred)
    #nstable.enet7=rbind(nstable.enet7, enet7.nspred)
    #nstable.enet8=rbind(nstable.enet8, enet8.nspred)
    #nstable.enet9=rbind(nstable.enet9, enet9.nspred)
    #######
  }
}
#sorte
#stacking cv-multifit
#######
#cvtable.lm=data.frame(cvtable.lm)
#cvtable.lm$ID=as.numeric(rownames(cvtable.lm))
#cvtable.lasso=data.frame(cvtable.lasso)
#cvtable.lasso$ID=as.numeric(rownames(cvtable.lasso))
#cvtable.ridge=data.frame(cvtable.ridge)
#cvtable.ridge$ID=as.numeric(rownames(cvtable.ridge))
#cvtable.enet1=data.frame(cvtable.enet1)
#cvtable.enet1$ID=as.numeric(rownames(cvtable.enet1))
#cvtable.enet2=data.frame(cvtable.enet2)
#cvtable.enet2$ID=as.numeric(rownames(cvtable.enet2))
#cvtable.enet3=data.frame(cvtable.enet3)
#cvtable.enet3$ID=as.numeric(rownames(cvtable.enet3))
#cvtable.enet4=data.frame(cvtable.enet4)
#cvtable.enet4$ID=as.numeric(rownames(cvtable.enet4))
#cvtable.enet5=data.frame(cvtable.enet5)
#cvtable.enet5$ID=as.numeric(rownames(cvtable.enet5))
#cvtable.enet6=data.frame(cvtable.enet6)
#cvtable.enet6$ID=as.numeric(rownames(cvtable.enet6))
#cvtable.enet7=data.frame(cvtable.enet7)
#cvtable.enet7$ID=as.numeric(rownames(cvtable.enet7))
#cvtable.enet8=data.frame(cvtable.enet8)
#cvtable.enet8$ID=as.numeric(rownames(cvtable.enet8))
#cvtable.enet9=data.frame(cvtable.enet9)
#cvtable.enet9$ID=as.numeric(rownames(cvtable.enet9))
#######

#stacking
#######
#table.lm=data.frame(table.lm)
#table.lm$ID=as.numeric(rownames(table.lm))
#table.lasso=data.frame(table.lasso)
#table.lasso$ID=as.numeric(rownames(table.lasso))
#table.ridge=data.frame(table.ridge)
#table.ridge$ID=as.numeric(rownames(table.ridge))
#table.enet1=data.frame(table.enet1)
#table.enet1$ID=as.numeric(rownames(table.enet1))
#table.enet2=data.frame(table.enet2)
#table.enet2$ID=as.numeric(rownames(table.enet2))
#table.enet3=data.frame(table.enet3)
#table.enet3$ID=as.numeric(rownames(table.enet3))
#table.enet4=data.frame(table.enet4)
#table.enet4$ID=as.numeric(rownames(table.enet4))
#table.enet5=data.frame(table.enet5)
#table.enet5$ID=as.numeric(rownames(table.enet5))
#table.enet6=data.frame(table.enet6)
#table.enet6$ID=as.numeric(rownames(table.enet6))
#table.enet7=data.frame(table.enet7)
#table.enet7$ID=as.numeric(rownames(table.enet7))
#table.enet8=data.frame(table.enet8)
#table.enet8$ID=as.numeric(rownames(table.enet8))
#table.enet9=data.frame(table.enet9)
#table.enet9$ID=as.numeric(rownames(table.enet9))
#######

#nostacking
#######
nstable.lm=data.frame(nstable.lm)
nstable.lm$ID=as.numeric(rownames(nstable.lm))
nstable.la=data.frame(nstable.la)
nstable.la$ID=as.numeric(rownames(nstable.la))
nstable.ri=data.frame(nstable.ri)
nstable.ri$ID=as.numeric(rownames(nstable.ri))
nstable.enet1=data.frame(nstable.enet1)
nstable.enet1$ID=as.numeric(rownames(nstable.enet1))
nstable.enet2=data.frame(nstable.enet2)
nstable.enet2$ID=as.numeric(rownames(nstable.enet2))
nstable.enet3=data.frame(nstable.enet3)
nstable.enet3$ID=as.numeric(rownames(nstable.enet3))
nstable.enet4=data.frame(nstable.enet4)
nstable.enet4$ID=as.numeric(rownames(nstable.enet4))
nstable.enet5=data.frame(nstable.enet5)
nstable.enet5$ID=as.numeric(rownames(nstable.enet5))
nstable.enet6=data.frame(nstable.enet6)
nstable.enet6$ID=as.numeric(rownames(nstable.enet6))
nstable.enet7=data.frame(nstable.enet7)
nstable.enet7$ID=as.numeric(rownames(nstable.enet7))
nstable.enet8=data.frame(nstable.enet8)
nstable.enet8$ID=as.numeric(rownames(nstable.enet8))
nstable.enet9=data.frame(nstable.enet9)
nstable.enet9$ID=as.numeric(rownames(nstable.enet9))
#######

#stacking cv-multifit
#######
#cvtable.lm=cvtable.lm[order(cvtable.lm$ID),]
#cvtable.lasso=cvtable.lasso[order(cvtable.lasso$ID),]
#cvtable.ridge=cvtable.ridge[order(cvtable.ridge$ID),]
#cvtable.enet1=cvtable.enet1[order(cvtable.enet1$ID),]
#cvtable.enet2=cvtable.enet2[order(cvtable.enet2$ID),]
#cvtable.enet3=cvtable.enet3[order(cvtable.enet3$ID),]
#cvtable.enet4=cvtable.enet4[order(cvtable.enet4$ID),]
#cvtable.enet5=cvtable.enet5[order(cvtable.enet5$ID),]
#cvtable.enet6=cvtable.enet6[order(cvtable.enet6$ID),]
#cvtable.enet7=cvtable.enet7[order(cvtable.enet7$ID),]
#cvtable.enet8=cvtable.enet8[order(cvtable.enet8$ID),]
#cvtable.enet9=cvtable.enet9[order(cvtable.enet9$ID),]
#######

#stacking
#######
#table.lm=table.lm[order(table.lm$ID),]
#table.lasso=table.lasso[order(table.lasso$ID),]
#table.ridge=table.ridge[order(table.ridge$ID),]
#table.enet1=table.enet1[order(table.enet1$ID),]
#table.enet2=table.enet2[order(table.enet2$ID),]
#table.enet3=table.enet3[order(table.enet3$ID),]
#table.enet4=table.enet4[order(table.enet4$ID),]
#table.enet5=table.enet5[order(table.enet5$ID),]
#table.enet6=table.enet6[order(table.enet6$ID),]
#table.enet7=table.enet7[order(table.enet7$ID),]
#table.enet8=table.enet8[order(table.enet8$ID),]
#table.enet9=table.enet9[order(table.enet9$ID),]
#######

#nostacking
#######
nstable.lm=nstable.lm[order(nstable.lm$ID),]
nstable.la=nstable.la[order(nstable.la$ID),]
nstable.ri=nstable.ri[order(nstable.ri$ID),]
nstable.enet1=nstable.enet1[order(nstable.enet1$ID),]
nstable.enet2=nstable.enet2[order(nstable.enet2$ID),]
nstable.enet3=nstable.enet3[order(nstable.enet3$ID),]
nstable.enet4=nstable.enet4[order(nstable.enet4$ID),]
nstable.enet5=nstable.enet5[order(nstable.enet5$ID),]
nstable.enet6=nstable.enet6[order(nstable.enet6$ID),]
nstable.enet7=nstable.enet7[order(nstable.enet7$ID),]
mstable.enet8=nstable.enet8[order(nstable.enet8$ID),]
mstable.enet9=nstable.enet9[order(nstable.enet9$ID),]
#######

#statistic calculation
#stacking cv-multifit
#######
#cvtable.lm=data.matrix(cvtable.lm[1:5])
#cvtable.lasso=data.matrix(cvtable.lasso[1:5])
#cvtable.ridge=data.matrix(cvtable.ridge[1:5])
#cvtable.enet1=data.matrix(cvtable.enet1[1:5])
#cvtable.enet2=data.matrix(cvtable.enet2[1:5])
#cvtable.enet3=data.matrix(cvtable.enet3[1:5])
#cvtable.enet4=data.matrix(cvtable.enet4[1:5])
#cvtable.enet5=data.matrix(cvtable.enet5[1:5])
#cvtable.enet6=data.matrix(cvtable.enet6[1:5])
#cvtable.enet7=data.matrix(cvtable.enet7[1:5])
#cvtable.enet8=data.matrix(cvtable.enet8[1:5])
#cvtable.enet9=data.matrix(cvtable.enet9[1:5])
#######

#stacking
#######
#table.lm=data.matrix(table.lm[1:5])
#table.lasso=data.matrix(table.lasso[1:5])
#table.ridge=data.matrix(table.ridge[1:5])
#table.enet1=data.matrix(table.enet1[1:5])
#table.enet2=data.matrix(table.enet2[1:5])
#table.enet3=data.matrix(table.enet3[1:5])
#table.enet4=data.matrix(table.enet4[1:5])
#table.enet5=data.matrix(table.enet5[1:5])
#table.enet6=data.matrix(table.enet6[1:5])
#table.enet7=data.matrix(table.enet7[1:5])
#table.enet8=data.matrix(table.enet8[1:5])
#table.enet9=data.matrix(table.enet9[1:5])
#######

#nostacking
#######
nstable.lm=data.matrix(nstable.lm[1:5])
nstable.la=data.matrix(nstable.la[1:5])
nstable.ri=data.matrix(nstable.ri[1:5])
nstable.enet1=data.matrix(nstable.enet1[1:5])
nstable.enet2=data.matrix(nstable.enet2[1:5])
nstable.enet3=data.matrix(nstable.enet3[1:5])
nstable.enet4=data.matrix(nstable.enet4[1:5])
nstable.enet5=data.matrix(nstable.enet5[1:5])
nstable.enet6=data.matrix(nstable.enet6[1:5])
nstable.enet7=data.matrix(nstable.enet7[1:5])
nstable.enet8=data.matrix(nstable.enet8[1:5])
nstable.enet9=data.matrix(nstable.enet9[1:5])
#######

##MSE (Stacking cv-multifit)
###########
#cvmse.lm=mean((cvtable.lm-YY)^2)
#cvmse.lasso=mean((cvtable.lasso-YY)^2)
#cvmse.ridge=mean((cvtable.ridge-YY)^2)
#cvmse.enet1=mean((cvtable.enet1-YY)^2)
#cvmse.enet2=mean((cvtable.enet2-YY)^2)
#cvmse.enet3=mean((cvtable.enet3-YY)^2)
#cvmse.enet4=mean((cvtable.enet4-YY)^2)
#cvmse.enet5=mean((cvtable.enet5-YY)^2)
#cvmse.enet6=mean((cvtable.enet6-YY)^2)
#cvmse.enet7=mean((cvtable.enet7-YY)^2)
#cvmse.enet8=mean((cvtable.enet8-YY)^2)
#cvmse.enet9=mean((cvtable.enet9-YY)^2)

#View(cvmse.lm)
#View(cvmse.lasso)
#View(cvmse.ridge)
#View(cvmse.enet1)
#View(cvmse.enet2)
#View(cvmse.enet3)
#View(cvmse.enet4)
#View(cvmse.enet5)
#View(cvmse.enet6)
#View(cvmse.enet7)
#View(cvmse.enet8)
#View(cvmse.enet9)
###########

##MSE (Stacking)
###########
#mse.lm = mean((table.lm-YY)^2)
#mse.lasso=mean((table.lasso-YY)^2)
#mse.ridge=mean((table.ridge-YY)^2)
#mse.enet1=mean((table.enet1-YY)^2)
#mse.enet2=mean((table.enet2-YY)^2)
#mse.enet3=mean((table.enet3-YY)^2)
#mse.enet4=mean((table.enet4-YY)^2)
#mse.enet5=mean((table.enet5-YY)^2)
#mse.enet6=mean((table.enet6-YY)^2)
#mse.enet7=mean((table.enet7-YY)^2)
#mse.enet8=mean((table.enet8-YY)^2)
#mse.enet9=mean((table.enet9-YY)^2)

#View(mse.lm)
#View(mse.lasso)
#View(mse.ridge)
#View(mse.enet1)
#View(mse.enet2)
#View(mse.enet3)
#View(mse.enet4)
#View(mse.enet5)
#View(mse.enet6)
#View(mse.enet7)
#View(mse.enet8)
#View(mse.enet9)
###########

##MSE (notacking)
###########
nsmse.lm=mean((nstable.lm-YY)^2)
nsmse.lasso=mean((nstable.la-YY)^2)
nsmse.ridge=mean((nstable.ri-YY)^2)
nsmse.enet1=mean((nstable.enet1-YY)^2)
nsmse.enet2=mean((nstable.enet2-YY)^2)
nsmse.enet3=mean((nstable.enet3-YY)^2)
nsmse.enet4=mean((nstable.enet4-YY)^2)
nsmse.enet5=mean((nstable.enet5-YY)^2)
nsmse.enet6=mean((nstable.enet6-YY)^2)
nsmse.enet7=mean((nstable.enet7-YY)^2)
nsmse.enet8=mean((nstable.enet8-YY)^2)
nsmse.enet9=mean((nstable.enet9-YY)^2)

View(nsmse.lm)
View(nsmse.lasso)
View(nsmse.ridge)
View(nsmse.enet1)
View(nsmse.enet2)
View(nsmse.enet3)
View(nsmse.enet4)
View(nsmse.enet5)
View(nsmse.enet6)
View(nsmse.enet7)
View(nsmse.enet8)
View(nsmse.enet9)
###########

##AVE BIAS (Stacking cv-multifit)
###########
#cvbias.lm=mean(cvtable.lm-YY)
#cvbias.lasso=mean(cvtable.lasso-YY)
#cvbias.ridge=mean(cvtable.ridge-YY)
#cvbias.enet1=mean(cvtable.enet1-YY)
#cvbias.enet2=mean(cvtable.enet2-YY)
#cvbias.enet3=mean(cvtable.enet3-YY)
#cvbias.enet4=mean(cvtable.enet4-YY)
#cvbias.enet5=mean(cvtable.enet5-YY)
#cvbias.enet6=mean(cvtable.enet6-YY)
#cvbias.enet7=mean(cvtable.enet7-YY)
#cvbias.enet8=mean(cvtable.enet8-YY)
#cvbias.enet9=mean(cvtable.enet9-YY)

#View(cvbias.lm)
#View(cvbias.lasso)
#View(cvbias.ridge)
#View(cvbias.enet1)
#View(cvbias.enet2)
#View(cvbias.enet3)
#View(cvbias.enet4)
#View(cvbias.enet5)
#View(cvbias.enet6)
#View(cvbias.enet7)
#View(cvbias.enet8)
#View(cvbias.enet9)
###########

##AVE BIAS (Stacking)
###########
#bias.lm=mean(table.lm-YY)
#bias.lasso=mean(table.lasso-YY)
#bias.ridge=mean(table.ridge-YY)
#bias.enet1=mean(table.enet1-YY)
#bias.enet2=mean(table.enet2-YY)
#bias.enet3=mean(table.enet3-YY)
#bias.enet4=mean(table.enet4-YY)
#bias.enet5=mean(table.enet5-YY)
#bias.enet6=mean(table.enet6-YY)
#bias.enet7=mean(table.enet7-YY)
#bias.enet8=mean(table.enet8-YY)
#bias.enet9=mean(table.enet9-YY)

#View(bias.lm)
#View(bias.lasso)
#View(bias.ridge)
#View(bias.enet1)
#View(bias.enet2)
#View(bias.enet3)
#View(bias.enet4)
#View(bias.enet5)
#View(bias.enet6)
#View(bias.enet7)
#View(bias.enet8)
#View(bias.enet9)
###########

##AVE BIAS (notacking)
###########
nsbias.lm=mean(nstable.lm-YY)
nsbias.lasso=mean(nstable.la-YY)
nsbias.ridge=mean(nstable.ri-YY)
nsbias.enet1=mean(nstable.enet1-YY)
nsbias.enet2=mean(nstable.enet2-YY)
nsbias.enet3=mean(nstable.enet3-YY)
nsbias.enet4=mean(nstable.enet4-YY)
nsbias.enet5=mean(nstable.enet5-YY)
nsbias.enet6=mean(nstable.enet6-YY)
nsbias.enet7=mean(nstable.enet7-YY)
nsbias.enet8=mean(nstable.enet8-YY)
nsbias.enet9=mean(nstable.enet9-YY)

View(nsbias.lm)
View(nsbias.lasso)
View(nsbias.ridge)
View(nsbias.enet1)
View(nsbias.enet2)
View(nsbias.enet3)
View(nsbias.enet4)
View(nsbias.enet5)
View(nsbias.enet6)
View(nsbias.enet7)
View(nsbias.enet8)
View(nsbias.enet9)
###########

##VARIANCE (Stacking cv-multifit)
###########
#cverr.lm=cvtable.lm-YY
#cvvar.lm=mean(apply(cverr.lm,2,var))
#cverr.lasso=cvtable.lasso-YY
#cvvar.lasso=mean(apply(cverr.lasso,2,var))
#cverr.ridge=cvtable.ridge-YY
#cvvar.ridge=mean(apply(cverr.ridge,2,var))
#cverr.enet1=cvtable.enet1-YY
#cvvar.enet1=mean(apply(cverr.enet1,2,var))
#cverr.enet2=cvtable.enet2-YY
#cvvar.enet2=mean(apply(cverr.enet2,2,var))
#cverr.enet3=cvtable.enet3-YY
#cvvar.enet3=mean(apply(cverr.enet3,2,var))
#cverr.enet4=cvtable.enet4-YY
#cvvar.enet4=mean(apply(cverr.enet4,2,var))
#cverr.enet5=cvtable.enet5-YY
#cvvar.enet5=mean(apply(cverr.enet5,2,var))
#cverr.enet6=cvtable.enet6-YY
#cvvar.enet6=mean(apply(cverr.enet6,2,var))
#cverr.enet7=cvtable.enet7-YY
#cvvar.enet7=mean(apply(cverr.enet7,2,var))
#cverr.enet8=cvtable.enet8-YY
#cvvar.enet8=mean(apply(cverr.enet8,2,var))
#cverr.enet9=cvtable.enet9-YY
#cvvar.enet9=mean(apply(cverr.enet9,2,var))

#View(cvvar.lm)
#View(cvvar.lasso)
#View(cvvar.ridge)
#View(cvvar.enet1)
#View(cvvar.enet2)
#View(cvvar.enet3)
#View(cvvar.enet4)
#View(cvvar.enet5)
#View(cvvar.enet6)
#View(cvvar.enet7)
#View(cvvar.enet8)
#View(cvvar.enet9)
###########

##VARIANCE (Stacking)
###########
err.lm=table.lm-YY
var.lm=mean(apply(err.lm,2,var))
err.lasso=table.lasso-YY
var.lasso=mean(apply(err.lasso,2,var))
err.ridge=table.ridge-YY
var.ridge=mean(apply(err.ridge,2,var))
err.enet1=table.enet1-YY
var.enet1=mean(apply(err.enet1,2,var))
err.enet2=table.enet2-YY
var.enet2=mean(apply(err.enet2,2,var))
err.enet3=table.enet3-YY
var.enet3=mean(apply(err.enet3,2,var))
err.enet4=table.enet4-YY
var.enet4=mean(apply(err.enet4,2,var))
err.enet5=table.enet5-YY
var.enet5=mean(apply(err.enet5,2,var))
err.enet6=table.enet6-YY
var.enet6=mean(apply(err.enet6,2,var))
err.enet7=table.enet7-YY
var.enet7=mean(apply(err.enet7,2,var))
err.enet8=table.enet8-YY
var.enet8=mean(apply(err.enet8,2,var))
err.enet9=table.enet9-YY
var.enet9=mean(apply(err.enet9,2,var))


View(var.lm)
View(var.lasso)
View(var.ridge)
View(var.enet1)
View(var.enet2)
View(var.enet3)
View(var.enet4)
View(var.enet5)
View(var.enet6)
View(var.enet7)
View(var.enet8)
View(var.enet9)
###########

##VARIANCE (nostacking)
###########
nserr.lm=nstable.lm-YY
nsvar.lm=mean(apply(nserr.lm,2,var))
nserr.lasso=nstable.la-YY
nsvar.lasso=mean(apply(nserr.lasso,2,var))
nserr.ridge=nstable.ri-YY
nsvar.ridge=mean(apply(nserr.ridge,2,var))
nserr.enet1=nstable.enet1-YY
nsvar.enet1=mean(apply(nserr.enet1,2,var))
nserr.enet2=nstable.enet2-YY
nsvar.enet2=mean(apply(nserr.enet2,2,var))
nserr.enet3=nstable.enet3-YY
nsvar.enet3=mean(apply(nserr.enet3,2,var))
nserr.enet4=nstable.enet4-YY
nsvar.enet4=mean(apply(nserr.enet4,2,var))
nserr.enet5=nstable.enet5-YY
nsvar.enet5=mean(apply(nserr.enet5,2,var))
nserr.enet6=nstable.enet6-YY
nsvar.enet6=mean(apply(nserr.enet6,2,var))
nserr.enet7=nstable.enet7-YY
nsvar.enet7=mean(apply(nserr.enet7,2,var))
nserr.enet8=nstable.enet8-YY
nsvar.enet8=mean(apply(nserr.enet8,2,var))
nserr.enet9=nstable.enet9-YY
nsvar.enet9=mean(apply(nserr.enet9,2,var))


View(nsvar.lm)
View(nsvar.lasso)
View(nsvar.ridge)
View(nsvar.enet1)
View(nsvar.enet2)
View(nsvar.enet3)
View(nsvar.enet4)
View(nsvar.enet5)
View(nsvar.enet6)
View(nsvar.enet7)
View(nsvar.enet8)
View(nsvar.enet9)
###########
