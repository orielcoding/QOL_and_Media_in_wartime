library(lavaan)
library(readxl)
library(semPlot)

DATA_FILE_NAME <- "processed_responses.xlsx"
current_dir <- file.path(getwd(), "..")
data_file <- file.path(current_dir, "..", 'data', DATA_FILE_NAME)
respondents_data <- read_excel(data_file)


social_media.model <- 	'  

			    social_media =~ x1 + x10 + x11 + x12 + x13 + x14 + x15 + x16
			    
				'


social_media.fit <- cfa(social_media.model, data = respondents_data)
summary(social_media.fit, standardized = TRUE, fit.measures = TRUE)


################################################################################

social_media.model <- 	'  

			    social_media =~ x1 + x11 + x12 + x13 + x14 + x15 + x16
			    
				'


social_media.fit <- cfa(social_media.model, data = respondents_data)
summary(social_media.fit, standardized = TRUE, fit.measures = TRUE)

################################################################################

social_media.model <- 	'  

			    social_media =~ x1 + x12 + x13 + x14 + x16
			    
				'


social_media.fit <- cfa(social_media.model, data = respondents_data)
summary(social_media.fit, standardized = TRUE, fit.measures = TRUE)

################################################################################

media.model <- 	'  

			    social_media =~ x1 + x12 + x13 + x14 + x16
			    news =~ x11 + x13 + x15
				'


media.fit <- cfa(media.model, data = respondents_data)
summary(media.fit, standardized = TRUE, fit.measures = TRUE)
semPaths(media.fit, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)

################################################################################

media.model <- 	'  

			    social_media =~ x1 + x12 + x13 + x14 + x16
			    news =~ x8 + x11 + x13 + x15
				'


media.fit <- cfa(media.model, data = respondents_data)
summary(media.fit, standardized = TRUE, fit.measures = TRUE)
semPaths(media.fit, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)

################################################################################
# not good enough
# personal_use - facebook, instegram, tiktok, telegram, whatsapp
# proffesional_use - linkedin, x 
# both: x (goes to proffesional because only this is interesting)
media.model <- 	'  

			    personal_use =~ x1 + x11 + x15
			    proffesional_use =~ x1 + x10 + x12 + x13 + x14 + x16
				'


media.fit <- cfa(media.model, data = respondents_data)
summary(media.fit, standardized = TRUE, fit.measures = TRUE)

################################################################################
# perfect result - but too much in common
# text - linkedin, x, telegram
# image - instegram, tiktok, telegram
# both: facebook
# irrelevant: whatsapp
media.model <- 	'  

			    text_focus =~ x1 + x11 + x13 + x15
			    image_focus =~ x1 + x12 + x13 + x14
				'


media.fit <- cfa(media.model, data = respondents_data)
summary(media.fit, standardized = TRUE, fit.measures = TRUE)

# good result 
# text - linkedin, x
# image - instegram, tiktok, telegram
# both: facebook
# irrelevant: whatsapp
media.model <- 	'  

			    text_focus =~ x1 + x11  + x15
			    image_focus =~ x1 + x12 + x13 + x14
				'


media.fit <- cfa(media.model, data = respondents_data)
summary(media.fit, standardized = TRUE, fit.measures = TRUE)

# not good enough
# text - linkedin, x, telegram
# image - instegram, tiktok
# both: facebook
# irrelevant: whatsapp
media.model <- 	'  

			    text_focus =~ x1 + x11 + x13 + x15
			    image_focus =~ x1 + x12 + x14
				'


media.fit <- cfa(media.model, data = respondents_data)
summary(media.fit, standardized = TRUE, fit.measures = TRUE) 

#################

# very good result!!!!!!!!!!!!
# text - linkedin, x
# image - instegram, tiktok
# both: facebook, telegram
# irrelevant: whatsapp
media.model <- 	'  

			    text_focus =~ x1 + x11 + x15
			    image_focus =~ x1 + x12 + x14
				'


media.fit <- cfa(media.model, data = respondents_data)
summary(media.fit, standardized = TRUE, fit.measures = TRUE)

# not good
# text - linkedin, x, facebook
# image - instegram, tiktok
# both: telegram
# irrelevant: whatsapp
media.model <- 	'  

			    text_focus =~ x1 + x10 + x11 + x15
			    image_focus =~ x1 + x12 + x14
				'


media.fit <- cfa(media.model, data = respondents_data)
summary(media.fit, standardized = TRUE, fit.measures = TRUE)

################################################################################
# bad result
# social_networking - facbook, x, instegram, tiktok, linkedin
# messaging - whatsapp, telegram
media.model <- 	'  

			    social_networking =~ x1 + x10 + x11 + x12 + x14 + x15
			    messaging =~ x1 + x13 + x16
				'


media.fit <- cfa(media.model, data = respondents_data)
summary(media.fit, standardized = TRUE, fit.measures = TRUE)

################################################################################
# content type -> bad result
# content_creation - instegram, tiktok
# content_sharing_communication - whatsapp, facebook, telegram, linkedin, x
media.model <- 	'  

			    content_creation =~ x1 + x12 + x14
			    content_sharing_communication =~ x1 + x10 + x11 + x13 + x15 + x16
				'


media.fit <- cfa(media.model, data = respondents_data)
summary(media.fit, standardized = TRUE, fit.measures = TRUE)

################################################################################
# sharing style -> not good
# close_circle - facebook, instegram, whatsapp
# open_sharing - x, telegram, tiktok, linkedin
media.model <- 	'  

			    close_circle =~ x1 + x10 + x12 + x16
			    open_sharing =~ x1 + x11 + x13 + x14 + x15
				'


media.fit <- cfa(media.model, data = respondents_data)
summary(media.fit, standardized = TRUE, fit.measures = TRUE)

################################################################################
# sharing style -> not good
# close_circle - facebook, instegram, whatsapp
# open_sharing - x, telegram, tiktok, linkedin
media.model <- 	'  

			    close_circle =~ x1 + x5 + x12 + x13 + x14 + x16
			    open_sharing =~ x2 + x3 + x7 + x15
				'


media.fit <- cfa(media.model, data = respondents_data)
summary(media.fit, standardized = TRUE, fit.measures = TRUE)


################################################################################
# sharing style -> not good
# close_circle - facebook, instegram, whatsapp
# open_sharing - x, telegram, tiktok, linkedin
media.model <- 	'  

			    image_news =~ x4 + x6 + x7
			    #text_news =~ x2 + x3 
			    text_focus =~ x11 + x13 + x15
			    image_focus =~ x1 + x12 + x13 + x14
			    #text =~ text_news + text_focus
			    #image =~ image_news + image_focus
				'


media.fit <- cfa(media.model, data = respondents_data)
summary(media.fit, standardized = TRUE, fit.measures = TRUE)


################################################################################
sink(results_file)
basemodel.model <- 	'  
			    non_visual_news =~ x4 + x6 + x7
			    text_focus_social_media =~ x11  + x15
			    image_focus_social_media =~   x1 + x12 + x14
				'


media.fit <- cfa(basemodel.model, data = respondents_data)
summary(media.fit, standardized = TRUE, fit.measures = TRUE)
sink()
semPaths(media.fit, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)

################################################################################
sink(results_file)
basemodel.model <- 	'  

			    image_focus_social_media =~ x1 + x11 + x12 + x14 + x15

				'


media.fit <- cfa(basemodel.model, data = respondents_data)
summary(media.fit, standardized = TRUE, fit.measures = TRUE)
sink()
semPaths(media.fit, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)



################################################################################
basemodel.model <- 	'  

			    			    media =~ x1+x5+x8+x9+x10+x12+x13+x14+x16
			    			    media2 =~ x2 + x4 + x6 + x7

				'

media.fit <- cfa(basemodel.model, data = respondents_data)
summary(media.fit, standardized = TRUE, fit.measures = TRUE)

################################################################################
basemodel.model <- 	'  
          offline_news =~ x2 + x6 + x7 # x4
			    news_and_knowledge =~  x3 + x4 + x11 + x15 # x13
			    social_contact =~ x1 + x3 + x5 + x10 + x12 + x16
			    content_consumption =~ x1 + x12 + x13 + x14 + x8 + x9
				'

media.fit <- cfa(basemodel.model, data = respondents_data)
modindices(media.fit, sort = TRUE, maximum.number = 5)
summary(media.fit, standardized = TRUE, fit.measures = TRUE)
