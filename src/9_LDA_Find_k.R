#Find the number of topics (k)

# Working directory from .Rproj
here::here("")

# Source setup scripts:
source(here::here("src","00_setup.R"))

# import the data
tw <-  read_csv("data/large_files/politicians_all_final_tweets.csv")

# Adjust datetime (Run code in this order!)
Sys.setlocale("LC_TIME", "C")
tw$date <- as.Date(strptime(tw$creato_il,"%a %b %d %H:%M:%S %z %Y", tz = "CET"))
tw$date <- na.replace(tw$date, as.Date(tw$creato_il))

# Create week variable
tw <- tw %>% mutate(week = cut.Date(date, breaks = "1 week", labels = FALSE))

# Create month variable
tw <- tw %>% mutate(month = cut.Date(date, breaks = "1 month", labels = FALSE))

# Remove missing from tweets column (using remove_na tidyverse)
tw <- tw %>% drop_na(tweet_testo)

# Remove space from genere variable
a <- unique(tw$genere)
tw$genere <- gsub(a[3],"male",tw$genere)

# Select variables for the analysis
dataset <- tw %>% select(nome, tweet_testo, genere, party_id,chamber,status, date, week, month )

corp <- corpus(dataset, text = "tweet_testo")

my_word <- as.list(read_csv("data/it_stopwords_new_list.csv", show_col_types = FALSE)) #read.csv with utf-8 fails importing accented words

my_list <- c("🇮🇹", my_word$stopwords, stopwords('italian'))

rev_dfm <- dfm(corp, remove =c(stopwords("italian"), my_list),
               tolower = TRUE, stem = FALSE, remove_punct = TRUE, remove_numbers=TRUE)

rev_dfm <-   dfm_trim(rev_dfm, min_termfreq = 0.95, termfreq_type = "quantile",
                      max_docfreq = 0.1, docfreq_type = "prop")

dtm <- quanteda::convert(rev_dfm, to = "topicmodels")

## Finding the best K
top_k <- c(10:40)
## let's create an empty data frame
results1 <- data.frame(first=vector(), second=vector(), third=vector()) 
system.time(
  for (i  in top_k) 
  { 
    set.seed(123)
    lda1 <- LDA(dtm, method= "Gibbs", k = (i),  control=list(verbose=50L, iter=1000))
    topic <- (i)
    coherence <- mean(topic_coherence(lda1, dtm))
    exclusivity <- mean(topic_exclusivity(lda1))
    results1 <- rbind(results1 , cbind(topic, coherence, exclusivity ))
  }
)
 #save(results1,file="data/results_k_10-40.Rda")
 
kable(head(results1))
kable(tail(results1))
str(results1)


plot1 <- as.ggplot(~plot(results1$coherence, results1$exclusivity,
                         main="Scatterplot K=10:40",xlab="Semantic Coherence",
                         ylab="Exclusivity ", pch=19,
                         col=ifelse(results1$coherence<=-155.8,"black","red")) +
                     text(results1$coherence, results1$exclusivity,
                          labels=results1$topic, cex= 1,  pos=4))

# ggsave("figs/plot_k_10-40.png", plot = plot1)
plot1
