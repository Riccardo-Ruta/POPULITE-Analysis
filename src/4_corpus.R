# Quanteda 29/04/2022
# Define the corpus and the dfm

# Working directory from .Rproj
here::here("")

# Source setup scripts:
source(here::here("src","00_setup.R"))

#-------------------------------------------------------------------

# import the data
#tw <- read.csv("data/large_files/politicians_all_final_tweets.csv", 
 #              sep = ",", encoding = "utf-8")

tw <-  read_csv("data/large_files/politicians_all_final_tweets.csv") # with this extraction read_csv works better with accent
colnames(tw)

# set #N/D as NA
tw <- na_if(tw,"#N/D")
tw <- na_if(tw_na, "")

# Adjust datetime (Run code in this order!)
Sys.setlocale("LC_TIME", "C")
tw$date <- as.Date(strptime(tw$creato_il,"%a %b %d %H:%M:%S %z %Y", tz = "CET"))
tw$date <- na.replace(tw$date, as.Date(tw$creato_il))

# check dates
check_dates <- tw %>% select(creato_il,date)

# Remove NA
#filtered <- tw %>% na.omit()

# Check the variables 
colnames(tw)

# Select variables for the analysis
dataset <- tw %>% select(nome, tweet_testo, genere, party_id,chamber,status, date )
colnames(dataset)


#############################################
# CORPUS
# Create the corpus
corpus <- corpus(dataset, text = "tweet_testo")
ndoc(corpus)
summary(corpus)
head(textstat_summary(corpus))

# Inspect the document level variables
sort(unique(corpus$nome))
unique(corpus$date)
unique(corpus$party_id)
unique(corpus$genere)

# subset corpus for signle politician
Meloni <- corpus_subset(corpus, nome %like% "MELONI")
ndoc(Meloni)
Meloni

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
# DFM
# Bag of word approach, non positional

# Create dfm
doc.dfm <- dfm(doc.tokens,tolower = T)

# top features
topfeatures(doc.dfm, 20)

#Dfm trimming:only words that occur in the top 20% of the distribution
#             and in less than 30% of documents
#             very frequent but document specific words
doc.dfm <- dfm_trim(doc.dfm, min_termfreq = 0.80, termfreq_type = "quantile",
                                max_docfreq = 0.3, docfreq_type = "prop")
doc.dfm

# top features after trimming
topfeatures(doc.dfm, 20)


# Plot the frequency of the top features in a text using the topfeatures.
system.time(features_dfm <- textstat_frequency(doc.dfm, n = 20))
features_dfm
str(features_dfm)

# plot with GGPLOT
ggplot(features_dfm, aes(x = feature, y = frequency)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Create DFM grouping by date
dfm_by_date <- dfm_group(doc.dfm, groups= date)
dfm_by_date

# Create DFM grouping by Nome
dfm_by_mome <- dfm_group(doc.dfm, groups= nome)
dfm_by_nome


