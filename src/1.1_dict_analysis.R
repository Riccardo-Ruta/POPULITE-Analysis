
###################################################
# Working directory from .Rproj
here::here("")

# Source setup scripts:-------------------------------------------------------------------
source(here::here("src","00_setup.R"))

# A <- filter(frat_daily,Tweets_num > 5)

# B <- A %>% select(data,Tweet_uniti)



# create the CORPUS
tw_corpus <- corpus(single_politician, text_field = "Tweet_uniti")
summary(tw_corpus)

# number of documents
ndoc(tw_corpus)

# inspect the document-level variables
head(docvars(tw_corpus))
tw_corpus



# tokenize

# tweet_dfm <- tokens(tw_corpus, remove_punct = TRUE,remove_numbers = T, remove_url = T) %>%
#   dfm(remove = c(stopwords("it"), ("+"), ("<"), (">"), ("00*"), (":"),(","),("?"),("."),("�"),("rt"),("pi")),
#       tolower = TRUE, stem = TRUE)

tweet_dfm <- tokens(tw_corpus, remove_punct = TRUE,remove_numbers = T, remove_url = T) %>%
  dfm(remove = stopwords("it"), tolower = TRUE, stem = TRUE)




head(tweet_dfm)

#Dfm trimming:only words that occur in the top 20% of the distribution and in less than 30% of documents very frequent but document specific words

system.time(tweet_dfm <- dfm_trim(tweet_dfm, min_termfreq = 0.80, termfreq_type = "quantile",
                            
                            max_docfreq = 0.3, docfreq_type = "prop"))

head(tweet_dfm)

topfeatures(tweet_dfm, 5)


####################################################
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
###################################################

test1 <- dfm(tweet_dfm, dictionary = Decadri_Boussalis_dict)
test1

##########################

test <- dfm_lookup(tweet_dfm,dictionary = Roodujin_dict)
test
