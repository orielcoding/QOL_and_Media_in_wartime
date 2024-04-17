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

results_file <- file.path(results_dir, "CFA_CORR_GRAPH.txt")

################################################################################
# model:4 latents. all qol in 1 latent. resilience. phone. x1,5,8,9,10,12,13,14,16.
four_latents.model <- 	'  
			    qol =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18 + y2 + y12 + y13 + y14 + y15 + y16 + y17 + y19

			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
			   
			    media =~ x1+x5+x8+x9+x10+x12+x13+x14+x16

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6
			    
				'
four_latents.model <- 	'  

			    media =~ x1+x5+x8+x9+x10+x12+x13+x14+x16


				'

four_latents.fit <- cfa(four_latents.model, data = respondents_data)
summary(four_latents.fit, standardized = TRUE, fit.measures = TRUE, ci = TRUE)
# result: RMSEA: .071 SRMR: .075 CFI: .7 TLI: .68 
# Notes: qol with 19 elements -> very complex latent factor. 
# parameters to estimate: loadings(19 + 10 + 6 + 9) + loadings_error(19 + 10 + 6 + 9) + cov(3 + 2 + 1) + var(4) = 98
# equations (data): (19 + 10 + 6 + 9)*(19 + 10 + 6 + 9 + 1)/2 = 1035
# df = 1035 - 96


################################################################################
# model:6 latents. qol to 3. resilience. phone. x1,5,8,9,10,12,13,14,16.
six_latents.model <- 	'  
			    functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			    competence =~  y2 + y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y19
			    qol =~ functioning + competence + positive_feeling
			    
			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
			   
			    media =~ x1+x5+x8+x9+x10+x12+x13+x14+x16

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6
			    
				'

six_latents.fit <- cfa(six_latents.model, data = respondents_data)
summary(six_latents.fit, standardized = TRUE, fit.measures = TRUE, ci = TRUE)
# result: RMSEA: .071 SRMR: .075 CFI: .7 TLI: .68 
# Notes: qol with 19 elements -> very complex latent factor. 
# parameters to estimate: loadings(19 + 10 + 6 + 9) + loadings_error(19 + 10 + 6 + 9) + cov(qol(3) + 6) + var(7) = 104
# equations (data): (19 + 10 + 6 + 9)*(19 + 10 + 6 + 9 + 1)/2 = 1035
# df = 1035 - 104

################################################################################
# model:6 latents. qol to 3. resilience. phone. x1,5,8,9,10,12,13,14,16.
six_latents.model <- 	'  
			    functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			    competence =~  y2 + y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y19
			    qol =~ functioning + competence + positive_feeling
			    
			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
			   
			    media =~ x1+x5+x8+x9+x10+x12+x13+x14+x16

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6
			    
				'

six_latents.fit <- cfa(six_latents.model, data = respondents_data)
modindices(fit, sort = TRUE, maximum.number = 5)
summary(six_latents.fit, standardized = TRUE, fit.measures = TRUE, ci = TRUE)
# result: RMSEA: .071 SRMR: .075 CFI: .7 TLI: .68 
# Notes: qol with 19 elements -> very complex latent factor. 
# parameters to estimate: loadings(19 + 10 + 6 + 9) + loadings_error(19 + 10 + 6 + 9) + cov(qol(3) + 6) + var(7) = 104
# equations (data): (19 + 10 + 6 + 9)*(19 + 10 + 6 + 9 + 1)/2 = 1035
# df = 1035 - 104
