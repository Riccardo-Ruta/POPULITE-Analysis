# Dictionary analysis 30/04/2022

# Working directory from .Rproj
here::here("")

# Source setup scripts:
source(here::here("src","00_setup.R"))

##########################################################
# RUN 4_CORPUS.R BEFORE THIS SCRIPT

# Populism dictionary analysis

# select the right corpus and create the DFM
DFM <- dfm(tokens(corpus,  remove_punct = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove_url = TRUE), remove = my_list)

DFM_trimmed <- dfm_trim(DFM, min_termfreq = 0.80, termfreq_type = "quantile",
                        max_docfreq = 0.3, docfreq_type = "prop")

############################
# Decadri_Boussalis_Grundl #
############################

# Daily Dictionary analysis with Decadri_Boussalis_Grundl on the whole dataset
dfm_dict1  <- dfm_lookup(DFM_trimmed, dictionary = Decadri_Boussalis_Grundl)
# Group by date
dfm_by_date1 <- dfm_group(dfm_dict1, groups= date)
dfm_by_date1
# Group by week
dfm_by_week1 <- dfm_group(dfm_dict1, groups= week)
dfm_by_week1
# Group by month
dfm_by_month1 <- dfm_group(dfm_dict1, groups= month)
dfm_by_month1


############################
# Rooduijn_Pauwels_Italian #
############################

# Daily Dictionary analysis with Roodujin_dict on the whole dataset
dfm_dict2  <- dfm_lookup(DFM_trimmed, dictionary = Rooduijn_Pauwels_Italian)
# Group by date
dfm_by_date2 <- dfm_group(dfm_dict2, groups= date)
dfm_by_date2
# Group by week
dfm_by_week2 <- dfm_group(dfm_dict2, groups= week)
dfm_by_week2
# Group by month
dfm_by_month2 <- dfm_group(dfm_dict2, groups= month)
dfm_by_month2


############################
#  Grundl_Italian_adapted  #
############################

# Daily Dictionary analysis with Roodujin_dict on the whole dataset
dfm_dict3  <- dfm_lookup(DFM_trimmed, dictionary = Grundl_Italian_adapted)
# Group by date
dfm_by_date3<- dfm_group(dfm_dict3, groups= date)
dfm_by_date3
# Group by week
dfm_by_week3 <- dfm_group(dfm_dict3, groups= week)
dfm_by_week3
# Group by month
dfm_by_month3 <- dfm_group(dfm_dict3, groups= month)
dfm_by_month3


############################
#    Decadri_Boussalis     #
############################

# Daily Dictionary analysis with Roodujin_dict on the whole dataset
dfm_dict4  <- dfm_lookup(DFM_trimmed, dictionary = Decadri_Boussalis)
# Group by date
dfm_by_date4<- dfm_group(dfm_dict4, groups= date)
dfm_by_date4
# Group by week
dfm_by_week4 <- dfm_group(dfm_dict4, groups= week)
dfm_by_week4
# Group by month
dfm_by_month4 <- dfm_group(dfm_dict4, groups= month)
dfm_by_month4


############################
#      my_dictionary      #
############################

# Daily Dictionary analysis with Roodujin_dict on the whole dataset
dfm_dict5  <- dfm_lookup(DFM_trimmed, dictionary = my_dictionary)
# Group by date
dfm_by_date5<- dfm_group(dfm_dict5, groups= date)
dfm_by_date5
# Group by week
dfm_by_week5 <- dfm_group(dfm_dict5, groups= week)
dfm_by_week5
# Group by month
dfm_by_month5 <- dfm_group(dfm_dict5, groups= month)
dfm_by_month5

#################
# VISULIZATIONS #
#################



