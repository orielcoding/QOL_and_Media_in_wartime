library(lavaan)
library(readxl)
library(semPlot)

respondents_data <- read_excel("12.12.respondents_scaled_data.xlsx")

full.model2 <- 'competence =~ y2 + y12 + y13 + y14 + y15
                   functioning =~ y3 + y4 + y5 + y8 + y9 + y10 + y11 + y18
                   positive_feeling =~ y1 + y6 + y7 + y16 + y17 + y19

                   resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10

                   y8 ~~ y9
                   y13 ~~ y14
                   y14 ~~ y15


       resilience ~ competence + functioning + positive_feeling'


full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2,standardized = TRUE , fit.measures = TRUE)

semPaths(full.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)
