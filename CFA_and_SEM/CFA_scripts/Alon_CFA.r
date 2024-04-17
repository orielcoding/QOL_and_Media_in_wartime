library(lavaan)
library(readxl)
library(semPlot)

################################################################################

DATA_FILE_NAME <- "processed_responses.xlsx"

# Get the current working directory
current_dir <- file.path(getwd(), "..")

# Set the results directory relative to the script directory
results_dir <- file.path(current_dir, "CFA_results")

# Create the directory if it doesn't exist
if (!dir.exists(results_dir)) {
  dir.create(results_dir, recursive = TRUE)
}

# access the data file and read it. 
data_file <- file.path(current_dir, "..", 'data', DATA_FILE_NAME)

respondents_data <- read_excel(data_file)

################################################################################
# Variation N.1: phone <-> social media <-> support

phone_social_media_support.model2 <- 	'  

			    social_media =~ x1 + x12 + x13 + x14 + x15 + x16

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6
			    
			    support =~ v1 + v2 + v3 + v4
			    
				'


phone_social_media_support.fit2 <- cfa(phone_social_media_support.model2, data = respondents_data)
summary(phone_social_media_support.fit2, standardized = TRUE, fit.measures = TRUE)


#######################################
# Variation N.1: social media <-> phone

phone_social_media.model2 <- 	'  
			    social_media =~ x1 + x12 + x13 + x14 + x15 + x16

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6
			    
				'


phone_social_media.fit2 <- cfa(phone_social_media.model2, data = respondents_data)
summary(phone_social_media.fit2, standardized = TRUE, fit.measures = TRUE)


########################################
# Variation N.1: social media <-> support


social_media_support.model <- 	'  

			    social_media =~ x1 + x12 + x13 + x14 + x15 + x16

			    support =~ v1 + v2 + v3 + v4
			    
				'


social_media_support.fit <- cfa(social_media_support.model, data = respondents_data)
summary(social_media_support.fit, standardized = TRUE, fit.measures = TRUE)

######
# Variation N.1: offline_news <-> support --->>> bad! negative cov. 

full.model2 <- 	'  

			    offline_news =~ x4 + x5 + x6

			    support =~ v1 + v2 + v3 + v4
			    
				'


full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)


################################################################################
################################################################################
# Variation N.2: resil <-> full qol, social media <-> resil, 

# Variation N.2: add social media <-> resil

full.model2 <- 	'  
			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
			   
			    social_media =~ x1 + x12 + x13 + x14 + x15 + x16

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6
			    
			    support =~ v1 + v2 + v3 + v4
			    
			    qol ~~ qol
				'

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)

################################################################################
# Variation N.3: add offline communication (x4-x6) <-> resil

full.model2 <- 	'  
			    functioning =~ y8 + y9 + y10 + y11
			    competence =~ y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y18 + y19

			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
			   
			    stress =~ u1 + u2 + u3
			   
			    social_media =~ x1 + x12 + x13 + x14 + x15 + x16
			    offline_news =~ x4 + x5 + x6
			   
			    phone =~ w1 + w2 + w3 + w4 + w5 + w6
			    
			    support =~ v1 + v2 + v3 + v4
 
			    #resilience ~ functioning + competence + positive_feeling
			    functioning ~ resilience
			    competence ~ resilience #+ offline_news + social_media
			    positive_feeling ~ resilience
				  resilience ~ offline_news + social_media
				
				#offline_news ~ competence
				#social_media ~ stress
				#social_media ~ phone
				'


full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)

########################################

# dropping x15. dropping x4-x7 factor
full.model2 <- 	'  
			    functioning =~ y8 + y9 + y10 + y11
			    competence =~ y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y18 + y19

			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
			   
			    stress =~ u1 + u2 + u3
			   
			    social_media =~ x1 + x12 + x13 + x14 + x16

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6
 
			    resilience ~ functioning + competence + positive_feeling
				resilience ~ social_media
				
				social_media ~ stress
				social_media ~ phone
				'


full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)

##################################################################

# include x4-x7
full.model2 <- 	'  
			    functioning =~ y8 + y9 + y10 + y11
			    competence =~ y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y18 + y19

			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
			   
			    stress =~ u1 + u2 + u3
			    
			    social_media =~ x1 + x12 + x13 + x14 + x16
			    offline_news =~ x4 + x5 + x6 + x7
			   
			    phone =~ w1 + w2 + w3 + w4 + w5 + w6

				'
	
full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)


##################################################################

# complex network alon model - new media constractors. not good enough.
full.model2 <- 	'  
			    functioning =~ y8 + y9 + y10 + y11
			    competence =~ y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y18 + y19

			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
			    
			    social_media =~ x1 + x5 + x8 + x9 + x12 + x13 + x14 + x16
			    offline_news =~ x2 + x4 + x6 + x7 + x11 + x15
			   
			    phone =~ w1 + w2 + w3 + w4 + w5 + w6

				'

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)


##################################################################

# complex network alon model - new media constractors. not good. 0.833, 0.053
full.model2 <- 	'  
			    functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11
			    competence =~ y2 + y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y18 + y19
			    
			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
			    
			    social_media =~ x1 + x5 + x8 + x9 + x12 + x13 + x14 + x16
			    offline_news =~ x2 + x4 + x6 + x7 + x11 + x15
			   
			    phone =~ w1 + w2 + w3 + w4 + w5 + w6

				'

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)


##################################################################

# complex network alon model - new media constractors. single qol. bad. cfi 0.68...
full.model2 <- 	'  
			    qol =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y2 + y12 + y13 + y14 + y15 + y16 + y17 + y18 + y19

			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
			    
			    social_media =~ x1 + x5 + x8 + x9 + x12 + x13 + x14 + x16
			    offline_news =~ x2 + x4 + x6 + x7 + x11 + x15
			   
			    phone =~ w1 + w2 + w3 + w4 + w5 + w6

				'

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)

##################################################################

# complex network alon model - new media constractors. not good. 0.833, 0.053
full.model2 <- 	'  
			    functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11
			    competence =~ y2 + y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y18 + y19
			    
			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
			    
			    social_media =~ x1 + x5 + x8 + x9 + x12 + x13 + x14 + x16
			    offline_news =~ x2 + x4 + x6 + x7 + x11 + x15
			   
			    phone =~ w1 + w2 + w3 + w4 + w5 + w6

				'

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)

