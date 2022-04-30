# Dictionary analysis 30/04/2022

# Working directory from .Rproj
here::here("")

# Source setup scripts:
source(here::here("src","00_setup.R"))

#-------------------------------------------------------------------
# Check the context of the words in the dictionary
kwic(toks, dict_newsmap["AFRICA"])

test <- dfm(doc.dfm, dictionary = Decadri_Boussalis_dict)
summary(test)
