# Dictionary analysis 30/04/2022

# Working directory from .Rproj
here::here("")

# Source setup scripts:
source(here::here("src","00_setup.R"))
# RUN 4_CORPUS.R BEFORE THIS SCRIPT

#-------------------------------------------------------------------

#Preliminar analysis

# Extract most common hashtags
tag_dfm <- dfm_select(doc.dfm, pattern = "#*")
toptag <- names(topfeatures(tag_dfm, 20))
head(toptag)

# Construct feature-occurrence matrix of hashtags
tag_fcm <- fcm(tag_dfm)
head(tag_fcm)

topgat_fcm <- fcm_select(tag_fcm, pattern = toptag)
textplot_network(topgat_fcm, min_freq = 0.1, edge_alpha = 0.8, edge_size = 5)

# Extract most frequently mentioned usernames
user_dfm <- dfm_select(doc.dfm, pattern = "@*")
topuser <- names(topfeatures(user_dfm, 20))
head(topuser)

#Construct feature-occurrence matrix of usernames
user_fcm <- fcm(user_dfm)
head(user_fcm)

user_fcm <- fcm_select(user_fcm, pattern = topuser)
textplot_network(user_fcm, min_freq = 0.1, edge_color = "orange", edge_alpha = 0.8, edge_size = 5)

#-------------------------------------------------------------------
# AFTER RUNNING 4_CORPUS.R SCRIPT FILTER THE DATASET and corpus FOR SINGLE POLITICIAN
politician_dataset <- dataset %>% filter(nome  %like% "MELONI")
politician <- corpus_subset(corpus, nome %like% "MELONI")
ndoc(politician)
politician

#-------------------------------------------------------------------


###################################################
# SYYZHET
# Inspect the dictionary
get_sentiment_dictionary(dictionary = "nrc", language = "italian")

# try usinng syuzhet
system.time(nrc_data <- get_nrc_sentiment(politician_dataset$tweet_testo, language="italian"))
str(nrc_data)

# I want to read the tweets that included a number of anger words > 2
politician_dataset$tweet_testo[nrc_data$anger > 2]

barplot(
  sort(colSums(prop.table(nrc_data[, 1:8]))), 
  horiz = TRUE, 
  cex.names = 0.7, 
  las = 1, 
  main = "Emotions in tweets by Giorgia Meloni", xlab="Percentage"
)

# let's plot the wordcloud of emotions

all <- c(
  paste(politician_dataset$tweet_testo[nrc_data$anger > 0], collapse=" "),
  paste(politician_dataset$tweet_testo[nrc_data$anticipation > 0], collapse=" "),
  paste(politician_dataset$tweet_testo[nrc_data$disgust > 0], collapse=" "),
  paste(politician_dataset$tweet_testo[nrc_data$fear > 0], collapse=" "),
  paste(politician_dataset$tweet_testo[nrc_data$joy > 0], collapse=" "),
  paste(politician_dataset$tweet_testo[nrc_data$sadness > 0], collapse=" "),
  paste(politician_dataset$tweet_testo[nrc_data$surprise > 0], collapse=" "),
  paste(politician_dataset$tweet_testo[nrc_data$trust > 0], collapse=" ")
)

str(all)

# clean the text

# function to make the text suitable for analysis
clean.text = function(x)
{
  # tolower
  x = tolower(x)
  # remove rt
  x = gsub("rt", "", x)
  # remove at
  x = gsub("@\\w+", "", x)
  # remove punctuation
  x = gsub("[[:punct:]]", "", x)
  # remove numbers
  x = gsub("[[:digit:]]", "", x)
  # remove links http
  x = gsub("http\\w+", "", x)
  # remove tabs
  x = gsub("[ |\t]{2,}", "", x)
  # remove blank spaces at the beginning
  x = gsub("^ ", "", x)
  # remove blank spaces at the end
  x = gsub(" $", "", x)
  return(x)
}

all <- clean.text(all)

# remove stop-words
all <- removeWords(all,  c(stopwords("italian"), my_list))

# create corpus
corpus_viz <- Corpus(VectorSource(all))

# create term-document matrix
tdm <- TermDocumentMatrix(corpus_viz)

# convert as matrix
tdm <- as.matrix(tdm)

# add column names
colnames(tdm) <- c('anger', 'anticipation', 'disgust', 'fear', 'joy', 'sadness', 'surprise', 'trust')

# Plot comparison wordcloud
layout(matrix(c(1, 2), nrow=2), heights=c(1, 4))
par(mar=rep(0, 4))
plot.new()
text(x=0.5, y=0.5, 'Emotion Comparison Word Cloud for tweets from Giorgia Meloni')
comparison.cloud(tdm, random.order=FALSE,
                 colors = c("#00B2FF", "red", "#FF0099", "#6600CC", "green", "orange", "blue", "brown"),
                 title.size=1.5, max.words=250)

##########################################################
# Populism dictionary analysis

# select the right corpus and create the DFM
DFM <- dfm(tokens(corpus,  remove_punct = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove_url = TRUE), remove = my_list)

DFM_trimmed <- dfm_trim(DFM, min_termfreq = 0.80, termfreq_type = "quantile",
                        max_docfreq = 0.3, docfreq_type = "prop")

# Daily Dictionary analysis with Decadri_Boussalis_dict on the whole dataset
dfm_dict1  <- dfm_lookup(DFM_trimmed, dictionary = Decadri_Boussalis_dict)
# Group by date
dfm_by_date1 <- dfm_group(dfm_dict1, groups= date)
dfm_by_date1
# Group by week
dfm_by_week <- dfm_group(dfm_dict1, groups= week)
dfm_by_week
# Group by month
dfm_by_month <- dfm_group(dfm_dict1, groups= month)
dfm_by_month


# Daily Dictionary analysis with Roodujin_dict on the whole dataset
dfm_dict2  <- dfm_lookup(DFM_trimmed, dictionary = Roodujin_dict)
# Group by date
dfm_by_date2 <- dfm_group(dfm_dict2, groups= date)
dfm_by_date2
# Group by week
dfm_by_week2 <- dfm_group(dfm_dict2, groups= week)
dfm_by_week2
# Group by month
dfm_by_month2 <- dfm_group(dfm_dict2, groups= month)
dfm_by_month2


# ### MELONI ####
# select the right corpus and create the DFM
meloni_DFM <- dfm(tokens(Meloni,  remove_punct = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove_url = TRUE), remove = my_list)

meloni_DFM_trimmed <- dfm_trim(DFM, min_termfreq = 0.80, termfreq_type = "quantile",
                        max_docfreq = 0.3, docfreq_type = "prop")

# Daily Dictionary analysis with Decadri_Boussalis_dict
dfm_dict1  <- dfm_lookup(meloni_DFM_trimmed, dictionary = Decadri_Boussalis_dict)
dfm_dict1
# Group by date
dfm_by_date1 <- dfm_group(dfm_dict1, groups= date)
dfm_by_date1
# Group by week
dfm_by_week <- dfm_group(dfm_dict1, groups= week)
dfm_by_week
# Group by month
dfm_by_month <- dfm_group(dfm_dict1, groups= month)
dfm_by_month

# Daily Dictionary analysis with Roodujin_dict on the whole dataset
dfm_dict2  <- dfm_lookup(meloni_DFM_trimmed, dictionary = Roodujin_dict)
dfm_dict2
# Group by date
dfm_by_date2 <- dfm_group(dfm_dict2, groups= date)
dfm_by_date2
# Group by week
dfm_by_week2 <- dfm_group(dfm_dict2, groups= week)
dfm_by_week2
# Group by month
dfm_by_month2 <- dfm_group(dfm_dict2, groups= month)
dfm_by_month2



