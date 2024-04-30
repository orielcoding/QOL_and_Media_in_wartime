library(lavaan)
library(readxl)
library(semPlot)

DATA_FILE_NAME <- "processed_responses.xlsx"
data_file <- file.path(current_dir, "..", 'data', DATA_FILE_NAME)
respondents_data <- read_excel(data_file)
################################################################################
# candidates to drop - x9, x8
# candidates to add - 
# need to examine models which disclude parts/ parceling. 

################################################################################

CFA1.model <- 	'  
          offline_news =~ x7 + x2 + x6  # x4
			    online_news =~  x4 + x3 + x11 + x15 # x13
			    social_contact =~ x10 + x1 + x3 + x5 +  x12 + x16
			    content_consumption =~ x12 + x1 +  x13 + x14 + x8 + x9
				'

CFA1.fit <- cfa(CFA1.model, data = respondents_data)
summary(CFA1.fit, standardized = TRUE, fit.measures = TRUE)


CFA2.model <- 	'  
          offline_news =~ x7 + x2 + x6  # x4
			    online_news =~  x4 + x3 + x11 + x15 # x13
			    social_contact =~ x10 + x1 + x5 +  x12 + x16
			    content_consumption =~ x12 + x1 +  x13 + x14 + x8 + x9
				'

CFA2.fit <- cfa(CFA2.model, data = respondents_data)
summary(CFA2.fit, standardized = TRUE, fit.measures = TRUE)



CFA3.model <- 	'  
          offline_news =~ x7 + x2 + x6 + x4
			    online_news =~  x4 + x3 + x11 + x15 # x13
			    social_contact =~ x10 + x1 + x5 +  x12 + x16
			    content_consumption =~ x12 + x1 +  x13 + x14 + x8 + x9
				'

CFA3.fit <- cfa(CFA3.model, data = respondents_data)
summary(CFA3.fit, standardized = TRUE, fit.measures = TRUE)


CFA4.model <- 	'  
          offline_news =~ x7 + x2 + x6
			    online_news =~  x4 + x3 + x11 + x15 + x13
			    social_contact =~ x10 + x1 + x5 +  x12 + x16
			    content_consumption =~ x12 + x1 +  x13 + x14 + x8 + x9
				'

CFA4.fit <- cfa(CFA4.model, data = respondents_data)
summary(CFA4.fit, standardized = TRUE, fit.measures = TRUE)



CFA5.model <- 	'  
          offline_news =~ x7 + x2 + x6
			    online_news =~  x4 + x3 + x11 + x15 + x13
			    social_contact =~ x10 + x1 + x5 +  x12
			    content_consumption =~ x12 + x1 +  x13 + x14 + x8 + x9
				'

CFA5.fit <- cfa(CFA5.model, data = respondents_data)
summary(CFA5.fit, standardized = TRUE, fit.measures = TRUE)



CFA6.model <- 	'  
          offline_news =~ x7 + x2 + x6
			    online_news =~  x4 + x3 + x11 + x15 + x13
			    social_contact =~ x10 + x1 + x5 +  x12
			    content_consumption =~ x12 + x1 +  x13 + x14 + x8
				'

CFA6.fit <- cfa(CFA6.model, data = respondents_data)
summary(CFA6.fit, standardized = TRUE, fit.measures = TRUE)



CFA7.model <- 	'  
          offline_news =~ x7 + x2 + x6
			    online_news =~  x4 + x3 + x11 + x15 + x13
			    social_contact =~ x10 + x1 + x5 +  x12
			    content_consumption =~ x12 + x1 +  x13 + x14 
				'

CFA7.fit <- cfa(CFA7.model, data = respondents_data)
summary(CFA7.fit, standardized = TRUE, fit.measures = TRUE)



CFA8.model <- 	'  
          offline_news =~ x7 + x2 + x6
			    online_news =~  x4 + x3 + x11 + x15 + x13
			    news =~ offline_news + online_news
			    social_contact =~ x10 + x1 + x5 +  x12
			    content_consumption =~ x12 + x1 +  x13 + x14 
				' # negative variance

CFA8.fit <- cfa(CFA8.model, data = respondents_data)
summary(CFA8.fit, standardized = TRUE, fit.measures = TRUE)


CFA9.model <- 	'  
          offline_news =~ x7 + x2 + x6
			    online_news =~  x4 + x3 + x11 + x15 + x13
			    news =~ offline_news + online_news
			    social_contact =~ x10 + x1 + x5 +  x12
			    content_consumption =~ x12 + x1 +  x13 + x14 
			    social =~ social_contact + content_consumption
				' # solution not found

CFA9.fit <- cfa(CFA9.model, data = respondents_data)
summary(CFA9.fit, standardized = TRUE, fit.measures = TRUE)


# parceling
respondents_data$offline_news_lt <- rowMeans(respondents_data[, c("x2", "x6", "x7")])
respondents_data$online_news_lt <- rowMeans(respondents_data[, c("x3", "x4", "x11", "x13", "x15")])
respondents_data$social_contact_lt <- rowMeans(respondents_data[, c("x1", "x5", "x10", "x12")])
respondents_data$content_consumption_lt <- rowMeans(respondents_data[, c("x1", "x12", "x13", "x14")])



CFA10.model <- 	'  
			    news =~ offline_news_lt + online_news_lt
			    social =~ social_contact_lt + content_consumption_lt

				' # solution not found

CFA10.fit <- cfa(CFA10.model, data = respondents_data)
summary(CFA10.fit, standardized = TRUE, fit.measures = TRUE)


CFA11.model <- 	'  
			    offline_news_lt ~~ online_news_lt + social_contact_lt + content_consumption_lt
			    online_news_lt ~~ social_contact_lt + content_consumption_lt
			    social_contact_lt ~~ content_consumption_lt

				' # solution not found

CFA11.fit <- cfa(CFA11.model, data = respondents_data)
summary(CFA11.fit, standardized = TRUE, fit.measures = TRUE)


CFA12.model <- 	'  
          offline_news =~ x7 + x2 + x6
			    online_news =~  x4 + x11 + x15 + x13
			    social_contact =~ x10 + x1 + x5 +  x12
			    content_consumption =~ x12 + x1 +  x13 + x14 
				'

CFA12.fit <- cfa(CFA12.model, data = respondents_data)
summary(CFA12.fit, standardized = TRUE, fit.measures = TRUE)


CFA13.model <- 	'  
          offline_news =~ x4 + x7 + x2 + x6
			    online_news =~   x11 + x15 + x13
			    social_contact =~ x10 + x1 + x5 +  x12
			    content_consumption =~ x12 + x1 +  x13 + x14 
				'

CFA13.fit <- cfa(CFA13.model, data = respondents_data)
summary(CFA13.fit, standardized = TRUE, fit.measures = TRUE)


modindices(CFA12.fit, sort = TRUE)

##########################################################
# Discluding data regards online news which was relatively weak factor


CFA14.model <- 	'  
          offline_news =~ x7 + x2 + x6
			    social_contact =~ x10 + x1 + x5 +  x12
			    content_consumption =~ x12 + x1 +  x13 + x14 
				'

CFA14.fit <- cfa(CFA14.model, data = respondents_data)
summary(CFA14.fit, standardized = TRUE, fit.measures = TRUE)


CFA15.model <- 	'  
          offline_news =~ x7 + x2 + x6
			    social_contact =~ x10 + x1 + x5 +  x12
			    content_consumption =~ x12 + x1 + x14 + x8
				'

CFA15.fit <- cfa(CFA15.model, data = respondents_data)
summary(CFA15.fit, standardized = TRUE, fit.measures = TRUE)


CFA16.model <- 	'  
          offline_news =~ x7 + x2 + x6
			    social_contact =~ x10 + x1 + x5 + x12 + x16
			    content_consumption =~ x12 + x1 + x14 + x8
				'

CFA16.fit <- cfa(CFA16.model, data = respondents_data)
summary(CFA16.fit, standardized = TRUE, fit.measures = TRUE)

###################
# 30.4 addition: testing without x8 and x9 (binary items). distinguish content and news.
CFA_ordinal.model <- 	'  
          offline_news =~ x7 + x2 + x6
			    social_contact =~ x10 + x5 + x16
			    #content_consumption =~ x12 + x1 + x14
			    indirect_news_exposure =~ x15 + x11 + x3
			    #push =~ x8 + x9 + x13
				'

CFA_ordinal.fit <- cfa(CFA_ordinal.model, data = respondents_data)
summary(CFA_ordinal.fit, standardized = TRUE, fit.measures = TRUE)

####################


CFA17.model <- 	'  
			    social_contact =~ x10 + x1 + x5 + x12 + x16
			    content_consumption =~ x12 + x1 + x14
			    war_news =~ x8 + x9 + x13 + x15 + x2
				'

CFA17.fit <- cfa(CFA17.model, data = respondents_data)
summary(CFA17.fit, standardized = TRUE, fit.measures = TRUE)


CFA18.model <- 	'  
			    social_contact =~ x10 + x1 + x5 + x12 + x16
			    war_news =~ x8 + x9 + x13 + x15 + x2
				'

CFA18.fit <- cfa(CFA18.model, data = respondents_data)
summary(CFA18.fit, standardized = TRUE, fit.measures = TRUE)


###################################################################
# FOCUSING ONLY IN INFORMATION ASPECT. NOT THE PURPOSE OF THE PLATFORMS. 


CFA19.model <- 	'  
			    social_news_and_communication =~ x10 + x5 + x16
			    graphical_news =~ x8 + x9 + x13 + x2
			    less_graphical_news =~ x11 + x15 + x3 + x4
			    
				' 

CFA19.fit <- cfa(CFA19.model, data = respondents_data)
summary(CFA19.fit, standardized = TRUE, fit.measures = TRUE)


CFA20.model <- 	'  
			    social_news_and_communication =~ x10 + x5 + x16
			    graphical_news =~ x8 + x9 + x13 + x2
			    less_graphical_news =~ x11 + x15 + x3
			    
				' #### best so far acceptable 

CFA20.fit <- cfa(CFA20.model, data = respondents_data)
summary(CFA20.fit, standardized = TRUE, fit.measures = TRUE)

##############################
CFA21.model <- 	'  
			    social_news_and_communication =~ x10 + x5 + x16
			    graphical_news =~ x13 + x8 + x9 
			    less_graphical_news =~ x15 + x11 + x3
			    
				'  #### best so far!!! good model

CFA21.fit <- cfa(CFA21.model, data = respondents_data)
summary(CFA21.fit, standardized = TRUE, fit.measures = TRUE)
###############################

CFA22.model <- 	'  
          consumption =~ x12 + x1 + x14
			    social_news_and_communication =~ x10 + x5 + x16
			    graphical_news =~ x13 + x8 + x9 
			    less_graphical_news =~ x15 + x11 + x3
			    
				' # not good enough - focus need to stay on news!

CFA22.fit <- cfa(CFA22.model, data = respondents_data)
summary(CFA22.fit, standardized = TRUE, fit.measures = TRUE)


CFA23.model <- 	'  
			    news_through_personal_media =~ x10 + x5 + x16
			    immidiate_news_pushes =~ x13 + x8 + x9
			    indirect_news_exposure =~ x15 + x11 + x3  + x7
				'
CFA23.fit <- cfa(CFA23.model, data = respondents_data)
summary(CFA23.fit, standardized = TRUE, fit.measures = TRUE)


CFA23.model <- 	'  
			    news_through_personal_media =~ x10 + x5 + x16
			    indirect_news_exposure =~ x15 + x11 + x3
			    immidiate_news_pushes =~ x13 + x8 + x9
			    offline_news =~ x7 + x2 + x6 

'
CFA23.fit <- cfa(CFA23.model, data = respondents_data)
summary(CFA23.fit, standardized = TRUE, fit.measures = TRUE)
semPaths(CFA23.fit, intercepts = TRUE,edge.label.cex = 1, what = 'std',structural = FALSE)


# alon
CFA23.model <- 	'  
			    #news_through_personal_media =~ x13 + x8 + x9
			    #indirect_news_exposure =~ x15 + x11 + x3
			    immidiate_news_pushes =~ x1 + x12 + x14 + x5 + x13
			    offline_news =~ x7 + x2 + x6 

'
CFA23.fit <- cfa(CFA23.model, data = respondents_data)
summary(CFA23.fit, standardized = TRUE, fit.measures = TRUE)
semPaths(CFA23.fit, intercepts = TRUE,edge.label.cex = 1, what = 'std',structural = FALSE)


CFA23.model <- 	'  
			    news_through_personal_media =~ x10 + x5 + x16
			    indirect_news_exposure =~ x15 + x11 + x3
			    immidiate_news_pushes =~ x13 + x8 + x9
			    offline_news =~ x7 + x2 + x6 

'
CFA23.fit <- cfa(CFA23.model, data = respondents_data)
summary(CFA23.fit, standardized = TRUE, fit.measures = TRUE)
semPaths(CFA23.fit, intercepts = TRUE,edge.label.cex = 1, what = 'std',structural = FALSE)




CFA24.model <- 	'  
			    news_through_personal_media =~ x10 + x5 + x16
			    indirect_news_exposure =~ x15 + x11 + x3
			    immidiate_news_pushes =~ x13 + x8 + x9
			    offline_news =~ x7 + x2 + x6
			    entertaiment =~ x1 + x12 + x14 
			    unaware_phone =~  w1 + w2 + w3 + w4 + w5 + w6 
			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
			    
'
CFA24.fit <- cfa(CFA24.model, data = respondents_data)
summary(CFA24.fit, standardized = TRUE, fit.measures = TRUE)
semPaths(CFA24.fit, intercepts = TRUE,edge.label.cex = 1, what = 'std',structural = FALSE)

# SEM 


SEM1.model <- 	'  
			    news_through_personal_media =~ x10 + x5 + x16
			    indirect_news_exposure =~ x15 + x11 + x3
			    immidiate_news_pushes =~ x13 + x8 + x9
			    offline_news =~ x7 + x2 + x6
			    #entertaiment =~ x1 + x12 + x14
			    unaware_phone =~  w2 + w3 + w4 + w5 + w6 

			    # SEM 
			    news_through_personal_media ~ unaware_phone
			    indirect_news_exposure ~ unaware_phone
			    offline_news ~ unaware_phone

				'
SEM1.fit <- cfa(SEM1.model, data = respondents_data)
summary(SEM1.fit, standardized = TRUE, fit.measures = TRUE)


SEM2.model <- 	'  
			    news_through_personal_media =~ x10 + x5 + x16
			    indirect_news_exposure =~ x15 + x11 + x13
			    immidiate_news_pushes =~ x13 + x8 + x9
			    offline_news =~ x7 + x2 + x6
			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 

			    # SEM 
			    resilience ~ news_through_personal_media + indirect_news_exposure
				'
SEM2.fit <- cfa(SEM2.model, data = respondents_data)
summary(SEM2.fit, standardized = TRUE, fit.measures = TRUE)
modindices(SEM2.fit, sort = TRUE, maximum.number = 10)
semPaths(SEM2.fit, intercepts = TRUE,edge.label.cex = 1, what = 'std',structural = FALSE)



SEM3.model <- 	'  
			    news_through_personal_media =~ x10 + x5 + x16
			    indirect_news_exposure =~ x15 + x11 + x13
			    immidiate_news_pushes =~ x13 + x8 + x9
			    offline_news =~ x7 + x2 + x6
			    #entertaiment =~ x1 + x12 + x14
			    
			    functioning =~ y10 + y1 +  y4 + y5 + y6 + y8 +  y11 + y13 + y14 #+ y3 + y9 + y12
			    competence =~  y16 + y2 + y15 + y17 + y18
			    positive_feeling =~ y7  + y19 + y20  +  y22
			    qol =~ functioning + competence + positive_feeling

          y13~~y14
        
			    # SEM 
			    functioning ~immidiate_news_pushes
		    	competence ~ news_through_personal_media

				'
SEM3.fit <- cfa(SEM3.model, data = respondents_data)
summary(SEM3.fit, standardized = TRUE, fit.measures = TRUE)
semPaths(SEM3.fit, intercepts = TRUE,edge.label.cex = 1, what = 'std',structural = FALSE)
modindices(SEM3.fit, sort = TRUE, maximum.number = 10)

SEM3.model <- 	'  
			    news_through_personal_media =~ x10 + x5 + x16
			    indirect_news_exposure =~ x15 + x11 + x13
			    immidiate_news_pushes =~ x13 + x8 + x9
			    offline_news =~ x7 + x2 + x6
			    #entertaiment =~ x1 + x12 + x14
			    
			    functioning =~ y10 + y1 +  y4 + y5 + y6 +  y11 + y13 + y14 + y21 #+ y3 + y9 + y12
			    competence =~  y16 + y2 + y15 + y17 + y18
			    positive_feeling =~ y7 + y19 + y20  +  y22
			    qol =~ functioning + competence + positive_feeling

			    #resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 
			    

			    # SEM 
			    functioning ~ immidiate_news_pushes + news_through_personal_media
		    	competence ~ news_through_personal_media

				'
SEM3.fit <- cfa(SEM3.model, data = respondents_data)
summary(SEM3.fit, standardized = TRUE, fit.measures = TRUE)
semPaths(SEM3.fit, intercepts = TRUE,edge.label.cex = 1, what = 'std',structural = FALSE)
modindices(SEM3.fit, sort = TRUE, maximum.number = 10)

SEM4.model <- 	'  
			    news_through_personal_media =~ x10 + x5 + x16
			    indirect_news_exposure =~ x15 + x11 + x13
			    #immidiate_news_pushes =~ x13 + x8 + x9
			    offline_news =~ x7 + x2 + x6
			    #entertaiment =~ x1 + x12 + x14
			    
			    unaware_phone =~  w2 + w3 + w4 + w5 + w6 
			    
			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 


			    # SEM 
			    news_through_personal_media ~ unaware_phone
			    indirect_news_exposure ~ unaware_phone
			    offline_news ~ unaware_phone

			    resilience ~ news_through_personal_media + indirect_news_exposure

				'
SEM4.fit <- cfa(SEM4.model, data = respondents_data)
summary(SEM4.fit, standardized = TRUE, fit.measures = TRUE)
semPaths(SEM4.fit, intercepts = TRUE,edge.label.cex = 1, what = 'std',structural = FALSE)
modindices(SEM4.fit, sort = TRUE, maximum.number = 10)



SEM5.model <- 	'  
			    news_through_personal_media =~ x10 + x5 + x16
			    indirect_news_exposure =~ x15 + x11 + x13
			    #immidiate_news_pushes =~ x13 + x8 + x9
			    offline_news =~ x7 + x2 + x6
			    #entertaiment =~ x1 + x12 + x14
			    
			    unaware_phone =~  w2 + w3 + w4 + w5 + w6 
			    
          functioning =~ y10 + y1 +  y4 + y5 + y6 + y8 +  y11 + y13 + y14 #+ y3 + y9 + y12
			    competence =~  y16 + y2 + y15 + y17 + y18
			    positive_feeling =~ y21 + y7  + y19 + y20  +  y22
			    qol =~ functioning + competence + positive_feeling


			    # SEM 
			    news_through_personal_media ~ unaware_phone
			    indirect_news_exposure ~ unaware_phone
			    offline_news ~ unaware_phone

			    functioning ~ indirect_news_exposure
		    	competence ~ news_through_personal_media
		    	qol ~ unaware_phone

				'
SEM5.fit <- cfa(SEM5.model, data = respondents_data)
summary(SEM5.fit, standardized = TRUE, fit.measures = TRUE)







respondents_data$z11 <- rowMeans(respondents_data[, c("z3", "z9")], na.rm = TRUE)




respondents_data$parcel1 <- rowMeans(respondents_data[, c("x5", "x10", "x16")], na.rm = TRUE)
respondents_data$parcel2 <- rowMeans(respondents_data[, c("x8", "x9", "x13")], na.rm = TRUE)

respondents_data$parcel3 <- rowMeans(respondents_data[, c("x2", "x6", "x7")], na.rm = TRUE)
respondents_data$parcel4 <- rowMeans(respondents_data[, c("x3", "x11", "x15")], na.rm = TRUE)


respondents_data$z11 <- rowMeans(respondents_data[, c("z3", "z9")], na.rm = TRUE)

