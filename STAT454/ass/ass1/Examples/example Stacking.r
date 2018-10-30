
#################
#Fit stacking model
#################
## Input: 
#		xmat, ymat: data matrix of predictors and outcomes
#		method1, method2: method used in 1st and 2nd stage of stacking
#		CV: indicator of whether or not use cross validation improved stacking
#		alpha1, alpha2: alpha values for elastic net, should be between 0 and 1.
#					  	ignored for other methods
## Output:
#		coef.step1, coef.step2 : coefficients for two stage fitted models, 
# 		method1, method2: same as input
#		model1, model2: fitted model of 1st and 2nd stage. 
#						It is useful for prediction of tree-based models.
#################
stacking <- function(xmat, ymat, CV=F,
					 method1=c("lm","LASSO","Ridge","ElasticNet"), alpha1=NULL,
					 method2=c("none","lm","LASSO","Ridge","ElasticNet"), alpha2=NULL)
{
	mtd1 <- match.arg(method1)
	mtd2 <- match.arg(method2)
	
	if (mtd1=="LASSO") alpha1=1 
	if (mtd2=="LASSO") alpha2=1 
	if (mtd1=="Ridge") alpha1=0
	if (mtd2=="Ridge") alpha2=0
	if (mtd1=="ElasticNet") 
	{
		if(is.null(alpha1)) stop("need alpha value for ElasticNet")
		if((alpha1<0) | (alpha1>1)) stop("ElasticNet need alpha between 0 and 1")
	}
	if (mtd2=="ElasticNet") 
	{
		if(is.null(alpha2)) stop("need alpha value for ElasticNet")
		if((alpha2<0) | (alpha2>1)) stop("ElasticNet need alpha between 0 and 1")
	}

	ny <- ncol(ymat)
	np <- ncol(xmat)
	nn <- nrow(xmat)
	if(nrow(ymat)!=nn) stop("Sample size of predictors and outcomes are not match!")	
	
	if(CV & (mtd2=="none")) stop("cv improved stacking need to specify stage 2")
	if(CV & (mtd2!="none")) fit1 <- cv.multiFit(xmat=xmat, ymat=ymat, alpha=alpha1, method=mtd1)
	fit1 <- multiFit(xmat=xmat, ymat=ymat, alpha=alpha1, method=mtd1)
	model1 <- fit1$model
	y.step1 <- fit1$y.fitted
	coef.step1 <- fit1$coef.mat

	if(mtd2=="none")
	{
		y.step2 <- y.step1
		coef.step2 <- NA
		model2 <- NA
	}else
	{
		fit2 <- multiFit(xmat=y.step1, ymat=ymat, alpha=alpha2, method=mtd2)
		model2 <- fit2$model
		# y.step2 <- fit2$y.fitted
		coef.step2 <- fit2$coef.mat		
	}
	return(list(coef.step1=coef.step1, coef.step2=coef.step2, 
				model1=model1, method1=method1,
				model2=model2, method2=method2))
}


#################
#Fit single model, called twice by stacking function
#################
## Input: 
#		xmat, ymat: data matrix of predictors and outcomes
#		method: method used to fit model
#		alpha: alpha value for elastic net, should be between 0 and 1. 
#			   ignored for other methods
## Output:
#		y.fitted: fitted values 
# 		coef.mat: coefficient matrix of fitted regression models
#		model: fitted model. It is useful for fittediction of tree-based models.
#################
multiFit <- function(xmat, ymat, alpha=NULL, method=c("lm","LASSO","Ridge","ElasticNet"))
{


	return(list(y.fitted=y.fitted, coef.mat=coef.mat, model=model0))
}

#################
#Fit single model with cross validation, called twice by stacking function
#################
## Input: 
#		 nfold: the number of folds used in cross validation
#		 idx.cv: index of fold, if values not given (default), randomly sample it  
#		 others: same as in function "stacking"
## Output:
#		y.fitted: cv predicted values 
# 		coef.mat: average coefficient matrix from all fold (equivalent to average final predictions)
#		model: a list of fitted model in all fold. It is useful for fittediction of tree-based models.
#################
cv.multiFit <- function(nfold=5, idx.cv=NULL, xmat, ymat, alpha=NULL, method=c("lm","LASSO","Ridge","ElasticNet"))
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



