
###################################################
# Working directory from .Rproj
here::here("")

# Source setup scripts:-------------------------------------------------------------------
source(here::here("src","00_setup.R"))

#import tweets
tw <- read_delim("data/tweet_510901_delim.csv",
                 delim = ";",
                 escape_double = FALSE,
                 trim_ws = TRUE)

View(tw)

# create the CORPUS
tw_corpus <- corpus(tw, text_field = "tweet_text")
summary(tw_corpus)

# number of documents
ndoc(tw_corpus)

# inspect the document-level variables
head(docvars(tw_corpus))
tw_corpus

######################################################
# Some cleaning
tw_corpus <- tokens(tw_corpus, remove_punct = T, remove_numbers = T, remove_url = T) # remove punct, numb and links
tw_corpus <- tokens_select(tw_corpus, stopwords('it'), selection = 'remove') # remove italian stopwords
tw_corpus <- tokens_wordstem(tw_corpus) # stemming
tw_corpus <- tokens_tolower(tw_corpus) # standardizes lower

summary(tw_corpus)

#####################################################
#convert tokenized tweets in dfm
tw_dfm <- dfm(tw_corpus,remove = c(stopwords("it"), ("+"), ("<"), (">"), ("00*"), (":"),(","),("?"),("."),("�")))
tw_dfm

topfeatures(tw_dfm, 5)

##############################################################
#import dictionaries file
populism_dictionaries <- read_delim("C:/Users/Riccardo/Desktop/Master Thesis/populism_dictionaries_delim.csv",
                                    delim = ";",
                                    escape_double = FALSE,
                                    trim_ws = TRUE)
View(populism_dictionaries)

Roodujin <- list(populism_dictionaries[1])
Groundi <- list(populism_dictionaries[2])

Roodujin <- list(populism = populism_dictionaries[1])
Groundi <- list(populism = populism_dictionaries[2])
Decadri <-  list(populism = populism_dictionaries[3])

Roodujin
Groundi
Decadri

# create the list of words for the dict
data1 <- as.data.frame(Roodujin)
data_list <- list(data1)

data_list


#create the dictionary
Roodujin_dict <- dictionary(Roodujin)

Groundi_dict <- dictionary(Groundi)

Decadri_dict <- dictionary(Decadri)

####################################################
# create my own dictionary

Roodujin_dict <- dictionary(list(populism = c("antidemocratic", "casta", "consens", "corrot", "disonest", "elit", "establishment",
                                        "ingann", "mentir", "menzogn", "partitocrazia", "propagand", "scandal", "tradim",
                                        "tradir", "tradit", "vergogn", "verita")))

Decadri_Boussalis_dict <- dictionary(list( people = c("abitant", "cittadin","consumator","contribuent","elettor","gente","popol",
                                                      "popolazion", "uomo della strada","comun mortal","italiano medio", "uomo medio"),
                                           Common_Will = c("senso comune","buon senso","plebescitar","referendum","plebiscito",
                                                           "petizione","democrazia diretta","volonta popolare","voto popolare",
                                                           "sovranita popolare","mandato popolare"),
                                           elite = c("antidemocratic","casta","consens","corrot","disonest","elit","establishment",
                                                     "ingann","mentir","menzogn","partitocrazia","propagand","scandal","tradim",
                                                     "tradir","tradit","vergogn","verita","presuntuos","spocchios","spocchia",
                                                     "puzza sotto il naso", "senso di superiorita","politicant","paternalistic",
                                                     "pezz gross","burocrat","torre d avorio","solit partit", "vecch partit",
                                                     "corruzione","avid","raccomandati","arrogant","attaccat all poltron",
                                                     "assetat di potere","manipolare","nomenklatura","professoron",
                                                     "bugie dei partiti", "falsita dei partiti","mazzett","mercanteggiamenti",
                                                     "pseudo-partit","baron","autocratic","sistema-partito","tecnocrat",
                                                     "altezzos","non democratic","prendere in giro","bullarsi di",
                                                     "clientelismo","dittatur* di partito","teatro politico","banchier",
                                                     "cosiddett giornalist"," cosiddetti media","lobbist")))
summary(Decadri_Boussalis_dict)
###################################################
# Made the anlysis

recent_corpus <- corpus_subset(tw_corpus,  like > 2)
summary(recent_corpus)
recent_corpus
byPresMat <- dfm(recent_corpus, dictionary = Decadri_Boussalis_dict)
byPresMat
summary(byPresMat)
