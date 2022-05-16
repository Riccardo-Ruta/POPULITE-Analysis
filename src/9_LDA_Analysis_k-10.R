# LDA Analysis k = 10
here::here("")
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

# Create the corpus
corp <- corpus(dataset, text = "tweet_testo")

# Create the Dfm removing stopwords and trimming
my_word <- as.list(read_csv("data/it_stopwords_new_list.csv", show_col_types = FALSE)) #read.csv with utf-8 fails importing accented words

my_list <- c("🇮🇹","<U+0001F534>","", "c'è","+", my_word$stopwords, stopwords('italian'))

rev_dfm <- dfm(tokens(corp,  remove_punct = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove_url = TRUE), remove = my_list)

rev_dfm <-   dfm_trim(rev_dfm, min_termfreq = 0.95, termfreq_type = "quantile",
                      max_docfreq = 0.1, docfreq_type = "prop")
#rev_dfm <- dfm_group(rev_dfm, groups= month)

#  Convert the Document Feature Matrix (Dfm) in a Topic Model (Dtm)
dtm <- quanteda::convert(rev_dfm, to = "topicmodels")

# Run the analysis with k = 10
system.time(lda_k_10 <- LDA(dtm, method= "Gibbs", k = 10, control = list(seed = 123)))
# save(lda_k_10, file = "data/lda_k_10.Rda")

terms <- get_terms(lda_k_10, 10)
dt1 <- terms[,1:10]

knitr::kable(dt1, col.names = c("Top terms 01","Top terms 02","Top terms 03",
                                "Top terms 04","Top terms 05","Top terms 06","Top terms 07","Top terms 08","Top terms 09","Top terms 10"))%>%
  kable_styling(latex_options = "scale_down")