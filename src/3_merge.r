#########################
#28/03/2022
#########################
###################################################
# Working directory from .Rproj
here::here("")

# Source setup scripts:-------------------------------------------------------------------
source(here::here("src","00_setup.R"))

# import the data
#tw <- read.csv("data/large_files/TweetPopulite (1).csv", 
#               sep = ";", encoding = "utf-8")#, escape_double = FALSE, trim_ws = TRUE)
tw <- read.csv("data/large_files/estrazione_tweet2020-2022.csv",
               sep = ";", encoding = "utf-8")


View(tw)

colnames(tw)

#set #N/D as NA
tw_na <- na_if(tw,"#N/D")

#remove NA
filtered <- tw_na %>% na.omit()

# remove Retweets
#filtered <- filter(filtered, !Tweet %like% "RT")
filtered <- filter(filtered, !tweet_text %like% "RT")

#Adjust datetime
Sys.setlocale("LC_TIME", "C")

#filtered$data <- as.Date(strptime(filtered$CreatoId,"%a %b %d %H:%M:%S %z %Y", tz = "CET"))
filtered$data <- as.Date(strptime(filtered$creato_il,"%a %b %d %H:%M:%S %z %Y", tz = "CET"))

typeof(filtered$data)

View(filtered)

# FILTER FOR THE NAME OF ONE POLITICIANS
#single_politician <- filter(filtered, Cognome %like% "FRATOIANNI")
single_politician <- filter(filtered, ï..name %like% "MELONI")


# GROUP BY DAY
#Group Tweets by date
#daily <- single_politician %>%
#  group_by(data) %>%
#  summarise(Tweet_uniti = paste(Tweet, collapse = ","))

daily <- single_politician %>%
  group_by(data) %>%
  summarise(Tweet_uniti = paste(tweet_text, collapse = ","))


# Add column with the count of the daily tweets  
#daily$Tweets_num <- (single_politician %>% group_by(data) %>% count())[2]
#daily <- as.data.frame(daily)


# GROUP BY WEEK
# Create the column for the week
#weekly <- single_politician %>%
#  mutate(week = cut.Date(data, breaks = "1 week", labels = FALSE)) %>% 
#  group_by(week) %>%
#  summarise(Tweet_uniti = paste(Tweet, collapse = ","))

weekly <- single_politician %>%
  mutate(week = cut.Date(data, breaks = "1 week", labels = FALSE)) %>% 
  group_by(week) %>%
  summarise(Tweet_uniti = paste(tweet_text, collapse = ","))

#Group Tweets by week
#frat_weekly %>%
#  group_by(week) %>%
#  summarize(date = min(as.Date(data)), ntweets = n())

#frat_weekly <- frat_weekly %>%
#  group_by(week) %>%
#  summarize(Tweet)

# Group by month
#monthly <- single_politician %>%
#  mutate(month = cut.Date(data, breaks = "1 month", labels = FALSE)) %>% 
#  group_by(month) %>%
#  summarise(Tweet_uniti = paste(Tweet, collapse = ","))

monthly <- single_politician %>%
  mutate(month = cut.Date(data, breaks = "1 month", labels = FALSE)) %>% 
  group_by(month) %>%
  summarise(Tweet_uniti = paste(tweet_text, collapse = ","))

monthly_df <- as.data.frame(monthly)

# Check the results
days <- max(single_politician$data) - min(single_politician$data)
days

unique(tw$name)
