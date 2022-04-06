#########################
#28/03/2022
#########################
###################################################
# Working directory from .Rproj
here::here("")

# Source setup scripts:-------------------------------------------------------------------
source(here::here("src","00_setup.R"))

# import the data
tw <- read.csv("data/large_files/TweetPopulite (1).csv", 
               sep = ";", encoding = "utf-8")#, escape_double = FALSE, trim_ws = TRUE)
View(tw)

colnames(tw)

#set #N/D as NA
tw_na <- na_if(tw,"#N/D")

#remove NA
filtered <- tw_na %>% na.omit()

# remove Retweets
filtered <- filter(filtered, !Tweet %like% "RT")


#Adjust datetime
Sys.setlocale("LC_TIME", "C")

filtered$data <- as.Date(strptime(filtered$CreatoId,"%a %b %d %H:%M:%S %z %Y", tz = "CET"))

typeof(filtered$data)

View(filtered)

# FILTER FRATOIANNI DATA
frat <- filter(filtered, Cognome %like% "FRATOIANNI")

#Filter for a specific date 
frat_11_28 <- filter(frat, data %like% "11-28")

#Group Tweets by date
frat_daily <- frat %>%
  group_by(data) %>%
  summarise(Tweet_uniti = paste(Tweet, collapse = ","))

#Add column with the count of the daily tweets  
frat_daily$Tweets_num <- (frat %>% group_by(data) %>% count())[2]
frat_daily <- as.data.frame(frat_daily)
View(frat_daily)

# Create the column for the week

frat_daily$period <- frat_daily %>%
  mutate(period = replace(data, data > 2021-07-05 & data < 2021-07-11, 1))

# Cretae the column for the week test

test <- frat %>%
  group_by(year = year(date), week = week(date)) %>%
  summarise_if(is.numeric, sum)

#Group Tweets by period
frat_daily <- frat %>%
  group_by(period) %>%
  summarise(Tweet_uniti = paste(Tweet, collapse = ","))










