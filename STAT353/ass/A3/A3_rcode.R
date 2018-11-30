#########################
##set working directory##
#########################
getwd()
setwd("/Users/lizhaocheng/Desktop/zhaocheng-s/STAT353/ass/A3")

#####################
##Q1 (Question 4.5)##
#####################

## 1. READ DATA
data1=read.table(file="data-table-B4.prn", header=TRUE)
attach(data1)
print(data1)

## 2. DATA ANALYSIS

## fit the margin for the scatter plot
par("mar")
par(mar=c(1,1,1,1))

## plot the data
par(mfrow=c(3,3))
plot(x1,y,main="QUESTION 4.5")
plot(x2,y)
plot(x3,y)
plot(x4,y)
plot(x5,y)
plot(x6,y)
plot(x7,y)
plot(x8,y)
plot(x9,y)

# fit the model
fit1=lm(y~x1+x2+x5+x7)

# view summary
anova(fit1)
summary(fit1)

###################################
## DATA FOR QUESTION (a) and (b) ##
###################################
# 1. compute the raw (oridinary) residuals e1
e1=fit1$residuals

# 2. compute the standardized residuals d1
MSE=(summary.lm(fit1)$sigma)^2 
d1=e1/sqrt(MSE)

# 3. compute the studentized residuals r1
X=cbind(c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),x1,x2,x5,x7)
XX=t(X)%*%X
invXX=solve(XX)
H=X%*%invXX%*%t(X)  # the H matrix
diagH=diag(H)       # diagonal elements of H
r1=e1/sqrt(MSE*(1-diagH)) 

# 4. compute the PRESS residuals PRESSe
PRESSe=e1/(1-diagH)

#display all data points, residuals and diagH
Resid=cbind(y, x1, x2, x5, x7, diagH, e1, d1, r1, PRESSe)
Resid=round(Resid, digits=3)  #keeps only 3 digits after the decimal point
#for easy display
View(Resid)

## (a). construct a normal probability of the four residuals
par(mfrow=c(2,2))
qqnorm(e1,main="Normal Q-Q plot w/ ord. res. e1")   #normal probability plot
qqline(e1)
qqnorm(d1,main="Normal Q-Q plot w/ stan. res. d1")   
qqline(d1)
qqnorm(r1,main="Normal Q-Q plot w/ stud. res. r1")   
qqline(r1)
qqnorm(PRESSe,main="Normal Q-Q plot w/ PRESS res.")
qqline(PRESSe)

## (b). construct a plot of the residuals versus the fitted values
par(mfrow=c(2,2))

# for ordinary residuals e1
fit_e1=y-e1
plot(fit_e1,e1,xlab="fitted values", ylab="residuals",ylim=c(-10,10))
abline(h=0)
title("raw residual vs fitted value")
abline(h=3*sqrt(MSE), col="blue")
abline(h=-3*sqrt(MSE), col="blue")

# for standardized residuals d1
fit_d1=y-d1
plot(fit_d1,d1,xlab="fitted values", ylab="residuals",ylim=c(-10,10))
abline(h=0)
title("standardized residual vs fitted value")
abline(h=3*sqrt(MSE), col="blue")
abline(h=-3*sqrt(MSE), col="blue")

# for studentized residuals r1
fit_r1=y-r1
plot(fit_r1,r1,xlab="fitted values", ylab="residuals",ylim=c(-10,10))
abline(h=0)
title("studentized residual vs fitted value")
abline(h=3*sqrt(MSE), col="blue")
abline(h=-3*sqrt(MSE), col="blue")

# for PRESS residuals e1
fit_PRESSe=y-PRESSe
plot(fit_PRESSe,PRESSe,xlab="fitted values", ylab="residuals",ylim=c(-10,10))
abline(h=0)
title("PRESS residual vs fitted value")
abline(h=3*sqrt(MSE), col="blue")
abline(h=-3*sqrt(MSE), col="blue")

detach(data1)

#####################
##Q2 (Question 4.6)##
#####################

## 1. READ DATA
data1=read.table(file="data-prob-2-7.prn", header=TRUE)
attach(data1)
print(data1)

## 2. DATA ANALYSIS

## plot the data
par(mfrow=c(1,1))
plot(x,y,main="QUESTION 4.6")

# fit the model
fit1=lm(y~x)

# view summary
anova(fit1)
summary(fit1)

###################################
## DATA FOR QUESTION (a) and (b) ##
###################################
# 1. compute the raw (oridinary) residuals e1
e1=fit1$residuals

# 2. compute the standardized residuals d1
MSE=(summary.lm(fit1)$sigma)^2 
d1=e1/sqrt(MSE)

# 3. compute the studentized residuals r1
X=cbind(c(1),x)
XX=t(X)%*%X
invXX=solve(XX)
H=X%*%invXX%*%t(X)  # the H matrix
diagH=diag(H)       # diagonal elements of H
r1=e1/sqrt(MSE*(1-diagH)) 

# 4. compute the PRESS residuals PRESSe
PRESSe=e1/(1-diagH)

#display all data points, residuals and diagH
Resid=cbind(y, x, diagH, e1, d1, r1, PRESSe)
Resid=round(Resid, digits=3)  #keeps only 3 digits after the decimal point
#for easy display
View(Resid)

## (a). construct a normal probability of the four residuals
par(mfrow=c(2,2))
qqnorm(e1,main="Normal Q-Q plot w/ ord. res. e1")   #normal probability plot
qqline(e1)
qqnorm(d1,main="Normal Q-Q plot w/ stan. res. d1")   
qqline(d1)
qqnorm(r1,main="Normal Q-Q plot w/ stud. res. r1")   
qqline(r1)
qqnorm(PRESSe,main="Normal Q-Q plot w/ PRESS res.")
qqline(PRESSe)

## fit the margin for the scatter plot
par("mar")
par(mar=c(1,1,1,1))

## (b). construct and interpret a plot of the residuals versus the predicted response.
par(mfrow=c(2,2))

# for ordinary residuals e1
fit_e1=y-e1
plot(fit_e1,e1,xlab="fitted values", ylab="residuals",ylim=c(-10,10))
abline(h=0)
title("raw residual vs fitted value")
abline(h=3*sqrt(MSE), col="blue")
abline(h=-3*sqrt(MSE), col="blue")

# for standardized residuals d1
fit_d1=y-d1
plot(fit_d1,d1,xlab="fitted values", ylab="residuals",ylim=c(-10,10))
abline(h=0)
title("standardized residual vs fitted value")
abline(h=3*sqrt(MSE), col="blue")
abline(h=-3*sqrt(MSE), col="blue")

# for studentized residuals r1
fit_r1=y-r1
plot(fit_r1,r1,xlab="fitted values", ylab="residuals",ylim=c(-10,10))
abline(h=0)
title("studentized residual vs fitted value")
abline(h=3*sqrt(MSE), col="blue")
abline(h=-3*sqrt(MSE), col="blue")

# for PRESS residuals e1
fit_PRESSe=y-PRESSe
plot(fit_PRESSe,PRESSe,xlab="fitted values", ylab="residuals",ylim=c(-10,10))
abline(h=0)
title("PRESS residual vs fitted value")
abline(h=3*sqrt(MSE), col="blue")
abline(h=-3*sqrt(MSE), col="blue")


detach(data1)

#####################
##Q3 (Question 5.5)##
#####################

## 1. READ DATA
data1=read.table(file="data-prob-5-5.prn", header=TRUE)

## 2. Data analysis
x2=data1[,2]*data1[,2] # Data[,2] is the x column; x2=x^2
xinv=1/data1[,2]       # xinv=1/x
data1=cbind(data1,x2,xinv)
attach(data1)
print(data1)

par(mfrow=c(1,1))
plot(x,y,xlab="weeks", ylab="defects per 10,000")

## [2] Fit simple linear model and quadratic model
# Plot model residuals to check for model adequacy. 
l1=lm(y~x)
abline(l1, col="blue")
r1=l1$residuals
fitted1=y-r1

l2=lm(y~x+x2)
r2=l2$residuals
fitted2=y-r2
points(x, fitted2, col="red")

par("mar")
par(mar=c(1,1,1,1))
par(mfrow=c(2,1))
plot(fitted1,r1 ,xlab="Fitted value y-hat", ylab="Residual ei", main="Simple linear model")
abline(h=0)  # simple linear model residual plot suggests the model is not adequate

plot(fitted2,r2 ,xlab="Fitted value y-hat", ylab="Residual ei", main="Quadratic model")
abline(h=0)  # quadratic model residual plot looks okay
summary(l2)

par(mfrow=c(1,1))
qqnorm(r2)    # check the normality of error
qqline(r2)
shapiro.test(r2) # test H0 that the errors are normally distributed.
# although the test is not significant at 5%, the Q-Q plot suggests violation of the normal assumption.


# (b) fit simple linear model with a transformed regressor variable
# plot model residuals to check for model adequacy. 
par(mfrow=c(1,1))
plot(xinv,y,xlab="1/weeks", ylab="defects per 10,000")

l3=lm(y~xinv)
abline(l3)     # nice linear relation between y and transformed x.
r3=l3$residuals
fitted3=y-r3

plot(fitted3,r3 ,xlab="Fitted value y-hat", ylab="Residual ei", main="Simple linear model with regressor 1/x")
abline(h=0)  # simple linear model residual plot suggests the model is not adequate
qqnorm(r3)    # check the normality of error using Q-Q plot
qqline(r3)
shapiro.test(r3) # test the H0 that the errors are normally distributed.
# the Q-Q plot looks somewhat better than that of the quadratic model.
