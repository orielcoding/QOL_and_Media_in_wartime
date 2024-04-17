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

results_file <- file.path(results_dir, "SEM_social_media_resilience.txt")

################################################################################
sink(results_file)

# text - linkedin, x
# image - instegram, tiktok
# both: facebook, telegram
# irrelevant: whatsapp
media_resilience.model <- 	'  

			    text_focus =~ x1 + x11 + x15
			    image_focus =~ x1 + x12 + x14

			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
          resilience ~ image_focus + text_focus
				'


media_resilience.fit <- cfa(media_resilience.model, data = respondents_data)
summary(media_resilience.fit, standardized = TRUE, fit.measures = TRUE)

sink()
semPaths(media_resilience.fit, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = FALSE)

################################################################################
sink(results_file)

# text - linkedin, x
# image - instegram, tiktok
# both: facebook, telegram
# irrelevant: whatsapp
media_resilience.model <- 	'  

			    text_focus =~ x1 + x11 + x15
			    image_focus =~ x1 + x12 + x14

			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
          resilience ~ image_focus
				'


media_resilience.fit <- cfa(media_resilience.model, data = respondents_data)
summary(media_resilience.fit, standardized = TRUE, fit.measures = TRUE)

sink()
semPaths(media_resilience.fit, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = FALSE)


################################################################################
sink(results_file)

# text - linkedin, x
# image - instegram, tiktok
# both: facebook, telegram
# irrelevant: whatsapp
media_resilience.model <- 	'  

			    text_focus =~ x1 + x11 + x15
			    image_focus =~ x1 + x12 + x14

			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
          resilience ~ text_focus
				'


media_resilience.fit <- cfa(media_resilience.model, data = respondents_data)
summary(media_resilience.fit, standardized = TRUE, fit.measures = TRUE)

sink()
semPaths(media_resilience.fit, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = FALSE)
