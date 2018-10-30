library(caret)
library(glmnet)

## Simulate a data set 
## y = 2*x1 + x2 + normal random error
set.seed(0)
sample.size <- 100
pp <- 48 # the number of noise predictors 
x1 <- runif(sample.size)
x2 <- sample(0:1, sample.size, replace=T)
xx <- matrix(rnorm(sample.size*pp, 0,5), sample.size, pp) # useless/noise predictors 
colnames(xx) <- paste0("x", 1:pp+2)
yy <- 5*x1 + 8*x2 + 3 + rnorm(sample.size)
dat <- data.frame(yy=yy, x1=x1, x2=x2, xx)


#############
# Compare two models by 10 fold Cross validation (external layer CV)
#############

# Use createFold function, it can generated stratified split according to outcome variable
# you should use average of 5 drugs as parameter for this function in assignment 1
nfold=10
idx.cv <- createFolds(dat$yy, k=nfold, list=F)  

#The candiate penalty parameter values to be selected by CV
grid=10^seq(10,-2,length=100) 

#create vector to save predicted values
y.pred <-  matrix(NA, nrow(dat), 2)
colnames(y.pred) <- c("LASSO", "lm")

# external layer CV to compare lasso and linear regression
for(ii in 1:nfold){
	#make train and test data for ii-th fold
	y.train <- dat[idx.cv!=ii, 1]
	y.test <-  dat[idx.cv==ii, 1]
	x.train <- as.matrix(dat[idx.cv!=ii, -1])
	x.test <-  as.matrix(dat[idx.cv==ii, -1])

# 	# This part is used to fit lasso model in general, but not needed for CV goal
# 	lasso1=glmnet(x.train,y.train,alpha=1,lambda=grid)
# 	plot(lasso1) # plot coefficient trace
# 	cv1 <- cv.glmnet(x.train, y.train, alpha=1) 
#	print(coef(lasso1, s=cv1$lambda.1se))
# 	y.pred[idx.cv==ii] <- predict(lasso1, x.test, s=cv1$lambda.1se)

	# fit lasso models and select value of penalty parameter by internal layer CV 
	cv1 <- cv.glmnet(x.train, y.train, alpha=1,lambda=grid) 
	# print(coef(cv1,s="lambda.1se"))
	y.pred[idx.cv==ii,1] <- predict(cv1, x.test, s="lambda.1se")
	
	# fit lm model
	tmp0 <- data.frame(yy=y.train, x.train)
	lm1 <- lm(yy~., data=tmp0)
	y.pred[idx.cv==ii,2] <- predict(lm1, as.data.frame(x.test))
}


# summary of errors and comparison between models
errors <- y.pred-yy
apply(errors, 2, var)
apply(errors, 2, mean) 
apply(errors^2, 2, mean)
apply(abs(errors), 2, mean)
(apply(errors^2, 2, mean)-apply(errors, 2, mean)^2) * sample.size/(sample.size-1)

wilcox.test(abs(errors)[,1] - abs(errors)[,2])
wilcox.test((errors^2)[,1] - (errors^2)[,2])

par(mfrow=c(1,3),cex=1.2)
boxplot(errors, main="errors")
abline(h=0,col=2)
boxplot(abs(errors), main="|errors|")
abline(h=0,col=2)
boxplot(errors^2, main="errors^2")
abline(h=0,col=2)