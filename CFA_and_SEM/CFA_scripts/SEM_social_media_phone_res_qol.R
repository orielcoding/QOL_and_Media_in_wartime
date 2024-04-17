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

results_file <- file.path(results_dir, "SEM_full_without_str_sup.txt")

################################################################################
# best and not sufficient
# y18 in both factors, z11
respondents_data$z11 <- rowMeans(respondents_data[, c("z3", "z9")], na.rm = TRUE)

full.model2 <- 	'  
          functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			    competence =~  y2 + y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y18 + y19
			    qol =~ functioning + competence + positive_feeling
			    
			    resilience =~ z1 + z2 + z4 + z5 + z6 + z7 + z8 + z10 + z11
			    
			    omega =~ functioning + resilience
			   
			    non_visual_news =~ x4 + x6 + x7
			    text_focus_social_media =~ x11  + x15
			    image_focus_social_media =~   x1 + x12 + x14

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6
			    
			    image_focus_social_media ~ phone
			    #qol ~ image_focus_social_media + resilience
			    omega ~ image_focus_social_media
				'

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)


semPaths(full.fit2, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = TRUE)

################################################################################
# best and not sufficient
# y18 in both factors, z11
respondents_data$z11 <- rowMeans(respondents_data[, c("z3", "z9")], na.rm = TRUE)

full.model2 <- 	'  
          functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			    competence =~  y2 + y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y18 + y19
			    qol =~ functioning + competence + positive_feeling
			    
			    resilience =~ z1 + z2 + z4 + z5 + z6 + z7 + z8 + z10 + z11
			   
			    non_visual_news =~ x4 + x6 + x7
			    text_focus_social_media =~ x11  + x15
			    image_focus_social_media =~   x1 + x12 + x14

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6
			    
			    image_focus_social_media ~ phone
			    qol ~ resilience
			    
				'

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)


semPaths(full.fit2, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = TRUE)

################################################################################
#worser
# y18 in both factor
full.model2 <- 	'  
          functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			    competence =~  y2 + y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17  + y19
			    qol =~ functioning + competence + positive_feeling
			    
			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
			   
			    non_visual_news =~ x4 + x6 + x7
			    text_focus_social_media =~ x11  + x15
			    image_focus_social_media =~   x1 + x12 + x14

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6
			    
			    image_focus_social_media ~ phone
			    qol ~ image_focus_social_media + resilience
				'

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)


semPaths(full.fit2, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = TRUE)

################################################################################
# worser
# y18 in both factor
full.model2 <- 	'  
          functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			    competence =~  y2 + y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y19
			    qol =~ functioning + competence + positive_feeling
			    
			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
			   
			    non_visual_news =~ x4 + x6 + x7
			    text_focus_social_media =~ x11  + x15
			    image_focus_social_media =~   x1 + x12 + x14

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6
			    
			    image_focus_social_media ~ phone
			    qol ~ image_focus_social_media + resilience
				'

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)


semPaths(full.fit2, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = TRUE)

################################################################################
# worser
# y18 in both factor, u2+u3
full.model2 <- 	'  
          functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			    competence =~  y2 + y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y18 + y19
			    qol =~ functioning + competence + positive_feeling
			    
			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
			   
			    non_visual_news =~ x4 + x6 + x7
			    text_focus_social_media =~ x11 + x15
			    image_focus_social_media =~ x1 + x12 + x14

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6
			    
			    #resilience ~ text_focus
			    image_focus_social_media ~ phone
			    qol ~ image_focus_social_media + resilience
			    text_focus_social_media ~ u2 + u3
				'

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)


semPaths(full.fit2, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = TRUE)

################################################################################
# not improving
# y18 in both factor, x17
full.model2 <- 	'  
          functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			    competence =~  y2 + y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y18 + y19
			    qol =~ functioning + competence + positive_feeling
			    
			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
			   
			    non_visual_news =~ x4 + x6 + x7
			    text_focus_social_media =~ x11 + x15
			    image_focus_social_media =~ x1 + x12 + x14

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6
			    
			    #resilience ~ text_focus
			    image_focus_social_media ~ phone
			    qol ~ image_focus_social_media + resilience
			    functioning ~ x17
				'

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)


semPaths(full.fit2, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = TRUE)

################################################################################
# not improving
# y18 in both factor, x17, u2+u3
full.model2 <- 	'  
          functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			    competence =~  y2 + y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y18 + y19
			    qol =~ functioning + competence + positive_feeling
			    
			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
			   
			    non_visual_news =~ x4 + x6 + x7
			    text_focus_social_media =~ x11 + x15
			    image_focus_social_media =~ x1 + x12 + x14

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6
			    
			    #resilience ~ text_focus
			    image_focus_social_media ~ phone
			    qol ~ image_focus_social_media + resilience
			    functioning ~ x17
			    text_focus_social_media ~ u2 + u3
				'

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)


semPaths(full.fit2, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = TRUE)

################################################################################
# not changing
# y18 in both factor, x17, u3 only
full.model2 <- 	'  
          functioning =~ y1 + y3 + y4 + y5 + y6 + y7 + y8 + y9 + y10 + y11 + y18
			    competence =~  y2 + y12 + y13 + y14 + y15
			    positive_feeling =~ y16 + y17 + y18 + y19
			    qol =~ functioning + competence + positive_feeling
			    
			    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10
			   
			    non_visual_news =~ x4 + x6 + x7
			    text_focus_social_media =~ x11 + x15
			    image_focus_social_media =~ x1 + x12 + x14

			    phone =~ w1 + w2 + w3 + w4 + w5 + w6
			    
			    #resilience ~ text_focus
			    image_focus_social_media ~ phone
			    qol ~ image_focus_social_media + resilience
			    functioning ~ x17
			    non_visual_news ~ u3
				'

full.fit2 <- cfa(full.model2, data = respondents_data)
summary(full.fit2, standardized = TRUE, fit.measures = TRUE)


semPaths(full.fit2, intercepts = TRUE, edge.label.cex = 1, what = 'std', structural = TRUE)
