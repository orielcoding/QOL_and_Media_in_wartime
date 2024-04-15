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

results_file <- file.path(results_dir, "CFA_qol.txt")

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
