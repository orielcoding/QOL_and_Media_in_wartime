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

##############################################################################

# Alon's qol structure:

resil_qol.model  <- 	'  
			    functioning =~ y8 + y9 + y10 + y11
			    competence =~ y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y18 + y19
			    qol =~ functioning + competence + positive_feeling

			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10

			    qol ~~ resilience
			    '

resil_qol.fit2 <- cfa(resil_qol.model, data = respondents_data)
summary(resil_qol.fit2,standardized = TRUE , fit.measures = TRUE)

semPaths(resil_qol.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)

##############################################################################
# full qol structure:

resil_qol.model <- 	'  
			    functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11
			    competence =~ y2 + y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y18 + y19
			    qol =~ functioning + competence + positive_feeling

			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10

			    qol ~ resilience
			    '

resil_qol.fit2 <- cfa(resil_qol.model, data = respondents_data)
summary(resil_qol.fit2,standardized = TRUE , fit.measures = TRUE)

semPaths(resil_qol.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)

##############################################################################
# y18 both factors 
output_file <- paste0(results_dir, "/CFA_resilience_to_QOL.txt")
sink(output_file)

resil_qol.model <- 	'  
			    functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			    competence =~ y2 + y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y18 + y19
			    qol =~ functioning + competence + positive_feeling

			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
          qol ~ resilience
			    '

resil_qol.fit2 <- cfa(resil_qol.model, data = respondents_data)
summary(resil_qol.fit2,standardized = TRUE , fit.measures = TRUE)

sink()

semPaths(resil_qol.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)


##############################################################################
# y18 in functioning
output_file <- paste0(results_dir, "/CFA_resilience_to_QOL.txt")
sink(output_file)

resil_qol.model <- 	'  
			    functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			    competence =~ y2 + y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y19
			    qol =~ functioning + competence + positive_feeling

			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
          qol ~ resilience
			    '

resil_qol.fit2 <- cfa(resil_qol.model, data = respondents_data)
summary(resil_qol.fit2,standardized = TRUE , fit.measures = TRUE)

sink()

semPaths(resil_qol.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)


##############################################################################
# Create a new item z11 as the average of z3 and z9
respondents_data$z11 <- rowMeans(respondents_data[, c("z3", "z9")], na.rm = TRUE)

# full qol structure: +y18 for functioning
output_file <- paste0(results_dir, "/CFA_resilience_to_QOL.txt")
sink(output_file)

resil_qol.model <- 	'  
			    functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			    competence =~ y2 + y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y18 + y19
			    qol =~ functioning + competence + positive_feeling

			    resilience =~ z1 + z2 + z4 + z5 + z6 + z7 + z8 + z10 + z11
          qol ~ resilience
			    '

resil_qol.fit2 <- cfa(resil_qol.model, data = respondents_data)
summary(resil_qol.fit2,standardized = TRUE , fit.measures = TRUE)

sink()

semPaths(resil_qol.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)

##############################################################################
# y18 in both factors + z11 -> not good enough but best
output_file <- paste0(results_dir, "/CFA_resilience_to_QOL.txt")
sink(output_file)

resil_qol.model <- 	'  
			    functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			    competence =~ y2 + y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y18 + y19
			    qol =~ functioning + competence + positive_feeling

			    resilience =~ z1 + z2 + z4 + z5 + z6 + z7 + z8 + z10 + z11
          qol ~ resilience
			    '

resil_qol.fit2 <- cfa(resil_qol.model, data = respondents_data)
summary(resil_qol.fit2,standardized = TRUE , fit.measures = TRUE)

sink()

semPaths(resil_qol.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)

##############################################################################
# y18 in both factors + z11 -> not good enough but best
output_file <- paste0(results_dir, "/CFA_resilience_to_QOL.txt")
sink(output_file)

resil_qol.model <- 	'  
			    functioning =~ y1 + y3 + y4 + y5  + y7 + y8 + y9 + y10 + y11 + y18
			    competence =~ y2 + y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17  + y19
			    qol =~ functioning + competence + positive_feeling

			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
          functioning ~~ resilience
          qol ~ resilience
			    '

resil_qol.fit2 <- cfa(resil_qol.model, data = respondents_data)
summary(resil_qol.fit2,standardized = TRUE , fit.measures = TRUE)

sink()

semPaths(resil_qol.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)


##############################################################################
# y18 in functioning + z11 -> not good enough
output_file <- paste0(results_dir, "/CFA_resilience_to_QOL.txt")
sink(output_file)

resil_qol.model <- 	'  
			    functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			    competence =~ y2 + y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y19
			    qol =~ functioning + competence + positive_feeling

			    resilience =~ z1 + z2 + z4 + z5 + z6 + z7 + z8 + z10 + z11
          qol ~ resilience
			    '

resil_qol.fit2 <- cfa(resil_qol.model, data = respondents_data)
summary(resil_qol.fit2,standardized = TRUE , fit.measures = TRUE)

sink()

semPaths(resil_qol.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)


##############################################################################
# original qol structure + z11
output_file <- paste0(results_dir, "/CFA_resilience_to_QOL.txt")
sink(output_file)

resil_qol.model <- 	'  
          functioning =~ y3 + y4 + y5 + y8 + y9 + y10 + y11 + y18
          competence =~  y2 + y12 + y13 + y14 + y15
          positive_feeling =~ y1 + y6 + y7 + y16 + y17 + y19
          qol =~ functioning + competence + positive_feeling

			    resilience =~ z1 + z2 + z4 + z5 + z6 + z7 + z8 + z10 + z11
          qol ~ resilience
			    '

resil_qol.fit2 <- cfa(resil_qol.model, data = respondents_data)
summary(resil_qol.fit2,standardized = TRUE , fit.measures = TRUE)

sink()

semPaths(resil_qol.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)


##############################################################################
# original qol structure + z11
output_file <- paste0(results_dir, "/CFA_resilience_to_QOL.txt")
sink(output_file)

resil_qol.model <- 	'  
          functioning =~ y3 + y4 + y5 + y8 + y9 + y10 + y11 + y18
          competence =~  y2 + y12 + y13 + y14 + y15
          positive_feeling =~ y1 + y6 + y7 + y16 + y17 + y19
          qol =~ functioning + competence + positive_feeling

			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
          qol ~ resilience
			    '

resil_qol.fit2 <- cfa(resil_qol.model, data = respondents_data)
summary(resil_qol.fit2,standardized = TRUE , fit.measures = TRUE)

sink()

semPaths(resil_qol.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)

##############################################################################

resil_qol.model <- 	'  
			    functioning =~ y1 + y4 + y5 + y6 + y8 + y10 + y11 + y13 + y14 + y21
			    competence =~  y2 + y15 + y16 + y17 + y18
			    positive_feeling =~ y7  + y19 + y20 + y22
			    qol =~ functioning + competence + positive_feeling

			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 
			    
          #functioning ~ resilience 
          #competence ~ resilience
          #positive_feeling ~ resilience
          qol ~ resilience
          #resilience ~ qol
'

resil_qol.fit2 <- cfa(resil_qol.model, data = respondents_data)
summary(resil_qol.fit2,standardized = TRUE , fit.measures = TRUE)


semPaths(resil_qol.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)


# Compute the factor scores for latent variables
factorScores <- lavPredict(resil_qol.fit2, type = "lv")

# Print the factor scores
print(factorScores)

