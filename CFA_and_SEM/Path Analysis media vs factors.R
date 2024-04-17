library(lavaan)
library(readxl)
library(semPlot)

DATA_FILE_NAME <- "processed_responses.xlsx"
data_file <- file.path(current_dir, "..", 'data', DATA_FILE_NAME)
respondents_data <- read_excel(data_file)

# y3 + y9 func, y12 comp - missing in the model, not imputed
# y8 is in func instead of pos

####################################################################
####################################################################
####################################################################
####################################################################
# control variables -> 1. gender 2. age 3. status 4. education

path_model <- '
    functioning =~ y10 +  y4 + y5 + y6 + y8 + y11 + y13 + y14 + y21
    competence =~  y16 + y2 + y15 + y17 + y18
    positive_feeling =~ y7 + y19 + y20  +  y22 + y1
    qol =~ functioning + competence + positive_feeling

    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 
			    

    # Direct paths from media items to QOL components
    functioning ~ age
    #functioning ~ status
    competence ~ age + gender
    positive_feeling ~ gender
    resilience ~ gender
'

# Fit the model
path_model.fit <- sem(path_model, data = respondents_data)

# Summary of the model fit
summary(path_model.fit, standardized = TRUE, fit.measures = TRUE)

####################################################################
####################################################################
####################################################################
####################################################################
# media 

path_model <- '
    functioning =~ y10 +  y4 + y5 + y6 + y8 + y11 + y13 + y14 + y21
    competence =~  y16 + y2 + y15 + y17 + y18
    positive_feeling =~ y7 + y19 + y20  +  y22 + y1
    qol =~ functioning + competence + positive_feeling

    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 
			    

    # Direct paths from media items to QOL components
    functioning ~ x10 + x16 + x15 + x11 + x13 + x8 + x9 + x7 + x2 + x6 + x1 + x12 + x14
    competence ~ x10 + x5 + x16 + x15 + x11 + x13 + x8 + x9 + x7 + x2 + x6 + x1 + x12 + x14
    positive_feeling ~ x10 + x5 + x16 + x15 + x11 + x13 + x8 + x9 + x7 + x2 + x6 + x1 + x12 + x14
    resilience ~ x10 + x5 + x16 + x15 + x11 + x13 + x8 + x9 + x7 + x2 + x6 + x1 + x12 + x14
'

# Fit the model
path_model.fit <- sem(path_model, data = respondents_data)

# Summary of the model fit
summary(path_model.fit, standardized = TRUE, fit.measures = TRUE)

####################################################################
# Dropping regressions with p_value(>|z|) above 0.7. 

path_model <- '
    functioning =~ y10 +  y4 + y5 + y6 + y8 + y11 + y13 + y14 + y21
    competence =~  y16 + y2 + y15 + y17 + y18
    positive_feeling =~ y7 + y19 + y20  +  y22 + y1
    qol =~ functioning + competence + positive_feeling

    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 
			    

    # Direct paths from media items to QOL components
    functioning ~ x10 + x16 + x15 + x13 + x2 + x6  + x1 + x12 + x14
    competence ~ x10 + x5 + x11 + x13 + x8 + x7 + x12 + x14
    positive_feeling ~ x10 + x5 + x16 + x13 + x9 + x7 + x2 + x6  + x1 + x12 + x14
    resilience ~ x10 + x5 + x16 + x15 + x13 + x8 + x7 + x2 + x6  + x1 + x12 + x14
'

# Fit the model
path_model.fit <- sem(path_model, data = respondents_data)

# Summary of the model fit
summary(path_model.fit, standardized = TRUE, fit.measures = TRUE)

####################################################################
# Dropping regressions with p_value(>|z|) above 0.3. 

path_model <- '
    functioning =~ y10 +  y4 + y5 + y6 + y8 + y11 + y13 + y14 + y21
    competence =~  y16 + y2 + y15 + y17 + y18
    positive_feeling =~ y7 + y19 + y20  +  y22 + y1
    qol =~ functioning + competence + positive_feeling

    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 
			    

    # Direct paths from media items to QOL components
    functioning ~ x10 + x16 + x15 + x2 + x6 + x12 + x14
    competence ~ x10 + x5 + x13 + x12 + x14
    positive_feeling ~ x10 + x5 + x16 + x13 + x7 + x2 + x6 + x12 + x14
    resilience ~ x10 + x5 + x15 + x13 + x8 + x7 + x2 + x12
'

# Fit the model
path_model.fit <- sem(path_model, data = respondents_data)

# Summary of the model fit
summary(path_model.fit, standardized = TRUE, fit.measures = TRUE)

####################################################################
# Dropping regressions with p_value(>|z|) above 0.2. 

path_model <- '
    functioning =~ y10 +  y4 + y5 + y6 + y8 + y11 + y13 + y14 + y21
    competence =~  y16 + y2 + y15 + y17 + y18
    positive_feeling =~ y7 + y19 + y20  +  y22 + y1
    qol =~ functioning + competence + positive_feeling

    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 
			    

    # Direct paths from media items to QOL components
    functioning ~ x16 + x2 + x14
    competence ~ x5 + x13 + x12
    positive_feeling ~ x5 + x16 + x13 + x7 + x2 
    resilience ~ x5 + x15 + x13 + x8 + x7 + x2
'

# Fit the model
path_model.fit <- sem(path_model, data = respondents_data)

# Summary of the model fit
summary(path_model.fit, standardized = TRUE, fit.measures = TRUE)


####################################################################
# Dropping regressions with p_value(>|z|) above 0.1. 

path_model <- '
    functioning =~ y10 +  y4 + y5 + y6 + y8 + y11 + y13 + y14 + y21
    competence =~  y16 + y2 + y15 + y17 + y18
    positive_feeling =~ y7 + y19 + y20  +  y22 + y1
    qol =~ functioning + competence + positive_feeling
    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 
			    

    # Direct paths from media items to QOL components
    functioning ~ x16 + x2 + x14
    competence ~ x5 + x13 + x12
    positive_feeling ~ x5 + x13 + x7 + x2
    resilience ~ x5 + x13 + x8 + x2
'

# Fit the model
path_model.fit <- sem(path_model, data = respondents_data)

# Summary of the model fit
summary(path_model.fit, standardized = TRUE, fit.measures = TRUE)


####################################################################
# Dropping regressions with p_value(>|z|) above 0.1.
# Adding control variables.

path_model <- '
    functioning =~ y10 +  y4 + y5 + y6 + y8 + y11 + y13 + y14 + y21
    competence =~  y16 + y2 + y15 + y17 + y18
    positive_feeling =~ y7 + y19 + y20  +  y22 + y1
    qol =~ functioning + competence + positive_feeling

    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 
			    

    # Direct paths from media items to QOL components
    functioning ~ x16 + x2 + age
    #functioning ~ x16 + x2 + status
    competence ~ x5 + gender
    positive_feeling ~ x5 + x7 + x2 + gender
    resilience ~ x5 + x13 + x8 + age + gender
'

# Fit the model
path_model.fit <- sem(path_model, data = respondents_data)

# Summary of the model fit
summary(path_model.fit, standardized = TRUE, fit.measures = TRUE)


####################################################################
####################################################################
####################################################################
####################################################################
# support regression p(>|z|) < 0.2

path_model <- '
    functioning =~ y10 +  y4 + y5 + y6 + y8 + y11 + y13 + y14 + y21
    competence =~  y16 + y2 + y15 + y17 + y18
    positive_feeling =~ y7 + y19 + y20  +  y22 + y1
    qol =~ functioning + competence + positive_feeling
    
    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 
			    

    # Direct paths from media items to QOL components
    functioning ~ v2
    competence ~ v3
    resilience ~ v1
'

# Fit the model
path_model.fit <- sem(path_model, data = respondents_data)

# Summary of the model fit
summary(path_model.fit, standardized = TRUE, fit.measures = TRUE)

####################################################################
####################################################################
####################################################################
####################################################################
# stress 

path_model <- '
    functioning =~ y10 +  y4 + y5 + y6 + y8 + y11 + y13 + y14 + y21
    competence =~  y16 + y2 + y15 + y17 + y18
    positive_feeling =~ y7 + y19 + y20  +  y22 + y1
    qol =~ functioning + competence + positive_feeling

    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 
			    

    # Direct paths from media items to QOL components
    functioning ~ u1 + u2 + u3 + u4 + u5 + u6 + u7 + u8 + u9 
    competence ~ u1 + u2 + u3 + u4 + u5 + u6 + u7 + u8 + u9 
    positive_feeling ~ u1 + u2 + u3 + u4 + u5  + u6 + u7 + u8 + u9 
    resilience ~ u1 + u2 + u3 + u4 + u5 + u6 + u7 + u8 + u9 
'

# Fit the model
path_model.fit <- sem(path_model, data = respondents_data)

# Summary of the model fit
summary(path_model.fit, standardized = TRUE, fit.measures = TRUE)


####################################################################
# stress , regressions p(>|z|) < 0.5

path_model <- '
    functioning =~ y10 +  y4 + y5 + y6 + y8 + y11 + y13 + y14 + y21
    competence =~  y16 + y2 + y15 + y17 + y18
    positive_feeling =~ y7 + y19 + y20  +  y22 + y1
    qol =~ functioning + competence + positive_feeling

    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 
			    

    # Direct paths from media items to QOL components
    functioning ~ u1 + u2 + u5 + u8 + u9 
    competence ~ u2 + u4 + u6 + u9 
    positive_feeling ~ u3 + u4 + u9 
    resilience ~ u1 + u7 + u8 + u9 
'

# Fit the model
path_model.fit <- sem(path_model, data = respondents_data)

# Summary of the model fit
summary(path_model.fit, standardized = TRUE, fit.measures = TRUE)


####################################################################
# stress , regressions p(>|z|) < 0.3

path_model <- '
    functioning =~ y10 +  y4 + y5 + y6 + y8 + y11 + y13 + y14 + y21
    competence =~  y16 + y2 + y15 + y17 + y18
    positive_feeling =~ y7 + y19 + y20  +  y22 + y1
    qol =~ functioning + competence + positive_feeling

    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 
			    

    # Direct paths from media items to QOL components
    functioning ~ u2 + u5 + u8 + u9 
    competence ~ u2 + u4 + u6 + u9 
    positive_feeling ~ u3 + u4 + u9 
    resilience ~ u1 + u8
'

# Fit the model
path_model.fit <- sem(path_model, data = respondents_data)

# Summary of the model fit
summary(path_model.fit, standardized = TRUE, fit.measures = TRUE)


####################################################################
# stress , regressions p(>|z|) < 0.2

path_model <- '
    functioning =~ y10 +  y4 + y5 + y6 + y8 + y11 + y13 + y14 + y21
    competence =~  y16 + y2 + y15 + y17 + y18
    positive_feeling =~ y7 + y19 + y20  +  y22 + y1
    qol =~ functioning + competence + positive_feeling

    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 
			    

    # Direct paths from media items to QOL components
    functioning ~ u2 + u8 + u9 
    competence ~ u2 + u4 + u9 
    positive_feeling ~ u4 + u9 
    resilience ~ u1 + u8
'

# Fit the model
path_model.fit <- sem(path_model, data = respondents_data)

# Summary of the model fit
summary(path_model.fit, standardized = TRUE, fit.measures = TRUE)


####################################################################
# stress , regressions p(>|z|) < 0.1

path_model <- '
    functioning =~ y10 +  y4 + y5 + y6 + y8 + y11 + y13 + y14 + y21
    competence =~  y16 + y2 + y15 + y17 + y18
    positive_feeling =~ y7 + y19 + y20  +  y22 + y1
    qol =~ functioning + competence + positive_feeling

    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 
			    

    # Direct paths from media items to QOL components
    functioning ~ u2 + u8
    competence ~ u2 + u4
    positive_feeling ~ u4 + u9 
'

# Fit the model
path_model.fit <- sem(path_model, data = respondents_data)

# Summary of the model fit
summary(path_model.fit, standardized = TRUE, fit.measures = TRUE)


####################################################################
# stress , regressions p(>|z|) < 0.2
# Adding control variables.

path_model <- '
    functioning =~ y10 +  y4 + y5 + y6 + y8 + y11 + y13 + y14 + y21
    competence =~  y16 + y2 + y15 + y17 + y18
    positive_feeling =~ y7 + y19 + y20  +  y22 + y1
    qol =~ functioning + competence + positive_feeling

    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 
			    

    # Direct paths from media items to QOL components
    functioning ~ u2 + u8 + u9
    competence ~ u2 + u9  + gender
    positive_feeling ~ u9  + gender
    resilience ~ u1 + u8 + gender
'

# Fit the model
path_model.fit <- sem(path_model, data = respondents_data)

# Summary of the model fit
summary(path_model.fit, standardized = TRUE, fit.measures = TRUE)




####################################################################
# stress , regressions p(>|z|) < 0.1
# Adding control variables.

path_model <- '
    functioning =~ y10 +  y4 + y5 + y6 + y8 + y11 + y13 + y14 + y21
    competence =~  y16 + y2 + y15 + y17 + y18
    positive_feeling =~ y7 + y19 + y20  +  y22 + y1
    qol =~ functioning + competence + positive_feeling

    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 
			    

    # Direct paths from media items to QOL components
    functioning ~ u2 + u8
    competence ~ u2 + gender
    positive_feeling ~ u9  + gender
'

# Fit the model
path_model.fit <- sem(path_model, data = respondents_data)

# Summary of the model fit
summary(path_model.fit, standardized = TRUE, fit.measures = TRUE)


####################################################################
####################################################################
####################################################################
####################################################################
# media + support + stress

path_model <- '
    functioning =~ y10 +  y4 + y5 + y6 + y8 + y11 + y13 + y14 + y21
    competence =~  y16 + y2 + y15 + y17 + y18
    positive_feeling =~ y7 + y19 + y20  +  y22 + y1
    qol =~ functioning + competence + positive_feeling

    resilience =~ z1 + z2 + z3 + z4 + z5 + z6 + z7 + z8 + z9 + z10 
			    

    # Direct paths from media items to QOL components
    functioning ~ u2 + u8 + x16 + x2
    competence ~ u2 + x5
    positive_feeling ~ u9  + x5 + x7 + x2
    resilience ~ x5 + x13 + x8 + v1
'

# Fit the model
path_model.fit <- sem(path_model, data = respondents_data)

# Summary of the model fit
summary(path_model.fit, standardized = TRUE, fit.measures = TRUE)
