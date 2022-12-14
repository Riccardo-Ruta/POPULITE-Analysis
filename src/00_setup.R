want <- c("here","quanteda","readr","quanteda.textplots","plyr",
          "dplyr", "tidyverse", "rio", "readtext", "quanteda.textstats",
          "sure", "syuzhet", "tm","wordcloud","readxl","na.tools", "ggplotify",
          "kableExtra", "knitr","ggplot2", "topicmodels","topicdoc", "cowplot",
          "quanteda.textmodels", "tidytext","textdata", "nnet","stm","sjPlot",
          "igraph")  # list of required packages
have <- want %in% rownames(installed.packages())
if ( any(!have) ) { install.packages( want[!have] ) }
rm(have, want)



library("here")
library(quanteda)
library(readr)
library("quanteda.textplots")
library(plyr)
library("dplyr")
library(tidyverse)
library(rio)
library(data.table)
library(readtext)
library(quanteda.textstats)
library(sure)
library(syuzhet)
library(tm)
library(wordcloud)
library(readxl)
library(na.tools)
library(ggplotify)
library(kableExtra)
library(knitr)
library(ggplot2)
library(topicmodels)
library(topicdoc)
library(cowplot)
library(quanteda.textmodels)
library(tidytext)
library(textdata)
library(nnet)
library(stm)
library(sjPlot)
library(igraph)


Sys.setlocale("LC_TIME", "C")