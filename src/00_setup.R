want <- c("here","quanteda","readr","quanteda.textplots")  # list of required packages
have <- want %in% rownames(installed.packages())
if ( any(!have) ) { install.packages( want[!have] ) }
rm(have, want)



library("here")
library(quanteda)
library(readr)
library("quanteda.textplots")
