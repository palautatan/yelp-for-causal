library(readr)
library(dplyr)


las_vegas <- read_csv("../../data/las-vegas-yelp.csv")[,-1]


las_vegas <- las_vegas %>% mutate(star_intervention=ifelse(stars>=3.5, 1, 0))
las_vegas <- las_vegas %>% mutate(age_binary=age>median(age),
                                  review_binary=review_count>median(review_count))

# names(las_vegas)
Y          <- las_vegas %>% select(open_2019) %>% pull()
predictors <- las_vegas %>% select(star_intervention, age_binary, review_binary, chain, american)



## TMLE.
library(SuperLearner)
SL.library<- c("SL.glm", "SL.step", "SL.gam")

X <- X1 <- X0 <- predictors
X1$star_intervention <- 1
X0$star_intervention <- 0 

QbarSL <- SuperLearner(Y=Y, 
                       X=X, 
                       SL.library=SL.library,
                       family="binomial")


QbarAW <- predict(QbarSL, newdata=X)$pred
Qbar1W <- predict(QbarSL, newdata=X1)$pred
Qbar0W <- predict(QbarSL, newdata=X0)$pred

# Simple sub
PsiHat.SS<-mean(Qbar1W - Qbar0W)
PsiHat.SS


gHatSL<- SuperLearner(Y=las_vegas$star_intervention, X=X %>% select(-star_intervention, -business_id, -neighborhood, -name, -address, -postal_code, -stars, -categories, -open_2019)),
SL.library=SL.library, family="binomial")
