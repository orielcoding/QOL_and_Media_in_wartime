library(lavaan)
library(readxl)
library(semPlot)

DATA_FILE_NAME <- "processed_responses.xlsx"
data_file <- file.path(current_dir, "..", 'data', DATA_FILE_NAME)
respondents_data <- read_excel(data_file)
#################################################################
SEM1.model <- 	'  
			    news_through_personal_media =~ x10 + x5 + x16
			    indirect_news_exposure =~ x15 + x11 + x13
			    immidiate_news_pushes =~ x13 + x8 + x9
			    offline_news =~ x7 + x2 + x6 
			    
			    immidiate_news_pushes ~ education

			    
'
SEM1.fit <- cfa(SEM1.model, data = respondents_data)
summary(SEM1.fit, standardized = TRUE, fit.measures = TRUE)

#################################################################

SEM2.model <- 	'  
			    functioning =~ y1+ y4 + y5 + y6 + y8  + y10 + y11  + y13 + y14 + y21
			    competence =~ y2 + y15 + y16 + y17 + y18
			    positive_feeling =~ y7 + y19 + y20 + y22
			    qol =~ functioning + competence + positive_feeling
			    
			    y13~~y14
			    
			    support =~ v2 + v3
			    
			    functioning ~ u7 + support
			    competence ~ gender
			    positive_feeling ~ gender #+ u9
			    #qol ~ `u1_סטודנט/ית`
'
SEM2.fit <- cfa(SEM2.model, data = respondents_data)
summary(SEM2.fit, standardized = TRUE, fit.measures = TRUE)

#################################################################

SEM2.model <- 	'  
			    functioning =~ y1+ y4 + y5 + y6 + y8  + y10 + y11  + y13 + y14 + y21
			    competence =~ y2 + y15 + y16 + y17 + y18
			    positive_feeling =~ y7 + y19 + y20 + y22
			    qol =~ functioning + competence + positive_feeling
			    
			    y13~~y14
			    
			    support =~ v2 + v3
			    
			    functioning ~ u7 + support + age
			    competence ~ age
			    #positive_feeling ~ gender
			    qol ~  gender
'
SEM2.fit <- cfa(SEM2.model, data = respondents_data)
summary(SEM2.fit, standardized = TRUE, fit.measures = TRUE)

#################################################################


SEM3.model <- 	'  
			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 
			    
			    resilience ~ `u1_סטודנט/ית`
'
SEM3.fit <- cfa(SEM3.model, data = respondents_data)
summary(SEM3.fit, standardized = TRUE, fit.measures = TRUE)



