library(lavaan)

full.model2 <- 'competence =~ y2 + y12 + y13 + y14 + y15
                   functioning =~ y3 + y4 + y5 + y8 + y9 + y10 + y11 + y18
                   positive_feeling =~ y1 + y6 + y7 + y16 + y17 + y19

                   unaware =~ w1 + w2 + w3 + w4 + w5 + w6

                   y10 ~~ y11

          unaware ~ competence + functioning + positive_feeling'

full.fit2 <- cfa(full.model2,12.12.respondents_scaled_data)
summary(full.fit2,standardized = TRUE , fit.measures = TRUE)

semPaths(full.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)
