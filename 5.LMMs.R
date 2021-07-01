library(lme4)
library(lmerTest)
library(repmis)

#download data files from Github and set a working directory
#################Question 1 & 2#########################
#load("/Users/danpapag/Desktop/GitHub_code/ddf_hr_dtd.Rdata")

#' Reproduecs Supplementary Table 2. Results of the LMM for the core home range size 50% and its response to seasonality.
#'  Reference level of season type is set to dry.
m <- lmer(df$AREA_SQM ~ df$season_type + scale(df$days_tracked) + (1|df$groupss_))
anova(m)
summary(m)

#' Reproduces Supplementary Table 3. Results of the LMM for home range size 95% and its response to seasonality. 
#' Reference level of season type is set to dry.
m <- lmer(df$AREA_95 ~ df$season_type + scale(df$days_tracked) + (1|df$groupss_))
anova(m)
summary(m)

#' Reproduces Supplementary Table 7. Results of the LMM, in which we added the number of individuals tracked in each group in
#' each season as a predictor for home range, alongside with the fixed and random effects of the LMM presented in 
#' Supplementary Table 2. 
#' We found that the number of individuals tracked in each group was not a significant predictor of home range size.
#' Reference level of season type is set to dry.
p <- data.frame(table(paste(df$season_, df$groupss_)))
df$ids_per_group_per_season <- p$Freq[match(paste(df$season_, df$groupss_), p$Var1)]

m <- lmer(df$AREA_SQM ~ df$season_type + scale(df$days_tracked) + (1|df$groupss_) 
           + df$ids_per_group_per_season)
anova(m)
summary(m)


#' Reproduces Supplementary Table 4. Results of the LMM for daily travel distance and its response to seasonality. 
#' Reference level of season type is set to dry.
m <- lmer(df$speed_km_day ~ df$season_type + scale(df$days_tracked) + (1|df$groupss_))
anova(m)
summary(m)

#################Question 3#########################

#load("/Users/danpapag/Desktop/GitHub_code/df_dhor.Rdata")

#' Reproduces Supplementary Table 5. Results of the LMM for day-to-day site fidelity 
#' and its response to seasonality. Reference level of season type is set to dry seasons.
df_<-df[!is.na(df$fidelity),]
m <- lmer(df_$fidelity ~ df_$season_type + scale(df_$days_tracked) + (1|df_$groupss_)) #+ (1|df_$season))
anova(m)
summary(m)

#################Question 4#########################

#load("/Users/danpapag/Desktop/GitHub_code/df_dshor.Rdata")

#' Reproduces Supplementary Table 6. Results of the LMM for seasonal range overlap
#' and its response to seasonality. Reference level of season type is set to the overlap between two dry seasons.

m <- lmer(df_years12$Overlap ~ df_years12$season_types + (1|df_years12$groupss_)) #+ (1|df_years12$year_season))
anova(m)
summary(m)






