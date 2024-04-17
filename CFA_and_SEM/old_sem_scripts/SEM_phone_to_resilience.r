library(lavaan)
library(readxl)
library(semPlot)

respondents_data <- read_excel("12.12.respondents_scaled_data.xlsx")

full.model2 <- 'resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10

                   unaware =~ w1 + w2 + w3 + w4 + w5 + w6

          resilience ~ unaware'

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2,standardized = TRUE , fit.measures = TRUE)

semPaths(full.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)
