attach(mtcars)
lm.model <- lm(mpg ~ cyl + disp + hp)
summary(lm.model)
anova(lm.model)

#CI
confint(lm.model)


LR_basic <- function(Y, X, CI.level = 0.95, ){

}
