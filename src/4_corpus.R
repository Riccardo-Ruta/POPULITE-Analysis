# Quanteda 29/04/2022
# define the corpus and the dfm

# check the varibles 
colnames(weekly_df)

#create the corpus
corpus <- corpus(weekly_df, text = "Tweet_uniti")
summary(corpus)

# search keyword in context
View(kwic(doc.tokens, "italiani", window = 3))

# Split the corpus into single tokens (remain positional)
doc.tokens <- tokens(corpus)

doc.tokens <- tokens(doc.tokens, remove_punct = TRUE, remove_numbers = TRUE)
  
doc.tokens <- tokens_select(doc.tokens, stopwords('italian'),selection='remove')

my_word <- read.csv("data/it_stopwords_new_list.csv", encoding = "utf-8")

doc.tokens <- tokens_remove(doc.tokens, my_word)

# Bag of word approach, non positional
doc.dfm <- dfm(doc.tokens)

# top features
topfeatures(doc.dfm.final, 10)

