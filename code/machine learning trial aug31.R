### machine learning and trees trial 
# Laura Dee aug 31

# Random Forests tutorial: http://trevorstephens.com/kaggle-titanic-tutorial/r-part-5-random-forests/
# XGBoost tutorial: https://www.analyticsvidhya.com/blog/2016/01/xgboost-algorithm-easy-steps/
  
library(xgboost)
library(readr)
library(stringr)
library(caret)
library(car)
require(data.table)

#install.packages('forestFloor')
#install.packages('party')
library(party)

library(randomForest)
library(forestFloor)
setwd("~/Dropbox/Forest ecosystem services & climate/")
for_prism_dat <- read.csv("LS_data_081016.csv")
head(for_prism_dat)
summary(for_prism_dat$AGL_BIO_MGPH)

## too many points to split, so round temperature values for now - default # of decimal places is 0.
for_prism_dat$roundPRISM_TMEAN <- round(for_prism_dat$PRISM_TMEAN, digits = 1)
for_prism_dat$roundPRISM_TMAX <- round(for_prism_dat$PRISM_TMAX)
for_prism_dat$roundPRISM_TMIN <- round(for_prism_dat$PRISM_TMIN)
for_prism_dat$roundPPT  <- round(for_prism_dat$PRISM_PPT)

for_prism_dat$roundPPT  <- round(for_prism_dat$PRISM_PPT, digit = 1)
## make a variable for temp range
for_prism_dat$tempRange <- for_prism_dat$PRISM_TMAX - for_prism_dat$PRISM_TMIN
for_prism_dat$RoundedtempRange  <- round(for_prism_dat$tempRange)

summary(for_prism_dat$roundPRISM_TMIN)
  #Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
  # -4.000  -2.000  -1.000  -0.245   1.000   5.000       1 

summary(for_prism_dat$PRISM_TMIN)
  #Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
  #-4.2600 -1.5200 -0.5500 -0.2412  0.9500  5.3300       1 
length(unique(for_prism_dat$PRISM_PPT))
#16158
length(unique(for_prism_dat$PRISM_TMIN))
# 888

### too many splits - so need to bin or round the temperature values,
# bc it needs to consider all of these 1600 values 

set.seed(415)

table(for_prism_dat$INVYR)  ## 1999-2012 (is there newer data?)
plot(for_prism_dat$INVYR, for_prism_dat$PRISM_TMEAN)

# rf <- randomForest(AGL_BIO_MGPH ~ PRISM_PPT + PRISM_TMIN,
#                     data = for_prism_dat[!is.na(for_prism_dat$AGL_BIO_MGPH),],
#                    importance = TRUE, 
#                    na.action = na.omit,
#                    ntrees = 1)
importance(rf)
varImpPlot(rf)
varImpPlot(rf, pch = 16)


rf <- randomForest(AGL_BIO_MGPH ~ STATECD + SLOPE + STDAGE + INVYR + 
                     roundPRISM_TMEAN + roundPRISM_TMAX + roundPRISM_TMIN + roundPPT + RoundedtempRange,
                     data = for_prism_dat[!is.na(for_prism_dat$AGL_BIO_MGPH),],
                     importance = TRUE, 
                     na.action = na.omit,
                     ntrees = 100)

importance(rf)
varImpPlot(rf, pch = 16, main = "AGL_BIO_MGPH predictions - trial")

partialPlot(rf, x.var = roundPPT, for_prism_dat[!is.na(for_prism_dat$AGL_BIO_MGPH),])

for_prism_dat$roundPPT <- na.omit(for_prism_dat$roundPPT)
partialPlot(rf, x.var = roundPPT, data = for_prism_dat)

?partialPlot.randomForest
# example from Trevor stephens tutorial:
# fit <- randomForest(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare +
#                       Embarked + Title + FamilySize + FamilyID2,
#                     data=train, 
#                     importance=TRUE, 
#                     ntree=2000)





# code from Grant as example:

rf<- randomForest(AGL_BIO_MGPH~., data=for_prism_dat, na.action = na.omit, type = regression, importance = T, ntree = 500)
rf
importance(rf)

# Predict FF C using the RF predict function. Note that pd.test is a vector of predicted FF C values without the random error (mu)
# included. 

pd<-predict(rf, newdata = ff.sub, type = "response")
