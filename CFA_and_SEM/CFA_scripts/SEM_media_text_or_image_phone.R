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

results_file <- file.path(results_dir, "CFA_media.txt")

################################################################################


# text - linkedin, x
# image - instegram, tiktok
# both: facebook, telegram
# irrelevant: whatsapp
media_resilience.model <- 	'  

			    text_focus =~ x1 + x11 + x15
			    image_focus =~ x1 + x12 + x14

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6
				'


media_resilience.fit <- cfa(media_resilience.model, data = respondents_data)
summary(media_resilience.fit, standardized = TRUE, fit.measures = TRUE)


semPaths(media_resilience.fit, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = FALSE)

################################################################################


# text - linkedin, x
# image - instegram, tiktok
# both: facebook, telegram
# irrelevant: whatsapp
media_resilience.model <- 	'  
          
			    text_focus =~ x11 + x15
			    image_focus =~ x1 + x12 + x14

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6

          image_focus ~ phone
          
				'


media_resilience.fit <- cfa(media_resilience.model, data = respondents_data)
summary(media_resilience.fit, standardized = TRUE, fit.measures = TRUE)


semPaths(media_resilience.fit, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = FALSE)

################################################################################


# text - linkedin, x
# image - instegram, tiktok
# both: facebook, telegram
# irrelevant: whatsapp
media_resilience.model <- 	'  

			    text_focus =~ x11 + x15
			    image_focus =~ x1 + x12 + x14

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6

          phone ~ image_focus
				'


media_resilience.fit <- cfa(media_resilience.model, data = respondents_data)
summary(media_resilience.fit, standardized = TRUE, fit.measures = TRUE)


semPaths(media_resilience.fit, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = FALSE)

################################################################################

# stronger regression but a bit lower (yet good) statistical measures.
# text - linkedin, x
# image - instegram, tiktok
# both: facebook, telegram
# irrelevant: whatsapp
media_resilience.model <- 	'  
          
			    text_focus =~  x11 + x15
			    image_focus =~ x1 + x12 + x14

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6

          phone ~ text_focus
				'


media_resilience.fit <- cfa(media_resilience.model, data = respondents_data)
summary(media_resilience.fit, standardized = TRUE, fit.measures = TRUE)


semPaths(media_resilience.fit, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = FALSE)

################################################################################

# less good than the opposite
# text - linkedin, x
# image - instegram, tiktok
# both: facebook, telegram
# irrelevant: whatsapp
media_resilience.model <- 	'  

			    text_focus =~  x11 + x15
			    image_focus =~ x1 + x12 + x14

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6

          text_focus ~ phone
				'


media_resilience.fit <- cfa(media_resilience.model, data = respondents_data)
summary(media_resilience.fit, standardized = TRUE, fit.measures = TRUE)


semPaths(media_resilience.fit, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = FALSE)


################################################################################

# text - linkedin, x
# image - instegram, tiktok
# both: facebook, telegram
# irrelevant: whatsapp
media_resilience.model <- 	'  

			    text_focus =~ x1 + x11 + x15
			    image_focus =~ x1 + x12 + x14

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6

          phone ~ text_focus + image_focus
				'


media_resilience.fit <- cfa(media_resilience.model, data = respondents_data)
summary(media_resilience.fit, standardized = TRUE, fit.measures = TRUE)


semPaths(media_resilience.fit, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = FALSE)
################################################################################

# text - linkedin, x
# image - instegram, tiktok
# both: facebook, telegram
# irrelevant: whatsapp
media_resilience.model <- 	'  

			    text_focus =~ x11 + x15
			    image_focus =~ x1 + x12 + x14

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6

          image_focus ~ phone
          text_focus ~ phone
				'


media_resilience.fit <- cfa(media_resilience.model, data = respondents_data)
summary(media_resilience.fit, standardized = TRUE, fit.measures = TRUE)


semPaths(media_resilience.fit, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = FALSE)

################################################################################

# text - linkedin, x
# image - instegram, tiktok
# both: facebook, telegram
# irrelevant: whatsapp
media_resilience.model <- 	'  
non_visual_news =~ x4 + x6 + x7
			    text_focus =~ x11 + x13 + x15
			    image_focus =~ x1 + x12 + x14

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6

          #image_focus ~ phone
          text_focus ~ phone
				'


media_resilience.fit <- cfa(media_resilience.model, data = respondents_data)
summary(media_resilience.fit, standardized = TRUE, fit.measures = TRUE)


semPaths(media_resilience.fit, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = FALSE)
