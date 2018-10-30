# Chapter 4 Lab: Logistic Regression, LDA, QDA, and KNN

# The Stock Market Data
# Daily percentage returns for the S&P 500 stock index between 2001 and 2005.

########################
# EDA: Exploratory Data Analysis
########################
library(ISLR)  # data is stored in this package
names(Smarket)
dim(Smarket)
summary(Smarket)
Smarket <- Smarket[,c(1,8, 2:7,9)]
#quickly visualize pairwise relationship between varaibles
pairs(Smarket)
# a better way
library(GGally)
ggpairs(Smarket)

attach(Smarket)

#########
# Alternative plots

# Categorical vs continuous
par(mfrow=c(2,2))
for(jj in c(1,9)) for(ii in 2:8) boxplot(Smarket[,ii]~Smarket[,jj],ylab=names(Smarket)[ii], xlab=names(Smarket)[jj])

# Categorical vs Categorical 
table( Smarket[,c(9,1)] )
barplot(table( Smarket[,c(9,1)] ))

# continuous vs continuous
ii=2; jj=3
temp <- ggplot(Smarket,aes(x=Smarket[,ii],y=Smarket[,jj])) + geom_point(alpha = 0.3)
print(temp + xlab(names(Smarket)[ii])+ ylab(names(Smarket)[jj]))


#Summarize correlations between variables
cor(Smarket)
cor(Smarket[,-9])
image(cor(Smarket[,-9]),x=1:8, y=1:8,col=gray.colors(100), xaxt="n", yaxt="n", xlab=NA, ylab=NA)
axis(side=1,at=(1:8), labels=names(Smarket)[1:8])
axis(side=2,at=(1:8), labels=names(Smarket)[1:8])


###############
# Training data 2001-2004, and test data will be 2015
###############
train=(Year<2005)
Smarket.2005=Smarket[!train,]
dim(Smarket.2005)
Direction.2005=Direction[!train]


# Logistic Regression

glm.fits=glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume,data=Smarket,family=binomial,subset=train)
glm.probs=predict(glm.fits,Smarket.2005,type="response")
glm.pred=rep("Down",252)
glm.pred[glm.probs>.5]="Up"
table(glm.pred,Direction.2005)
mean(glm.pred==Direction.2005)
mean(glm.pred!=Direction.2005)
glm.fits=glm(Direction~Lag1+Lag2,data=Smarket,family=binomial,subset=train)
glm.probs=predict(glm.fits,Smarket.2005,type="response")
glm.pred=rep("Down",252)
glm.pred[glm.probs>.5]="Up"
table(glm.pred,Direction.2005)
mean(glm.pred==Direction.2005)
106/(106+76)
predict(glm.fits,newdata=data.frame(Lag1=c(1.2,1.5),Lag2=c(1.1,-0.8)),type="response")

# Linear Discriminant Analysis

library(MASS)
lda.fit=lda(Direction~Lag1+Lag2,data=Smarket,subset=train)
lda.fit
plot(lda.fit)
lda.pred=predict(lda.fit, Smarket.2005)
names(lda.pred)
lda.class=lda.pred$class
table(lda.class,Direction.2005)
mean(lda.class==Direction.2005)
sum(lda.pred$posterior[,1]>=.5)
sum(lda.pred$posterior[,1]<.5)
lda.pred$posterior[1:20,1]
lda.class[1:20]
sum(lda.pred$posterior[,1]>.9)

# Quadratic Discriminant Analysis

qda.fit=qda(Direction~Lag1+Lag2,data=Smarket,subset=train)
qda.fit
qda.class=predict(qda.fit,Smarket.2005)$class
table(qda.class,Direction.2005)
mean(qda.class==Direction.2005)

# K-Nearest Neighbors

library(class)
train.X=cbind(Lag1,Lag2)[train,]
test.X=cbind(Lag1,Lag2)[!train,]
train.Direction=Direction[train]
set.seed(1)
knn.pred=knn(train.X,test.X,train.Direction,k=1)
table(knn.pred,Direction.2005)
(83+43)/252
knn.pred=knn(train.X,test.X,train.Direction,k=3)
table(knn.pred,Direction.2005)
mean(knn.pred==Direction.2005)

detach(Smarket)
