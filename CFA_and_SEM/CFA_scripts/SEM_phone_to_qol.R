library(lavaan)
library(readxl)
library(semPlot)
library(lmx)

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

results_file <- file.path(results_dir, "SEM_phone_to_qol.txt")

################################################################################
# y18 in functioning
sink(results_file)

full.model2 <- '
                unaware =~ w1 + w2 + w3 + w4 + w5 + w6
                functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			          competence =~ y2 + y12 + y13 + y14 + y15
			          positive_feeling =~ y16 + y17 + y19
			          qol =~ functioning + competence + positive_feeling
                
                qol ~ unaware
                '

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2,standardized = TRUE , fit.measures = TRUE)

# Save the results to the output file
sink()

semPaths(full.fit2, intercepts = TRUE,edge.label.cex = 1, what = 'std',structural = TRUE)

################################################################################
# y18 in both
sink(results_file)

full.model2 <- '
                unaware =~ w1 + w2 + w3 + w4 + w5 + w6
                functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			          competence =~ y2 + y12 + y13 + y14 + y15
			          positive_feeling =~ y16 + y17 + y18 + y19
			          qol =~ functioning + competence + positive_feeling
                
                qol ~ unaware
                '

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2,standardized = TRUE , fit.measures = TRUE)

# Save the results to the output file
sink()

semPaths(full.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)


################################################################################
# y18 in both + z11
sink(results_file)

full.model2 <- '
                unaware =~ w1 + w2 + w3 + w4 + w5 + w6
                
                functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			          competence =~ y2 + y12 + y13 + y14 + y15
			          positive_feeling =~ y16 + y17 + y18 + y19
			          qol =~ functioning + competence + positive_feeling
			          
			          resilience =~ z1 + z2 + z4 + z5 + z6 + z7 + z8 + z10 + z11
                
                qol ~ unaware
                qol ~~ resilience
                '

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2,standardized = TRUE , fit.measures = TRUE)

# Save the results to the output file
sink()

semPaths(full.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)


################################################################################
# y18 in functioning + z11
sink(results_file)

full.model2 <- '
                unaware =~ w1 + w2 + w3 + w4 + w5 + w6
                
                functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			          competence =~ y2 + y12 + y13 + y14 + y15
			          positive_feeling =~ y16 + y17 + y19
			          qol =~ functioning + competence + positive_feeling
			          
			          resilience =~ z1 + z2 + z4 + z5 + z6 + z7 + z8 + z10 + z11
                
                qol ~ unaware
                #resilience ~ unaware
                qol ~~ resilience
                '

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2,standardized = TRUE , fit.measures = TRUE)

# Save the results to the output file
sink()

semPaths(full.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)

################################################################################
# y18 in functioning + regular resilience
sink(results_file)

full.model2 <- '
                unaware =~ w1 + w2 + w3 + w4 + w5 + w6
                
                functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			          competence =~ y2 + y12 + y13 + y14 + y15
			          positive_feeling =~ y16 + y17 + y19
			          qol =~ functioning + competence + positive_feeling
			          
			          resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
                
                qol ~ unaware
                #resilience ~ unaware
                qol ~~ resilience
                '

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2,standardized = TRUE , fit.measures = TRUE)

# Save the results to the output file
sink()

semPaths(full.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)

################################################################################
# y18 in both + regular resilience
sink(results_file)

full.model2 <- '
                unaware =~ w1 + w2 + w3 + w4 + w5 + w6
                
                functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			          competence =~ y2 + y12 + y13 + y14 + y15
			          positive_feeling =~ y16 + y17 + y18 + y19
			          qol =~ functioning + competence + positive_feeling
			          
			          resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
                
                qol ~ unaware
                #resilience ~ unaware
                qol ~~ resilience
                '

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2,standardized = TRUE , fit.measures = TRUE)

# Save the results to the output file
sink()

semPaths(full.fit2, intercepts = FALSE,edge.label.cex = 1, what = 'std',structural = TRUE)
