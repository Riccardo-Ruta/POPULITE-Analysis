#--------------------------------
#POPULITE ANALYSIS 10/03/2022


###################################################
# Working directory from .Rproj
here::here("")

# Source setup scripts:-------------------------------------------------------------------
source(here::here("src","00_setup.R"))

# import tweets
data <- fread("data/large_files/tweet_utf8.csv")

df <- filter(data, !tweet_text %like% "RT")
df_rt <- filter(data, tweet_text %like% "RT")


new_df <- df[,list(tweet_text,giorno)]
new_df

aa <- group_by(new_df, giorno)
aa
########################################################
# dati importati con la data corretta
tweet_utf8 <- read_delim("data/large_files/tweet_utf8.csv", 
                         delim = ";", escape_double = FALSE, col_types = cols(data = col_date(format = "%d-%b-%Y"), 
                                                                              ora = col_time(format = "%H:%M:%S")), 
                         trim_ws = TRUE)
View(tweet_utf8)

df <- filter(tweet_utf8, data > "2021/10/19" & data < "2021/10/21")
df
#########################################################
# 16/03/2022
tw <- read_delim("data/large_files/TweetPopulite (1).csv", 
                               delim = ";", escape_double = FALSE, trim_ws = TRUE)
View(tw)

tw$character <- as.numeric(tw$id_pol)
tw$conteggio <- count(unique(tw$character))


a <- tw %>% count(id_pol)

summary(a$n)

filter(a, n == 8900)

filter(tw,id_pol == 171639008)

gen <- filter(tw, Genere == "#N/D")
# Genere missing in 246102
summary(gen)

nom <- filter(tw, Nome == "#N/D")
# Nome missing in 246102
summary(nom)

nom_id <- filter(tw, Nome == "#N/D" & id_tweet == "#N/D"  )
# Nome missing in 0
summary(nom_id)

text <- filter(tw, Tweet == "#N/D")
# Nome missing in 277837      
summary(text)

data <- filter(tw, CreatoId == "#N/D")
# Nome missing in 277837            
summary(data)

gruppo <- filter(tw, GruppoPolitico == "#N/D")
# Nome missing in 325166            
summary(gruppo)

#####################################################
tw <- read.csv("data/large_files/TweetPopulite (1).csv", 
                 sep = ";", encoding = "utf-8")#, escape_double = FALSE, trim_ws = TRUE)
View(tw)

a <- filter(tw, id_tweet == 166277240 )
View(a)
a$Tweet

# 3145936

col <- colnames(tw)
col

new_df <- data.frame()

for (i in colnames(tw)) { 
  print(paste(i,(summary(tw[i] != "#N/D")[2])))
  print(paste(i,(summary(tw[i] != "#N/D")[3])))
  print("---------------------")
}
####################################################
#17/03/2022

#how to select columns using pipe
test <- tw %>% select(Genere)

#how to filter by observations
test2 <- tw %>% filter(Genere=="#N/D")

# Numero di utenti per cui il Gender ?? missing: 255
print(paste("Genere",(tw %>% filter(Genere =="#N/D") %>% distinct(id_pol) %>% count())))

# seleziono le osservazioni in cui il genere ?? mancante
gender_missing <- tw %>% filter(Genere =="#N/D")

# Numero di utenti per cui il Gender e il testo ?? missing : 250
print(paste("Genere e Tweet missing",(tw %>% filter(Genere =="#N/D" & Tweet == "#N/D") %>% distinct(id_pol) %>% count())))

# seleziono le osservazioni in cui il genere e il testo ?? mancante
gen_twet_missing <- tw %>% filter(Genere =="#N/D" & Tweet == "#N/D")

# Numero di utenti per cui il Gruppo Politico ?? missing: 385
print(paste("GruppoPolitico", tw %>% filter(GruppoPolitico =="#N/D") %>% distinct(id_pol) %>% count()))

# Numero di utenti per cui il Nome ?? missing: 255
print(paste("Nome", tw %>% filter(Nome =="#N/D") %>% distinct(id_pol) %>% count()))

# Numero di utenti per cui il url ?? missing: 14
print(paste("Url",tw %>% filter(Url =="#N/D") %>% distinct(id_pol) %>% count()))

# Numero di utenti per cui il Tweet ?? missing: 772
print(paste("Tweet",tw %>% filter(Tweet  =="#N/D") %>% distinct(id_pol) %>% count()))

# Numero di utenti per cui il CreatoId ?? missing: 772
print(paste("CreatoId",tw %>% filter(CreatoId  =="#N/D") %>% distinct(id_pol) %>% count()))

for (i in colnames(tw)) { 
  print(distinct(i))
}

#fix time format

time_format <- "%a %b %d %H:%M:%S %z %Y"
tw$new_time <- as.POSIXct(strptime(tw$created_at, time_format, tz="GMT"), tz="GMT")

##########################################################
#18/03/2022
# Controllo se ci sono 255 utenti con il Genere missing o 
# se ci sono degli id_pol errati (che non corrispOndono ad utenti reali)
# id_pol corrisponde a singolo utente?

# Conto distinti id_pol filtrati per Genere mancante
print(paste("Genere",(tw %>% filter(Genere =="#N/D") %>% distinct(id_pol) %>% count())))

# conto distinti id_pol filtrati per testo mancante
print(paste("Tweet",tw %>% filter(Tweet  =="#N/D") %>% distinct(id_pol) %>% count()))

## conto distinti id_pol filtrati per testo mancante e Genere mancante
tw %>% filter(Genere =="#N/D" & Tweet !="#N/D" ) %>% distinct(id_pol) #%>% count()

#conto il numero dei singoli id_pol presenti nel dataset
#779
# dovrebbero essere 976, essendo 779 abbiamo 197 id_pol "in pi??"
tw %>% distinct(id_pol) %>% count()

#Conto il numero di id_pol che hanno almeno 1 Tweet missing
# 772
tw %>% filter(Tweet == "#N/D") %>% distinct(id_pol) %>% count()

# Conto il numero di id_pol con Genere missing e Tweet presente
#253
tw %>% filter(Genere == "#N/D" & Tweet != "#N/D") %>% distinct(id_pol) %>% count()


#Conto il numero di id_pol che hanno almeno un caso in cui il Tweet non ?? missing
#773
bb %>% filter(Tweet!= "#N/D") %>% distinct(id_pol) %>% count()

#Conto il numero di id_pol che hanno almeno un caso in cui il Tweet ?? missing
#772
bb %>% filter(Tweet== "#N/D") %>% distinct(id_pol) %>% count()

# creo df con solo osservazioni in cui il Genere ?? missing
zz <- tw %>% filter(Genere== "#N/D")
#creo un sub df in cui ci sono solo osservazioni con Tweet missing
zz1 <- zz %>% filter(Tweet == "#N/D")
#creo un sub df in cui ci sono solo osservazioni con Tweet missing
zz2 <- zz %>% filter(Tweet != "#N/D")

# Conto i distinti id_pol di zz1
#250
zz1 %>% distinct(id_pol) %>% count()

# Conto i distinti id_pol di zz2
#253
zz2 %>% distinct(id_pol) %>% count()
