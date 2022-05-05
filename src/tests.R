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
#05/05/2022
# useless part of 1_dict_analysis.R

#import tweets
tw <- read_delim("data/tweets.csv",
                 delim = ";",
                 escape_double = FALSE,
                 col_types = cols(id = col_character()),
                 trim_ws = TRUE)

View(tw)
unique(tw[1])

#------------------------------
# try subset using regex
df <- fread("data/tweets.csv")
subset <- df[id %like% "1450"]
summary(subset)
subset
#------------------------------
# create the CORPUS
tw_corpus <- corpus(tw, text_field = "tweet_text")
summary(tw_corpus)

# number of documents
ndoc(tw_corpus)

# inspect the document-level variables
head(docvars(tw_corpus))
tw_corpus

#------------------------------
# Some cleaning
tw_corpus <- tokens(tw_corpus, remove_punct = T, remove_numbers = T, remove_url = T) # remove punct, numb and links
tw_corpus <- tokens_select(tw_corpus, stopwords('it'), selection = 'remove') # remove italian stopwords
tw_corpus <- tokens_wordstem(tw_corpus) # stemming
tw_corpus <- tokens_tolower(tw_corpus) # standardizes lower

summary(tw_corpus)

#------------------------------
#convert tokenized tweets in dfm
tw_dfm <- dfm(tw_corpus,remove = c(stopwords("it"), ("+"), ("<"), (">"), ("00*"), (":"),(","),("?"),("."),("�")))
tw_dfm

topfeatures(tw_dfm, 5)
#--------------
Roodujin <- list(populism_dictionaries[1])
Groundi <- list(populism_dictionaries[2])
Roodujin <- list(populism = populism_dictionaries[1])
Groundi <- list(populism = populism_dictionaries[2])
Decadri <-  list(populism = populism_dictionaries[3])
#----------------------
#create the dictionary
Roodujin_dict <- dictionary(Roodujin)
Groundi_dict <- dictionary(Groundi)
Decadri_dict <- dictionary(Decadri)
#--------------
# create my own dictionary

Roodujin_dict <- dictionary(list(populism = c("antidemocratic*", "casta", "consens*", "corrot*", "disonest*", "elit*", "establishment",
                                              "ingann*", "mentir*", "menzogn*", "partitocrazia", "propagand*", "scandal*", "tradim*",
                                              "tradir*", "tradit*", "vergogn*", "verita")))

Decadri_Boussalis_dict <- dictionary(list( people = c("abitant*", "cittadin*","consumator*","contribuent*","elettor*","gente","popol*",
                                                      "popolazion*", "uomo della strada","comun* mortal*","italiano medio", "uomo medio"),
                                           Common_Will = c("senso comune","buon senso","plebescitar*","referendum","plebiscito",
                                                           "petizione","democrazia diretta","volonta popolare","voto popolare",
                                                           "sovranita popolare","mandato popolare"),
                                           elite = c("antidemocratic*","casta","consens*","corrot*","disonest*","elit*","establishment",
                                                     "ingann*","mentir*","menzogn*","partitocrazia","propagand*","scandal*","tradim*",
                                                     "tradir*","tradit*","vergogn*","verita","presuntuos*","spocchios*","spocchia",
                                                     "puzza sotto il naso", "senso di superiorita","politicant*","paternalistic*",
                                                     "pezz* gross*","burocrat*","torre d avorio","solit* partit*", "vecch* partit*",
                                                     "corruzione","avid*","raccomandati","arrogant*","attaccat* all* poltron*",
                                                     "assetat* di potere","manipolare","nomenklatura","professoron*",
                                                     "bugie dei partiti", "falsita dei partiti","mazzett*","mercanteggiamenti",
                                                     "pseudo-partit*","baron*","autocratic*","sistema-partito","tecnocrat*",
                                                     "altezzos*","non democratic*","prendere in giro","bullarsi di",
                                                     "clientelismo","dittatur* di partito","teatro politico","banchier*",
                                                     "cosiddett* giornalist*"," cosiddetti media","lobbist*")))
summary(Decadri_Boussalis_dict)
print(Decadri_Boussalis_dict)
#---------------------------------

# Made the anlysis on a subset

recent_corpus <- corpus_subset(tw_corpus,  like > 2)
summary(recent_corpus)
recent_corpus
byPresMat <- dfm(recent_corpus, dictionary = Decadri_Boussalis_dict)
byPresMat
summary(byPresMat)

#------------------------------
# 2) new Test 07/03/2022
#import tweets
tweets <- read_delim("data/tweets.csv", delim = ";", 
                     escape_double = FALSE, col_types = cols(id = col_character()), 
                     trim_ws = TRUE)
summary(tweets)

#tweets <- tweets[2]
summary(tweets)

#create corpus
doc.corpus <- corpus(tweets)
doc.corpus <- corpus(tweets,text_field = "tweet_text")
head(doc.corpus)

# inspect the document-level variables
head(docvars(doc.corpus))

#tokenize and transform into dfm
tweet_dfm <- tokens(doc.corpus, remove_punct = TRUE,remove_numbers = T, remove_url = T) %>%
  dfm(remove = c(stopwords("it"), ("+"), ("<"), (">"), ("00*"), (":"),(","),("?"),("."),("�"),("rt"),("pi")),
      tolower = TRUE, stem = TRUE)
head(tweet_dfm)

tweet_dfm <-dfm_trim(tweet_dfm, min_docfreq = 2, verbose=TRUE)

########################################
# import tweets
#df <- read.csv("data/large_files/dataset_excell.csv",
#              sep = ";",
#             encoding = "utf-8")


# count NA observation for each variable [PROBABòY NOT WORKING]
for (i in colnames(df)) {
  print(paste(i, "-->", sum(is.na(df$i))))
}

# count missing observation not set as NA
sum(df=="")

# count missing observation for each variable [NOT WORKING]
for (i in colnames(df)) {
  print(i)
  print(sum(df$i==""))
}

# create the script for hard coded count of missing
for (i in colnames(df)) {
  print(paste("sum(df$",i,"=='')",sep= ""))
}

# count missing for each variable hard coded
sum(df$ï..name =='')
sum(df$tweet_text =='')
sum(df$creato_il =='')
sum(df$creato_il_code =='')
sum(df$url =='')
sum(df$tw_screen_name =='')
sum(df$party_id =='')
sum(df$gender =='')
sum(df$X =='')

# create the script for hard coded length
for (i in colnames(df)) {
  print(paste("length(df$",i,")",sep= ""))
}

# length of each variable hard coded
length(df$ï..name)
length(df$tweet_text)
length(df$creato_il)
length(df$creato_il_code)
length(df$url)
length(df$tw_screen_name)
length(df$party_id)
length(df$gender)
length(df$X)

# Count the number of politicians with at least one tweets missing
df %>% filter(tweet_text== "") %>% distinct(ï..name) %>% count()
#######################################################
# 05/05/2022

# set #N/D as NA
tw <- na_if(tw,"#N/D")
tw <- na_if(tw_na, "")