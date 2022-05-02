# Quanteda 29/04/2022
# Define the corpus and the dfm

# Working directory from .Rproj
here::here("")

# Source setup scripts:
source(here::here("src","00_setup.R"))

#-------------------------------------------------------------------

# import the data
tw <- read.csv("data/large_files/TweetPopulite (1).csv", 
               sep = ";", encoding = "utf-8")

# set #N/D as NA
tw_na <- na_if(tw,"#N/D")
# Remove NA
filtered <- tw_na %>% na.omit()
# Remove Retweets
filtered <- filter(filtered, !Tweet %like% "RT")
# Adjust datetime
Sys.setlocale("LC_TIME", "C")
filtered$data <- as.Date(strptime(filtered$CreatoId,"%a %b %d %H:%M:%S %z %Y", tz = "CET"))
# Check the varibles 
colnames(filtered)
# Select variables for the analysis
dataset <- filtered %>% select(Cognome, Nome, Genere, GruppoPolitico, Tweet, data )
colnames(dataset)


#############################################
# CORPUS
# Create the corpus
corpus <- corpus(dataset, text = "Tweet")
ndoc(corpus)
summary(corpus)
head(textstat_summary(corpus))

# Inspect the document level variables
sort(unique(corpus$Cognome))
unique(corpus$data)
unique(corpus$GruppoPolitico)
unique(corpus$Genere)

# subset corpus for signle politician
Meloni <- corpus_subset(corpus, Cognome == "MELONI")
ndoc(Meloni)
Meloni

############################################
# TOKENS

# Split the corpus into single tokens (remain positional)
doc.tokens <- tokens(corpus)

doc.tokens <- tokens(doc.tokens, remove_punct = TRUE, remove_numbers = TRUE)
  
doc.tokens <- tokens_select(doc.tokens, stopwords('italian'), selection='remove')

my_word <- read_csv("data/it_stopwords_new_list.csv", show_col_types = FALSE) #(read.csv with utf-8 fails importing accented words )

my_list <- as.list(my_word)

doc.tokens <- tokens_select(doc.tokens, my_list, selection='remove')

doc.tokens <- tokens_remove(doc.tokens, my_word)

# search keyword in context
View(kwic(doc.tokens, "fa", window = 3))

#######################################
# DFM
# Bag of word approach, non positional

doc.dfm <- dfm(doc.tokens, remove = c(stopwords("italian"),my_list), tolower = T, remove_punct = T, remove_numbers = T)
str(doc.dfm)

# top features
topfeatures(doc.dfm, 10)

#Dfm trimming:only words that occur in the top 20% of the distribution
#             and in less than 30% of documents
#             very frequent but document specific words
doc.dfm <- dfm_trim(doc.dfm, min_termfreq = 0.80, termfreq_type = "quantile",
                                max_docfreq = 0.3, docfreq_type = "prop")
doc.dfm

# top features after trimming
topfeatures(doc.dfm, 10)


# Plot the frequency of the top features in a text using the topfeatures.
features_dfm <- textstat_frequency(doc.dfm, n = 20)
features_dfm
str(features_dfm)

# plot with GGPLOT
ggplot(features_dfm, aes(x = feature, y = frequency)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Create DFM grouping by date
dfm_by_date <- dfm_group(doc.dfm, groups= data)
dfm_grouped

# Create DFM grouping by Cognome
dfm_by_cognome <- dfm_group(doc.dfm, groups= Cognome)
dfm_by_cognome


