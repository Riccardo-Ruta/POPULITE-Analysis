#TEXT ANALYSIS
#create the corpus
tweets_corpus <- corpus(tweets, text_field = "text")

summary(tweets_corpus)
#getting the type, the tokens, the number of sentences

#docvars
head(docvars(tweets_corpus))

#number of tokens per doc 
ntoken(tweets_corpus)
tweets_tokens <- tokens(tweets_corpus)

#subset corpus per party
tweets_lega <- summary(corpus_subset(tweets_corpus, party == 'lega nord'))

#subset corpus per politician
tweets_salvini <- summary(corpus_subset(tweets_corpus, name == 'SALVINI'))

#explore corpus text
#1) corpus containing the pattern "immigrati" and similar
kwic(tweets_tokens, pattern = "immigrati")
#2) corpus containing the pattern "migr", so including different words
kwic(tweets_tokens, pattern = "migr", valuetype = "regex")
#3) exploring a corpus with two words in it
kwic(tweets_tokens, pattern = phrase("casa loro")) %>%
  head()
#4) corpus containing the pattern "Covid" and similar
kwic(tweets_tokens, pattern = "Covid")
