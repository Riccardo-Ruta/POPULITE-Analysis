want <- c("here","quanteda","readr","quanteda.textplots",
          "dplyr", "tidyverse", "rio", "readtext", "quanteda.textstats",
          "plyr", "sure", "syuzhet", "tm","wordcloud")  # list of required packages
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
library(readtext)
library(quanteda.textstats)
library(plyr)
library(sure)
library(syuzhet)
library(tm)
library(wordcloud)
