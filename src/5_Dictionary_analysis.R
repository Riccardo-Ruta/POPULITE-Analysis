# Dictionary analysis 30/04/2022

# Working directory from .Rproj
here::here("")

# Source setup scripts:
source(here::here("src","00_setup.R"))

#-------------------------------------------------------------------
# Check the context of the words in the dictionary
kwic(toks, dict_newsmap["AFRICA"])

# AFTER RUNNING 4_CORPUS.R SCRIPT FILTER THE DATASET and corpus FOR SINGLE POLITICIAN
politician_dataset <- dataset %>% filter(Cognome %like% "MELONI")
politician <- corpus_subset(corpus, Cognome == "MELONI")
ndoc(politician)
politician

# CREATE DFM FOR SINGLE POLITICIAN
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

###################################################

# try usinng syuzhet
nrc_data <- get_nrc_sentiment(politician_dataset$Tweet, language="italian")
str(nrc_data)

# I want to read the tweets that included a number of anger words>2
politician_dataset$Tweet[nrc_data$anger > 2]

barplot(
  sort(colSums(prop.table(nrc_data[, 1:8]))), 
  horiz = TRUE, 
  cex.names = 0.7, 
  las = 1, 
  main = "Emotions in tweets from selected politician", xlab="Percentage"
)

# let's plot the wordcloud of emotions

all = c(
  paste(politician_dataset$Tweet[nrc_data$anger > 0], collapse=" "),
  paste(politician_dataset$Tweet[nrc_data$anticipation > 0], collapse=" "),
  paste(politician_dataset$Tweet[nrc_data$disgust > 0], collapse=" "),
  paste(politician_dataset$Tweet[nrc_data$fear > 0], collapse=" "),
  paste(politician_dataset$Tweet[nrc_data$joy > 0], collapse=" "),
  paste(politician_dataset$Tweet[nrc_data$sadness > 0], collapse=" "),
  paste(politician_dataset$Tweet[nrc_data$surprise > 0], collapse=" "),
  paste(politician_dataset$Tweet[nrc_data$trust > 0], collapse=" ")
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

all = clean.text(all)
# remove stop-words
all = removeWords(all,  c(stopwords("italian")))
# create corpus
corpus_viz = Corpus(VectorSource(all))
# create term-document matrix
tdm = TermDocumentMatrix(corpus_viz)
# convert as matrix
tdm = as.matrix(tdm)
# add column names
colnames(tdm) = c('anger', 'anticipation', 'disgust', 'fear', 'joy', 'sadness', 'surprise', 'trust')

# Plot comparison wordcloud
layout(matrix(c(1, 2), nrow=2), heights=c(1, 4))
par(mar=rep(0, 4))
plot.new()
text(x=0.5, y=0.5, 'Emotion Comparison Word Cloud for tweets from selected politician')
comparison.cloud(tdm, random.order=FALSE,
                 colors = c("#00B2FF", "red", "#FF0099", "#6600CC", "green", "orange", "blue", "brown"),
                 title.size=1.5, max.words=250)
##########################################################


