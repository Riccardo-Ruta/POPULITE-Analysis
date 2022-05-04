#ALL TEST
###################################################
#test

# create my own function to accorp tweets
unisci <- function(x){
  x <- x %>%
    group_by(data) %>%
    summarise(Tweet = paste(Tweet, collapse = ","))
}

#############################################
for (i in 0:nrow(frat)) {
  frat$test <- paste(frat$Tweet[i])
}

frat$test <- paste(frat$Tweet[i])
#########################################
# FILTER DATA REMOVING MISSING AND RETWEETS
filtered_2 <- filter(tw,  id_pol != "#N/D" &
                       id_tw_user != "#N/D" &
                       id_tweet != "#N/D" &
                       Url != "#N/D" &
                       Cognome != "#N/D" &
                       Nome != "#N/D" &
                       Genere!= "#N/D" &
                       GruppoPolitico != "#N/D" &
                       Tweet != "#N/D" &
                       CreatoId != "#N/D" &
                       CreatoIlCodice!= "#N/D" &
                       !Tweet %like% "RT" )
###############################################
# creazione colonna settimana -- non funziona

frat_daily$period <- frat_daily %>%
  mutate(period = replace(data, data > "2021-07-05" & data < "2021-07-11", 1))

#Group Tweets by period -- non funziona
frat_daily <- frat %>%
  group_by(period) %>%
  summarise(Tweet_uniti = paste(Tweet, collapse = ","))
#################################################
# 03/05/2022

# CREATE DFM FOR SINGLE POLITICIAN using english sentyment dict
politician_dfm <- dfm(politician,
                      dictionary = data_dictionary_LSD2015[1:2])
head(politician_dfm, 10)
summary(politician_dfm)

# RUN SENTIMENT ANALYSIS (THIS IS IN ENGLISH !!!!!)
sentiment <- politician_dfm

Dictionary <- as.data.frame(sentiment)
str(Dictionary )
Dictionary$Sentiment <- Dictionary$posit-Dictionary$negat
str(Dictionary )
summary(Dictionary$Sentiment)

# Let's suppose we want to plot the sentiment vs. the volume
politician_dataset$Sentiment <- Dictionary$Sentiment # add the sentiment values back to the data frame you got via Twitter
colnames(politician_dataset)

# get daily summaries of the results (average sentiments and number of tweets)
daily <- ddply(politician_dataset, ~ data, summarize, num_tweets = length(Sentiment), ave_sentiment = mean(Sentiment  )) 
str(daily)

# correlation between the volume of discussion and sentiment
cor(daily$ave_sentiment, daily$num_tweets)

# plot the daily sentiment vs. volume
sentiment <- ggplot(daily, aes(x=data, y=ave_sentiment)) + geom_line(linetype = "dashed", colour="red") +
  ggtitle("Sentiment") + xlab("Day") + ylab("Sentiment") + theme_gray(base_size = 12)

volume <- ggplot(daily, aes(x=data, y=num_tweets)) + geom_line() +
  ggtitle("Politician #") + xlab("Day") + ylab("Volume") + theme_gray(base_size = 12)

grid.arrange(sentiment , volume , ncol = 1)
#################################################
# 04/05/2022

# Create DFM grouping by date
dfm_by_date <- dfm_group(doc.dfm, groups= date)
dfm_by_date

# Create DFM grouping by Nome
dfm_by_mome <- dfm_group(doc.dfm, groups= nome)
dfm_by_nome

###############################################