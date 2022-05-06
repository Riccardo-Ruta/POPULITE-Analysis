# Quanteda 29/04/2022
# Define the corpus and the dfm

# Working directory from .Rproj
here::here("")

# Source setup scripts:
source(here::here("src","00_setup.R"))

#-------------------------------------------------------------------

# import the data
tw <-  read_csv("data/large_files/politicians_all_final_tweets.csv") # with this extraction read_csv works better with accent
colnames(tw)

# Adjust datetime (Run code in this order!)
Sys.setlocale("LC_TIME", "C")
tw$date <- as.Date(strptime(tw$creato_il,"%a %b %d %H:%M:%S %z %Y", tz = "CET"))
tw$date <- na.replace(tw$date, as.Date(tw$creato_il))

# check dates
check_dates <- tw %>% select(creato_il,date)
view(check_dates)

# Create week variable
tw <- tw %>% mutate(week = cut.Date(date, breaks = "1 week", labels = FALSE))
# Check the results
difftime(max(tw$date), min(tw$date), units = "weeks")

# Create month variable
tw <- tw %>% mutate(month = cut.Date(date, breaks = "1 month", labels = FALSE))
max(tw$month)

# check the results
length(seq(from = min(tw$date), to = max(tw$date), by = 'month'))

# Remove missing from tweets column (using remove_na tidyverse)
sum(is.na(tw$tweet_testo))
tw <- tw %>% drop_na(tweet_testo)

# Check the variables 
colnames(tw)

# Check single variable content
unique(tw$party_id)
unique(tw$genere)
unique(tw$chamber)
unique(tw$status)

# Remove space from genere variable [RUN ONLY ONCE!]
a <- unique(tw$genere)
a[3]
which(tw$genere == a[3])
tw$genere <- gsub(a[3],"male",tw$genere)

# check result
which(tw$genere == a[3])
unique(tw$genere)

# Select variables for the analysis
dataset <- tw %>% select(nome, tweet_testo, genere, party_id,chamber,status, date, week, month )
colnames(dataset)


#############################################
# CORPUS
# Create the corpus
corpus <- corpus(dataset, text = "tweet_testo")
ndoc(corpus)
summary(corpus)
system.time(head(textstat_summary(corpus)))

# Inspect the document level variables
sort(unique(corpus$nome))
unique(corpus$date)
unique(corpus$party_id)
unique(corpus$genere)

############################################
# TOKENS

# Split the corpus into single tokens (remain positional)
system.time(doc.tokens <- tokens(corpus, remove_punct = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove_url = TRUE))

my_word <- as.list(read_csv("data/it_stopwords_new_list.csv", show_col_types = FALSE)) #read.csv with utf-8 fails importing accented words

my_list <- c("🇮🇹", my_word$stopwords, stopwords('italian'))

doc.tokens <- tokens_select(doc.tokens, my_list, selection='remove')

# search some stopwords for check
kwic(doc.tokens, "fa", window = 3)

#######################################



