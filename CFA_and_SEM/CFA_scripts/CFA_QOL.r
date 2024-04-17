library(lavaan)
library(readxl)
library(semPlot)

################################################################################

DATA_FILE_NAME <- "processed_responses.xlsx"

# Get the current working directory
current_dir <- file.path(getwd(), "..")

# access the data file and read it. 
data_file <- file.path(current_dir, "..", 'data', DATA_FILE_NAME)

respondents_data <- read_excel(data_file)

################################################################################
# y3 + y9 func
# y12 comp
# y1 and y8 are in func instead of pos

QOL.model <- 	'  
          functioning =~ y10 + y1 +  y4 + y5 + y6 + y8 +  y11 + y13 + y14
			    competence =~  y16 + y2 + y15 + y17 + y18
			    positive_feeling =~ y21 + y7  + y19 + y20  +  y22
			    qol =~ functioning + competence + positive_feeling
				'
QOL.fit <- cfa(QOL.model, data = respondents_data)
summary(QOL.fit, standardized = TRUE, fit.measures = TRUE)

################################################################################
# y3 + y9 func
# y12 comp
# y1 in func instead of pos
## y1 in pos as original
QOL.model <- 	'  
          functioning =~ y10 +  y4 + y5 + y6 + y8 +  y11 + y13 + y14
			    competence =~  y16 + y2 + y15 + y17 + y18
			    positive_feeling =~ y21 + y7  + y19 + y20  +  y22 + y1
			    qol =~ functioning + competence + positive_feeling
				'
QOL.fit <- cfa(QOL.model, data = respondents_data)
summary(QOL.fit, standardized = TRUE, fit.measures = TRUE)

################################################################################
# y3 + y9 func
# y12 comp
## y1 and y8 in pos as original ## NOT LEGIT - negative lv. 
QOL.model <- 	'  
          functioning =~ y10 +  y4 + y5 + y6 +  y11 + y13 + y14
			    competence =~  y16 + y2 + y15 + y17 + y18
			    positive_feeling =~ y21 + y7  + y19 + y20  +  y22 + y1 + y8
			    qol =~ functioning + competence + positive_feeling
				'
QOL.fit <- cfa(QOL.model, data = respondents_data)
summary(QOL.fit, standardized = TRUE, fit.measures = TRUE)
alpha_qol_factor1 <- psych::alpha(respondents_data[qol1_y])
alpha_qol_factor2 <- psych::alpha(respondents_data[qol2_y])
alpha_qol_factor3 <- psych::alpha(respondents_data[qol3_y])
alpha_qol <- psych::alpha(respondents_data[c(qol1_y, qol2_y, qol3_y)])

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)


semPaths(full.fit2, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = FALSE)



################################################################################
FROM HERE DOWN ITS OLD QOL ANALYSIS INCLUDED IMPUTATION THAT IS UNDESIRED.
################################################################################

##############################################################################
# full newwwwwwwwww!!!!!!!!!! qol structure - added y3, y9, y12
# previous study: y3 y9 - functioning, y12- competence

qol.model <- 	'  
			    functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y13 + y14 + y21
			    competence =~ y2 + y12 + y15 + y16 + y17 + y18
			    positive_feeling =~ y19 + y20 + y22
			    qol =~ functioning + competence + positive_feeling
			    '


qol.fit2 <- cfa(qol.model, data = respondents_data)
summary(qol.fit2,standardized = TRUE , fit.measures = TRUE, ci=TRUE)

semPaths(qol.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)



##############################################################################
# full newwwwwwwwww!!!!!!!!!! qol structure - added y3, y9, y12
# y3 y9 - functioning, y12- functioning - due to this study

qol.model <- 	'  
			    functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y12 + y13 + y14 + y21
			    competence =~ y2 + y15 + y16 + y17 + y18
			    positive_feeling =~ y19 + y20 + y22
			    qol =~ functioning + competence + positive_feeling
			    '


qol.fit2 <- cfa(qol.model, data = respondents_data)
summary(qol.fit2,standardized = TRUE , fit.measures = TRUE, ci=TRUE)

semPaths(qol.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)

##############################################################################
# full newwwwwwwwww!!!!!!!!!! qol structure - added y3, y9, y12
# previous study: y3 y9 - functioning, y12- competence
# y7 -> positive feelings

qol.model <- 	'  
			    functioning =~ y1 + y3 + y4 + y5 + y6 + y8 + y9 + y10 + y11 + y13 + y14 + y21
			    competence =~ y2 + y12 + y15 + y16 + y17 + y18
			    positive_feeling =~ y7 + y19 + y20 + y22
			    qol =~ functioning + competence + positive_feeling
			    '


qol.fit2 <- cfa(qol.model, data = respondents_data)
summary(qol.fit2,standardized = TRUE , fit.measures = TRUE, ci=TRUE)

semPaths(qol.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)


##############################################################################
# full newwwwwwwwww!!!!!!!!!! qol structure - added y3, y9, y12
# previous study: y3 y9 y12- functioning
# y7 -> positive feelings

qol.model <- 	'  
			    functioning =~ y1 + y3 + y4 + y5 + y6 + y8 + y9 + y10 + y11 + y12 + y13 + y14 + y21
			    competence =~ y2 + y15 + y16 + y17 + y18
			    positive_feeling =~ y7 + y19 + y20 + y22
			    qol =~ functioning + competence + positive_feeling
			    '


qol.fit2 <- cfa(qol.model, data = respondents_data)
summary(qol.fit2,standardized = TRUE , fit.measures = TRUE, ci=TRUE)

semPaths(qol.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)


##############################################################################
# full newwwwwwwwww!!!!!!!!!! qol structure - added y3, y9, y12
# previous study: y3 y9 - functioning
# y7 y21-> positive feelings

qol.model <- 	'  
			    functioning =~ y1 + y3 + y4 + y5 + y6 + y8 + y9 + y10 + y11 + y13 + y14 
			    competence =~ y2 + y12 + y15 + y16 + y17 + y18
			    positive_feeling =~ y7 + y19 + y20 + y21 + y22
			    qol =~ functioning + competence + positive_feeling
			    '


qol.fit2 <- cfa(qol.model, data = respondents_data)
summary(qol.fit2,standardized = TRUE , fit.measures = TRUE, ci=TRUE)

semPaths(qol.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)

##############################################################################
# full newwwwwwwwww!!!!!!!!!! qol structure - added y3, y9, y12
# previous study: y3 y9 y12- functioning
# y7 y21-> positive feelings
# BEST from new

qol.model <- 	'  
			    functioning =~ y1+ y4 + y5 + y6 + y8  + y10 + y11  + y13 + y14 + y21#+ y3 + y9 + y12
			    competence =~ y2 + y15 + y16 + y17 + y18
			    positive_feeling =~ y7 + y19 + y20 + y22
			    qol =~ functioning + competence + positive_feeling
			    
			    y13~~y14
			    
			    			    unaware_phone =~  w2 + w3 + w4 + w5 + w6 

			    functioning ~ u7 + v3 + v2 + v3 
			    competence ~ gender + `u1_בחל"ת`
			    positive_feeling ~ gender
			    #qol ~ u9
			    '


qol.fit2 <- cfa(qol.model, data = respondents_data)

summary(qol.fit2,standardized = TRUE , fit.measures = TRUE, ci=TRUE)

semPaths(qol.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)
##############################################################################

##############################################################################
# full newwwwwwwwww!!!!!!!!!! qol structure - added y3, y9, y12
# previous study: y3 y9 y12- functioning
# y7 y21-> positive feelings
# BEST from new

qol.model <- 	'  
			    functioning =~ y1+ y4 + y5 + y6 + y8  + y10 + y11  + y13 + y14 + y21#+ y3 + y9 + y12
			    competence =~ y2 + y15 + y16 + y17 + y18
			    positive_feeling =~ y7 + y19 + y20 + y22
			    qol =~ functioning + competence + positive_feeling
			    
			    y13~~y14
			    
			    			    unaware_phone =~  w2 + w3 + w4 + w5 + w6 

			    
			    qol ~ unaware_phone
			    #qol ~ u9
			    '


qol.fit2 <- cfa(qol.model, data = respondents_data)

summary(qol.fit2,standardized = TRUE , fit.measures = TRUE, ci=TRUE)

semPaths(qol.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)
#################################################################

# previous study data!
# original setup
respondents_data <- read.csv(file.path(current_dir, "..", '2019 study', 'res_SEM.csv'))
qol.model <- 	'  
			    functioning =~  y4 + y5 + y6 + y10 + y11 + y13 + y14 + y21 + y9 + y3
			    competence =~ y2 + y15 + y16 + y17 + y18 + y12 
			    positive_feeling =~ y1  + y7 + y8 + y19 + y20 + y22
			    qol =~ functioning + competence + positive_feeling
			    '


qol.fit2 <- cfa(qol.model, data = respondents_data)
modindices(qol.fit2, sort = TRUE, maximum.number = 5)
summary(qol.fit2,standardized = TRUE , fit.measures = TRUE, ci=TRUE)
semPaths(qol.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)

