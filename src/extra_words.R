###### LIST OF WORDS LINKED TO THE PARTIES (party_all)######
# words linked to the parties
party_pd <- c("pd","partitodemocratico","p_democratico","partito_democratico",
              "letta","partitodemocratico","p_democratico","partito_democratico")

party_fdi <- c("fdi","fratelliditalia","fratelliitalia","fratelliditaiia",
               "fdi_parlamento","fratelli_italia","gfratelli_d'italia",
               "fratellid'italia","meloni")

party_m5s <- c("m5s","movimento5stelle","movimentocinquestelle","5stelle",
               "cinquestelle","mov5stelle","conte","#conte","m5s_senato",
               "m5s_camera","m5scampania","puglia_m5s","movimento5stelle",
               "giuseppeconteit")

party_fi <- c("forzaitalia","forza_italia","gruppoficamera","gruppofisenato",
              "fi_toscana","fipuglia2020","fi_parlamento","fi_ultimissime",
              "berlusconi_pe","fi_giovani","fi_veneto")

party_lega <- c("legasalvini","legacamera","votalega","lega_senato",
                "lega_camera","legasicilia")
party_minori <- c("italiaviva","italia_viva","renzi","#renzi",
                  "coraggio_italia","coraggioitalia",
                  "liberieuguali","liberi_e_uguali","liberiuguali",
                  "piu_europa")
party <- c(party_lega,party_fi,party_m5s,party_fdi,party_pd,party_minori)
party_mentions <- paste("@",party,sep = "")
party_hashtag <- paste("#",party,sep = "")

party_all <- c(party,party_mentions,party_hashtag)

##################################

load("data/dataset.Rda")
load("data/tw.Rda")
load("data/dfm.Rda")

# list of party_id
partyid <- unique(dataset$party_id)

#list of surnames
nome <- unique(dataset$nome)
df1 <- data.frame(nome)
df2 <- extract(df1, nome, c("FirstName", "LastName"), "([^ ]+) (.*)")
surnames <- df2$FirstName

# list of twitter names
utenti <- unique(tw$tw_screen_name)

# mentions to the account
mentions <- paste("@",utenti, sep = "")

# hashtag mentions
hashatag <- paste("#",utenti, sep = "")

######################

# create my new list of word to be removed
extra_words <- c(partyid, surnames, party_all,
                 stopwords('spanish'), stopwords("french"),
                 stopwords("english"),
                 utenti, mentions, hashatag)

# Save extra_words
#save(extra_words,file="data/extra_words.Rda")

# Remove from the dfm
DFM <- dfm_select(DFM, extra_words, selection='remove')
