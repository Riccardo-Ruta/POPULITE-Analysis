want <- c("here","quanteda","readr","quanteda.textplots","dplyr", "tidyverse", "rio")  # list of required packages
have <- want %in% rownames(installed.packages())
if ( any(!have) ) { install.packages( want[!have] ) }
rm(have, want)



library("here")
library(quanteda)
library(readr)
library("quanteda.textplots")
library("dplyr")
library(tidyverse)
library(rio)
library(data.table)
